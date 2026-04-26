WorldLevelSystem = WorldLevelSystem or {}

function WorldLevelSystem:Init(gameMode)
    self.gameMode = gameMode
    self.current_level = 1
    self.unlocked = { [1] = true }
    self:Publish()
end

function WorldLevelSystem:GetConfig(level)
    return WorldLevelConfig[level or self.current_level] or WorldLevelConfig[1]
end

function WorldLevelSystem:GetXPModifier()
    return self:GetConfig().xp or 1
end

function WorldLevelSystem:GetMaxPlayerLevel()
    return self:GetConfig().max_player_level or math.min(100, (self.current_level or 1) * 10)
end

function WorldLevelSystem:GetEnemyHealthModifier()
    return self:GetConfig().enemy_health or 1
end

function WorldLevelSystem:GetEnemyDamageModifier()
    return self:GetConfig().enemy_damage or 1
end

function WorldLevelSystem:Unlock(level)
    if not WorldLevelConfig[level] then return end
    self.unlocked[level] = true
    self:Publish()
end

function WorldLevelSystem:Select(keys)
    local playerID = tonumber(keys.PlayerID or keys.player_id or -1)
    local level = tonumber(keys.level or keys.world_level or 1)
    if not self.unlocked[level] then
        SirvUtils:NotifyPlayer(playerID, "Ese Nivel de Mundo todavía no está desbloqueado.", "warning")
        return
    end
    self.current_level = level
    self:Publish()
    if ShopSystem then ShopSystem:Publish() end
    SirvUtils:NotifyAll("Nivel de Mundo cambiado a " .. level .. ".", "success")
end

function WorldLevelSystem:Publish()
    CustomNetTables:SetTableValue("world_level_data", "state", { current = self.current_level, unlocked = self.unlocked, config = WorldLevelConfig })
end
