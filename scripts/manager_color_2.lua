-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
function onInit()
	ColorManager.COLOR_FULL = "DDDDDD";
	ColorManager.COLOR_THREE_QUARTER = "FF6161";
	ColorManager.COLOR_HALF = "F29476";
	ColorManager.COLOR_QUARTER = "F5CE6C";
	ColorManager.COLOR_EMPTY = "DDDDDD";

	ColorManager.COLOR_GRADIENT_TOP = { r = 0, g = 0, b = 0 };
	ColorManager.COLOR_GRADIENT_MID = { r = 96, g = 0, b = 0 };
	ColorManager.COLOR_GRADIENT_BOTTOM = { r = 255, g = 0, b = 0 };

	ColorManager.COLOR_HEALTH_UNWOUNDED = "77CE77";
	ColorManager.COLOR_HEALTH_DYING_OR_DEAD = "909090";
	ColorManager.COLOR_HEALTH_UNCONSCIOUS = "C7BAEB";

	ColorManager.COLOR_HEALTH_SIMPLE_WOUNDED = "77CE77";
	ColorManager.COLOR_HEALTH_SIMPLE_BLOODIED = "FF6161";

	ColorManager.COLOR_HEALTH_LT_WOUNDS = "77CE77";
	ColorManager.COLOR_HEALTH_MOD_WOUNDS = "F5CE6C";
	ColorManager.COLOR_HEALTH_HVY_WOUNDS = "F29476";
	ColorManager.COLOR_HEALTH_CRIT_WOUNDS = "FF6161";

	ColorManager.COLOR_HEALTH_GRADIENT_TOP = { r = 0, g = 128, b = 0 };
	ColorManager.COLOR_HEALTH_GRADIENT_MID = { r = 210, g = 112, b = 23 };
	ColorManager.COLOR_HEALTH_GRADIENT_BOTTOM = { r = 192, g = 0, b = 0 };

	ColorManager.COLOR_TOKEN_HEALTH_UNWOUNDED = "00C000";
	ColorManager.COLOR_TOKEN_HEALTH_DYING_OR_DEAD = "C0C0C0";
	ColorManager.COLOR_TOKEN_HEALTH_UNCONSCIOUS = "8C3BFF";

	ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED = "80C000";
	ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED = "FF0000";

	ColorManager.COLOR_TOKEN_HEALTH_LT_WOUNDS = "80C000";
	ColorManager.COLOR_TOKEN_HEALTH_MOD_WOUNDS = "FFC000";
	ColorManager.COLOR_TOKEN_HEALTH_HVY_WOUNDS = "FF6000";
	ColorManager.COLOR_TOKEN_HEALTH_CRIT_WOUNDS = "FF0000";

	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_TOP = { r = 0, g = 192, b = 0 };
	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID = { r = 255, g = 192, b = 0 };
	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM = { r = 255, g = 0, b = 0 };

	Interface.onHotkeyDrop = onHotkeyDrop;
end

function onHotkeyDrop(dragdata)
	if (dragdata.getDescription() or "") ~= "" then
		dragdata.setIcon("empty");
	end
end