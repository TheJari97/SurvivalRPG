BossSystem = BossSystem or {}

function BossSystem:Init(gameMode)
    self.gameMode = gameMode
    self.killed = {}
    self.active_bosses = {}
end

function BossSystem:OnBossSpawned(unit, category, zone)
    if not unit then return end
    unit.srpg_mechanics = self:RollMechanics(category, zone)
    self.active_bosses[unit:entindex()] = unit.srpg_mechanics
    self:StartMechanicThink(unit)
end

function BossSystem:RollMechanics(category, zone)
    local mechanics = {}
    local count = 1
    if category == "elite" then count = zone >= 5 and 2 or 1 end
    if category == "area_boss" then count = zone >= 5 and 3 or 2 end
    if category == "zone_boss" then count = math.min(5, 2 + math.floor(zone / 2)) end

    local pools = { "weak", "common" }
    if zone >= 3 then table.insert(pools, "strong") end
    if zone >= 7 then table.insert(pools, "strong") end

    local used = {}
    while #mechanics < count do
        local poolName = pools[RandomInt(1, #pools)]
        local pool = BossMechanicsConfig[poolName] or BossMechanicsConfig.weak
        local pick = self:PickWeightedMechanic(pool)
        if pick and not used[pick.id] then
            used[pick.id] = true
            table.insert(mechanics, pick)
        end
    end
    return mechanics
end

function BossSystem:PickWeightedMechanic(pool)
    local total = 0
    for _, mechanic in pairs(pool or {}) do
        total = total + (mechanic.weight or 1)
    end
    if total <= 0 then return (pool or {})[1] end

    local roll = RandomFloat(0, total)
    local cursor = 0
    for _, mechanic in pairs(pool or {}) do
        cursor = cursor + (mechanic.weight or 1)
        if roll <= cursor then return mechanic end
    end

    return pool[#pool]
end

function BossSystem:StartMechanicThink(unit)
    Timers:CreateTimer(2.0, function()
        if not unit or unit:IsNull() or not unit:IsAlive() then return nil end
        local mechanics = unit.srpg_mechanics or {}
        for _, mechanic in pairs(mechanics) do
            mechanic._next_cast = mechanic._next_cast or GameRules:GetGameTime() + RandomFloat(3, mechanic.cooldown or 10)
            if GameRules:GetGameTime() >= mechanic._next_cast then
                self:CastMechanic(unit, mechanic)
                mechanic._next_cast = GameRules:GetGameTime() + (mechanic.cooldown or 12)
            end
        end
        return 1.0
    end)
end

function BossSystem:CastMechanic(unit, mechanic)
    if mechanic.type == "summon" then
        local summonName = "npc_sirv_z" .. math.min(unit.srpg_zone or 1, 5) .. "_melee"
        for i = 1, mechanic.count or 2 do
            local summon = CreateUnitByName(summonName, unit:GetAbsOrigin() + RandomVector(RandomInt(120, 260)), true, nil, nil, DOTA_TEAM_BADGUYS)
            if summon and EnemySpawnSystem then
                summon.srpg_category = "common"
                summon.srpg_zone = unit.srpg_zone
                EnemySpawnSystem:ScaleUnit(summon)
            end
        end
        return
    end

    if mechanic.type == "enrage" then
        unit:AddNewModifier(unit, nil, "modifier_sirv_boss_enrage", { duration = mechanic.duration or 8 })
        return
    end

    if mechanic.type == "reflect_damage" then
        unit:AddNewModifier(unit, nil, "modifier_sirv_boss_reflect", {
            duration = mechanic.duration or 6,
            reflect_pct = mechanic.reflect_pct or 10,
        })
        return
    end

    local radius = mechanic.radius or 360
    local enemies = FindUnitsInRadius(
        unit:GetTeamNumber(),
        unit:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    for _, target in pairs(enemies) do
        ApplyDamage({
            victim = target,
            attacker = unit,
            damage = (mechanic.damage or 80) * (WorldLevelSystem:GetEnemyDamageModifier() or 1),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = nil,
        })
    end
end

function BossSystem:OnUnitKilled(unit, attacker)
    if not unit or not unit.srpg_boss_key then return end
    local flag = unit.srpg_boss_key
    self.killed[flag] = true
    ZoneSystem:MarkBossKilled(flag)
    if attacker and attacker.GetPlayerOwnerID then
        local playerID = attacker:GetPlayerOwnerID()
        PlayerProgressionSystem:SetBossFlag(playerID, flag)
        if QuestSystem then QuestSystem:OnBossKilled(playerID, flag) end
    end
    CustomNetTables:SetTableValue("game_state", "bosses", self.killed)
end

LinkLuaModifier("modifier_sirv_boss_enrage", "systems/boss_system.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirv_boss_reflect", "systems/boss_system.lua", LUA_MODIFIER_MOTION_NONE)
modifier_sirv_boss_enrage = class({})
function modifier_sirv_boss_enrage:IsHidden() return false end
function modifier_sirv_boss_enrage:IsPurgable() return false end
function modifier_sirv_boss_enrage:DeclareFunctions()
    return { MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
end
function modifier_sirv_boss_enrage:GetModifierBaseDamageOutgoing_Percentage() return 35 end
function modifier_sirv_boss_enrage:GetModifierAttackSpeedBonus_Constant() return 55 end

modifier_sirv_boss_reflect = class({})
function modifier_sirv_boss_reflect:IsHidden() return false end
function modifier_sirv_boss_reflect:IsPurgable() return false end
function modifier_sirv_boss_reflect:OnCreated(kv)
    kv = kv or {}
    self.reflect_pct = tonumber(kv.reflect_pct or 10) or 10
end
function modifier_sirv_boss_reflect:DeclareFunctions()
    return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end
function modifier_sirv_boss_reflect:OnTakeDamage(event)
    if not IsServer() then return end
    local parent = self:GetParent()
    if event.unit ~= parent then return end
    if not event.attacker or event.attacker:IsNull() or event.attacker:GetTeamNumber() == parent:GetTeamNumber() then return end
    if event.damage <= 0 then return end

    ApplyDamage({
        victim = event.attacker,
        attacker = parent,
        damage = event.damage * (self.reflect_pct / 100),
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
        ability = nil,
    })
end
