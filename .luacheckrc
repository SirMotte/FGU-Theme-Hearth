-- luacheck configuration for FGU Theme Hearth

-- Global variables defined by FGU, rulesets, and local scripts
globals = {
    -- CoreRPG / FGU Engine API
    "ActorManager",
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
    "adjhp",
    "createControl",
    "dying",
    "friendfoe",
    "getDatabaseNode",
    "hptemp",
    "idelete",
    "nonlethal",
    "registerMenuItem",
    "self",
    "super",
    "temphp",
    "window",
    "wounded",

    -- Script Lifecycle & Exports
    "createTHACOMatrix",
    "frameToCore",
    "iconToCore",
    "isThemeLoaded",
    "onClose",
    "onHealthChanged",
    "onHotkeyDrop",
    "onInit",
    "onValueChanged",
    "setDefaultButtonIcons",
    "setDefaultIcon",
    "setDefaultStateIcons",
    "setDefaultTheme",
    "update",
    "updateFont",
    "updateFontTitle",
    "updateFrameTheme",
    "updateIconColor",
    "updateRedLabel",
    "updateSpecialButton",
    "updateTabState",
    "updateThemeFont"
}

-- Allow setting global variables at the top level
allow_defined_top = true

-- Suppress warning 131 (unused global variables - common for FGU callbacks like onInit)
-- Suppress warning 212 (unused arguments - common in FGU interface callbacks)
ignore = { "131", "212" }

-- Disable max line length warning (common in color theme declarations)
max_line_length = false
