import os
import shutil
import struct
import sys
import time
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

PRIMITIVE_CONTROLS = {
    "buttoncontrol", "buttonfield", "chatentry", "chatwindow",
    "diecontrol", "diefield", "formattedtextcontrol", "formattedtextfield",
    "genericcontrol", "imagecontrol", "imagedatacontrol", "linkcontrol",
    "linkfield", "numbercontrol", "numberfield", "portraitselectioncontrol",
    "scrollbarcontrol", "scrollercontrol", "stringcontrol", "stringfield",
    "subwindow", "tokencontrol", "tokenfield", "windowlist",
    "windowreferencecontrol", "windowreferencefield"
}


def validate_extension(project_root: Path) -> None:
    print("Running FGU XML static validation...")
    errors = []

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

        # 1. Template multi-tag merge check (prevents derived template tag clobbering)
        for tmpl in xml_root.findall(".//template"):
            tname = tmpl.get("name", "<unnamed>")
            children = list(tmpl)
            if not children:
                continue
            base = children[0]
            if base.tag not in PRIMITIVE_CONTROLS:
                seen_tags = {}
                for child in base:
                    tag = child.tag
                    merge_attr = child.get("merge", "")
                    if tag in seen_tags and merge_attr not in ("add", "resetandadd", "delete"):
                        errors.append(
                            f"[{rel}] Template '{tname}' inherits from non-primitive template "
                            f"'{base.tag}' and has multiple <{tag}> tags without merge='add'/'resetandadd' "
                            f"(second <{tag}> overwrites the first in FGU)"
                        )
                    seen_tags[tag] = True

        # 2. Asset existence check
        for elem in xml_root.iter():
            val = elem.get("source") if elem.tag == "includefile" else elem.get("file")
            attr = "source" if elem.tag == "includefile" else "file"
            if not val:
                continue
            if elem.tag == "script" and not val.startswith(("scripts/", "rulesets/")):
                continue
            if not (project_root / val).is_file():
                errors.append(f"[{rel}] Missing file referenced by <{elem.tag} {attr}='{val}'>")

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
                if offset_el is not None and offset_el.text:
                    parts = [int(x.strip()) for x in offset_el.text.split(",")]
                    if len(parts) == 4:
                        l, t, r, b = parts
                        if l + r > w or t + b > h:
                            errors.append(
                                f"[{rel}] framedef '{fname}' offset ({l},{t},{r},{b}) "
                                f"exceeds bitmap '{bmp_file}' dimensions ({w}x{h})"
                            )

        # 4. Windowclass sheetdata duplicate control check
        for wc in xml_root.findall(".//windowclass"):
            wname = wc.get("name", "<unnamed>")
            sd = wc.find("sheetdata")
            if sd is None:
                continue
            active_controls = set()
            for ctrl in sd:
                cname = ctrl.get("name")
                if not cname:
                    continue
                merge_attr = ctrl.get("merge", "")
                key = (ctrl.tag, cname)
                if merge_attr == "delete":
                    active_controls.discard(key)
                elif merge_attr == "add":
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

        # 6. Intra-file duplicate unscoped definition check
        for tag in ("icon", "font", "framedef"):
            seen_defs = set()
            for elem in xml_root.findall(f".//{tag}"):
                dname = elem.get("name")
                if not dname or elem.get("merge"):
                    continue
                key = (dname, elem.get("ruleset", ""), elem.get("version", ""))
                if key in seen_defs:
                    errors.append(f"[{rel}] Duplicate <{tag} name='{dname}'> definition")
                seen_defs.add(key)

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
