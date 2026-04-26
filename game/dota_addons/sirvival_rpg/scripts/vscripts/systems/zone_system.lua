ZoneSystem = ZoneSystem or {}

function ZoneSystem:Init(gameMode)
    self.gameMode = gameMode
    self.current_zone = 1
    self.completed = {}
    self:Publish()
end

function ZoneSystem:CanEnter(playerID, zone)
    local cfg = ZoneConfig[zone]
    if not cfg then return false, "Zona inexistente." end
    local hero = SirvUtils:GetPlayerHero(playerID)
    local heroLevel = hero and hero:GetLevel() or 1
    if heroLevel < cfg.min_level then return false, "Necesitas nivel " .. cfg.min_level .. "." end
    if WorldLevelSystem.current_level < cfg.world_level then return false, "Necesitas Nivel de Mundo " .. cfg.world_level .. "." end
    local gear = PlayerProgressionSystem:GetGearScore(playerID)
    if gear < (cfg.gear_score or 0) then return false, "Necesitas Gear Score " .. cfg.gear_score .. "." end
    if cfg.required_boss and not self.completed[cfg.required_boss] then return false, "Falta derrotar el jefe requerido: " .. cfg.required_boss .. "." end
    return true, "OK"
end

function ZoneSystem:RequestZoneEntry(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    local zone = tonumber(keys.zone or 1)
    local ok, reason = self:CanEnter(playerID, zone)
    if not ok then
        SirvUtils:NotifyPlayer(playerID, reason, "warning")
        return
    end
    self.current_zone = zone
    self:Publish()
    if EnemySpawnSystem then
        EnemySpawnSystem:StartZone(zone)
    end
    SirvUtils:NotifyPlayer(playerID, "Entrada permitida a Zona " .. zone .. ".", "success")
end

function ZoneSystem:RequestZoneUnlock(keys)
    self:RequestZoneEntry(keys)
end

function ZoneSystem:MarkBossKilled(flag)
    if not flag then return end
    self.completed[flag] = true
    local bossZone = tonumber(string.match(flag, "zone_boss_(%d+)") or 0)
    if bossZone > 0 and bossZone < 10 then
        WorldLevelSystem:Unlock(math.min(10, bossZone + 1))
        self:OpenGateForZone(bossZone + 1)
    end
    self:Publish()
    SirvUtils:NotifyAll("Jefe completado: " .. flag .. ".", "success")
end

function ZoneSystem:OpenGateForZone(zone)
    local cfg = ZoneConfig[zone]
    if not cfg or not cfg.gate then return end

    DoEntFire(cfg.gate, "Unlock", "", 0, nil, nil)
    DoEntFire(cfg.gate, "Open", "", 0.05, nil, nil)
    DoEntFire(cfg.gate, "Disable", "", 0.1, nil, nil)
    SirvUtils:NotifyAll("Puerta abierta hacia Zona " .. tostring(zone) .. ".", "success")
end

function ZoneSystem:Publish()
    CustomNetTables:SetTableValue("zone_data", "state", { current = self.current_zone, completed = self.completed, zones = ZoneConfig })
    CustomNetTables:SetTableValue("sirvival_state", "zone", { current = self.current_zone, completed = self.completed })
end
