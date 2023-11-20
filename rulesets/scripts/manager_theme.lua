-- Override ThemeManager script used by Cyberpunk RED ruleset
isThemeLoaded = false;

function onInit()
	ColorManager.setSidebarCategoryIconColor("FFF0CA");
	ColorManager.setSidebarRecordIconColor("FFF0CA");
end

function updateFont(control)
	control.setColor("#DDDDDD");
end

function updateFontTitle(control)
	control.setColor("#FFF0CA");
end

function updateRedLabel(control, readOnly)
	ThemeManager.updateThemeFont["refBNotoWhite"](control);
	control.setColor("#DDDDDD");
end


function setDefaultTheme(control, sCPRFrame, bAllowFocus, noTheme, theme)
	if theme == nil then theme = {0,0,0,0} end;
	if noTheme == nil then noTheme = {0,0,0,0} end;
	if bAllowFocus == nil then bAllowFocus = false; end
	
	-- Additional, if fielddark, add fieldfocus
	if bAllowFocus then
		control.setStateFrame("keyedit", "fieldFocusSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		control.setStateFrame("hover", "fieldFocusSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
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
	if sCPRIcon == "window_resize_red"
		or sCPRIcon == "window_resize"
		or sCPRIcon == "window_resize_filled" then
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
		
		if newUpIcon ~= nil and newDownIcon ~= nil then
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
		element.setFrame("fieldSimple", offset[1], offset[2], offset[3], offset[4]);
	end,
	["fieldStaticBlk"] = function(element, noTheme, theme) 
		updateFontTitle(element);
	end,
	["fieldFramePC"] = function(element) 
		updateFont(element);
	end,
	["fieldFramePC_darkenLight"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("darkenField", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("fieldlight", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["fieldFramePC_BG"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("fieldFrame", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("fieldlight", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["fieldFramePC_DarkenEdit"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("darkenFieldEdit", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
			element.setStateFrame("hover", "fieldFocusSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
			element.setStateFrame("keyedit", "fieldFocusSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("fielddark", theme[1], theme[2], theme[3], theme[4]);
			element.setStateFrame("hover", "fieldfocus", theme[1], theme[2], theme[3], theme[4]);
			element.setStateFrame("keyedit", "fieldfocus", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["fieldFramePC_Simple"] = function(element, noTheme, theme, bReadOnly)
		if bReadOnly == nil then bReadOnly = true; end
		if not isThemeLoaded then
			element.setFrame("fieldSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			if bReadOnly then
				element.setFrame("fieldlight", theme[1], theme[2], theme[3], theme[4]);
			else
				element.setFrame("fielddark", theme[1], theme[2], theme[3], theme[4]);
			end
		end
		if not bReadOnly then
			if not isThemeLoaded then 
				element.setStateFrame("hover", "fieldFocusSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
				element.setStateFrame("keyedit", "fieldFocusSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
			else
				element.setStateFrame("hover", "fieldfocus", theme[1], theme[2], theme[3], theme[4]);
				element.setStateFrame("keyedit", "fieldfocus", theme[1], theme[2], theme[3], theme[4]);
			end
		else
			element.setStateFrame("hover", nil, 0,0,0,0);
			element.setStateFrame("keyedit", nil, 0,0,0,0);
		end
	end,
	["fieldFramePC_ListSimple"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("fieldSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("combobox_list", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["fieldFramePC_ListRed"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("fieldSimpleRed", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("combobox_list", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["fieldFramePC_ListBlack"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("fieldSimpleBlk", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("combobox_list", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["fieldFramePC_ListSimpleElem"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("fieldSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("mini_name", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["fieldFramePC_ListSimpleLink"] = function(element, noTheme) 
		if not isThemeLoaded then
			element.setFrame("fieldSimple", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame(nil);
		end
	end,
	["fieldFrameNPC"] = function(element, isReadOnly) 
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
			element.setFrame(sInNoTheme, noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame(sInTheme, theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["darkFrameNPCSkill"] = function(element, isReadOnly) 
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
				element.setFrame("fieldlight", theme[1], theme[2], theme[3], theme[4]);
			else
				element.setFrame("fielddark",  theme[1], theme[2], theme[3], theme[4]);
			end
		else
			if isReadOnly then 
				element.setFrame("darkenField", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
			else
				element.setFrame("darkenFieldEdit", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
			end
		end
	end,
	["darkFrameDice"] = function(element, isReadOnly, isEmpty) 
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
			element.setFrame(nil, noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("darkenField", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["roleFrame"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("roleFrame", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("combobox_list", theme[1], theme[2], theme[3], theme[4]);
		end
	end,
	["clearFrame"] = function(element, isReadOnly) 
		if isReadOnly then 
			element.setFrame(nil, 0, 0, 0, 0); 
		else 
			element.setFrame("fielddark", 7, 5, 7, 5);
		end 
	end,
	["whiteFrameRedBGImgCheck"] = function(element, isReadOnly) 
	
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
		if not isThemeLoaded then 
			element.setFrame("formattedTextFrame", 8, 8, 8, 8); 
		else
			element.setFrame("fielddark", 7,5,7,5);
		end
	end,
	["border"] = function(element, isReadOnly) 
		if not isThemeLoaded then return; end 
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
		ThemeManager.updateThemeFont["refBNotoWhite"](element);
		if isThemeLoaded then 
			element.setFrame("headerblack", 5,0,5,0);
		end
	end,
	["redFrameStandardList"] = function(element, isReadOnly) 
		if isThemeLoaded then 
			element.setFrame("darkenField");
		end
	end,
	["numFrame"] = function(element, noTheme, theme) 
		if not isThemeLoaded then
			element.setFrame("numFrame", noTheme[1], noTheme[2], noTheme[3], noTheme[4]);
		else
			element.setFrame("fieldlight", theme[1], theme[2], theme[3], theme[4]);
		end
	end
}

updateThemeFont = {
	["PCBodyFrame"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-b-12");
		else
			element.setFont("sheetlabelmini");
		end
	end,
	["refBNoto"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-b-15");
		else
			element.setFont("reference-b");
		end
	end,
	["refBNotoWhite"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-b-15-white");
		else
			element.setFont("reference-b");
		end
	end,
	["refHeadNoto48"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-48");
		else
			element.setFont("reference-page-header");
		end
	end,
	["refHeadNoto24"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-b-24");
		else
			element.setFont("windowtitle");
		end
	end,
	["notoWindowTitle"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-b-18-white");
		else
			element.setFont("windowtitle");
		end
	end,
	["noto18"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-18");
		else
			element.setFont("windowtitle");
		end
	end,
	["noto18normal"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-18");
		else
			element.setFont("reference-b");
		end
	end,
	["notoB18"] = function(element) 
		if not isThemeLoaded then
			element.setFont("noto-b-18");
		else
			element.setFont("reference-b");
		end
	end,
	["noto15"] = function(element) 
		if not isThemeLoaded then return; end
		element.setFont("reference-r");
	end,
	["noto12"] = function(element) 
		if not isThemeLoaded then return; end
		if element.setDisplayFont then
			element.setDisplayFont("sheetlabelmini");
		else
			element.setFont("sheetlabelmini");
		end
	end,
}