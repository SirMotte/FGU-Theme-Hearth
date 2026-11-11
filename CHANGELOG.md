[COLOR=#FF8C00][SIZE=4][B]Update to v2.9.61 - Torchbearer[/B][/SIZE][/COLOR]

[COLOR="#FF0000"][B]Changelog[/B][/COLOR]
[LIST]
[*] CoreRPG Calendar & Health Status Colors: Fixed a database handler leak and crash after closing the Calendar by registering calendar_month and calendar_day UI colors natively via ColorManager.setUIColor and removing the calendar_main script override; resolved an ActorHealthManager load-order race so Dying, Destroyed, Unconscious, Disabled, Staggered, and Bloodied statuses use Hearth's dark-mode palette instead of unthemed CoreRPG colors; and modernized hotkey drop registration to Interface.addKeyedEventHandler.
[*] CoreRPG Graphics, Fonts & Templates: Added a dedicated magnifying-glass icon for search (replacing the 204x30 input-box frame mapping), mapped CoreRPG's 6 standardized radial_power_action_* icons, corrected calendarday-b and calendarday-bi to Roboto Bold and Bold Italic TTFs, fixed dicetower_normal/dicetower_drop 9-slice bounds for FGU 5.1.14+, preserved <tintable /> on button_refresh, themed button_expand_base/button_collapse_base, and moved windowmenubar_ctbox into corerpg_compilation.xml.
[*] Character Sheet Sizing & OSR Rulesets (Swords & Wizardry, OSE2, AD&D 2E, 4E, PFRPG2): Restored per-ruleset character sheet minimum dimensions and top menubar offsets so wider/taller sheets (such as Swords & Wizardry, AD&D 2E, 4E, and PFRPG2) no longer clip; fixed OSE2 spells_main primitive font deletion, white #FFFFFFFF field backgrounds, hidden Level_new control visibility, and Host/Client CT temp_hp (#69B7FF) contrast.
[*] AD&D 2E, D&D 4E, D&D 5E & 3.5E/PFRPG: Brightened 2E chat roll fonts (successfont, failfont, hitfont, warning) for dark-mode legibility, renamed htabs to tabs_h, added shadow to font-hpcurrent, simplified char_matrix_thaco.lua via super.onInit() while preserving BECMI support, darkened 2E label_ability_details_stat backcolor and lightened 4E NPC trap diamond bullets, replaced 5E's invalid merge="merge" Death Indicator control override with a safe runtime nil guard, and removed false dimming of 3.5E/PFRPG1 armor check penalty and spell failure fields.
[*] Cyberpunk RED, PFRPG2, Mongoose Traveller 2E, Daggerheart, CoC7E & ICRPG: Chained super.onInit()/super.update() across Cyberpunk RED inline control scripts, added noto-b-24, fixed noto-b-12 size and 50x70 dice frame slices/decals, and added nil-safe frame offset helpers in ThemeManager; recolored PFRPG2 linked HP fields (hptemp_linked, wounded_linked, dying_linked), NPC quickref labels, and Runesmith/Commander class labels; recolored MGT2 VARMU vehicle structure damage fields on both Host and Client CT; converted Daggerheart's attribute frame to a stretchable 9-slice; aligned CoC7E tabs_npcsheet width/offset; and normalized ICRPG hex color prefixes.
[*] Community Extensions & Asset Hygiene: Eliminated unscoped graphics_extensions.xml icon/frame clobbers against CoreRPG, 5E, 4E, 2E, SFRPG, and XCore (fieldred), fixed battletracker_commander and Mad Nomad Combat Stats template merges, added aliases for renamed extension icons, corrected Colorful Language color names, consolidated 7 duplicate TTF font pairs, and pruned unreferenced graphic assets and obsolete ruleset definitions.
[*] Build Validator & CI Tooling: Upgraded build.py static validation to enforce valid merge attributes, windowclass sheetdata multi-tag/unnamed control rules, explicit 9-slice/negative offset bounds, case-sensitive and orphaned asset checks, cross-file/intra-file load-order clobber detection, and inline XML Lua checks; tightened .luacheckrc (allow_defined_top = false), added Luacheck and contents: write permissions to release CI, and added manager_desktop2.lua support to ConvertColors.ps1.
[/LIST]

[COLOR=#FF8C00][SIZE=4][B]Update to v2.9.60 - Torchbearer[/B][/SIZE][/COLOR]

[COLOR="#FF0000"][B]Changelog[/B][/COLOR]
[LIST]
[*] CoreRPG & 5E Action Roll Buttons (2026-10 Update): Added Hearth-styled dark button graphics for the new Save / Power Save action buttons (button_action_save, button_action_save_down, button_action_powersave, button_action_powersave_down) and mapped Cast action buttons (button_action_cast, button_action_cast_down) to Hearth's dark roll buttons so the new 5E Spell Actions tab and PC Actions tab match the rest of the action bar.
[*] CoreRPG Effect Cycler Toggles (2026 Effects Rewrite): Added Hearth-themed dark-bordered pill icons for all 9 new CoreRPG effect cycler states across Application (button_toggle_round_once, button_toggle_round_twice, button_toggle_turn_once), Targeting (button_toggle_trgt_self, button_toggle_self_trgt), and Expiration (button_toggle_endnext, button_toggle_restshort, button_toggle_restlong, button_toggle_turn) modes.
[*] CoreRPG Cleanup: Removed obsolete label_ct template override from corerpg_compilation.xml.
[/LIST]

[COLOR=#FF8C00][SIZE=4][B]Update to v2.9.59 - Torchbearer[/B][/SIZE][/COLOR]

[COLOR="#FF0000"][B]Changelog[/B][/COLOR]
[LIST]
[*] CoreRPG Combat Tracker: Fixed NPC Visibility (button_ct_entry_tokenvis) and NPC Identification (button_ct_entry_isidentified) toggle buttons being stuck greyed out and unclickable by adding explicit merge="resetandadd" and merge="add" attributes to their <state> definitions when inheriting from button_ct_entry_token_decorator_base.
[*] CoreRPG Window Layout: Added <left> anchor offsets to windowmenubar_referencelist, windowmenubar_tokenbag, and windowmenubar_storybox to prevent left-side titlebar toolbar buttons from clipping off the left window edge, and restored <disabled /> on anchor_content_charsheethelper_top/bottom.
[*] Old School Essentials & AD&D 2E: Removed white alternating row stripes from OSE (list_abilities, charsheet_classes) to match the uniform Hearth list styling across rulesets, and updated dnd2e_compilation.xml (cta_skills_host) <child> overrides to use merge="resetandadd" + merge="add".
[*] D&D 5E: Added merge="merge" to npc_importantdeath_label in npc_combat_top_2014 so the control is only modified when the Death Indicator extension is loaded.
[*] Extension Compatibility: Modernized the Author extension masterindexitem override to inherit from CoreRPG's string_listitem_center_noframe_static_linked without clobbering native link click/drag handlers, guarded its DB handlers so they only attach when Author is active, and removed the retired <close> template override from ct_theaterofmind_combat.
[*] Build & CI Validation: Added an automated FGU XML static validator to build.py and GitHub Actions (lint.yml) checking derived template multi-tag merge attributes, <child> resetandadd/add pairing, 9-slice frame bounds against PNG headers, asset/script file existence, and duplicate definitions.
[/LIST]

[COLOR=#FF8C00][SIZE=4][B]Update to v2.9.58 - Torchbearer[/B][/SIZE][/COLOR]

[COLOR="#FF0000"][B]Changelog[/B][/COLOR]
[LIST]
[*] Old School Essentials (Official Ruleset): Added dedicated ruleset support (ose_compilation.xml) separated from legacy OSE2, including a Hearth-colored Turn Tracker torch sidebar icon (token_torch), character sheet header buffer and 515x700 sizing, readable ability effect score colors (#FFF0CA/#63ED63/#FF4F4F), high-contrast sky-blue Temp HP (#69B7FF) on the Character Sheet and Combat Tracker, dark ct_subgroupbox frame, sheetlabel_ct font, and Hearth alternating row shading.
[*] Daggerheart: Added dedicated ruleset support (daggerheart_compilation.xml) with custom dark-interior shield frames for Trait Totals, Evasion, and Armor, high-contrast counter icons for Proficiency, Hope, HP, and Stress, 9 Hearth-colored sidebar record icons, and dark font contrast overrides.
[*] Swords & Wizardry: Added dedicated ruleset support (sw_compilation.xml) with custom combat roll icons (Initiative, Surprise, Turn Undead), font contrast overrides, dark field backgrounds on Class and Spell records, and sky-blue CT Temp HP (#69B7FF).
[*] XCore: Added dedicated ruleset support (xcore_compilation.xml) with custom gear/editor icons (cog, calc, label, smalldice), dark frame overrides (simple_brown, simple_blue, fieldred, fieldlight_copy), and dark header/field overrides for Arrays, Character Sheet roll sections, Rolls, and Items.
[*] OSE2: Fixed class_detail level_label control type (<stringcontrol> instead of hidden <hn> numberfield) so the level label remains visible, and aligned spelllevel control tag in npc_spells_detail_ct.
[*] Mongoose Traveller 2E (MGT2): Added charspacecraft-sheetlabel (#DDDDDD) and charspacecraft-sheetinline (#FFF0CA) font overrides to fix unreadable black text on spacecraft sheets.
[*] Extension Scoping: Scoped Cyberpunk RED ThemeManager script and ICRPG graphics include to their respective rulesets so they no longer overwrite global sidebar record icon colors or pollute other rulesets.
[*] CoreRPG & Sidebar Icons: Recolored the bottom sidebar expand/collapse arrow buttons (sidebar_action_expand / sidebar_action_collapse) to #FFF0CA to match the rest of the sidebar across all rulesets, added 5 additional sidebar record icons (array, location, magic, occupation, picture), restored dynamic active/disabled color toggling on CT token decorator buttons, restored name="title" and <disabled /> on windowtitlebar, and added Shield HP / field error UI color definitions.
[*] CoreRPG / 5E: Mapped Hearth rest icons to native CoreRPG menu_rest* radial icon names and removed obsolete 5E charsheet radial rest menu overrides.
[*] Typography & Fonts: Added Giant language font (#DDDDDD) for OSE/OSE2 chat legibility, standardized record/image/npc/story header fonts onto bundled Roboto Bold, and removed duplicate font/frame/icon definitions.
[*] Extension & Multi-Ruleset Safety: Added nil-safety guards and local variable scoping to masterindexitem, MNMStats, and 3.5E/PFRPG inventory armor penalty scripts.
[*] Build, CI & Package Size: Pruned 181 unreferenced font/graphic assets (~1.89 MB) and 3 empty ruleset XML stubs, fixed ConvertColors.ps1 PowerShell syntax, and expanded Luacheck CI to cover rulesets/scripts and Hearth-Edition-Dev.
[/LIST]

[COLOR=#FF8C00][SIZE=4][B]Update to v2.9.57 - Torchbearer[/B][/SIZE][/COLOR]

[COLOR="#FF0000"][B]Changelog[/B][/COLOR]
[LIST]
[*] CoreRPG: Modernized against CoreRPG 4.8.0+. Safely removed 50+ dead templates inheriting from retired FGU base templates (close_*, help_*, button_window_size*).
[*] CoreRPG: Consolidated ct_entry merge with ct_entry_colors.lua and cleaned dicetower bounds layout conflict.
[*] 2E: Fixed dark text in character sheet abilities section by adding font definitions for abilityscore_box (#FFF0CA), abilityscore_box_mini (#DDDDDD), and abilityfields (#DDDDDD).
[*] 2E: Explicitly scoped AD&D font definitions in extension.xml to the 2E ruleset.
[*] 2E: Fixed Attack Matrix column and number contrast on the Combat/Actions tab with theme-aligned dark tiles and warm ember highlight for AC 0.
[*] 2E: Fixed Kit placeholder label overlap on character sheet when a kit is populated.
[*] 2E: Added anchor_content_charsheet_tabbed_top template to eliminate character sheet header/portrait clipping into the top window menubar.
[*] 2E: Fixed cta_skills_host alternating row colors using native FGU XML indexed child merging.
[*] OSE2: Added anchor_content_charsheet_tabbed_top template with right-side buffer and window size tuning for clean character sheet header spacing.
[*] PFRPG2: Unified char_actions_quickref script blocks to ensure temphp, wounded, and dying labels all recolor without script overwrites.
[*] 5E: Removed obsolete power action radial overrides to restore native CoreRPG 4.x power action radial submenus.
[*] CoC7E: Added explicit ruleset scoping to extension include and removed dead templates.
[*] Graphics: Modernized radial menus to native FGU vector rendering; consolidated duplicate font, frame, and icon definitions; isolated ruleset-specific icons (2E, SFRPG).
[*] FGU Compatibility: Fixed frame slice bounds across reference-section, reference-chapter, campaignlist_tables, tabs_h, tabs_elo, and acicon to ensure 100% compliance with FGU 5.1.14+ strict frame validation.
[/LIST]

[COLOR=#FF8C00][SIZE=4][B]Update to v2.9.56 - Torchbearer[/B][/SIZE][/COLOR]

[COLOR="#FF0000"][B]Changelog[/B][/COLOR]
[LIST]
[*] CoreRPG: Fixed a positioning offset typo in the chat share button template.
[*] FGU Extension: Chained the hotkey drop callback hook to prevent collisions with other extensions.
[*] Mongoose Traveller 2E (MGT2): Aligned Combat Tracker NPC rows immediately on tracker startup.
[*] Build System: Modernized build/zipping scripts and replaced them with a cross-platform Python build script.
[/LIST]

[COLOR=#FF8C00][SIZE=4][B]Update to v2.9.55 - Torchbearer[/B][/SIZE][/COLOR]

[COLOR="#FF0000"][B]Changelog[/B][/COLOR]
[LIST]
[*] Mongoose Traveller 2E (MGT2): refined the client (player) Combat Tracker header so the END / STR / DEX labels line up with their data columns and the Name label sits over the name column.
[*] Mongoose Traveller 2E (MGT2): adjusted the host (GM) Combat Tracker header bar position and lined the visibility icon up with the per-actor row icons.
[*] Mongoose Traveller 2E (MGT2): on dead/dying NPC rows, the faction icon is now hidden while the delete (trash) button is shown, so the Init/Mod/END/STR/DEX columns stay aligned with live rows. MGT2-only; no effect on any other ruleset.
[*] Repository maintenance: the local Claude tooling folder (.claude/) is now ignored by git and no longer tracked.
[/LIST]

[COLOR=#FF8C00][SIZE=4][B]Update to v2.9.52 - Torchbearer[/B][/SIZE][/COLOR]

[COLOR="#FF0000"][B]Changelog[/B][/COLOR]
[LIST]
[*] 5E Life Ledger extension compatibility: the theme now owns the 5E Combat Tracker header column order (Init, HP, Tmp, Wnd/Cur) so it stays predictable when Life Ledger is installed. The labels are rebuilt cleanly to fix the column chain that Life Ledger reshuffles, on both the host and client headers.
[*] Reproduced Life Ledger's Wnd/Cur header toggle so the re-emitted wounds label follows the HP Display (HPDM) option instead of staying stuck on "Wnd". This is a no-op when Life Ledger isn't installed.
[*] Added Mongoose Traveller 2E (MGT2) support with a Traveller-specific client Combat Tracker header margin so the player CT header lines up with the data columns below it.
[/LIST]

[COLOR="#FF0000"][B]Download:[/B][/COLOR]

Fantasy Grounds Forge (Recommended)
(Run an update using the FG Client if you're already subscribed):
https://forge.fantasygrounds.com/shop/items/12/view

GitHub:
https://github.com/SirMotte/FGU-Theme-Hearth/releases
