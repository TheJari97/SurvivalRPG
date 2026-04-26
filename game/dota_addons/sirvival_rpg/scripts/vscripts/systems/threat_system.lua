ThreatSystem = ThreatSystem or {}

function ThreatSystem:Init(gameMode)
    self.gameMode = gameMode
    ListenToGameEvent("entity_hurt", function(keys) self:OnEntityHurt(keys) end, self)
end

function ThreatSystem:GetEntityFromKeys(keys, names)
    if not keys then return nil end

    for _, name in ipairs(names) do
        local entIndex = tonumber(keys[name] or -1)
        if entIndex and entIndex > 0 then
            local entity = EntIndexToHScript(entIndex)
            if entity then return entity end
        end
    end
    return nil
end

function ThreatSystem:OnEntityHurt(keys)
    local victim = self:GetEntityFromKeys(keys, { "entindex_killed", "entindex_victim", "entindex" })
    local attacker = self:GetEntityFromKeys(keys, { "entindex_attacker", "attacker_entindex" })

    if not victim or not attacker then return end
    if victim:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then return end
    if not attacker:IsRealHero() then return end

    local playerID = attacker:GetPlayerOwnerID()
    if playerID == nil or playerID < 0 then return end

    local damage = tonumber(keys.damage or keys.damage_amount or 1) or 1
    damage = damage * self:GetAggroMultiplier(attacker)
    victim.srpg_threat = victim.srpg_threat or {}
    victim.srpg_threat[playerID] = (victim.srpg_threat[playerID] or 0) + math.max(1, damage)
    victim.srpg_last_attacker_player = playerID
end

function ThreatSystem:GetItemSpecial(item, key)
    if not item then return 0 end
    local ok, value = pcall(function() return item:GetSpecialValueFor(key) end)
    if ok and value then return tonumber(value) or 0 end
    return 0
end

function ThreatSystem:GetAggroMultiplier(hero)
    local reduction = 0
    if hero then
        for slot = 0, 8 do
            local item = hero:GetItemInSlot(slot)
            reduction = reduction + self:GetItemSpecial(item, "aggro_reduction")
        end
    end
    return math.max(0.25, 1 - (reduction / 100))
end

function ThreatSystem:IsHeroInsideSafeZone(hero, origin, radius)
    if not hero or hero:IsNull() then return false end
    return (hero:GetAbsOrigin() - origin):Length2D() <= radius
end

function ThreatSystem:ClearSafeZoneThreat(enemy, origin, radius)
    if not enemy.srpg_threat then return end

    for playerID, _ in pairs(enemy.srpg_threat) do
        local hero = SirvUtils:GetPlayerHero(playerID)
        if self:IsHeroInsideSafeZone(hero, origin, radius) then
            enemy.srpg_threat[playerID] = nil
        end
    end
end

function ThreatSystem:GetBestTargetOutsideSafeZone(enemy, origin, radius)
    local bestHero = nil
    local bestThreat = -1

    if enemy.srpg_threat then
        for playerID, threat in pairs(enemy.srpg_threat) do
            local hero = SirvUtils:GetPlayerHero(playerID)
            if hero and hero:IsAlive() and not self:IsHeroInsideSafeZone(hero, origin, radius) then
                if threat > bestThreat then
                    bestThreat = threat
                    bestHero = hero
                end
            end
        end
    end

    if bestHero then return bestHero end

    if not HeroList or not HeroList.GetAllHeroes then
        return nil
    end

    local heroes = HeroList:GetAllHeroes()
    local bestDistance = 999999
    for _, hero in pairs(heroes) do
        if hero:IsRealHero() and hero:IsAlive() and not self:IsHeroInsideSafeZone(hero, origin, radius) then
            local distance = (hero:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D()
            if distance < bestDistance then
                bestDistance = distance
                bestHero = hero
            end
        end
    end

    return bestHero
end

function ThreatSystem:GetRetreatPosition(enemy, origin, radius)
    if enemy.srpg_spawn_name then
        local spawn = Entities:FindByName(nil, enemy.srpg_spawn_name)
        if spawn then
            return spawn:GetAbsOrigin() + RandomVector(180)
        end
    end

    local direction = enemy:GetAbsOrigin() - origin
    if direction:Length2D() < 1 then
        direction = RandomVector(1)
    else
        direction = direction:Normalized()
    end

    return origin + direction * (radius + 450)
end

function ThreatSystem:ResetEnemyForSafeZone(enemy, origin, radius)
    if not enemy or enemy:IsNull() or not enemy:IsAlive() then return end

    self:ClearSafeZoneThreat(enemy, origin, radius)
    enemy:SetHealth(enemy:GetMaxHealth())
    enemy:Stop()

    local retreatPosition = self:GetRetreatPosition(enemy, origin, radius)
    FindClearSpaceForUnit(enemy, retreatPosition, true)

    local target = self:GetBestTargetOutsideSafeZone(enemy, origin, radius)
    if target then
        enemy:MoveToTargetToAttack(target)
    else
        enemy:MoveToPositionAggressive(retreatPosition)
    end
end
