function onInit()
	if super and super.onInit then
		super.onInit()
	end
	setStateColor(0, ColorManager.COLOR_SECONDARY_FOREGROUND, ColorManager.COLOR_SECONDARY_FOREGROUND, ColorManager.COLOR_SECONDARY_FOREGROUND);
	setStateColor(1, ColorManager.COLOR_PRIMARY_FOREGROUND, ColorManager.COLOR_PRIMARY_FOREGROUND, ColorManager.COLOR_PRIMARY_FOREGROUND);
end
