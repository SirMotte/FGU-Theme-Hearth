--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end

	local sTempColor = ColorManager.COLOR_TEMP_HP;
	if temphp then
		temphp.setColor(sTempColor);
	elseif hptemp then
		hptemp.setColor(sTempColor);
	elseif temp_hp then
		temp_hp.setColor(sTempColor);
	end

	if nonlethal then
		nonlethal.setColor(ColorManager.COLOR_HEALTH_UNCONSCIOUS);
	end
end