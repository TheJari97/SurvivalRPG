CraftingSystem = CraftingSystem or {}

function CraftingSystem:Init(gameMode)
    self.gameMode = gameMode
    self:Publish()
end

function CraftingSystem:Open(keys)
    self:Publish()
end

local function CountItem(hero, itemName)
    local count = 0
    for slot = 0, 8 do
        local item = hero:GetItemInSlot(slot)
        if item and item:GetAbilityName() == itemName then count = count + math.max(1, item:GetCurrentCharges()) end
    end
    return count
end

local function ConsumeItem(hero, itemName, amount)
    local remaining = amount
    for slot = 0, 8 do
        local item = hero:GetItemInSlot(slot)
        if item and item:GetAbilityName() == itemName then
            local charges = item:GetCurrentCharges()
            if charges <= 1 or charges <= remaining then
                remaining = remaining - math.max(1, charges)
                hero:RemoveItem(item)
            else
                item:SetCurrentCharges(charges - remaining)
                remaining = 0
            end
            if remaining <= 0 then return true end
        end
    end
    return remaining <= 0
end

function CraftingSystem:CraftItem(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    local recipeID = tostring(keys.recipe or keys.recipe_id or "")
    local recipe = CraftingRecipes[recipeID]
    local hero = SirvUtils:GetPlayerHero(playerID)
    if not hero or not recipe then
        SirvUtils:NotifyPlayer(playerID, "Receta inexistente.", "warning")
        return
    end
    if PlayerResource:GetGold(playerID) < (recipe.gold or 0) then
        SirvUtils:NotifyPlayer(playerID, "No tienes oro suficiente para craftear.", "warning")
        return
    end
    if QuestSystem and not QuestSystem:IsRecipeUnlocked(playerID, recipeID) then
        SirvUtils:NotifyPlayer(playerID, "Esa receta todavia no esta desbloqueada.", "warning")
        return
    end
    for itemName, amount in pairs(recipe.requires or {}) do
        if CountItem(hero, itemName) < amount then
            SirvUtils:NotifyPlayer(playerID, "Faltan materiales: " .. itemName, "warning")
            return
        end
    end
    for itemName, amount in pairs(recipe.requires or {}) do
        ConsumeItem(hero, itemName, amount)
    end
    PlayerResource:ModifyGold(playerID, -(recipe.gold or 0), false, DOTA_ModifyGold_PurchaseItem)
    local result = recipe.result
    if recipe.result_pool and #recipe.result_pool > 0 then
        result = recipe.result_pool[RandomInt(1, #recipe.result_pool)]
    end
    hero:AddItemByName(result)
    SirvUtils:NotifyPlayer(playerID, "Crafteo completado.", "success")
end

function CraftingSystem:Publish()
    CustomNetTables:SetTableValue("crafting_data", "recipes", CraftingRecipes)
end
