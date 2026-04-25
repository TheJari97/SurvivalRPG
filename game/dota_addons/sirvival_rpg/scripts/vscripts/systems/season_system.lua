SeasonSystem = SeasonSystem or {}

function SeasonSystem:Init(gameMode)
    self.gameMode = gameMode
    self:Publish()
end

function SeasonSystem:Open(keys)
    self:Publish()
end

function SeasonSystem:Publish()
    CustomNetTables:SetTableValue("season_data", "state", SeasonConfig)
end
