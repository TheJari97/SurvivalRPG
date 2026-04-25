SaveSystem = SaveSystem or {}

function SaveSystem:Init(gameMode)
    self.gameMode = gameMode
    self.memory = {}
end

function SaveSystem:GetSteamID(playerID)
    return tostring(PlayerResource:GetSteamAccountID(playerID) or playerID)
end

function SaveSystem:BuildSavePayload(playerID)
    local hero = SirvUtils:GetPlayerHero(playerID)
    local heroName = hero and hero:GetUnitName() or "unknown"
    PlayerProgressionSystem:InitializePlayer(playerID)
    return {
        steam_id = self:GetSteamID(playerID),
        season_id = SeasonConfig.current_season_id,
        heroes = {
            [heroName] = PlayerProgressionSystem.progress[playerID],
        },
        artifacts = ArtifactSystem.player_artifacts[playerID] or {},
        pets = PetSystem.players[playerID] or {},
        note = "Placeholder en memoria. No hay persistencia real sin backend externo.",
    }
end

function SaveSystem:LoadPlayerData(playerID)
    local key = self:GetSteamID(playerID) .. ":" .. SeasonConfig.current_season_id
    return self.memory[key]
end

function SaveSystem:SavePlayerDataPlaceholder(playerID)
    local key = self:GetSteamID(playerID) .. ":" .. SeasonConfig.current_season_id
    self.memory[key] = self:BuildSavePayload(playerID)
    CustomNetTables:SetTableValue("season_data", "last_save_" .. playerID, self.memory[key])
    return self.memory[key]
end

function SaveSystem:RequestSave(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    self:SavePlayerDataPlaceholder(playerID)
    SirvUtils:NotifyPlayer(playerID, "Guardado temporal creado en memoria. No persiste al cerrar Dota.", "warning")
end
