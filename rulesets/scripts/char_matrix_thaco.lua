--
-- Sir Motte's Magnificent Darkness (Hearth Edition)
-- Attack Matrix Theme Contrast Fix for AD&D 2E
--

function onInit()
    local node = getDatabaseNode();
    if not node then
        return;
    end
    if DataCommonADND.coreVersion == "1e" then
        DB.addHandler(DB.getPath(node, "combat.matrix.*"), "onUpdate", update);
    else
        if ActorManager.isPC(node) then
            DB.addHandler(DB.getPath(node, "combat.thaco.score"), "onUpdate", update);
        else
            DB.addHandler(DB.getPath(node, "thaco"), "onUpdate", update);
        end
    end
    createTHACOMatrix();
end

function onClose()
    local node = getDatabaseNode();
    if not node then
        return;
    end
    if DataCommonADND.coreVersion == "1e" then
        DB.removeHandler(DB.getPath(node, "combat.matrix.*"), "onUpdate", update);
    else
        if ActorManager.isPC(node) then
            DB.removeHandler(DB.getPath(node, "combat.thaco.score"), "onUpdate", update);
        else
            DB.removeHandler(DB.getPath(node, "thaco"), "onUpdate", update);
        end
    end
end

function createTHACOMatrix()
    local node = getDatabaseNode();
    if not node then
        return;
    end
    local bisPC = (ActorManager.isPC(node));
    local bUseMatrix = (DataCommonADND.coreVersion == "1e");
    local nTHACO = DB.getValue(node, "combat.thaco.score", 20);
    if (not bisPC) then
        nTHACO = DB.getValue(node, "thaco", 20);
    end

    local aMatrixRolls = {};
    if bUseMatrix and not bisPC then
        local sHitDice = CombatManagerADND.getNPCHitDice(node);
        if DataCommonADND.aMatrix[sHitDice] then
            aMatrixRolls = DataCommonADND.aMatrix[sHitDice];
        end
    end

    -- Hearth Theme Palette Colors for Attack Matrix
    local sHighlightColor = "342C26"; -- Dark warm brown highlight
    local sAltColor = "231E1B";       -- Alternating darker tile
    local sZeroColor = "5C2B16";      -- Warm Hearth ember for AC 0
    local bHighlight = true;

    for i = -10, 10, 1 do
        local nTHAC = nTHACO - i;
        if bUseMatrix then
            nTHAC = DB.getValue(node, "combat.matrix.thac" .. i, 20);
            if not bisPC and #aMatrixRolls > 0 then
                nTHAC = aMatrixRolls[math.abs(i - 11)];
            end
        end

        local sMatrixACName = "thaco_matrix_ac_" .. i;
        local sMatrixACValue = i;
        local sMatrixNumberName = "thac" .. i;
        local cntNum = nil;
        if bUseMatrix then
            cntNum = createControl("number_thaco_matrix", sMatrixNumberName, "combat.matrix." .. sMatrixNumberName);
        else
            cntNum = createControl("number_thaco_matrix", sMatrixNumberName);
        end

        cntNum.setFrame(nil);
        cntNum.setValue(nTHAC);

        local cntAC = createControl("label_fieldtop_thaco_matrix", sMatrixACName);
        cntAC.setReadOnly(true);
        cntAC.setValue(sMatrixACValue);

        if (i == 0) then
            cntNum.setBackColor(sZeroColor);
            cntAC.setBackColor(sZeroColor);
            cntNum.setColor("FFF0CA");
            cntAC.setColor("FFF0CA");
        elseif bHighlight then
            cntNum.setBackColor(sHighlightColor);
            cntAC.setBackColor(sHighlightColor);
        else
            cntNum.setBackColor(sAltColor);
            cntAC.setBackColor(sAltColor);
        end
        cntAC.setAnchor("left", sMatrixNumberName, "left", "absolute", 0);

        bHighlight = not bHighlight;
    end
end

function update()
    local node = getDatabaseNode();
    if not node then
        return;
    end
    local bUseMatrix = (DataCommonADND.coreVersion ~= "2e");

    local nTHACO;
    if ActorManager.isPC(node) then
        nTHACO = DB.getValue(node, "combat.thaco.score", 20);
    else
        nTHACO = DB.getValue(node, "thaco", 20);
    end

    for i = -10, 10, 1 do
        local nTHAC = nTHACO - i;
        if bUseMatrix then
            nTHAC = DB.getValue(node, "combat.matrix.thac" .. i, 20);
        end

        local sMatrixNumberName = "thac" .. i;
        local cnt = self[sMatrixNumberName];
        if cnt then
            cnt.setValue(nTHAC);
        end
    end
end
