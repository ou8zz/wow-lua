print(">>Script: Buffer.")
-- Buff法术列表 (48162;43223;48469;48074;48170;42995;53307;)
local BuffSpells = {48162, 43223, 48469, 48074, 48170, 42995, 53307}
local itemId=52019

local function OnItemUse(event, player, item, target)
    if item:GetEntry() == itemId then
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

RegisterItemEvent(itemId, 2, OnItemUse)