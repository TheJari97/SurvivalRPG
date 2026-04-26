EnemySpawnSystem = EnemySpawnSystem or {}

function EnemySpawnSystem:Init(gameMode)
    self.gameMode = gameMode
    self.spawned_hub = false
    self.active = {}
    self.camps = {}
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
        self:SpawnCamp(spawnName, cfg.units, "common", zone, 4 + zone)
    end
    local unitTier = math.min(zone, 5)
    self:SpawnCamp(cfg.elite_spawn, "npc_sirv_z" .. unitTier .. "_elite", "elite", zone, 1)
    self:SpawnCamp(cfg.area_boss_spawn, "npc_sirv_area_boss_" .. unitTier, "area_boss", zone, 1, "area_boss_" .. zone)
    if self:IsZoneBossCompleted(zone) then
        self:SpawnZoneBossReplacement(zone, false)
    else
        self:SpawnCamp(cfg.zone_boss_spawn, "npc_sirv_zone_boss_" .. unitTier, "zone_boss", zone, 1, "zone_boss_" .. zone)
    end
end

function EnemySpawnSystem:SpawnAllUnlocked()
    for zone = 1, 10 do
        self:StartZone(zone)
    end
end

function EnemySpawnSystem:GetCampKey(spawnName, category, bossFlag)
    return tostring(spawnName or "unknown") .. ":" .. tostring(bossFlag or category or "common")
end

function EnemySpawnSystem:PickCampUnit(unitPool, index)
    if type(unitPool) == "table" then
        if #unitPool <= 0 then return nil end
        return unitPool[RandomInt(1, #unitPool)]
    end
    return unitPool
end

function EnemySpawnSystem:IsRespawnable(category, bossFlag)
    if bossFlag then return false end
    return category == "common" or category == "elite"
end

function EnemySpawnSystem:GetRespawnDelay(category)
    if category == "elite" then return SurvivalConfig.ELITE_RESPAWN_DELAY or 90 end
    return SurvivalConfig.CAMP_RESPAWN_DELAY or 35
end

function EnemySpawnSystem:IsZoneBossCompleted(zone)
    local flag = "zone_boss_" .. tostring(zone or 0)
    if ZoneSystem and ZoneSystem.completed and ZoneSystem.completed[flag] then return true end
    if BossSystem and BossSystem.killed and BossSystem.killed[flag] then return true end
    return false
end

function EnemySpawnSystem:SpawnZoneBossReplacement(zone, force)
    local cfg = ZoneConfig[zone]
    if not cfg or not cfg.zone_boss_spawn then return end

    local unitTier = math.min(zone, 5)
    self:SpawnCamp(cfg.zone_boss_spawn, "npc_sirv_z" .. unitTier .. "_elite", "elite", zone, 1, nil, force)
end

function EnemySpawnSystem:SpawnCamp(spawnName, unitPool, category, zone, count, bossFlag, force)
    local ent = Entities:FindByName(nil, spawnName)
    if not ent then return end
    local campKey = self:GetCampKey(spawnName, category, bossFlag)
    local existing = self.camps[campKey]
    if existing and not force and ((existing.alive or 0) > 0 or existing.respawn_scheduled) then return end

    local origin = ent:GetAbsOrigin()
    self.camps[campKey] = {
        spawn_name = spawnName,
        unit_pool = unitPool,
        category = category,
        zone = zone,
        count = count,
        boss_flag = bossFlag,
        alive = 0,
        respawnable = self:IsRespawnable(category, bossFlag),
        respawn_scheduled = false,
    }

    for i = 1, count do
        local unitName = self:PickCampUnit(unitPool, i)
        if not unitName then return end
        local unit = CreateUnitByName(unitName, origin + RandomVector(RandomInt(0, 180)), true, nil, nil, DOTA_TEAM_BADGUYS)
        if unit then
            self.camps[campKey].alive = self.camps[campKey].alive + 1
            unit.srpg_camp_key = campKey
            unit.srpg_spawn_name = spawnName
            unit.srpg_unit_name = unitName
            unit.srpg_category = category
            unit.srpg_zone = zone
            unit.srpg_boss_key = bossFlag
            self:ScaleUnit(unit)
            self:EquipEnemy(unit, category, zone)
            self:StartEnemyBehavior(unit)
            if (bossFlag or category == "elite") and BossSystem then
                BossSystem:OnBossSpawned(unit, category, zone)
            end
        end
    end
end

function EnemySpawnSystem:OnUnitKilled(unit)
    if not unit or not unit.srpg_camp_key then return end
    local camp = self.camps[unit.srpg_camp_key]
    if not camp then return end

    camp.alive = math.max(0, (camp.alive or 1) - 1)
    if camp.alive > 0 or not camp.respawnable or camp.respawn_scheduled then return end

    camp.respawn_scheduled = true
    local campKey = unit.srpg_camp_key
    Timers:CreateTimer(self:GetRespawnDelay(camp.category), function()
        local data = self.camps[campKey]
        if not data then return nil end
        data.respawn_scheduled = false
        self:SpawnCamp(data.spawn_name, data.unit_pool, data.category, data.zone, data.count, data.boss_flag, true)
        return nil
    end)
end

function EnemySpawnSystem:OnZoneBossCompleted(zone)
    local targetZone = tonumber(zone or 0) or 0
    if targetZone <= 0 then return end

    local enemies = FindUnitsInRadius(
        DOTA_TEAM_BADGUYS,
        Vector(0, 0, 0),
        nil,
        FIND_UNITS_EVERYWHERE,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
        if enemy.srpg_zone == targetZone then
            self:ApplyPostBossScaling(enemy)
        end
    end

    Timers:CreateTimer(SurvivalConfig.ELITE_RESPAWN_DELAY or 90, function()
        self:SpawnZoneBossReplacement(targetZone, false)
        return nil
    end)
end

function EnemySpawnSystem:EquipEnemy(unit, category, zone)
    if not EnemyEquipmentConfig or not unit then return end
    local item = EnemyEquipmentConfig:Pick(zone, category)
    if not item then return end

    unit.srpg_equipped_items = unit.srpg_equipped_items or {}
    table.insert(unit.srpg_equipped_items, item)

    if item.health and item.health > 0 then
        unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() + item.health)
        unit:SetMaxHealth(unit:GetBaseMaxHealth())
        unit:SetHealth(unit:GetMaxHealth())
    end
    if item.damage and item.damage > 0 then
        unit:SetBaseDamageMin(unit:GetBaseDamageMin() + item.damage)
        unit:SetBaseDamageMax(unit:GetBaseDamageMax() + item.damage)
    end
    if item.armor and item.armor > 0 then
        unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() + item.armor)
    end
end

function EnemySpawnSystem:StartEnemyBehavior(unit)
    if not unit or not unit.srpg_unit_name then return end
    if string.find(unit.srpg_unit_name, "_healer") then
        self:StartHealerThink(unit)
    end
end

function EnemySpawnSystem:StartHealerThink(unit)
    Timers:CreateTimer(2.5, function()
        if not unit or unit:IsNull() or not unit:IsAlive() then return nil end

        local allies = FindUnitsInRadius(
            unit:GetTeamNumber(),
            unit:GetAbsOrigin(),
            nil,
            650,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY,
            DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
        )

        local target = nil
        local missing = 0
        for _, ally in pairs(allies) do
            local deficit = ally:GetMaxHealth() - ally:GetHealth()
            if ally:IsAlive() and deficit > missing then
                target = ally
                missing = deficit
            end
        end

        if target and missing > 0 then
            local worldScale = 1
            if WorldLevelSystem and WorldLevelSystem.GetEnemyHealthModifier then
                worldScale = WorldLevelSystem:GetEnemyHealthModifier() or 1
            end
            target:Heal(70 * worldScale, unit)
        end

        return 6.0
    end)
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
    self:ApplyPostBossScaling(unit)
end

function EnemySpawnSystem:ApplyPostBossScaling(unit)
    if not unit or unit:IsNull() or unit.srpg_post_zone_boss_scaled then return end
    if not unit.srpg_zone or not self:IsZoneBossCompleted(unit.srpg_zone) then return end

    unit.srpg_post_zone_boss_scaled = true
    local healthMultiplier = SurvivalConfig.POST_ZONE_BOSS_HEALTH_MULTIPLIER or 1.35
    local damageMultiplier = SurvivalConfig.POST_ZONE_BOSS_DAMAGE_MULTIPLIER or 1.2
    unit:SetBaseMaxHealth(math.floor(unit:GetBaseMaxHealth() * healthMultiplier))
    unit:SetMaxHealth(unit:GetBaseMaxHealth())
    unit:SetHealth(unit:GetMaxHealth())
    unit:SetBaseDamageMin(math.floor(unit:GetBaseDamageMin() * damageMultiplier))
    unit:SetBaseDamageMax(math.floor(unit:GetBaseDamageMax() * damageMultiplier))
end
