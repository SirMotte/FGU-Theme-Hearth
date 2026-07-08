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
