SafeZoneSystem = SafeZoneSystem or {}

function SafeZoneSystem:Init(gameMode)
    self.gameMode = gameMode
    self.origin = nil
    Timers:CreateTimer(1.0, function()
        self:Think()
        return 1.0
    end)
end

function SafeZoneSystem:GetOrigin()
    if self.origin then return self.origin end
    self.origin = SirvUtils:FindEntityOrigin("respawn_hub", Vector(0, 0, 0))
    return self.origin
end

function SafeZoneSystem:Think()
    local origin = self:GetOrigin()
    local radius = SurvivalConfig.SAFE_ZONE_RADIUS or 900

    local allies = FindUnitsInRadius(
        DOTA_TEAM_GOODGUYS,
        origin,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, hero in pairs(allies) do
        if hero:IsRealHero() and hero:IsAlive() then
            local heal = hero:GetMaxHealth() * ((SurvivalConfig.SAFE_ZONE_HEAL_PCT or 2) / 100)
            local mana = hero:GetMaxMana() * ((SurvivalConfig.SAFE_ZONE_MANA_PCT or 2) / 100)
            hero:Heal(heal, nil)
            hero:GiveMana(mana)
        end
    end

    local enemies = FindUnitsInRadius(
        DOTA_TEAM_GOODGUYS,
        origin,
        nil,
        radius + 500,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, enemy in pairs(enemies) do
        local distance = (enemy:GetAbsOrigin() - origin):Length2D()
        local aggroTarget = nil
        if enemy.GetAggroTarget then
            local ok, target = pcall(function() return enemy:GetAggroTarget() end)
            if ok then aggroTarget = target end
        end
        local targetInSafeZone = aggroTarget and aggroTarget:IsRealHero() and (aggroTarget:GetAbsOrigin() - origin):Length2D() <= radius

        if distance <= radius or targetInSafeZone then
            if ThreatSystem then
                ThreatSystem:ResetEnemyForSafeZone(enemy, origin, radius)
            else
                local direction = enemy:GetAbsOrigin() - origin
                if direction:Length2D() < 1 then
                    direction = RandomVector(1)
                else
                    direction = direction:Normalized()
                end
                enemy:SetHealth(enemy:GetMaxHealth())
                FindClearSpaceForUnit(enemy, origin + direction * (radius + 300), true)
                enemy:MoveToPositionAggressive(origin + direction * (radius + 700))
            end
        end
    end
end
