--
-- MGT2-only Hearth adjustment for host (ct_entry) and client (client_ct_entry) combat tracker entries.
--
-- Attached via rulesets/mgt2_compilation.xml, which is gated ruleset="MGT2" in extension.xml,
-- so this script never loads on any other ruleset.
--
-- Purpose:
-- 1. Recolor MGT2's hardcoded VARMU ("on") vehicle structure damage status/attribute text
--    (which upstream sets to #404040 / #008000) to Hearth's dark-mode health UI palette.
-- 2. On the host CT, keep the right-anchored control chain a constant length so the stat columns
--    (Init/Mod/END/STR/DEX) on a dying/dead row stay aligned with live rows by hiding friendfoe
--    while idelete is visible.

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	local node = getDatabaseNode();
	if not Session.IsHost and node then
		DB.addHandler(DB.getPath(node, "structure_damage"), "onUpdate", onHealthChanged);
	end
	OptionsManager.registerCallback("VARMU", onHealthChanged);
	onHealthChanged();
end

function onClose()
	local node = getDatabaseNode();
	if not Session.IsHost and node then
		DB.removeHandler(DB.getPath(node, "structure_damage"), "onUpdate", onHealthChanged);
	end
	OptionsManager.unregisterCallback("VARMU", onHealthChanged);
	if super and super.onClose then
		super.onClose();
	end
end

function onHealthChanged()
	if super and super.onHealthChanged then
		super.onHealthChanged();
	end

	local nodeActor = link and link.getTargetDatabaseNode() or getDatabaseNode();
	if nodeActor and ActorManager.isRecordType(nodeActor, "vehicle") and OptionsManager.getOption("VARMU") == "on" then
		local nStructureDamage = structure_damage and structure_damage.getValue() or DB.getValue(nodeActor, "structure_damage", 0);
		local sColor;
		if nStructureDamage >= 40 then
			sColor = ColorManager.getUIColor("health_dyingordead");
		elseif nStructureDamage >= 30 then
			sColor = ColorManager.getUIColor("health_wounds_heavy");
		elseif nStructureDamage >= 20 then
			sColor = ColorManager.getUIColor("health_wounds_moderate");
		elseif nStructureDamage >= 10 then
			sColor = ColorManager.getUIColor("health_wounds_light");
		else
			sColor = ColorManager.getUIColor("health_unwounded");
		end

		if endurance then
			endurance.setColor(sColor);
		end
		if dexterity then
			dexterity.setColor(sColor);
		end
		if strength then
			strength.setColor(sColor);
		end
		if status and status.setColor then
			status.setColor(sColor);
		end
		if hits then
			hits.setColor(sColor);
		end
		if structure_damage then
			structure_damage.setColor(sColor);
		end
	end

	if friendfoe and idelete then
		friendfoe.setVisible(not idelete.isVisible());
	end
end
