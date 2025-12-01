-- 简化版Buffer物品脚本 (仅物品功能)
local BFEnableModule = true
local BuffByLevel = true
local BuffCureRes = true
local MaxLevel = 80

-- Buff法术列表 (48162;43223;48469;48074;48170;42995;53307;)
local BuffSpells = {
    "48162", "43223", "48469", "48074", "48170", "42995", "53307"
}

-- 获取适合角色等级的法术
local function GetSpellForLevel(spellId, player)
    local level = player:GetLevel()
    
    -- 获取法术链的第一个法术
    local firstSpell = GetSpellFirstRank(spellId) or spellId
    
    if level >= MaxLevel then
        -- 返回最高等级的法术
        return GetSpellLastRank(firstSpell) or spellId
    end
    
    -- 根据等级计算合适的法术等级
    local spellRanks = GetNumSpellRanks(firstSpell)
    if spellRanks <= 1 then
        return firstSpell
    end
    
    local spellIndex = math.floor((level * spellRanks) / MaxLevel)
    if spellIndex >= spellRanks then
        spellIndex = spellRanks - 1
    end
    
    return GetSpellNthRank(firstSpell, spellIndex + 1) or firstSpell
end

-- Buff玩家主函数
local function BuffPlayer(player)
    if not BFEnableModule then
        return
    end
    
    -- 治疗复活病
    if BuffCureRes and player:HasAura(15007) then
        player:RemoveAura(15007)
        player:SendBroadcastMessage("The aura of death has been lifted from you " .. player:GetName() .. ". Watch yourself out there!")
    end
    
    -- 应用buff
    for _, spellIdStr in ipairs(BuffSpells) do
        local spellId = tonumber(spellIdStr)
        if spellId then
            if BuffByLevel then
                local spell = GetSpellForLevel(spellId, player)
                player:CastSpell(player, spell, true)
            else
                player:CastSpell(player, spellId, true)
            end
        end
    end
end

-- 物品使用事件
local function OnItemUse(event, player, item, target)
    -- 替换这里的物品ID为您想要使用的物品ID
    if item:GetEntry() == 52019 then
        BuffPlayer(player)
        player:SendBroadcastMessage("You have been buffed!")
        return false -- 允许物品消耗(如果是消耗品)
    end
    return true -- 不消耗物品
end

-- 注册物品事件 (替换52019为您实际使用的物品ID)
RegisterItemEvent(52019, 2, OnItemUse) -- 52019是原始脚本中的物品ID

-- 辅助函数(如果Eluna不提供这些函数，则使用简化版本)
function GetSpellFirstRank(spellId)
    -- 简化实现：返回原ID
    return spellId
end

function GetSpellLastRank(spellId)
    -- 简化实现：返回原ID
    return spellId
end

function GetSpellNthRank(spellId, rank)
    -- 简化实现：返回原ID
    return spellId
end

function GetNumSpellRanks(spellId)
    -- 简化实现：返回固定值
    return 1
end