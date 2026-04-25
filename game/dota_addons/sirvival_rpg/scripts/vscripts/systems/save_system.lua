SaveSystem = SaveSystem or {}

function SaveSystem:Init(gameMode)
    self.gameMode = gameMode
    self.memory = {}
    self.status = {}
    self.backend_load_body = {}
end

function SaveSystem:GetSteamID(playerID)
    if PlayerResource and PlayerResource.GetSteamID then
        local ok, steamID = pcall(function() return PlayerResource:GetSteamID(playerID) end)
        if ok and steamID and tostring(steamID) ~= "0" then
            return tostring(steamID)
        end
    end

    if PlayerResource and PlayerResource.GetSteamAccountID then
        local ok, accountID = pcall(function() return PlayerResource:GetSteamAccountID(playerID) end)
        if ok and accountID and tostring(accountID) ~= "0" then
            return tostring(accountID)
        end
    end

    return tostring(playerID)
end

function SaveSystem:GetSaveKey(playerID)
    return self:GetSteamID(playerID) .. ":" .. tostring(SeasonConfig.current_season_id)
end

function SaveSystem:GetMatchID()
    if GameRules and GameRules.Script_GetMatchID then
        local ok, matchID = pcall(function() return GameRules:Script_GetMatchID() end)
        if ok and matchID then return tostring(matchID) end
    end
    return "local_tools"
end

function SaveSystem:CaptureInventory(hero)
    local inventory = {}
    if not hero then return inventory end

    for slot = 0, 8 do
        local item = hero:GetItemInSlot(slot)
        if item then
            inventory[#inventory + 1] = {
                slot = slot,
                name = item:GetAbilityName(),
                charges = item:GetCurrentCharges(),
            }
        end
    end

    return inventory
end

function SaveSystem:BuildSavePayload(playerID)
    local hero = SirvUtils:GetPlayerHero(playerID)
    local heroName = hero and hero:GetUnitName() or "unknown"
    PlayerProgressionSystem:InitializePlayer(playerID)

    return {
        schema_version = 1,
        addon_version = SurvivalConfig.VERSION,
        steam_id = self:GetSteamID(playerID),
        player_id = playerID,
        match_id = self:GetMatchID(),
        saved_at_game_time = math.floor(GameRules:GetGameTime()),
        season_id = SeasonConfig.current_season_id,
        heroes = {
            [heroName] = PlayerProgressionSystem.progress[playerID],
        },
        inventory = self:CaptureInventory(hero),
        artifacts = ArtifactSystem.player_artifacts[playerID] or {},
        pets = PetSystem.players[playerID] or {},
        world_level = {
            current = WorldLevelSystem.current_level,
            unlocked = WorldLevelSystem.unlocked,
        },
        zones = {
            current = ZoneSystem.current_zone,
            completed = ZoneSystem.completed,
        },
    }
end

function SaveSystem:LoadPlayerData(playerID)
    return self.memory[self:GetSaveKey(playerID)]
end

function SaveSystem:SavePlayerDataPlaceholder(playerID)
    local key = self:GetSaveKey(playerID)
    self.memory[key] = self:BuildSavePayload(playerID)
    CustomNetTables:SetTableValue("season_data", "last_save_" .. playerID, self.memory[key])
    self:PublishStatus(playerID, "memory", "Guardado temporal en memoria. Se pierde al cerrar la partida.")
    return self.memory[key]
end

function SaveSystem:IsBackendEnabled()
    return SaveBackendConfig
        and SaveBackendConfig.ENABLED == true
        and SaveBackendConfig.BASE_URL ~= nil
        and SaveBackendConfig.BASE_URL ~= ""
end

function SaveSystem:BuildURL(path)
    local base = tostring(SaveBackendConfig.BASE_URL or "")
    base = string.gsub(base, "/+$", "")
    path = tostring(path or "")
    if string.sub(path, 1, 1) ~= "/" then
        path = "/" .. path
    end
    return base .. path
end

function SaveSystem:GetDedicatedServerKey()
    if not SaveBackendConfig.SEND_DEDICATED_SERVER_KEY then
        return "disabled"
    end

    local version = SaveBackendConfig.DEDICATED_SERVER_KEY_VERSION or "survival_rpg_v1"
    if type(GetDedicatedServerKeyV3) == "function" then
        return tostring(GetDedicatedServerKeyV3(version))
    end
    if type(GetDedicatedServerKeyV2) == "function" then
        return tostring(GetDedicatedServerKeyV2(version))
    end
    if type(GetDedicatedServerKey) == "function" then
        return tostring(GetDedicatedServerKey(version))
    end
    return "Unavailable_LocalTools"
end

function SaveSystem:PublishStatus(playerID, mode, message)
    self.status[playerID] = {
        mode = mode,
        message = message,
        backend_enabled = self:IsBackendEnabled(),
        season_id = SeasonConfig.current_season_id,
    }
    CustomNetTables:SetTableValue("sirvival_save", tostring(playerID), self.status[playerID])
end

function SaveSystem:SendBackendRequest(method, path, payload, callback)
    if type(CreateHTTPRequestScriptVM) ~= "function" then
        if callback then callback(false, { Body = "CreateHTTPRequestScriptVM unavailable" }) end
        return
    end

    local request = CreateHTTPRequestScriptVM(method, self:BuildURL(path))
    if not request then
        if callback then callback(false, { Body = "Request could not be created" }) end
        return
    end

    request:SetHTTPRequestHeaderValue("Content-Type", "application/json")
    request:SetHTTPRequestHeaderValue("X-SRPG-Addon-Version", SurvivalConfig.VERSION)
    request:SetHTTPRequestHeaderValue("X-SRPG-Server-Key", self:GetDedicatedServerKey())
    request:SetHTTPRequestAbsoluteTimeoutMS(SaveBackendConfig.TIMEOUT_MS or 8000)
    request:SetHTTPRequestNetworkActivityTimeout(SaveBackendConfig.TIMEOUT_MS or 8000)
    request:SetHTTPRequestRawPostBody("application/json", JsonUtils.Encode(payload or {}))

    if SaveBackendConfig.LOG_REQUESTS then
        print("[SurvivalRPG] Backend " .. method .. " " .. self:BuildURL(path))
    end

    request:Send(function(result)
        local statusCode = tonumber(result and result.StatusCode or 0) or 0
        local ok = statusCode >= 200 and statusCode < 300
        if callback then callback(ok, result or {}) end
    end)
end

function SaveSystem:RequestLoad(playerID)
    playerID = tonumber(playerID or -1)
    if playerID < 0 then return nil end

    local localData = self:LoadPlayerData(playerID)
    if not self:IsBackendEnabled() then
        self:PublishStatus(playerID, "memory", "Modo local: sin backend externo configurado.")
        return localData
    end

    self:PublishStatus(playerID, "loading", "Solicitando progreso al backend...")
    self:SendBackendRequest("POST", SaveBackendConfig.LOAD_PATH, {
        steam_id = self:GetSteamID(playerID),
        player_id = playerID,
        season_id = SeasonConfig.current_season_id,
        addon_version = SurvivalConfig.VERSION,
    }, function(ok, result)
        if ok then
            self.backend_load_body[playerID] = result.Body or ""
            self:PublishStatus(playerID, "backend", "Backend respondio. Falta activar lectura de payload real.")
        else
            self:PublishStatus(playerID, "memory", "Backend no disponible. Usando datos temporales.")
        end
    end)

    return localData
end

function SaveSystem:SavePlayerData(playerID)
    playerID = tonumber(playerID or -1)
    if playerID < 0 then return nil end

    local key = self:GetSaveKey(playerID)
    local payload = self:BuildSavePayload(playerID)
    self.memory[key] = payload
    CustomNetTables:SetTableValue("season_data", "last_save_" .. playerID, payload)

    if not self:IsBackendEnabled() then
        self:PublishStatus(playerID, "memory", "Guardado temporal en memoria. Backend apagado.")
        return payload
    end

    self:PublishStatus(playerID, "saving", "Enviando guardado al backend...")
    self:SendBackendRequest("POST", SaveBackendConfig.SAVE_PATH, payload, function(ok, result)
        if ok then
            self:PublishStatus(playerID, "backend", "Guardado enviado al backend.")
            SirvUtils:NotifyPlayer(playerID, "Guardado enviado al backend.", "success")
        else
            self:PublishStatus(playerID, "memory", "No se pudo guardar en backend. Queda copia temporal.")
            SirvUtils:NotifyPlayer(playerID, "No se pudo guardar en backend. Queda copia temporal.", "warning")
        end
    end)

    return payload
end

function SaveSystem:RequestSave(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    self:SavePlayerData(playerID)
    if not self:IsBackendEnabled() then
        SirvUtils:NotifyPlayer(playerID, "Guardado temporal creado en memoria. No persiste al cerrar Dota.", "warning")
    end
end
