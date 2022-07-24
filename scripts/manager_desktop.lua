--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

local _nSidebarVersion = 2;

local _bInitialized = false;
local _wShortcuts;

local _rcDockOffset = { left = 5, top = 0, right = 5, bottom = 0 };
local _rcVisibilityButtonOffset = { left = 5, top = 5, right = 5, bottom = 5 };

local _szDockCategory = { w = 160, h = 40 };
local _rcDockCategoryOffset = { left = 0, top = 0, right = 0, bottom = 0 };
local _szDockCategoryPadding = { w = 10, h = 10 };
local _nDockCategoryTextOffset = 5;

local _szDockButton = { w = 160, h = 40 };
local _rcDockButtonOffset = { left = 0, top = 0, right = 0, bottom = 0 };
local _szDockButtonIconPadding = { w = 5, h = 5 };
local _szDockButtonTextPadding = { w = 10, h = 10 };

local _cDockCategoryIconColor = "EBDDBA"; -- Replaceable Color: Primary Foreground
local _cDockCategoryTextColor = "EBDDBA"; -- Replaceable Color: Primary Foreground
local _cDockIconColor = "DDDDDD"; -- Replaceable Color: Secondary Foreground
local _cDockTextColor = "DDDDDD"; -- Replaceable Color: Secondary Foreground

local _nSidebarVisibility = true;
local _tSidebarCategories = {};
local _tSidebarCategoriesExpanded = {};
local _tDefaultRecordTypeCategories = {
	["charsheet"] = "player",
	["charstarshipsheet"] = "player",
	["charship"] = "player",
	["note"] = "player",
	["advantages"] = "create",
	["archetype"] = "create",
	["archetypes"] = "create",
	["background"] = "create",
	["career"] = "create",
	["clan"] = "create",
	["class"] = "create",
	["discipline"] = "create",
	["enchantment"] = "create",
	["edge"] = "create",
	["exploit"] = "create",
	["extrasflaw"] = "create",
	["feat"] = "create",
	["hindrance"] = "create",
	["homeworld"] = "create",
	["lookupdata"] = "create",
	["merit"] = "create",
	["occupation"] = "create",
	["occupations"] = "create",
	["power"] = "create",
	["powers"] = "create",
	["powereffects"] = "create",
	["predator"] = "create",
	["profession"] = "create",
	["psionic"] = "create",
	["race"] = "create",
	["skill"] = "create",
	["skillgroup"] = "create",
	["skills"] = "create",
	["specialability"] = "create",
	["spell"] = "create",
	["spells"] = "create",
	["talent"] = "create",
	["talents"] = "create",
	["theme"] = "create",
	["trait"] = "create",
};

--
--	Initialization and Clean Up
--

function onInit()
	Interface.onDesktopInit = onDesktopInit;
	Interface.onDesktopClose = onDesktopClose;
end

function onDesktopInit()
	LibraryData.initialize();
	DesktopManager.initializeSidebar();
end

function onDesktopClose()
	DesktopManager.saveSidebarState();
end

--
--	Sidebar theming
--

function getSidebarDockWidth()
	if _nSidebarVisibility <= 0 then
		local nDockCategoryWidth = _szDockCategory.w + (_rcDockCategoryOffset.left + _rcDockCategoryOffset.right);
		local nDockButtonWidth = _szDockButton.w + (_rcDockButtonOffset.left + _rcDockButtonOffset.right);
		return math.max(nDockCategoryWidth, nDockButtonWidth);
	end
	local nDockIconWidth = DesktopManager.getSidebarDockIconWidth();
	if _nSidebarVisibility == 1 then
		return nDockIconWidth * 2;
	end
	return nDockIconWidth;
end
function getSidebarDockWidthWithOffsets()
	local nSidebarWidth = DesktopManager.getSidebarDockWidth();
	return nSidebarWidth + (_rcDockOffset.left + _rcDockOffset.right);
end
function getSidebarDockIconWidth()
	return math.min(_szDockButton.w, _szDockButton.h) + (_rcDockButtonOffset.left + _rcDockButtonOffset.right);
end

function setSidebarDockOffset(l, t, r, b)
	_rcDockOffset.left = l;
	_rcDockOffset.top = t;
	_rcDockOffset.right = r;
	_rcDockOffset.bottom = b;
end
function setSidebarVisibilityButtonOffset(l, t, r, b)
	_rcVisibilityButtonOffset.left = l;
	_rcVisibilityButtonOffset.top = t;
	_rcVisibilityButtonOffset.right = r;
	_rcVisibilityButtonOffset.bottom = b;
end

function getSidebarDockCategorySize()
	return {
		w = _szDockCategory.w,
		h = _szDockCategory.h
	};
end
function getSidebarDockCategoryOffset()
	return {
		left = _rcDockCategoryOffset.left,
		top = _rcDockCategoryOffset.top,
		right = _rcDockCategoryOffset.right,
		bottom = _rcDockCategoryOffset.bottom
	};
end
function getSidebarDockCategoryPadding()
	return {
		w = _szDockCategoryPadding.w,
		h = _szDockCategoryPadding.h
	};
end
function getSidebarDockCategoryTextOffset()
	return _nDockCategoryTextOffset;
end
function setSidebarDockCategorySize(w, h)
	_szDockCategory.w = w;
	_szDockCategory.h = h;
end
function setSidebarDockCategoryOffset(l, t, r, b)
	_rcDockCategoryOffset.left = l;
	_rcDockCategoryOffset.top = t;
	_rcDockCategoryOffset.right = r;
	_rcDockCategoryOffset.bottom = b;
end
function setSidebarDockCategoryPadding(w, h)
	_szDockCategoryPadding.w = w;
	_szDockCategoryPadding.h = h;
end
function setSidebarDockCategoryTextOffset(n)
	_nDockCategoryTextOffset = n;
end

function getSidebarDockButtonSize()
	return {
		w = _szDockButton.w,
		h = _szDockButton.h
	};
end
function getSidebarDockButtonOffset()
	return {
		left = _rcDockButtonOffset.left,
		top = _rcDockButtonOffset.top,
		right = _rcDockButtonOffset.right,
		bottom = _rcDockButtonOffset.bottom
	};
end
function getSidebarDockButtonIconPadding()
	return {
		w = _szDockButtonIconPadding.w,
		h = _szDockButtonIconPadding.h
	};
end
function getSidebarDockButtonTextPadding()
	return {
		w = _szDockButtonTextPadding.w,
		h = _szDockButtonTextPadding.h
	};
end
function setSidebarDockButtonSize(w, h)
	_szDockButton.w = w;
	_szDockButton.h = h;
end
function setSidebarDockButtonOffset(l, t, r, b)
	_rcDockButtonOffset.left = l;
	_rcDockButtonOffset.top = t;
	_rcDockButtonOffset.right = r;
	_rcDockButtonOffset.bottom = b;
end
function setSidebarDockButtonIconPadding(w, h)
	_szDockButtonIconPadding.w = w;
	_szDockButtonIconPadding.h = h;
end
function setSidebarDockButtonTextPadding(w, h)
	_szDockButtonTextPadding.w = w;
	_szDockButtonTextPadding.h = h;
end

function getSidebarDockCategoryIconColor()
	return _cDockCategoryIconColor;
end
function getSidebarDockCategoryTextColor()
	return _cDockCategoryTextColor;
end
function getSidebarDockIconColor()
	return _cDockIconColor;
end
function getSidebarDockTextColor()
	return _cDockTextColor;
end
function setSidebarDockCategoryIconColor(s)
	_cDockCategoryIconColor = s;
end
function setSidebarDockCategoryTextColor(s)
	_cDockCategoryTextColor = s;
end
function setSidebarDockIconColor(s)
	_cDockIconColor = s;
end
function setSidebarDockTextColor(s)
	_cDockTextColor = s;
end

--
--	Sidebar Initialization
--

function initializeSidebar()
	-- Build sidebar
	DesktopManager.loadSidebarState();
    DesktopManager.configureSidebarTheming();
	DesktopManager.rebuildSidebar();

	_bInitialized = true;
end

function onSidebarSizeChanged()
	DesktopManager.updateSidebarAnchorWindowPosition();
end

function getSidebarWindow()
	if not _wShortcuts then
		_wShortcuts = Interface.findWindow("shortcuts", "");
		_wShortcuts.onSizeChanged = DesktopManager.onSidebarSizeChanged;
	end
	return _wShortcuts;
end

function getSidebarAnchorWindow()
	if not _wAnchor then
		_wAnchor = Interface.findWindow("shortcutsanchor", "");
	end
	return _wAnchor;
end

function updateSidebarAnchorWindowPosition()
	local wAnchor = DesktopManager.getSidebarAnchorWindow();
	wAnchor.setPosition(-DesktopManager.getSidebarDockWidthWithOffsets(), 0, true);
end

function configureSidebarTheming()
	DesktopManager.updateSidebarAnchorWindowPosition();

	local wShortcuts = DesktopManager.getSidebarWindow();

	local nSidebarVisState = DesktopManager.getSidebarVisibilityState();
	local nSidebarWidth = DesktopManager.getSidebarDockWidth();
	local nSidebarWidthWithOffsets = DesktopManager.getSidebarDockWidthWithOffsets();
	local nDockIconWidth = DesktopManager.getSidebarDockIconWidth();

	-- Apply sidebar size
	wShortcuts.shortcutframe.setAnchoredWidth(nSidebarWidthWithOffsets);
	wShortcuts.shortcutbar.setAnchoredWidth(nSidebarWidth);

	-- Configure theming support
	wShortcuts.shortcutbar.setAnchor("top", "", "top", "absolute", _rcDockOffset.top);
	wShortcuts.shortcutbar.setAnchor("bottom", "", "bottom", "absolute", -(nDockIconWidth + (_rcVisibilityButtonOffset.top + _rcVisibilityButtonOffset.bottom) + _rcDockOffset.bottom));
	wShortcuts.shortcutbar.setAnchor("left", "", "left", "absolute", _rcDockOffset.left);

	local nScrollbarAnchorOffset = math.min(0, -(15 - _rcDockOffset.right));
	wShortcuts.scrollbar_shortcutbar.setAnchor("left", "shortcutbar", "right", "absolute", nScrollbarAnchorOffset);

	wShortcuts.button_visibility.setAnchor("left", "", "left", "absolute", _rcVisibilityButtonOffset.left);
	wShortcuts.button_visibility.setAnchor("bottom", "", "bottom", "absolute", -_rcVisibilityButtonOffset.bottom);
	wShortcuts.button_visibility.setAnchoredHeight(nDockIconWidth);
	wShortcuts.button_visibility.setAnchoredWidth(nDockIconWidth);
	if nSidebarVisState == 2 then
		wShortcuts.button_visibility_icon.setIcon("sidebar_action_expand");
	else
		wShortcuts.button_visibility_icon.setIcon("sidebar_action_collapse");
	end
	wShortcuts.button_visibility_icon.setColor(DesktopManager.getSidebarDockIconColor());

	wShortcuts.shortcutbar.subwindow.list.setAnchoredWidth(nSidebarWidth);
	for _,w in ipairs(wShortcuts.shortcutbar.subwindow.list.getWindows()) do
		w.updateTheming();
	end
end

function rebuildSidebar()
	local wShortcuts = DesktopManager.getSidebarWindow();

	-- Clear any previous windows
	wShortcuts.shortcutbar.subwindow.list.closeAll();

    -- Build tool button list
    local tToolButtons = {};

    local tTool;
    if Session.IsHost then
    	tTool = Desktop.aCoreDesktopStack["host"];
    else
    	tTool = Desktop.aCoreDesktopStack["client"];
    end
    for i,vButton in ipairs(tTool) do
    	table.insert(tToolButtons, { sIcon = vButton.sIcon, sLabelRes = vButton.tooltipres, sClass = vButton.class, sPath = vButton.path });
    end

    -- Add tool category
	local wToolCategory = wShortcuts.shortcutbar.subwindow.list.createWindow();
	wToolCategory.setCategory(DesktopManager.getSidebarToolCategory(), tToolButtons);

    -- Build remaining dock button list
    local tDockButtons = {};

	local sLibraryCategory = DesktopManager.getSidebarLibraryCategory();
    for _,vButton in ipairs(Desktop.aCoreDesktopDockV4["live"]) do
    	table.insert(tDockButtons, { sCategory = sLibraryCategory, sLabelRes = vButton.tooltipres, sClass = vButton.class, sPath = vButton.path });
    end

    local aRecords = LibraryData.getRecordTypes();
    for _,sRecordType in pairs(aRecords) do
        local tRecordTypeInfo = LibraryData.getRecordTypeInfo(sRecordType);
        if not tRecordTypeInfo.bHidden then
	        local sRecordCategory = tRecordTypeInfo.sSidebarCategory or DesktopManager.getSidebarDefaultCategoryByRecordType(sRecordType);
	        table.insert(tDockButtons, { sCategory = sRecordCategory, sRecordType = sRecordType });
	    end
    end

    -- Build dock category list
    _tSidebarCategories = DesktopManager.getSidebarDefaultCategories();
    local tButtonsByCategory = { };

	for _,vButton in ipairs(tDockButtons) do
		if not StringManager.contains(_tSidebarCategories, vButton.sCategory) then
			table.insert(_tSidebarCategories, vButton.sCategory);
		end
		if not tButtonsByCategory[vButton.sCategory] then
			tButtonsByCategory[vButton.sCategory] = {};
		end
		table.insert(tButtonsByCategory[vButton.sCategory], vButton);
	end

	-- Add dock buttons
	for _,sCategory in ipairs(_tSidebarCategories) do
		local w = wShortcuts.shortcutbar.subwindow.list.createWindow();
		table.sort(tButtonsByCategory[sCategory], sortSidebarAlphaWithinCategory);
		w.setCategory(sCategory, tButtonsByCategory[sCategory]);
	end
end

function sortSidebarAlphaWithinCategory(a,b)
	local sLabelA;
	if a.sRecordType then
		sLabelA = LibraryData.getDisplayText(a.sRecordType);
	elseif a.sLabelRes then
		sLabelA = Interface.getString(a.sLabelRes);
	else
		sLabelA = "";
	end

	local sLabelB;
	if b.sRecordType then
		sLabelB = LibraryData.getDisplayText(b.sRecordType);
	elseif b.sLabelRes then
		sLabelB = Interface.getString(b.sLabelRes);
	else
		sLabelB = "";
	end

	return sLabelA < sLabelB;
end

--
--  One-Off Tool Registration
--

function registerSidebarToolButton(tButton, vIndex)
    local tTool;
    if Session.IsHost then
    	tTool = Desktop.aCoreDesktopStack["host"];
    else
    	tTool = Desktop.aCoreDesktopStack["client"];
    end
    if type(vIndex) == "number" then
	    table.insert(tTool, vIndex, tButton);
	elseif bFront then
	    table.insert(tTool, 1, tButton);
	else
	    table.insert(tTool, tButton);
	end

	if _bInitialized then
		DesktopManager.rebuildSidebar();
	end
end

function registerSidebarStackButton(tButton, vIndex)
	registerSidebarToolButton(tButton, vIndex);
end

--
--	Sidebar Categories
--

function getSidebarDefaultCategory()
	return "campaign";
end
function getSidebarDefaultCategoryByRecordType(sRecordType)
	if _tDefaultRecordTypeCategories[sRecordType] then
		return _tDefaultRecordTypeCategories[sRecordType];
	end
	return DesktopManager.getSidebarDefaultCategory();
end
function getSidebarDefaultCategories()
	return { "library", "player", "campaign" };
end
function getSidebarLibraryCategory()
	return "library";
end
function getSidebarToolCategory()
	return "tool";
end

--
--	Sidebar State
--

function loadSidebarState()
	DesktopManager.checkSidebarDataVersionState();
	DesktopManager.loadSidebarVisibilityState();
	DesktopManager.loadSidebarCategoryState();
end
function saveSidebarState()
	DesktopManager.setSidebarDataVersionState();
	DesktopManager.saveSidebarVisibilityState();
	DesktopManager.saveSidebarCategoryState();
end

function checkSidebarDataVersionState()
	if (CampaignRegistry.sidebarversion or 0) < _nSidebarVersion then
		CampaignRegistry.sidebarexpand = nil;
	end
end
function setSidebarDataVersionState()
	CampaignRegistry.sidebarversion = _nSidebarVersion;
end

function loadSidebarVisibilityState()
    if type(CampaignRegistry.sidebarvisibility) ~= "number" then
		CampaignRegistry.sidebarvisibility = nil;
	end
	_nSidebarVisibility = CampaignRegistry.sidebarvisibility or 0;

	local wShortcuts = DesktopManager.getSidebarWindow();
	wShortcuts.button_visibility.setValue(_nSidebarVisibility);
end
function saveSidebarVisibilityState()
	CampaignRegistry.sidebarvisibility = _nSidebarVisibility;
end
function getSidebarVisibilityState()
	return _nSidebarVisibility;
end
function setSidebarVisibilityState(nValue)
	_nSidebarVisibility = nValue;
	DesktopManager.configureSidebarTheming();
end

function loadSidebarCategoryState()
    if type(CampaignRegistry.sidebarexpand) ~= "table" or #CampaignRegistry.sidebarexpand == 0 then
		CampaignRegistry.sidebarexpand = nil;
	end

	_tSidebarCategoriesExpanded = {};
	if CampaignRegistry.sidebarexpand then
		for _,v in ipairs(CampaignRegistry.sidebarexpand) do
			table.insert(_tSidebarCategoriesExpanded, v);
		end
	else
		table.insert(_tSidebarCategoriesExpanded, DesktopManager.getSidebarToolCategory());
	end
end
function saveSidebarCategoryState()
	CampaignRegistry.sidebarexpand = {};
	for _,v in ipairs(_tSidebarCategoriesExpanded) do
		if StringManager.contains(_tSidebarCategories, v) or v == DesktopManager.getSidebarToolCategory() then
			table.insert(CampaignRegistry.sidebarexpand, v);
		end
	end
end
function getSidebarCategoryState(sCategory)
	return StringManager.contains(_tSidebarCategoriesExpanded, sCategory);
end
function toggleSidebarCategoryState(sCategory)
	local bHandled = false;
	for k,v in ipairs(_tSidebarCategoriesExpanded) do
		if v == sCategory then
			table.remove(_tSidebarCategoriesExpanded, k);
			bHandled = true;
		end
	end
	if not bHandled then
		table.insert(_tSidebarCategoriesExpanded, sCategory);
	end

	local wShortcuts = DesktopManager.getSidebarWindow();
	for _,w in ipairs(wShortcuts.shortcutbar.subwindow.list.getWindows()) do
		if w.getCategory() == sCategory then
			w.updateState();
		end
	end
end

--
--	Sidebar Actions
--

function toggleIndex(sRecordType)
	local sClass, sRecord = DesktopManager.getListLink(sRecordType);
	if not sClass then
		return;
	end
	Interface.toggleWindow(sClass, sRecord);
end

function getListLink(sRecordType)
	local rRecordType = LibraryData.getRecordTypeInfo(sRecordType);
	if not rRecordType then
		return;
	end

	if rRecordType.fGetLink then
		return rRecordType.fGetLink();
	end

	local sDisplayIndex = "masterindex";
	if rRecordType.sDisplayIndex then
		sDisplayIndex = rRecordType.sDisplayIndex;
	end

	local aMappings = LibraryData.getMappings(sRecordType);
	return sDisplayIndex, aMappings[1];
end

--
--  Data Module Sets for Campaign Setup
--

local _tDataModuleSets = {};

function addDataModuleSets(aDataModulesSetsValue)
	if not aDataModulesSetsValue then
		return;
	end
	for _,v in ipairs(aDataModulesSetsValue) do
		DesktopManager.addDataModuleSet(v.name, v.modules);
	end
end

function addDataModuleSet(sDataModuleSetNameValue, aDataModulesValue)
	table.insert(_tDataModuleSets, { sName=sDataModuleSetNameValue, aModules=aDataModulesValue });
end

function getDataModuleSets()
	return _tDataModuleSets;
end

--
--	DEPRECATED
--

function setSidebarStackOffset(l, t, r, b)
	Debug.console("DesktopManager.setSidebarStackOffset - DEPRECATED - 2022-02-01 - Use DesktopManager.setSidebarDockOffset(l, t, r, b).");
	ChatManager.SystemMessage("DesktopManager.setSidebarStackOffset - DEPRECATED - 2022-02-01 - Contact forge/extension author");
end
function setSidebarStackButtonSize(w, h)
	Debug.console("DesktopManager.setSidebarStackButtonSize - DEPRECATED - 2022-02-01 - Use DesktopManager.setSidebarDockButtonSize(w, h) instead.");
	ChatManager.SystemMessage("DesktopManager.setSidebarStackButtonSize - DEPRECATED - 2022-02-01 - Contact forge/extension author");
end
function setSidebarStackButtonOffset(l, t, r, b)
	Debug.console("DesktopManager.setSidebarStackOffset - DEPRECATED - 2022-02-01 - Use DesktopManager.setSidebarDockButtonOffset(l, t, r, b).");
	ChatManager.SystemMessage("DesktopManager.setSidebarStackOffset - DEPRECATED - 2022-02-01 - Contact forge/extension author");
end
