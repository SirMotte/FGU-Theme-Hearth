--
-- Sir Motte's Magnificent Darkness (Hearth Edition)
-- Attack Matrix Theme Contrast Fix for AD&D 2E
--

function onInit()
	if not getDatabaseNode() then
		return;
	end
	if super and super.onInit then
		super.onInit();
	end

	-- Hearth Theme Palette Colors for Attack Matrix
	local sHighlightColor = "342C26"; -- Dark warm brown highlight
	local sAltColor = "231E1B";       -- Alternating darker tile
	local sZeroColor = "5C2B16";      -- Warm Hearth ember for AC 0
	local bHighlight = true;

	for i = -10, 10, 1 do
		local cntNum = self["thac" .. i];
		local cntAC = self["thaco_matrix_ac_" .. i];
		local sBackColor = (i == 0) and sZeroColor or (bHighlight and sHighlightColor or sAltColor);

		if cntNum then
			cntNum.setBackColor(sBackColor);
			if i == 0 then
				cntNum.setColor("FFF0CA");
			end
		end
		if cntAC then
			cntAC.setBackColor(sBackColor);
			if i == 0 then
				cntAC.setColor("FFF0CA");
			end
		end

		bHighlight = not bHighlight;
	end
end
