--
-- MGT2-only Hearth adjustment for the host combat tracker entry (ct_entry).
--
-- Attached via rulesets/mgt2_compilation.xml, which is gated ruleset="MGT2" in extension.xml,
-- so this script never loads on any other ruleset.
--
-- Purpose: keep the right-anchored control chain a constant length so the stat columns
-- (Init/Mod/END/STR/DEX) on a dying/dead row stay aligned with live rows. A dead non-PC row
-- shows the delete (idelete) button, which inserts a 20px slot into the right-to-left relative
-- anchor chain and shifts every column to its left. The faction icon (friendfoe) is the same
-- width (20) and sits in that same chain, so we hide it exactly while idelete is showing:
-- one slot out, one slot in, chain length unchanged.
--
-- The MGT2 ruleset owns onHealthChanged (ct/scripts/ct_entry.lua), which sets idelete's
-- visibility. We call super first so idelete.isVisible() reflects the updated state, then sync
-- the faction icon to the opposite.

function onInit()
	if super and super.onInit then
		super.onInit();
	end
	onHealthChanged();
end

function onHealthChanged()
	if super and super.onHealthChanged then
		super.onHealthChanged();
	end

	if friendfoe and idelete then
		friendfoe.setVisible(not idelete.isVisible());
	end
end
