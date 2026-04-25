PlayerLifeSystem = PlayerLifeSystem or {}
LivesSystem = PlayerLifeSystem

function PlayerLifeSystem:Init(gameMode)
    self.gameMode = gameMode
    self.lives = {}
    self.eliminated = {}
end

function PlayerLifeSystem:InitializePlayers()
    for playerID = 0, SurvivalConfig.MAX_PLAYERS - 1 do
        if PlayerResource:IsValidPlayerID(playerID) then
            self.lives[playerID] = SurvivalConfig.LIVES_PER_PLAYER
            self.eliminated[playerID] = false
        end
    end
    self:Publish()
end

function PlayerLifeSystem:OnHeroKilled(hero)
    if not hero or not hero:IsRealHero() then return end
    local playerID = hero:GetPlayerOwnerID()
    self.lives[playerID] = math.max(0, (self.lives[playerID] or SurvivalConfig.LIVES_PER_PLAYER) - 1)
    if self.lives[playerID] <= 0 then
        self.eliminated[playerID] = true
        SirvUtils:NotifyPlayer(playerID, "Te quedaste sin vidas. Espera a que el equipo termine o reinicie.", "warning")
    else
        Timers:CreateTimer(SurvivalConfig.RESPAWN_DELAY, function()
            if hero and not hero:IsNull() then
                hero:RespawnHero(false, false)
                local origin = RespawnSystem and RespawnSystem:GetRespawnOrigin(playerID) or Vector(0, 0, 0)
                FindClearSpaceForUnit(hero, origin, true)
            end
        end)
    end
    self:Publish()
    self:CheckDefeat()
end

function PlayerLifeSystem:CheckDefeat()
    local active = 0
    local eliminated = 0
    for playerID = 0, SurvivalConfig.MAX_PLAYERS - 1 do
        if PlayerResource:IsValidPlayerID(playerID) then
            active = active + 1
            if self.eliminated[playerID] then eliminated = eliminated + 1 end
        end
    end
    if active > 0 and active == eliminated then
        GameRules.srpg_defeated = true
        GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
    end
end

function PlayerLifeSystem:Publish()
    CustomNetTables:SetTableValue("game_state", "lives", self.lives)
    CustomNetTables:SetTableValue("sirvival_state", "lives", self.lives)
end
