-- Override ThemeManager script used by Cyberpunk RED ruleset
isThemeLoaded = false;

local ZERO_OFFSET = { 0, 0, 0, 0 };

local function setControlFrame(control, sFrame, tOffset)
	if not control then
		return;
	end
	tOffset = tOffset or ZERO_OFFSET;
	control.setFrame(sFrame, tOffset[1] or 0, tOffset[2] or 0, tOffset[3] or 0, tOffset[4] or 0);
end

local function setControlStateFrame(control, sState, sFrame, tOffset)
	if not control then
		return;
	end
	tOffset = tOffset or ZERO_OFFSET;
	control.setStateFrame(sState, sFrame, tOffset[1] or 0, tOffset[2] or 0, tOffset[3] or 0, tOffset[4] or 0);
end

function onInit()
	ColorManager.setSidebarCategoryIconColor("FFF0CA");
	ColorManager.setSidebarRecordIconColor("DDDDDD");
end

function updateFont(control)
	if control then
		control.setColor("#DDDDDD");
	end
end

function updateFontTitle(control)
	if control then
		control.setColor("#FFF0CA");
	end
end

function updateRedLabel(control, readOnly)
	if control then
		ThemeManager.updateThemeFont["refBNotoWhite"](control);
		control.setColor("#DDDDDD");
	end
end


function setDefaultTheme(control, sCPRFrame, bAllowFocus, noTheme, theme)
	if bAllowFocus == nil then bAllowFocus = false; end

	-- Additional, if fielddark, add fieldfocus
	if bAllowFocus then
		setControlStateFrame(control, "keyedit", "fieldFocusSimple", noTheme);
		setControlStateFrame(control, "hover", "fieldFocusSimple", noTheme);
	end

	return false;
end

-- Map of frames to CoreRPG frames
frameToCore = {
	[""] = "",
	["fieldFrame"] = "fielddark",
	["fieldFrame_NPC"] = "fielddark",
	["border"] = "fielddark",
	["fieldSimple"] = "fieldlight",
	["fieldSimpleRed"] = "fieldlight",
	["fieldSimpleBlk"] = "fieldlight",
	["roleFrame"] = "",
	["thin_buttonup"] = "mini_name",
	["recordsheet_red"] = "recordsheet",
};

iconToCore = {
	["ddRightArrow"] = "arrow_sm_right",
	["ddDownArrow"] = "arrow_sm_down",
	["button_cyberdeck"] = "button_space",
	["button_cyberdeck_down"] = "button_space_down",
	["window_resize_red"] = "window_resize",
	["d10RollDown"] = "button_roll_down",
	["d10Roll"] = "button_roll",
}

function setDefaultIcon(control, sCPRIcon)
	if control and (sCPRIcon == "window_resize_red"
		or sCPRIcon == "window_resize"
		or sCPRIcon == "window_resize_filled") then
		control.setIcon("");
		return false;
	end

	return false;
end

function setDefaultStateIcons(control, sCPROffIcon, sCPROnIcon)
	return false;
end

function setDefaultButtonIcons(control, sCPRUpIcon, sCPRDownIcon)
	if sCPRUpIcon == "d10Roll" then
		local newUpIcon = iconToCore[sCPRUpIcon];
		local newDownIcon = iconToCore[sCPRDownIcon];

		if control and newUpIcon ~= nil and newDownIcon ~= nil then
			control.setStateIcons(0, newUpIcon, newDownIcon);
		end
		return true;
	else
		return false;
	end
end

function updateTabState(control, index, sSubwindow, sBaseDisplay, sThemeDisplay)
	return false;
end

function updateSpecialButton(control)
	updateFontTitle(control);
end

function updateIconColor(control)
	updateFontTitle(control);
end

updateFrameTheme = {
	["whiteFrameStandard"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if isReadOnly then
			if not isThemeLoaded then
				element.setFrame("fieldSimple", 5, 0, 5, 0);
			else
				element.setFrame("fieldlight", 10, 5, 10, 5);
			end
		else
			if not isThemeLoaded then
				element.setFrame("fieldSimpleEdit", 5, 0, 5, 0);
			else
				element.setFrame("fielddark", 10, 5, 10, 5);
			end
		end
	end,

	["fieldSimpleStatic"] = function(element, offset)
		setControlFrame(element, "fieldSimple", offset);
	end,
	["fieldStaticBlk"] = function(element, noTheme, theme)
		updateFontTitle(element);
	end,
	["fieldFramePC"] = function(element)
		updateFont(element);
	end,
	["fieldFramePC_darkenLight"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "darkenField", noTheme);
		else
			setControlFrame(element, "fieldlight", theme);
		end
	end,
	["fieldFramePC_BG"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "fieldFrame", noTheme);
		else
			setControlFrame(element, "fieldlight", theme);
		end
	end,
	["fieldFramePC_DarkenEdit"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "darkenFieldEdit", noTheme);
			setControlStateFrame(element, "hover", "fieldFocusSimple", noTheme);
			setControlStateFrame(element, "keyedit", "fieldFocusSimple", noTheme);
		else
			setControlFrame(element, "fielddark", theme);
			setControlStateFrame(element, "hover", "fieldfocus", theme);
			setControlStateFrame(element, "keyedit", "fieldfocus", theme);
		end
	end,
	["fieldFramePC_Simple"] = function(element, noTheme, theme, bReadOnly)
		if bReadOnly == nil then bReadOnly = true; end
		if not isThemeLoaded then
			setControlFrame(element, "fieldSimple", noTheme);
		else
			if bReadOnly then
				setControlFrame(element, "fieldlight", theme);
			else
				setControlFrame(element, "fielddark", theme);
			end
		end
		if not bReadOnly then
			if not isThemeLoaded then
				setControlStateFrame(element, "hover", "fieldFocusSimple", noTheme);
				setControlStateFrame(element, "keyedit", "fieldFocusSimple", noTheme);
			else
				setControlStateFrame(element, "hover", "fieldfocus", theme);
				setControlStateFrame(element, "keyedit", "fieldfocus", theme);
			end
		elseif element then
			element.setStateFrame("hover", nil, 0,0,0,0);
			element.setStateFrame("keyedit", nil, 0,0,0,0);
		end
	end,
	["fieldFramePC_ListSimple"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "fieldSimple", noTheme);
		else
			setControlFrame(element, "combobox_list", theme);
		end
	end,
	["fieldFramePC_ListRed"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "fieldSimpleRed", noTheme);
		else
			setControlFrame(element, "combobox_list", theme);
		end
	end,
	["fieldFramePC_ListBlack"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "fieldSimpleBlk", noTheme);
		else
			setControlFrame(element, "combobox_list", theme);
		end
	end,
	["fieldFramePC_ListSimpleElem"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "fieldSimple", noTheme);
		else
			setControlFrame(element, "mini_name", theme);
		end
	end,
	["fieldFramePC_ListSimpleLink"] = function(element, noTheme)
		if not isThemeLoaded then
			setControlFrame(element, "fieldSimple", noTheme);
		elseif element then
			element.setFrame(nil);
		end
	end,
	["fieldFrameNPC"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if isReadOnly then
			if not isThemeLoaded then
				element.setFrame("fieldFrame_NPC", 5, 8, 5, 3);
			else
				element.setFrame("fieldlight", 10, 13, 10, 5);
			end
		else
			if not isThemeLoaded then
				element.setFrame("fieldFrame_NPCEdit", 5, 8, 5, 3);
			else
				element.setFrame("fielddark", 10, 13, 10, 5);
			end
		end
	end,
	["frameSpecialStatic"] = function(element, sInNoTheme, sInTheme, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, sInNoTheme, noTheme);
		else
			setControlFrame(element, sInTheme, theme);
		end
	end,
	["darkFrameNPCSkill"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if isReadOnly then
			if not isThemeLoaded then
				element.setFrame("", 5, 0, 5, 0);
			else
				element.setFrame("", 0, 0, 0, 0);
			end
			element.setStateFrame("hover", nil, 0 ,0, 0, 0);
			element.setStateFrame("keyedit", nil, 0, 0, 0, 0);
		else
			if not isThemeLoaded then
				element.setFrame("darkenFieldEdit", 5, 0, 5, 0);
				element.setStateFrame("hover", "fieldFocusSimple", 5, 0, 5, 0);
				element.setStateFrame("keyedit", "fieldFocusSimple", 5, 0, 5, 0);
			else
				element.setFrame("fielddark", 7, 5, 7, 5);
				element.setStateFrame("hover", "fieldfocus", 7, 5, 7, 5);
				element.setStateFrame("keyedit", "fieldfocus", 7, 5, 7, 5);
			end
		end
	end,
	["darkFrameNPCSkillNum"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if isReadOnly then
			if not isThemeLoaded then
				element.setFrame("", 5, 0, 5, 0);
			else
				element.setFrame("", 0, 0, 0, 0);
			end
			element.setStateFrame("hover", nil, 0 ,0, 0, 0);
			element.setStateFrame("keyedit", nil, 0, 0, 0, 0);
		else
			if not isThemeLoaded then
				element.setFrame("darkenFieldEdit", 0, 0, 0, 0);
				element.setStateFrame("hover", "fieldFocusSimple", 0, 0, 0, 0);
				element.setStateFrame("keyedit", "fieldFocusSimple", 0, 0, 0, 0);
			else
				element.setFrame("fielddark", 5, 5, 5, 5);
				element.setStateFrame("hover", "fieldfocus", 5, 5, 5, 5);
				element.setStateFrame("keyedit", "fieldfocus", 5, 5, 5, 5);
			end
		end
	end,
	["darkFrameStandard"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if isThemeLoaded then
			if isReadOnly then
				element.setFrame("fieldlight", 7, 5, 7, 5);
			else
				element.setFrame("fielddark",  7, 5, 7, 5);
			end
		else
			if isReadOnly then
				element.setFrame("darkenField", 5, 0, 5, 0);
			else
				element.setFrame("darkenFieldEdit", 5, 0, 5, 0);
			end
		end
	end,
	["darkFrameStandardOffset"] = function(element, isReadOnly, noTheme, theme)
		if isThemeLoaded then
			if isReadOnly then
				setControlFrame(element, "fieldlight", theme);
			else
				setControlFrame(element, "fielddark", theme);
			end
		else
			if isReadOnly then
				setControlFrame(element, "darkenField", noTheme);
			else
				setControlFrame(element, "darkenFieldEdit", noTheme);
			end
		end
	end,
	["darkFrameDice"] = function(element, isReadOnly, isEmpty)
		if not element then
			return;
		end
		if isReadOnly and isEmpty then
			if not isThemeLoaded then
				element.setFrame("darkenFullDice", 0, 0, 0, 0);
			else
				element.setFrame("fielddice", 5, 5, 5, 5);
			end
		elseif not isReadOnly and isEmpty then
			if not isThemeLoaded then
				element.setFrame("darkenFullDiceEdit", 0, 0, 0, 0);
			else
				element.setFrame("fielddice", 5, 5, 5, 5);
			end
		elseif isReadOnly then
			if not isThemeLoaded then
				element.setFrame("darkenField", 0, 0, 0, 0);
			else
				element.setFrame("fielddice", 5, 5, 5, 5);
			end
		else
			if not isThemeLoaded then
				element.setFrame("darkenFieldEdit", 0, 0, 0, 0);
			else
				element.setFrame("fielddice", 5, 5, 5, 5);
			end
		end
	end,
	["simpleFrameDice"] = function(element, isReadOnly, isEmpty)
		if not element then
			return;
		end
		if isReadOnly and isEmpty then
			if not isThemeLoaded then
				element.setFrame("fieldSimpleDiceEdit", 0, 0, 0, 0);
			else
				element.setFrame("fielddice", 5, 5, 5, 5);
			end
		elseif not isReadOnly and isEmpty then
			if not isThemeLoaded then
				element.setFrame("fieldSimpleDiceEdit", 0, 0, 0, 0);
			else
				element.setFrame("fielddice", 5, 5, 5, 5);
			end
		elseif isReadOnly then
			if not isThemeLoaded then
				element.setFrame("fieldSimple", 0, 0, 0, 0);
			else
				element.setFrame("fielddice", 5, 5, 5, 5);
			end
		else
			if not isThemeLoaded then
				element.setFrame("fieldSimple", 0, 0, 0, 0);
			else
				element.setFrame("fielddice", 5, 5, 5, 5);
			end
		end
	end,
	["darkFrameNoOffset"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if isThemeLoaded then
			if isReadOnly then
				element.setFrame("fieldlight", 7, 5, 7, 5);
			else
				element.setFrame("fielddark",  7, 5, 7, 5);
			end
		else
			if isReadOnly then
				element.setFrame("darkenField", 0,0,0,0);
			else
				element.setFrame("darkenFieldEdit", 0,0,0,0);
			end
		end
	end,
	["darkFrameLarge"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if not isThemeLoaded and isReadOnly then
			element.setFrame("darkenField", 8, 8, 8, 8);
		elseif not isThemeLoaded then
			element.setFrame("darkenFieldEditLarge", 8, 8, 8, 8);
		elseif isThemeLoaded and isReadOnly then
			element.setFrame(nil, 0,0,0,0);
		else
			element.setFrame("fielddark", 7,5,7,5);
		end
	end,
	["darkFrameEmptyStatic"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, nil, noTheme);
		else
			setControlFrame(element, "darkenField", theme);
		end
	end,
	["roleFrame"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "roleFrame", noTheme);
		else
			setControlFrame(element, "combobox_list", theme);
		end
	end,
	["clearFrame"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if isReadOnly then
			element.setFrame(nil, 0, 0, 0, 0);
		else
			element.setFrame("fielddark", 7, 5, 7, 5);
		end
	end,
	["whiteFrameRedBGImgCheck"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if not isThemeLoaded and isReadOnly then
			element.setFrame("darkenField", 1, 1, 1, 1);
		elseif not isThemeLoaded then
			element.setFrame("fieldSimple", 1, 1, 1, 1);
		elseif isThemeLoaded and isReadOnly then
			element.setFrame(nil, 0,0,0,0);
		else
			element.setFrame("mini_name", 1,1,1,1);
		end
	end,
	["formattedFrame"] = function(element, isReadOnly)
		if not element then
			return;
		end
		if not isThemeLoaded and isReadOnly then
			element.setFrame("formattedTextFrame", 8, 8, 8, 8);
		elseif not isThemeLoaded then
			element.setFrame("formattedTextFrameEdit", 8, 8, 8, 8);
		elseif isThemeLoaded and isReadOnly then
			element.setFrame(nil, 0,0,0,0);
		else
			element.setFrame("fielddark", 7,5,7,5);
		end
	end,
	["formattedFrameRole"] = function(element)
		if not element then
			return;
		end
		if not isThemeLoaded then
			element.setFrame("formattedTextFrame", 8, 8, 8, 8);
		else
			element.setFrame("fielddark", 7,5,7,5);
		end
	end,
	["border"] = function(element, isReadOnly)
		if not isThemeLoaded or not element then return; end
		element.setFrame("fieldlight", 7, 5, 7, 5);
		if not isReadOnly then
			element.setFrame("fielddark", 7, 5, 7, 5);
			element.setStateFrame("hover", "fieldfocus", 7, 5, 7, 5);
		end
	end,
	["redFrameStandard"] = function(element, isReadOnly)
		updateRedLabel(element);
	end,
	["redFrameStandardGray"] = function(element, isReadOnly)
		if not element then
			return;
		end
		ThemeManager.updateThemeFont["refBNotoWhite"](element);
		if isThemeLoaded then
			element.setFrame("headerblack", 5,0,5,0);
		end
	end,
	["redFrameStandardList"] = function(element, isReadOnly)
		if isThemeLoaded and element then
			element.setFrame("darkenField");
		end
	end,
	["numFrame"] = function(element, noTheme, theme)
		if not isThemeLoaded then
			setControlFrame(element, "numFrame", noTheme);
		else
			setControlFrame(element, "fieldlight", theme);
		end
	end
}

local function setControlFont(element, sFont)
	if element then
		element.setFont(sFont);
	end
end

updateThemeFont = {
	["PCBodyFrame"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-b-12" or "sheetlabelmini");
	end,
	["refBNoto"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-b-15" or "reference-b");
	end,
	["refBNotoWhite"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-b-15-white" or "reference-b");
	end,
	["refHeadNoto48"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-48" or "reference-page-header");
	end,
	["refHeadNoto24"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-b-24" or "windowtitle");
	end,
	["notoWindowTitle"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-b-18-white" or "windowtitle");
	end,
	["noto18"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-18" or "windowtitle");
	end,
	["noto18normal"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-18" or "reference-b");
	end,
	["notoB18"] = function(element)
		setControlFont(element, not isThemeLoaded and "noto-b-18" or "reference-b");
	end,
	["noto15"] = function(element)
		if not isThemeLoaded or not element then return; end
		element.setFont("reference-r");
	end,
	["noto12"] = function(element)
		if not isThemeLoaded or not element then return; end
		if element.setDisplayFont then
			element.setDisplayFont("sheetlabelmini");
		else
			element.setFont("sheetlabelmini");
		end
	end,
}
