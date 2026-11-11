-- luacheck configuration for FGU Theme Hearth

-- Global variables defined by FGU, rulesets, and local scripts
globals = {
    -- CoreRPG / FGU Engine API
    "ActorHealthManager",
    "ActorManager",
    "AuthorManager",
    "Bartender",
    "ColorManager",
    "ColorManagerKw",
    "CombatManagerADND",
    "DataCommonADND",
    "DB",
    "Input",
    "Interface",
    "LibraryData",
    "MNMStats",
    "OptionsManager",
    "Session",
    "StringManager",
    "ThemeManager",
    "User",
    "UtilityManager",
    "WindowMenuManager",

    -- FGU Window / Control Context Globals
    "activitysections",
    "adjhp",
    "createControl",
    "dexterity",
    "dying",
    "dying_linked",
    "endurance",
    "friendfoe",
    "getDatabaseNode",
    "getName",
    "getValue",
    "hits",
    "hptemp",
    "hptemp_linked",
    "idelete",
    "label_day",
    "label_wounds",
    "link",
    "nonlethal",
    "registerMenuItem",
    "self",
    "setBackColor",
    "setColor",
    "setVisible",
    "status",
    "strength",
    "structure_damage",
    "super",
    "temp_hp",
    "temphp",
    "window",
    "wounded",
    "wounded_linked",

    -- Script Lifecycle & Exports
    "changeHealthDisplay",
    "createTHACOMatrix",
    "frameToCore",
    "iconToCore",
    "isThemeLoaded",
    "onClose",
    "onHealthChanged",
    "onHotkeyDrop",
    "onInit",
    "onSubchapterChanged",
    "onValueChanged",
    "recolorSectionLabel",
    "setDefaultButtonIcons",
    "setDefaultIcon",
    "setDefaultStateIcons",
    "setDefaultTheme",
    "setState",
    "update",
    "updateColorsForTheme",
    "updateFont",
    "updateFontTitle",
    "updateFrameTheme",
    "updateIconColor",
    "updatePreparedRunes",
    "updatePreparedTactics",
    "updateRedLabel",
    "updateSpecialButton",
    "updateTabState",
    "updateThemeFont",
    "updateVisibility"
}

-- Disallow setting undeclared global variables at the top level
allow_defined_top = false

-- Exclude build artifacts directory
exclude_files = { "out/**" }

-- Suppress warning 131 (unused global variables - common for FGU callbacks like onInit)
-- Suppress warning 212 (unused arguments - common in FGU interface callbacks)
ignore = { "131", "212" }

-- Disable max line length warning (common in color theme declarations)
max_line_length = false
