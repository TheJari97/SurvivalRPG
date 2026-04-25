ArtifactSystem = ArtifactSystem or {}

function ArtifactSystem:Init(gameMode)
    self.gameMode = gameMode
    self.player_artifacts = {}
    self:Publish()
end

function ArtifactSystem:Open(keys)
    self:Publish()
end

function ArtifactSystem:UpgradeArtifact(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    local artifact = tostring(keys.artifact or "wall_heart")
    self.player_artifacts[playerID] = self.player_artifacts[playerID] or {}
    local level = (self.player_artifacts[playerID][artifact] or 0) + 1
    self.player_artifacts[playerID][artifact] = level
    SirvUtils:NotifyPlayer(playerID, "Artefacto mejorado a nivel " .. level .. ".", "success")
    self:Publish()
end

function ArtifactSystem:Publish()
    CustomNetTables:SetTableValue("artifact_data", "catalog", ArtifactConfig)
    CustomNetTables:SetTableValue("artifact_data", "players", self.player_artifacts)
end
