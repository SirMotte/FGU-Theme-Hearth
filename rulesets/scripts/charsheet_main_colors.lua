--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
	if super and super.onInit then
		super.onInit();
	end

	if temphp then
		temphp.setColor(ColorManager.COLOR_TEMP_HP);
	elseif hptemp then
		hptemp.setColor(ColorManager.COLOR_TEMP_HP);
	end

	if wounded then
		wounded.setColor(ColorManager.COLOR_HEALTH_HVY_WOUNDS);
	end

	if dying then
		dying.setColor(ColorManager.COLOR_HEALTH_CRIT_WOUNDS);
	end
end