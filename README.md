# Sir Motte's Magnificent Darkness - Hearth Edition

Current Version: 2.9.55 - Torchbearer  
Release Date: June 25, 2026 - [Latest Changelog](https://www.fantasygrounds.com/forums/showthread.php?58034-Theme-SirMottes-Magnificent-Darkness&p=705296#post705296)

Original author: Sir Motte  
Maintainer: Justin Freitas

This is a Theme Extension for the [Fantasy Grounds Virtual Tabletop](https://www.fantasygrounds.com/).

![Showcase](https://user-images.githubusercontent.com/82598692/214700861-9e55f3c0-1541-41c6-b1fc-d6bd61e0ec5f.png)

Please relay questions and issue reports to [JustinFreitas](https://www.fantasygrounds.com/forums/member.php?34294-JustinFreitas).
You can still contact Sir_Motte, preferably on Discord, but he is, for now, no longer actively involved.

## Supported Rulesets (to varying degrees)

- Dungeons & Dragons 5E
- Dungeons & Dragons Classic / AdnD / 2E
- Dungeons & Dragons 3.5E
- Dungeons & Dragons 4E
- Pathfinder 1E
- Pathfinder 2E (and Legacy)
- XCore
- Cypher System
- Cyberpunk Red
- OSE2
- Mongoose Traveller 2E
- Other Rulesets might work surprisingly well, please test them and possibly report your findings.

## Special Contributors

- [MeAndUnique](https://github.com/MeAndUnique)
- [Saagael](https://github.com/Gtaray)
- [JustinFreitas](https://forge.fantasygrounds.com/crafter/60/view-profile) - Current Maintainer
- [bmos](https://github.com/bmos)
- [Zarestia](https://github.com/ZarestiaDev)
- Unofficial Developers Guild

## Foreword

Developed to reduce eye strain during low-light use of FGU while aligning with established visual‑UI principles and the creator’s preferences, this theme emphasizes a clean, flat UI and strong readability.

## Features

- Reduced dark color palette
- 7:1 value contrast for readable text even at small font sizes
- Redesigned UI: no soft edges, 3D effects, or textures — simple, flat, and clean
- Fonts replaced with Roboto Sans
- Adjusted font sizes and colors for consistency and legibility
- Color‑coded action buttons for faster recognition
- Enhanced radial menu with additional unique icons (thanks to Saagael and MeAndUnique)
- Hotkey bar improvements: no distracting link icons (implemented by MeAndUnique)
  Note: previously placed hotkey links must be re-linked to remove existing icons

## Compatibility Information & Known Problems

This theme uses a high load order of 1500 so it can overwrite most extensions’ UI elements. Any extension that should override this theme must set its load order to 1501 or higher in its extension.xml

- Font extensions (e.g. by Mattekure) — may revert text color to black, making it hard to read.
- Console warnings — you may see [Warning] entries related to this theme; these are harmless and indicate an unsupported extension. [ERROR] entries are serious; please report any errors mentioning this theme.
- Chat Aesthetics Configurator (by Drowbe, maintained by rhagelstrom) — its font and chat color settings conflict with this theme. If you use it, set the configurator to default color in its settings.
- PFRPG2 ruleset — if used, restart both the client and the launcher after installing the theme; otherwise action icons may not display.
- Author extension by Celestian — currently causes storyframe list entries to appear black and hard to read. Avoid using the theme during world building while Author is enabled.

## Installation - Forge (Recommended)

1. Subscribe to the FG Forge item: <https://forge.fantasygrounds.com/shop/items/12/view> and update your Fantasy Grounds client.
2. On your campaign's Details page, enable the extension listed as **Theme: Hearth** in the **Extensions** section, then launch the campaign.
3. Done — enjoy the theme!

## Installation — Manual (GitHub)

1. Download the theme from GitHub: <https://github.com/SirMotte/FGU-Theme-Hearth/releases>
2. Move the file named `Theme_SirMotte_Hearth.ext` into the `Extensions` folder inside your Fantasy Grounds Data directory.
3. On your campaign's Details page, enable the extension listed as **Theme: Hearth** in the **Extensions** section, then launch the campaign.
4. Done — enjoy the theme!

## Customization Bonus Extension

- To customize your GM icon, download the GM Icon Replacer extension and follow its README: <https://github.com/SirMotte/FGU-GM-Icon-Replacer/blob/GM-Icon_Replacer-Main/README.md>.

Enjoy!
Sir Motte

## Changelog History

- 2.9.49 - Torchbearer - Frame adjustments, UI templates, and documentation sync.
- 2.9.50 - Torchbearer - Fix for Global Effects button in top bar of Combat Tracker.
- 2.9.51 - Torchbearer - Combat Tracker Global Effects header rework (safe full-width method). ICRPG and Cyberpunk Red font path fixes. Arcane Ward pactmagic pressed icon fix.
- 2.9.52 - Torchbearer - 5E Life Ledger extension compatibility for the Combat Tracker header column order (Init, HP, Tmp, Wnd/Cur) with Wnd/Cur HPDM toggle support. Added Mongoose Traveller 2E (MGT2) support with a Traveller-specific client CT header margin.
- 2.9.53 - Torchbearer - Image pane highlight color change.
- 2.9.54 - Torchbearer - Reverted the image pane color back to the 2.9.52 color since FGU is providing the fix for the highlight color in the layers pane.
- 2.9.55 - Torchbearer - MGT2 client CT header alignment refinement (END/STR/DEX labels and Name), host CT header repositioning with visibility icon aligned to row icons, and dead/dying NPC rows now hide the faction icon while the delete button shows so columns stay aligned (MGT2-only). Repo maintenance: ignore the local .claude/ tooling folder in git.

## Credits

A number of icons are derived from the [ByteDance Open Source Icon Library](https://iconpark.bytedance.com/official). They were heavily modified but provided a valuable starting point.
