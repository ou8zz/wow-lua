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

        local group = player:GetGroup()
        if group then
            print(">>> Player is in a group")  -- 添加调试信息
            -- 给整个队伍施加Buff
            -- 使用更安全的方式遍历组成员
            local members = group:GetMembers()
            if members then
                for i = 1, #members do
                    local member = members[i]
                    -- 检查member是否有效玩家对象
                    if member and type(member) == "table" and member.GetName and member:IsInWorld() then
                        for _, spellId in ipairs(BuffSpells) do
                            player:CastSpell(member, spellId, true)
                        end
                    elseif type(member) == "userdata" or type(member) == "string" then
                        -- 如果member是GUID，尝试转换为玩家对象
                        -- 这里需要根据实际API调整
                        print("Member type:", type(member))
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

RegisterItemEvent(52019, 2, OnItemUse)