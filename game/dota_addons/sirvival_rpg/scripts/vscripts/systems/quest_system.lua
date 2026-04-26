QuestSystem = QuestSystem or {}

function QuestSystem:Init(gameMode)
    self.gameMode = gameMode
    self.players = {}
    self:PublishAll()
end

function QuestSystem:Ensure(playerID)
    self.players[playerID] = self.players[playerID] or {
        completed = {},
        unlocked_recipes = {},
        kills = {
            total = 0,
            by_category = {},
            by_zone = {},
        },
    }
    return self.players[playerID]
end

function QuestSystem:IsQuestCompleted(playerID, questID)
    local data = self:Ensure(playerID)
    return data.completed[questID] == true
end

function QuestSystem:IsRecipeUnlocked(playerID, recipeID)
    local recipe = CraftingRecipes and CraftingRecipes[recipeID]
    if not recipe or not recipe.unlock_quest then return true end
    local data = self:Ensure(playerID)
    return data.unlocked_recipes[recipeID] == true or data.completed[recipe.unlock_quest] == true
end

function QuestSystem:OnPlayerInitialized(playerID)
    self:Ensure(playerID)
    self:Publish(playerID)
end

function QuestSystem:OnEnemyKilled(playerID, killed)
    if playerID == nil or playerID < 0 or not killed then return end
    local data = self:Ensure(playerID)
    local category = killed.srpg_category or "common"
    local zone = tostring(killed.srpg_zone or 1)

    data.kills.total = (data.kills.total or 0) + 1
    data.kills.by_category[category] = (data.kills.by_category[category] or 0) + 1
    data.kills.by_zone[zone] = (data.kills.by_zone[zone] or 0) + 1
    self:Publish(playerID)
end

function QuestSystem:OnBossKilled(playerID, flag)
    if playerID == nil or playerID < 0 or not flag then return end
    local data = self:Ensure(playerID)
    data.boss_flags = data.boss_flags or {}
    data.boss_flags[flag] = true
    self:Publish(playerID)
end

function QuestSystem:GetHeroLevel(playerID)
    local progress = PlayerProgressionSystem.progress[playerID]
    if progress and progress.level then return progress.level end
    local hero = SirvUtils:GetPlayerHero(playerID)
    if hero and hero.GetLevel then return hero:GetLevel() end
    return 1
end

function QuestSystem:CanComplete(playerID, questID)
    local quest = QuestConfig.quests[questID]
    if not quest then return false, "Mision inexistente." end
    local data = self:Ensure(playerID)
    if data.completed[questID] then return false, "Mision ya completada." end

    local req = quest.requirements or {}
    if req.level and self:GetHeroLevel(playerID) < req.level then
        return false, "Necesitas nivel " .. tostring(req.level) .. "."
    end

    if req.quest_completed and not data.completed[req.quest_completed] then
        return false, "Falta completar una mision previa."
    end

    if req.category_kills then
        for category, amount in pairs(req.category_kills) do
            if (data.kills.by_category[category] or 0) < amount then
                return false, "Faltan enemigos: " .. category .. " " .. tostring(amount) .. "."
            end
        end
    end

    if req.boss_flags then
        local progress = PlayerProgressionSystem.progress[playerID] or {}
        local bossFlags = progress.boss_flags or {}
        for _, flag in pairs(req.boss_flags) do
            if bossFlags[flag] ~= true and (data.boss_flags or {})[flag] ~= true then
                return false, "Falta derrotar: " .. flag .. "."
            end
        end
    end

    if req.max_game_time and GameRules:GetGameTime() > req.max_game_time then
        return false, "La mision de tiempo ya expiro."
    end

    return true, "OK"
end

function QuestSystem:ApplyRewards(playerID, rewards)
    rewards = rewards or {}
    local hero = SirvUtils:GetPlayerHero(playerID)

    if rewards.gold and rewards.gold > 0 then
        PlayerResource:ModifyGold(playerID, rewards.gold, true, DOTA_ModifyGold_Unspecified or 0)
    end

    if rewards.xp and rewards.xp > 0 then
        PlayerProgressionSystem:AddXP(playerID, rewards.xp)
    end

    if hero and rewards.items then
        for _, itemName in pairs(rewards.items) do
            hero:AddItemByName(itemName)
        end
    end

    if rewards.unlock_pet and PetSystem then
        PetSystem:UnlockPetForCurrentHero(playerID, rewards.unlock_pet)
    end

    if rewards.unlock_zone and PlayerProgressionSystem then
        PlayerProgressionSystem:InitializePlayer(playerID)
        PlayerProgressionSystem.progress[playerID].unlocked_zones[rewards.unlock_zone] = true
        if ZoneSystem then ZoneSystem:OpenGateForZone(rewards.unlock_zone) end
    end
end

function QuestSystem:CompleteQuest(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    local questID = tostring(keys.quest or keys.quest_id or "")
    local ok, reason = self:CanComplete(playerID, questID)
    if not ok then
        SirvUtils:NotifyPlayer(playerID, reason, "warning")
        return
    end

    local quest = QuestConfig.quests[questID]
    local data = self:Ensure(playerID)
    data.completed[questID] = true

    local rewards = quest.rewards or {}
    if rewards.unlock_recipes then
        for _, recipeID in pairs(rewards.unlock_recipes) do
            data.unlocked_recipes[recipeID] = true
        end
    end

    self:ApplyRewards(playerID, rewards)
    self:Publish(playerID)
    SirvUtils:NotifyPlayer(playerID, "Mision completada: " .. (quest.title_es or questID), "success")
end

function QuestSystem:BuildQuestList(playerID)
    local list = {}
    for questID, quest in pairs(QuestConfig.quests or {}) do
        list[#list + 1] = {
            id = questID,
            title_es = quest.title_es,
            category = quest.category,
            description_es = quest.description_es,
            requirements = quest.requirements or {},
            rewards = quest.rewards or {},
            completed = self:IsQuestCompleted(playerID, questID),
        }
    end
    return list
end

function QuestSystem:Publish(playerID)
    if playerID == nil then return self:PublishAll() end
    CustomNetTables:SetTableValue("quest_data", tostring(playerID), {
        state = self:Ensure(playerID),
        quests = self:BuildQuestList(playerID),
        categories = QuestConfig.categories,
    })
end

function QuestSystem:PublishAll()
    CustomNetTables:SetTableValue("quest_data", "catalog", {
        quests = QuestConfig.quests,
        categories = QuestConfig.categories,
    })
end
