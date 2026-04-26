EnemySpawnSystem = EnemySpawnSystem or {}

function EnemySpawnSystem:Init(gameMode)
    self.gameMode = gameMode
    self.spawned_hub = false
    self.active = {}
end

function EnemySpawnSystem:SpawnHubNPCs()
    if self.spawned_hub then return end
    for entityName, unitName in pairs(SurvivalConfig.HUB_NPCS) do
        local ent = Entities:FindByName(nil, entityName)
        if ent then
            CreateUnitByName(unitName, ent:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
        end
    end
    self.spawned_hub = true
end

function EnemySpawnSystem:StartZone(zone)
    local cfg = ZoneConfig[zone]
    if not cfg or cfg.safe_zone then return end
    for index, spawnName in ipairs(cfg.spawns) do
        local unitName = cfg.units[((index - 1) % #cfg.units) + 1]
        self:SpawnCamp(spawnName, unitName, "common", zone, 4 + zone)
    end
    local unitTier = math.min(zone, 5)
    self:SpawnCamp(cfg.elite_spawn, "npc_sirv_z" .. unitTier .. "_elite", "elite", zone, 1)
    self:SpawnCamp(cfg.area_boss_spawn, "npc_sirv_area_boss_" .. unitTier, "area_boss", zone, 1, "area_boss_" .. zone)
    self:SpawnCamp(cfg.zone_boss_spawn, "npc_sirv_zone_boss_" .. unitTier, "zone_boss", zone, 1, "zone_boss_" .. zone)
end

function EnemySpawnSystem:SpawnAllUnlocked()
    for zone = 1, 10 do
        self:StartZone(zone)
    end
end

function EnemySpawnSystem:SpawnCamp(spawnName, unitName, category, zone, count, bossFlag)
    local ent = Entities:FindByName(nil, spawnName)
    if not ent then return end
    local origin = ent:GetAbsOrigin()
    for i = 1, count do
        local unit = CreateUnitByName(unitName, origin + RandomVector(RandomInt(0, 180)), true, nil, nil, DOTA_TEAM_BADGUYS)
        if unit then
            unit.srpg_spawn_name = spawnName
            unit.srpg_unit_name = unitName
            unit.srpg_category = category
            unit.srpg_zone = zone
            unit.srpg_boss_key = bossFlag
            self:ScaleUnit(unit)
            if (bossFlag or category == "elite") and BossSystem then
                BossSystem:OnBossSpawned(unit, category, zone)
            end
        end
    end
end

function EnemySpawnSystem:ScaleUnit(unit)
    local players = SirvUtils:GetConnectedPlayerCount()
    local playerScale = SurvivalConfig.PLAYER_SCALING[players] or SurvivalConfig.PLAYER_SCALING[1]
    local healthScale = (WorldLevelSystem:GetEnemyHealthModifier() or 1) * (playerScale.health or 1)
    local damageScale = (WorldLevelSystem:GetEnemyDamageModifier() or 1) * (playerScale.damage or 1)
    unit:SetBaseMaxHealth(math.floor(unit:GetBaseMaxHealth() * healthScale))
    unit:SetMaxHealth(unit:GetBaseMaxHealth())
    unit:SetHealth(unit:GetMaxHealth())
    unit:SetBaseDamageMin(math.floor(unit:GetBaseDamageMin() * damageScale))
    unit:SetBaseDamageMax(math.floor(unit:GetBaseDamageMax() * damageScale))
end
