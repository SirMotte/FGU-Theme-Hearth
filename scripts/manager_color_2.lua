--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--
local originalHotkeyDrop;

function onInit()
	ColorManager.COLOR_FULL = "DDDDDD"; -- Replaceable Color: Usage Full
	ColorManager.COLOR_THREE_QUARTER = "FF6161"; -- Replaceable Color: Usage Three Quarter
	ColorManager.COLOR_HALF = "F29476"; -- Replaceable Color: Usage Half
	ColorManager.COLOR_QUARTER = "F5CE6C"; -- Replaceable Color: Usage One Quarter
	ColorManager.COLOR_EMPTY = "DDDDDD"; -- Replaceable Color: Usage Empty

	ColorManager.COLOR_GRADIENT_TOP = { r = 0, g = 0, b = 0 }; -- Replaceable Channels: Gradient Top
	ColorManager.COLOR_GRADIENT_MID = { r = 96, g = 0, b = 0 }; -- Replaceable Channels: Gradient Mid
	ColorManager.COLOR_GRADIENT_BOTTOM = { r = 255, g = 0, b = 0 }; -- Replaceable Channels: Gradient Bottom

	ColorManager.COLOR_HEALTH_UNWOUNDED = "77CE77"; -- Replaceable Color: Healthy
	ColorManager.COLOR_HEALTH_DYING_OR_DEAD = "909090"; -- Replaceable Color: Dead
	ColorManager.COLOR_HEALTH_UNCONSCIOUS = "C7BAEB"; -- Replaceable Color: Unconscious

	ColorManager.COLOR_HEALTH_SIMPLE_WOUNDED = "77CE77"; -- Replaceable Color: Light Wounds
	ColorManager.COLOR_HEALTH_SIMPLE_BLOODIED = "FF6161"; -- Replaceable Color: Bloodied

	ColorManager.COLOR_HEALTH_LT_WOUNDS = "77CE77"; -- Replaceable Color: Light Wounds
	ColorManager.COLOR_HEALTH_MOD_WOUNDS = "F5CE6C"; -- Replaceable Color: Moderate Wounds
	ColorManager.COLOR_HEALTH_HVY_WOUNDS = "F29476"; -- Replaceable Color: Heavy Wounds
	ColorManager.COLOR_HEALTH_CRIT_WOUNDS = "FF6161"; -- Replaceable Color: Critical Wounds

	ColorManager.COLOR_HEALTH_GRADIENT_TOP = { r = 0, g = 128, b = 0 }; -- Replaceable Channels: Health Gradient Top
	ColorManager.COLOR_HEALTH_GRADIENT_MID = { r = 210, g = 112, b = 23 }; -- Replaceable Channels: Health Gradient Mid
	ColorManager.COLOR_HEALTH_GRADIENT_BOTTOM = { r = 192, g = 0, b = 0 }; -- Replaceable Channels: Health Gradient Bottom

	ColorManager.COLOR_TOKEN_HEALTH_UNWOUNDED = "00C000"; -- Replaceable Color: Token Healthy
	ColorManager.COLOR_TOKEN_HEALTH_DYING_OR_DEAD = "909090"; -- Replaceable Color: Token Dead
	ColorManager.COLOR_TOKEN_HEALTH_UNCONSCIOUS = "C7BAEB"; -- Replaceable Color: Token Unconscious

	ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED = "80C000"; -- Replaceable Color: Token Light Wounds
	ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED = "FF0000"; -- Replaceable Color: Token Bloodied

	ColorManager.COLOR_TOKEN_HEALTH_LT_WOUNDS = "80C000"; -- Replaceable Color: Token Light Wounds
	ColorManager.COLOR_TOKEN_HEALTH_MOD_WOUNDS = "FFC000"; -- Replaceable Color: Token Moderate Wounds
	ColorManager.COLOR_TOKEN_HEALTH_HVY_WOUNDS = "FF6000"; -- Replaceable Color: Token Heavy Wounds
	ColorManager.COLOR_TOKEN_HEALTH_CRIT_WOUNDS = "FF0000"; -- Replaceable Color: Token Critical Wounds

	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_TOP = { r = 0, g = 192, b = 0 }; -- Replaceable Channels: Token Gradient Top
	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID = { r = 255, g = 192, b = 0 }; -- Replaceable Channels: Token Gradient Mid
	ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM = { r = 255, g = 0, b = 0 }; -- Replaceable Channels: Token Gradient Bottom

	ColorManager.COLOR_ADJUSTED_HP = "D592FF"; -- Replaceable Color: Adjusted HP
	ColorManager.COLOR_TEMP_HP = "69B7FF"; -- Replaceable Color: Temporary HP
	ColorManager.COLOR_HEALTH_SHIELD = "69B7FF"; -- Replaceable Color: Temporary HP
	ColorManager.COLOR_TOKEN_HEALTH_SHIELD = "69B7FF"; -- Replaceable Color: Temporary HP
	ColorManager.COLOR_PRIMARY_FOREGROUND = "FFF0CA";  -- Replaceable Color: Primary Foreground
	ColorManager.COLOR_SECONDARY_FOREGROUND = "DDDDDD"; -- Replaceable Color: Secondary Foreground
	ColorManager.COLOR_CALENDAR_BACKGROUND = "473C33"; -- Replaceable Color: Calendar Background
	ColorManager.COLOR_CALENDAR_HOLIDAY = "F2AB76"; -- Replaceable Color: Calendar Holiday
	ColorManager.COLOR_CALENDAR_MONTH = "FF6161"; -- Replaceable Color: Calendar Month

	ColorManager.COLOR_MODIFIED_VALUE = "F3D876"; -- Replaceable Color: Modified VALUE

	if ColorManager.setUIColor then
		ColorManager.setUIColor("field_error", "FF6161");

		ColorManager.setUIColor("usage_full", ColorManager.COLOR_FULL);
		ColorManager.setUIColor("usage_3quarter", ColorManager.COLOR_THREE_QUARTER);
		ColorManager.setUIColor("usage_half", ColorManager.COLOR_HALF);
		ColorManager.setUIColor("usage_1quarter", ColorManager.COLOR_QUARTER);
		ColorManager.setUIColor("usage_empty", ColorManager.COLOR_EMPTY);
		ColorManager.setUIColor("usage_gradient_top", ColorManager.COLOR_GRADIENT_TOP);
		ColorManager.setUIColor("usage_gradient_mid", ColorManager.COLOR_GRADIENT_MID);
		ColorManager.setUIColor("usage_gradient_bottom", ColorManager.COLOR_GRADIENT_BOTTOM);

		ColorManager.setUIColor("health_unwounded", ColorManager.COLOR_HEALTH_UNWOUNDED);
		ColorManager.setUIColor("health_dyingordead", ColorManager.COLOR_HEALTH_DYING_OR_DEAD);
		ColorManager.setUIColor("health_unconscious", ColorManager.COLOR_HEALTH_UNCONSCIOUS);
		ColorManager.setUIColor("health_simple_wounded", ColorManager.COLOR_HEALTH_SIMPLE_WOUNDED);
		ColorManager.setUIColor("health_simple_bloodied", ColorManager.COLOR_HEALTH_SIMPLE_BLOODIED);
		ColorManager.setUIColor("health_wounds_light", ColorManager.COLOR_HEALTH_LT_WOUNDS);
		ColorManager.setUIColor("health_wounds_moderate", ColorManager.COLOR_HEALTH_MOD_WOUNDS);
		ColorManager.setUIColor("health_wounds_heavy", ColorManager.COLOR_HEALTH_HVY_WOUNDS);
		ColorManager.setUIColor("health_wounds_critical", ColorManager.COLOR_HEALTH_CRIT_WOUNDS);
		ColorManager.setUIColor("health_gradient_top", ColorManager.COLOR_HEALTH_GRADIENT_TOP);
		ColorManager.setUIColor("health_gradient_mid", ColorManager.COLOR_HEALTH_GRADIENT_MID);
		ColorManager.setUIColor("health_gradient_bottom", ColorManager.COLOR_HEALTH_GRADIENT_BOTTOM);
		ColorManager.setUIColor("health_shield", ColorManager.COLOR_HEALTH_SHIELD);

		ColorManager.setUIColor("token_health_unwounded", ColorManager.COLOR_TOKEN_HEALTH_UNWOUNDED);
		ColorManager.setUIColor("token_health_dyingordead", ColorManager.COLOR_TOKEN_HEALTH_DYING_OR_DEAD);
		ColorManager.setUIColor("token_health_unconscious", ColorManager.COLOR_TOKEN_HEALTH_UNCONSCIOUS);
		ColorManager.setUIColor("token_health_simple_wounded", ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_WOUNDED);
		ColorManager.setUIColor("token_health_simple_bloodied", ColorManager.COLOR_TOKEN_HEALTH_SIMPLE_BLOODIED);
		ColorManager.setUIColor("token_health_wounds_light", ColorManager.COLOR_TOKEN_HEALTH_LT_WOUNDS);
		ColorManager.setUIColor("token_health_wounds_moderate", ColorManager.COLOR_TOKEN_HEALTH_MOD_WOUNDS);
		ColorManager.setUIColor("token_health_wounds_heavy", ColorManager.COLOR_TOKEN_HEALTH_HVY_WOUNDS);
		ColorManager.setUIColor("token_health_wounds_critical", ColorManager.COLOR_TOKEN_HEALTH_CRIT_WOUNDS);
		ColorManager.setUIColor("token_health_gradient_top", ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_TOP);
		ColorManager.setUIColor("token_health_gradient_mid", ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_MID);
		ColorManager.setUIColor("token_health_gradient_bottom", ColorManager.COLOR_TOKEN_HEALTH_GRADIENT_BOTTOM);
		ColorManager.setUIColor("token_health_shield", ColorManager.COLOR_TOKEN_HEALTH_SHIELD);

		ColorManager.setUIColor("calendar_month", ColorManager.COLOR_CALENDAR_MONTH);
		ColorManager.setUIColor("calendar_day", ColorManager.COLOR_PRIMARY_FOREGROUND);
	end

	if ActorHealthManager and ActorHealthManager.registerDefaultStatusHealthColors then
		ActorHealthManager.registerDefaultStatusHealthColors();
		if User.getRulesetName() == "Daggerheart" and ActorHealthManager.registerStatusHealthColor then
			ActorHealthManager.registerStatusHealthColor(ActorHealthManager.STATUS_UNCONSCIOUS, ColorManager.getUIColor("health_dyingordead"));
		end
	end

	ColorManager.setWindowMenuIconColor(ColorManager.COLOR_SECONDARY_FOREGROUND); -- Set the icon color of window toolbars
	ColorManager.setButtonIconColor(ColorManager.COLOR_SECONDARY_FOREGROUND);
	ColorManager.setButtonTextColor(ColorManager.COLOR_SECONDARY_FOREGROUND);

	if not Bartender then
		if Interface.addKeyedEventHandler then
			Interface.addKeyedEventHandler("onHotkeyDrop", "", onHotkeyDrop);
		else
			originalHotkeyDrop = Interface.onHotkeyDrop;
			Interface.onHotkeyDrop = onHotkeyDrop;
		end
	end

	if ColorManagerKw then
		ColorManagerKw.COLOR_UNIT_SELECTION = "322C27"; -- Replaceable Color: Unit Selection
	end
end

function onHotkeyDrop(dragdata)
	local bReturn;
	if originalHotkeyDrop then
		bReturn = originalHotkeyDrop(dragdata);
	end
	if (dragdata.getDescription() or "") ~= "" then
		dragdata.setIcon("empty");
	end
	return bReturn;
end
