PlayerProgressionSystem = PlayerProgressionSystem or {}

function PlayerProgressionSystem:Init(gameMode)
    self.gameMode = gameMode
    self.progress = {}
end

function PlayerProgressionSystem:InitializePlayer(playerID)
    local hero = SirvUtils:GetPlayerHero(playerID)
    local heroName = hero and hero:GetUnitName() or "unknown"
    self.progress[playerID] = self.progress[playerID] or {
        level = 1,
        xp = 0,
        skill_points = 0,
        total_skill_points = 0,
        spent_skill_points = 0,
        gear_score = 0,
        hero = heroName,
        unlocked_zones = { [1] = true },
        unlocked_world_levels = { [1] = true },
        boss_flags = {},
    }
    self:ApplyHeroProgress(playerID)
    self:Publish(playerID)
end

function PlayerProgressionSystem:AddXP(playerID, amount)
    self:InitializePlayer(playerID)
    local data = self.progress[playerID]
    local mult = WorldLevelSystem and WorldLevelSystem:GetXPModifier() or 1
    data.xp = data.xp + math.floor((amount or 0) * mult)
    while data.level < XPConfig.max_level and data.xp >= XPConfig:GetRequiredXP(data.level) do
        data.xp = data.xp - XPConfig:GetRequiredXP(data.level)
        data.level = data.level + 1
        SirvUtils:NotifyPlayer(playerID, "Subiste a nivel " .. data.level .. ".", "success")
    end
    self:ApplyHeroProgress(playerID)
    if QuestSystem then QuestSystem:Publish(playerID) end
    self:Publish(playerID)
end

function PlayerProgressionSystem:GetSpentAbilityPoints(hero)
    if not hero then return 0 end

    local heroCfg = HeroConfig[hero:GetUnitName()]
    local spent = 0
    for _, abilityName in ipairs((heroCfg and heroCfg.abilities) or {}) do
        local ability = hero:FindAbilityByName(abilityName)
        if ability then spent = spent + (ability:GetLevel() or 0) end
    end
    return spent
end

function PlayerProgressionSystem:ApplyHeroProgress(playerID)
    local data = self.progress[playerID]
    local hero = SirvUtils:GetPlayerHero(playerID)
    if not data or not hero then return end

    data.total_skill_points = XPConfig:GetSkillPointsForLevel(data.level)
    data.spent_skill_points = self:GetSpentAbilityPoints(hero)
    data.skill_points = math.max(0, data.total_skill_points - data.spent_skill_points)

    while hero:GetLevel() < data.level do
        hero:HeroLevelUp(false)
    end
    if hero.SetAbilityPoints then
        hero:SetAbilityPoints(data.skill_points)
    end
end

function PlayerProgressionSystem:SetBossFlag(playerID, flag)
    self:InitializePlayer(playerID)
    self.progress[playerID].boss_flags[flag] = true
    self:Publish(playerID)
end

function PlayerProgressionSystem:GetGearScore(playerID)
    self:InitializePlayer(playerID)
    local hero = SirvUtils:GetPlayerHero(playerID)
    local score = 0
    if hero then
        for slot = 0, 8 do
            local item = hero:GetItemInSlot(slot)
            if item then score = score + (item:GetSpecialValueFor("gear_score") or 0) end
        end
    end
    self.progress[playerID].gear_score = score
    return score
end

function PlayerProgressionSystem:Publish(playerID)
    if playerID ~= nil then
        CustomNetTables:SetTableValue("player_progress", tostring(playerID), self.progress[playerID] or {})
    else
        CustomNetTables:SetTableValue("player_progress", "all", self.progress)
    end
end
