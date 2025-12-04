print(">>Script: Buffer.")
-- Buff法术列表 (48162;43223;48469;48074;48170;42995;53307;)
local BuffSpells = {48162, 43223, 48469, 48074, 48170, 42995, 53307}

local function OnItemUse(event, player, item, target)
    
    print(">>> Item use event triggered")  -- 调试信息

    print(">>> Item used:", item:GetEntry(), "by player:", player:GetName())  -- 添加调试信息
    
    if item:GetEntry() == 50459 then
        print(">>> Processing item 50459")  -- 添加调试信息
        
        -- 移除复活病
        if player:HasAura(15007) then
            player:RemoveAura(15007)
            player:SendBroadcastMessage("The aura of death has been lifted from you " .. player:GetName() .. ".")
        end

        local group = player:GetGroup()
        if group then
            print(">>> Player is in a group")  -- 添加调试信息
            -- 给整个队伍施加Buff
            for _, memberId in ipairs(group:GetMembers()) do
                local member = GetPlayerByGUID(memberId)
                if member and member:IsInWorld() then
                    for _, spellId in ipairs(BuffSpells) do
                        player:CastSpell(member, spellId, true)
                    end
                end
            end
            player:SendBroadcastMessage("Your group has been buffed!")
        else
            print(">>> Player is not in a group")  -- 添加调试信息
            -- 如果没有队伍，则给自己施加Buff
            for _, spellId in ipairs(BuffSpells) do
                player:CastSpell(player, spellId, true)
            end
            player:SendBroadcastMessage("You have been buffed!")
        end

        return false -- 消耗物品
    end
    return true
end

RegisterItemEvent(50459, 2, OnItemUse)