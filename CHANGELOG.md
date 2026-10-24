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
