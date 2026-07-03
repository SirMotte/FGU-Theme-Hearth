-- luacheck configuration for FGU Theme Hearth

-- Global variables defined by FGU and local scripts
globals = {
    "ColorManager",
    "ColorManagerKw",
    "Interface",
    "Bartender",
    "onInit",
    "onHotkeyDrop"
}

-- Allow setting global variables at the top level
allow_defined_top = true

-- Suppress warning 131 (unused global variables - common for FGU callbacks like onInit)
ignore = { "131" }

-- Disable max line length warning (common in color theme declarations)
max_line_length = false
