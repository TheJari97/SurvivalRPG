DropSystem = DropSystem or {}

function DropSystem:Init(gameMode)
    self.gameMode = gameMode
end

function DropSystem:RollDrop(killed, attacker)
    if not killed or not attacker or not attacker:IsRealHero() then return end
    local category = killed.srpg_category or "common"
    local tableCfg = DropTables[category] or DropTables.common
    local players = SirvUtils:GetConnectedPlayerCount()
    local playerBonus = (SurvivalConfig.PLAYER_SCALING[players] or SurvivalConfig.PLAYER_SCALING[1]).drop or 1
    local worldBonus = (WorldLevelSystem:GetConfig().drop or 1)
    local chance = (tableCfg.chance or 0) * playerBonus * worldBonus
    if RandomFloat(0, 100) <= chance then
        local item = self:PickItem(killed.srpg_zone or 1, category)
        if item then attacker:AddItemByName(item) end
    end
    if RandomFloat(0, 100) <= (tableCfg.materials or 0) then
        attacker:AddItemByName(self:PickMaterial(killed.srpg_zone or 1, category))
    end
    local playerID = attacker:GetPlayerOwnerID()
    PlayerProgressionSystem:AddXP(playerID, killed:GetDeathXP() or 0)
end

function DropSystem:PickItem(zone, category)
    local rarityPool = DropTables.world_level_rarity[WorldLevelSystem.current_level] or { "basic", "common" }
    local rarity = rarityPool[RandomInt(1, #rarityPool)]
    local slots = ItemTierConfig.slots
    local slot = slots[RandomInt(1, #slots)]
    return "item_sirv_" .. rarity .. "_" .. slot
end

function DropSystem:PickMaterial(zone, category)
    if category == "zone_boss" then return "item_sirv_material_boss_mark" end
    if category == "area_boss" then return "item_sirv_material_elite_core" end
    if zone >= 5 then return "item_sirv_material_titan_blood" end
    if zone >= 3 then return "item_sirv_material_ancient_gem" end
    if zone >= 2 then return "item_sirv_material_wild_essence" end
    return "item_sirv_material_iron_fragment"
end
