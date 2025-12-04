print(">>Script: Buffer.")
-- Buff法术列表 (48162;43223;48469;48074;48170;42995;53307;)
local BuffSpells = {48162, 43223, 48469, 48074, 48170, 42995, 53307}

local function OnItemUse(event, player, item, target)
    print(">>> Item use event triggered")  -- 调试信息
    print(">>> Item used:", item:GetEntry(), "by player:", player:GetName())  -- 添加调试信息
    
    if item:GetEntry() == 52019 then
        print(">>> Processing item 52019")  -- 修正注释
        
        -- 移除复活病
        if player:HasAura(15007) then
            player:RemoveAura(15007)
            player:SendBroadcastMessage("The aura of death has been lifted from you " .. player:GetName() .. ".")
        end

        for _, spellId in ipairs(BuffSpells) do
            player:CastSpell(player, spellId, true)
        end
        player:SendBroadcastMessage("You have been buffed!")

        return false -- 消耗物品
    end
    return true
end

RegisterItemEvent(52019, 2, OnItemUse)