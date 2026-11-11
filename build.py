import os
import re
import shutil
import struct
import sys
import time
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path, PurePosixPath

PRIMITIVE_CONTROLS = {
    "buttoncontrol", "buttonfield", "chatentry", "chatwindow",
    "diecontrol", "diefield", "formattedtextcontrol", "formattedtextfield",
    "genericcontrol", "imagecontrol", "imagedatacontrol", "linkcontrol",
    "linkfield", "numbercontrol", "numberfield", "portraitselectioncontrol",
    "scrollbarcontrol", "scrollercontrol", "stringcontrol", "stringfield",
    "subwindow", "tokencontrol", "tokenfield", "windowlist",
    "windowreferencecontrol", "windowreferencefield"
}

VALID_MERGE_VALUES = {"join", "replace", "delete", "add", "resetandadd"}

SLICE_TAGS = (
    "topleft", "top", "topright",
    "left", "middle", "right",
    "bottomleft", "bottom", "bottomright",
    "decal",
)

LUA_TOKEN_RE = re.compile(
    r"--\[(=*)\[[\s\S]*?\]\1\]"          # block comment
    r"|--[^\r\n]*"                        # line comment
    r"|\[(=*)\[[\s\S]*?\]\2\]"            # long string
    r"|\"(?:\\.|[^\"\\\r\n])*\""          # double-quoted string
    r"|'(?:\\.|[^'\\\r\n])*'"             # single-quoted string
    r"|\b(?:function|if|do|end|repeat|until)\b"
    r"|[(){}\[\]]"
)

LUA_STRIP_COMMENTS_STRINGS_RE = re.compile(
    r"--\[(=*)\[[\s\S]*?\]\1\]"
    r"|--[^\r\n]*"
    r"|\[(=*)\[[\s\S]*?\]\2\]"
    r"|\"(?:\\.|[^\"\\\r\n])*\""
    r"|'(?:\\.|[^'\\\r\n])*'"
)


def check_lua_snippet(code: str) -> list[str]:
    errs: list[str] = []
    block_stack: list[str] = []
    delim_stack: list[str] = []
    pairs = {")": "(", "}": "{", "]": "["}

    for m in LUA_TOKEN_RE.finditer(code):
        tok = m.group(0)
        if tok.startswith("--") or tok.startswith(('"', "'")) or (tok.startswith("[") and len(tok) > 1):
            continue
        if tok in ("function", "if", "do"):
            block_stack.append(tok)
        elif tok == "repeat":
            block_stack.append("repeat")
        elif tok == "end":
            if not block_stack or block_stack[-1] == "repeat":
                errs.append("unmatched 'end'")
                break
            block_stack.pop()
        elif tok == "until":
            if not block_stack or block_stack[-1] != "repeat":
                errs.append("unmatched 'until'")
                break
            block_stack.pop()
        elif tok in "({[":
            delim_stack.append(tok)
        elif tok in ")}]":
            if not delim_stack or delim_stack[-1] != pairs[tok]:
                errs.append(f"unmatched '{tok}'")
                break
            delim_stack.pop()

    if block_stack:
        errs.append(f"unclosed Lua block(s): {', '.join(block_stack)}")
    if delim_stack:
        errs.append(f"unclosed delimiter(s): {', '.join(delim_stack)}")

    stripped = LUA_STRIP_COMMENTS_STRINGS_RE.sub(" ", code)
    for m in re.finditer(r"\bif\s+super\.([A-Za-z_][A-Za-z0-9_]*)\b", stripped):
        errs.append(f"unguarded 'if super.{m.group(1)}' (use 'if super and super.{m.group(1)}')")

    return errs


def extract_inline_lua(project_root: Path, out_dir: Path) -> None:
    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    count = 0
    for xml_path in sorted(project_root.rglob("*.xml")):
        if "out" in xml_path.parts or ".git" in xml_path.parts:
            continue
        rel = xml_path.relative_to(project_root).as_posix()
        try:
            xml_root = ET.parse(xml_path).getroot()
        except Exception:
            continue
        safe_stem = rel.replace("/", "__").replace(".xml", "")
        for idx, sc in enumerate(xml_root.findall(".//script"), start=1):
            if sc.get("file") or not sc.text or not sc.text.strip():
                continue
            cleaned_lines = [line.rstrip(" \t\r") for line in sc.text.splitlines()]
            while cleaned_lines and cleaned_lines[0] == "":
                cleaned_lines.pop(0)
            while cleaned_lines and cleaned_lines[-1] == "":
                cleaned_lines.pop()
            if not cleaned_lines:
                continue
            count += 1
            dest = out_dir / f"{safe_stem}_{idx:02d}.lua"
            body = "\n".join(cleaned_lines)
            dest.write_text(f"-- Source: {rel} (inline <script> #{idx})\n{body}\n", encoding="utf-8")

    if count == 0:
        (out_dir / "_empty.lua").write_text("-- no inline scripts\n", encoding="utf-8")
    print(f"Extracted {count} inline XML <script> block(s) to {out_dir}")


def validate_extension(project_root: Path) -> None:
    print("Running FGU XML & Asset static validation...")
    errors: list[str] = []
    dir_listing_cache: dict[Path, set[str]] = {}

    def check_case_sensitive_file(rel_str: str) -> tuple[bool, str]:
        norm = PurePosixPath(rel_str.replace("\\", "/")).as_posix()
        parts = [p for p in norm.split("/") if p and p != "."]
        cur = project_root
        for part in parts:
            if cur not in dir_listing_cache:
                try:
                    dir_listing_cache[cur] = set(os.listdir(cur))
                except OSError:
                    dir_listing_cache[cur] = set()
            if part not in dir_listing_cache[cur]:
                if (cur / part).exists():
                    actual = next((x for x in dir_listing_cache[cur] if x.lower() == part.lower()), part)
                    parent_rel = cur.relative_to(project_root).as_posix() if cur != project_root else "."
                    return False, f"case mismatch for '{norm}' (found '{actual}' in '{parent_rel}')"
                return False, f"missing file '{norm}'"
            cur = cur / part
        if not cur.is_file():
            return False, f"not a file '{norm}'"
        return True, norm

    parsed_trees: dict[str, ET.Element] = {}
    referenced_files: set[str] = set()

    for xml_path in sorted(project_root.rglob("*.xml")):
        if "out" in xml_path.parts or ".git" in xml_path.parts:
            continue
        rel = xml_path.relative_to(project_root).as_posix()
        try:
            tree = ET.parse(xml_path)
        except Exception as e:
            errors.append(f"[{rel}] XML parse error: {e}")
            continue

        xml_root = tree.getroot()
        parsed_trees[rel] = xml_root

        # 0. Valid merge attribute values on every element
        for elem in xml_root.iter():
            mval = elem.get("merge")
            if mval is not None and mval not in VALID_MERGE_VALUES:
                errors.append(
                    f"[{rel}] Invalid merge='{mval}' on <{elem.tag} name='{elem.get('name', '')}'> "
                    f"(allowed: {', '.join(sorted(VALID_MERGE_VALUES))})"
                )

        # 1. Template multi-tag merge check (prevents derived template tag clobbering)
        for tmpl in xml_root.findall(".//template"):
            tname = tmpl.get("name", "<unnamed>")
            children = list(tmpl)
            if not children:
                continue
            base = children[0]
            if base.tag not in PRIMITIVE_CONTROLS or tmpl.get("merge") == "join":
                seen_tags = {}
                for child in base:
                    tag = child.tag
                    merge_attr = child.get("merge", "")
                    if tag in seen_tags and merge_attr not in ("add", "resetandadd", "delete"):
                        errors.append(
                            f"[{rel}] Template '{tname}' ('{base.tag}') has multiple <{tag}> tags "
                            f"without merge='add'/'resetandadd' (second <{tag}> overwrites the first in FGU)"
                        )
                    seen_tags[tag] = True

        # 2. Asset & script existence + case-sensitive path check (attributes and inner text)
        for elem in xml_root.iter():
            candidates: list[tuple[str, str]] = []
            if elem.tag == "includefile" and elem.get("source"):
                candidates.append(("source", elem.get("source", "").strip()))
            if elem.get("file"):
                fval = elem.get("file", "").strip()
                if not (elem.tag == "script" and not fval.startswith(("scripts/", "rulesets/"))):
                    candidates.append(("file", fval))
            if elem.tag in ("bitmap", "ttf", "fgffile") and not elem.get("file") and elem.text and elem.text.strip():
                candidates.append(("text", elem.text.strip()))

            for attr_kind, val in candidates:
                if not val:
                    continue
                ok, info = check_case_sensitive_file(val)
                if not ok:
                    loc_desc = f"<{elem.tag}>='{val}'" if attr_kind == "text" else f"<{elem.tag} {attr_kind}='{val}'>"
                    errors.append(f"[{rel}] Invalid file reference {loc_desc}: {info}")
                else:
                    referenced_files.add(info)

        # 3. Frame slice bounds check (FGU 5.1.14+ strict 9-slice validation)
        for framedef in xml_root.findall(".//framedef"):
            fname = framedef.get("name", "<unnamed>")
            bmp = framedef.find("bitmap")
            if bmp is None:
                continue
            bmp_file = bmp.get("file") or (bmp.text.strip() if bmp.text else "")
            if not bmp_file or not (project_root / bmp_file).is_file():
                continue
            with open(project_root / bmp_file, "rb") as f:
                hdr = f.read(24)
            if len(hdr) >= 24 and hdr[:8] == b"\x89PNG\r\n\x1a\n":
                w, h = struct.unpack(">II", hdr[16:24])
                offset_el = framedef.find("offset")
                if offset_el is not None and offset_el.text and offset_el.text.strip():
                    try:
                        parts = [int(x.strip()) for x in offset_el.text.split(",")]
                    except ValueError:
                        errors.append(f"[{rel}] framedef '{fname}' has non-integer <offset> '{offset_el.text.strip()}'")
                        parts = []
                    if parts:
                        if len(parts) != 4:
                            errors.append(f"[{rel}] framedef '{fname}' <offset> must have 4 values, got {len(parts)}")
                        else:
                            l, t, r, b = parts
                            if min(parts) < 0:
                                errors.append(
                                    f"[{rel}] framedef '{fname}' has negative offset ({l},{t},{r},{b})"
                                )
                            elif l + r > w or t + b > h:
                                errors.append(
                                    f"[{rel}] framedef '{fname}' offset ({l},{t},{r},{b}) "
                                    f"exceeds bitmap '{bmp_file}' dimensions ({w}x{h})"
                                )

                for st in SLICE_TAGS:
                    sel = framedef.find(st)
                    if sel is None:
                        continue
                    raw_rect = sel.get("rect") or (sel.text.strip() if sel.text else "")
                    if not raw_rect:
                        continue
                    try:
                        sparts = [int(x.strip()) for x in raw_rect.split(",")]
                    except ValueError:
                        errors.append(f"[{rel}] framedef '{fname}' <{st}> has non-integer rect '{raw_rect}'")
                        continue
                    if len(sparts) != 4:
                        errors.append(f"[{rel}] framedef '{fname}' <{st}> rect must have 4 values, got {len(sparts)}")
                        continue
                    sx, sy, sw, sh = sparts
                    if min(sparts) < 0:
                        errors.append(
                            f"[{rel}] framedef '{fname}' <{st}> rect ({sx},{sy},{sw},{sh}) has negative value(s)"
                        )
                    elif sx + sw > w or sy + sh > h or (w > 0 and sx >= w) or (h > 0 and sy >= h):
                        errors.append(
                            f"[{rel}] framedef '{fname}' <{st}> rect ({sx},{sy},{sw},{sh}) "
                            f"exceeds bitmap '{bmp_file}' dimensions ({w}x{h})"
                        )

        # 4. Windowclass sheetdata checks (unnamed controls, multi-tag clobbering, duplicate controls)
        for wc in xml_root.findall(".//windowclass"):
            wname = wc.get("name", "<unnamed>")
            wmerge = wc.get("merge", "")
            sd = wc.find("sheetdata")
            if sd is None:
                continue
            active_controls = set()
            for ctrl in sd:
                cname = ctrl.get("name")
                cmerge = ctrl.get("merge", "")
                if wmerge == "join" and not cname and cmerge in ("", "join") and len(ctrl) > 0:
                    errors.append(
                        f"[{rel}] windowclass '{wname}' (merge='join') has unnamed sheetdata control "
                        f"<{ctrl.tag}> with child overrides (missing name attribute)"
                    )
                if (wmerge == "join" and cmerge in ("", "join")) or ctrl.tag not in PRIMITIVE_CONTROLS:
                    seen_ctags = {}
                    for ch in ctrl:
                        ch_merge = ch.get("merge", "")
                        if ch.tag in seen_ctags and ch_merge not in ("add", "resetandadd", "delete"):
                            errors.append(
                                f"[{rel}] windowclass '{wname}' control <{ctrl.tag} name='{cname or ''}'> "
                                f"has multiple <{ch.tag}> tags without merge='add'/'resetandadd'"
                            )
                        seen_ctags[ch.tag] = True

                if not cname:
                    continue
                key = (ctrl.tag, cname)
                if cmerge == "delete":
                    active_controls.discard(key)
                elif cmerge == "add":
                    active_controls.add(key)
                else:
                    if key in active_controls:
                        errors.append(
                            f"[{rel}] windowclass '{wname}' has duplicate sheetdata control "
                            f"<{ctrl.tag} name='{cname}'> without prior merge='delete'"
                        )
                    active_controls.add(key)

        # 5. Multi-<child> alternating row merge check (requires resetandadd + add)
        for elem in xml_root.iter():
            child_tags = [c for c in elem if c.tag == "child"]
            if len(child_tags) >= 2:
                first_merge = child_tags[0].get("merge", "")
                if first_merge != "resetandadd":
                    errors.append(
                        f"[{rel}] <{elem.tag} name='{elem.get('name', '')}'> has {len(child_tags)} "
                        f"<child> tags but first <child> has merge='{first_merge}' (expected 'resetandadd')"
                    )
                for idx, ch in enumerate(child_tags[1:], start=2):
                    if ch.get("merge", "") != "add":
                        errors.append(
                            f"[{rel}] <{elem.tag} name='{elem.get('name', '')}'> <child> #{idx} "
                            f"has merge='{ch.get('merge', '')}' (expected 'add')"
                        )

        # 6. Inline XML <script> Lua syntax/balance & safety check
        for idx, sc in enumerate(xml_root.findall(".//script"), start=1):
            if sc.get("file") or not sc.text or not sc.text.strip():
                continue
            lua_errs = check_lua_snippet(sc.text)
            for lerr in lua_errs:
                errors.append(f"[{rel}] Inline <script> #{idx}: {lerr}")

    # 7. Cross-file & intra-file definition clobber check in extension.xml load order
    ext_root = parsed_trees.get("extension.xml")
    if ext_root is not None:
        ann_el = ext_root.find(".//announcement")
        ver_el = ext_root.find(".//properties/version")
        if ann_el is not None and ver_el is not None and ver_el.text:
            ver_str = ver_el.text.strip()
            ann_text = ann_el.get("text", "")
            if f"v{ver_str}" not in ann_text:
                errors.append(
                    f"[extension.xml] <version>{ver_str}</version> does not match <announcement text='{ann_text}'>"
                )

        base_el = ext_root.find("base")
        if base_el is not None:
            ordered_defs: list[tuple[str, str, str, str, str]] = []
            for el in base_el:
                if el.tag == "includefile":
                    src = (el.get("source") or "").strip()
                    inc_rs = (el.get("ruleset") or "").strip()
                    sub_root = parsed_trees.get(PurePosixPath(src.replace("\\", "/")).as_posix())
                    if sub_root is not None:
                        sub_rel = PurePosixPath(src.replace("\\", "/")).as_posix()
                        for ch in sub_root.iter():
                            if ch.tag in ("icon", "framedef", "font") and ch.get("name") and not ch.get("merge"):
                                eff_rs = (ch.get("ruleset") or inc_rs).strip()
                                ordered_defs.append((sub_rel, ch.tag, ch.get("name", ""), eff_rs, ch.get("version", "")))
                elif el.tag in ("icon", "framedef", "font") and el.get("name") and not el.get("merge"):
                    ordered_defs.append(("extension.xml", el.tag, el.get("name", ""), el.get("ruleset", "").strip(), el.get("version", "")))

            seen_defs: dict[tuple[str, str], list[tuple[str, str, str]]] = {}
            for src_rel, tag, dname, eff_rs, ver in ordered_defs:
                key = (tag, dname)
                prev_list = seen_defs.get(key, [])
                if eff_rs == "":
                    for p_rel, p_rs, p_ver in prev_list:
                        if ver == "" or p_ver == "" or ver == p_ver:
                            if p_rel == src_rel and p_rs != "":
                                errors.append(
                                    f"[{src_rel}] Unscoped <{tag} name='{dname}'> placed after "
                                    f"ruleset-scoped ('{p_rs}') definition (clobbers ruleset override)"
                                )
                            elif p_rel == src_rel:
                                errors.append(f"[{src_rel}] Duplicate <{tag} name='{dname}'> definition")
                            else:
                                errors.append(
                                    f"[{src_rel}] Unscoped <{tag} name='{dname}'> clobbers earlier "
                                    f"definition in [{p_rel}] (ruleset='{p_rs or '*'}')"
                                )
                            break
                else:
                    rs_set = set(eff_rs.split("|"))
                    for p_rel, p_rs, p_ver in prev_list:
                        if p_rs != "" and (rs_set & set(p_rs.split("|"))) and (ver == "" or p_ver == "" or ver == p_ver):
                            if p_rel == src_rel:
                                errors.append(
                                    f"[{src_rel}] Duplicate <{tag} name='{dname}'> definition for ruleset='{eff_rs}'"
                                )
                            else:
                                errors.append(
                                    f"[{src_rel}] <{tag} name='{dname}'> (ruleset='{eff_rs}') clobbers "
                                    f"earlier definition in [{p_rel}] (ruleset='{p_rs}')"
                                )
                            break
                seen_defs.setdefault(key, []).append((src_rel, eff_rs, ver))

    # 8. Also scan standalone Lua files for any direct graphics/... asset paths & check syntax balance
    for lua_path in sorted(project_root.rglob("*.lua")):
        if "out" in lua_path.parts or ".git" in lua_path.parts:
            continue
        lua_rel = lua_path.relative_to(project_root).as_posix()
        lua_text = lua_path.read_text(encoding="utf-8", errors="replace")
        for lerr in check_lua_snippet(lua_text):
            errors.append(f"[{lua_rel}] Lua check failed: {lerr}")
        uncommented = re.sub(r"--[^\r\n]*", "", lua_text)
        for m in re.finditer(r'["\'](graphics/[^"\']+\.(?:png|ttf))["\']', uncommented, re.IGNORECASE):
            ok, info = check_case_sensitive_file(m.group(1))
            if ok:
                referenced_files.add(info)

    # 9. Unreferenced XML include check & unreferenced PNG/TTF asset check under graphics/
    for rel_xml in sorted(parsed_trees):
        if rel_xml != "extension.xml" and rel_xml not in referenced_files:
            errors.append(f"[{rel_xml}] XML file is not included by extension.xml")

    graphics_dir = project_root / "graphics"
    if graphics_dir.is_dir():
        for asset_path in sorted(graphics_dir.rglob("*")):
            if asset_path.is_file() and asset_path.suffix.lower() in (".png", ".ttf"):
                asset_rel = asset_path.relative_to(project_root).as_posix()
                if asset_rel not in referenced_files:
                    errors.append(
                        f"[{asset_rel}] Unreferenced asset under graphics/ (not referenced by any active XML or Lua file)"
                    )

    if errors:
        print(f"\nValidation FAILED with {len(errors)} error(s):", file=sys.stderr)
        for err in errors:
            print(f"  - {err}", file=sys.stderr)
        sys.exit(1)

    print("Validation passed (0 errors).\n")


def build_extension():
    start_time = time.time()

    # Paths relative to this script (assumed to be at the project root)
    project_root = Path(__file__).parent.resolve()
    if "--extract-inline-lua" in sys.argv:
        idx = sys.argv.index("--extract-inline-lua")
        if idx + 1 >= len(sys.argv):
            print("Usage: python build.py --extract-inline-lua <output_dir>", file=sys.stderr)
            sys.exit(1)
        extract_inline_lua(project_root, Path(sys.argv[idx + 1]))
        return

    validate_extension(project_root)
    if "--validate-only" in sys.argv:
        return

    out_dir = project_root / "out"
    temp_dir = out_dir / "Theme_SirMotte_Hearth"
    output_ext_file = out_dir / "Theme_SirMotte_Hearth.ext"

    print("==================================================")
    print("Building Fantasy Grounds Hearth Theme Extension...")
    print(f"Project root: {project_root}")
    print(f"Output file:  {output_ext_file}")
    print("==================================================\n")

    # 1. Clean and recreate temp and output directories
    if temp_dir.exists():
        shutil.rmtree(temp_dir)
    if output_ext_file.exists():
        output_ext_file.unlink()

    # Create the out directory if missing
    out_dir.mkdir(parents=True, exist_ok=True)
    temp_dir.mkdir(parents=True, exist_ok=True)

    # 2. Define files and directories to copy
    # format: (source_path_relative_to_root, destination_subpath)
    assets_to_copy = [
        ("extension.xml", ""),
        ("SirMotte_footface.png", ""),
        ("graphics", "graphics"),
        ("rulesets", "rulesets"),
        ("scripts", "scripts")
    ]

    # 3. Copy assets to the temporary directory
    print("Copying assets...")
    for rel_src, rel_dest in assets_to_copy:
        src_path = project_root / rel_src
        dest_path = temp_dir / rel_dest

        if not src_path.exists():
            print(f"Warning: Source path does not exist: {src_path}")
            continue

        if src_path.is_file():
            shutil.copy2(src_path, dest_path)
        elif src_path.is_dir():
            shutil.copytree(src_path, dest_path, dirs_exist_ok=True)

    # 4. Create the ZIP/EXT archive using Python's native zipfile module
    print(f"\nCompressing into {output_ext_file.name} (Level 9)...")

    # Use ZIP_DEFLATED for standard compression.
    # Level 9 is the highest standard compression level.
    with zipfile.ZipFile(output_ext_file, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as zipf:
        # Walk through the temp dir and add files relative to it
        for root, dirs, files in os.walk(temp_dir):
            for file in sorted(files):
                file_path = Path(root) / file
                # Write file with a POSIX path relative to temp_dir (so they sit at the zip root)
                arcname = file_path.relative_to(temp_dir).as_posix()
                zipf.write(file_path, arcname)

    # 5. Clean up temporary directory
    print("Cleaning up temporary build folder...")
    shutil.rmtree(temp_dir)

    elapsed_time = time.time() - start_time
    print(f"\nBuild successfully completed in {elapsed_time:.3f} seconds!")


if __name__ == "__main__":
    build_extension()
