RespawnSystem = RespawnSystem or {}

function RespawnSystem:Init(gameMode)
    self.gameMode = gameMode
end

function RespawnSystem:GetRespawnOrigin(playerID)
    local zone = ZoneSystem and ZoneSystem.current_zone or 1
    local name = zone > 1 and ("respawn_zone_" .. zone) or "respawn_hub"
    local hero = SirvUtils:GetPlayerHero(playerID)
    local fallback = hero and hero:GetAbsOrigin() or Vector(0, 0, 0)
    return SirvUtils:FindEntityOrigin(name, SirvUtils:FindEntityOrigin("respawn_hub", fallback))
end
