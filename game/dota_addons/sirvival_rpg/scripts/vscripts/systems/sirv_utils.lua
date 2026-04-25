SirvUtils = SirvUtils or {}

function SirvUtils:GetConnectedPlayerCount()
    local count = 0
    for playerID = 0, SurvivalConfig.MAX_PLAYERS - 1 do
        if PlayerResource:IsValidPlayerID(playerID) and PlayerResource:GetConnectionState(playerID) == DOTA_CONNECTION_STATE_CONNECTED then
            count = count + 1
        end
    end
    return math.max(1, count)
end

function SirvUtils:GetPlayerHero(playerID)
    if playerID == nil then return nil end
    return PlayerResource:GetSelectedHeroEntity(playerID)
end

function SirvUtils:NotifyPlayer(playerID, message, style)
    local player = PlayerResource:GetPlayer(playerID)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "srpg_toast", { message = message, style = style or "info" })
        CustomGameEventManager:Send_ServerToPlayer(player, "sirv_toast", { message = message, style = style or "info" })
    end
end

function SirvUtils:NotifyAll(message, style)
    CustomGameEventManager:Send_ServerToAllClients("srpg_toast", { message = message, style = style or "info" })
    CustomGameEventManager:Send_ServerToAllClients("sirv_toast", { message = message, style = style or "info" })
end

function SirvUtils:FindEntityOrigin(name, fallback)
    local ent = Entities:FindByName(nil, name)
    if ent then return ent:GetAbsOrigin() end
    return fallback
end

function SirvUtils:PublishGameState(extra)
    extra = extra or {}
    local data = {
        version = SurvivalConfig.VERSION,
        map = SurvivalConfig.MAP_NAME,
        players = self:GetConnectedPlayerCount(),
        world_level = WorldLevelSystem and WorldLevelSystem.current_level or 1,
        current_zone = ZoneSystem and ZoneSystem.current_zone or 1,
        lives = PlayerLifeSystem and PlayerLifeSystem.lives or {},
        defeated = GameRules.srpg_defeated == true,
    }
    for k, v in pairs(extra) do data[k] = v end
    CustomNetTables:SetTableValue("game_state", "global", data)
    CustomNetTables:SetTableValue("sirvival_state", "global", data)
end
