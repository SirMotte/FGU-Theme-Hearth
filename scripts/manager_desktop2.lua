--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

local _cDockCategoryIconColor = "FFF0CA"; -- Replaceable Color: Primary Foreground
local _cDockCategoryTextColor = "FFF0CA"; -- Replaceable Color: Primary Foreground
local _cDockIconColor = "DDDDDD"; -- Replaceable Color: Secondary Foreground
local _cDockTextColor = "DDDDDD"; -- Replaceable Color: Secondary Foreground

function onInit()
	ColorManager.setSidebarCategoryIconColor(_cDockCategoryIconColor);
	ColorManager.setSidebarCategoryTextColor(_cDockCategoryTextColor);
	ColorManager.setSidebarRecordIconColor(_cDockIconColor);
	ColorManager.setSidebarRecordTextColor(_cDockTextColor);
end
