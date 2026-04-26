ShopSystem = ShopSystem or {}

function ShopSystem:Init(gameMode)
    self.gameMode = gameMode
    self:Publish()
end

function ShopSystem:OpenShop(keys)
    self:Publish()
end

function ShopSystem:GetAvailableItems()
    local worldLevel = WorldLevelSystem and WorldLevelSystem.current_level or 1
    return ShopConfig:GetAvailableItems(worldLevel)
end

function ShopSystem:BuyItem(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    local itemName = tostring(keys.item or "")
    local hero = SirvUtils:GetPlayerHero(playerID)
    if not hero then return end

    local allowed = false
    for _, item in pairs(self:GetAvailableItems()) do
        if item == itemName then allowed = true end
    end
    if not allowed then
        SirvUtils:NotifyPlayer(playerID, "La tienda no vende ese objeto en este Nivel de Mundo.", "warning")
        return
    end

    local cost = GetItemCost(itemName) or 0
    if PlayerResource:GetGold(playerID) < cost then
        SirvUtils:NotifyPlayer(playerID, "No tienes oro suficiente.", "warning")
        return
    end

    PlayerResource:ModifyGold(playerID, -cost, false, DOTA_ModifyGold_PurchaseItem)
    hero:AddItemByName(itemName)
    SirvUtils:NotifyPlayer(playerID, "Compra realizada.", "success")
end

function ShopSystem:BuyBasicItem(keys)
    self:BuyItem(keys)
end

function ShopSystem:BuildProgressionCatalog()
    local catalog = {}
    for _, rarity in ipairs(ItemTierConfig.rarities or {}) do
        for _, slot in ipairs(ItemTierConfig.slots or {}) do
            catalog[#catalog + 1] = "item_sirv_" .. rarity .. "_" .. slot
        end
    end
    return catalog
end

function ShopSystem:BuildRecipePreview()
    local preview = {}
    for recipeID, recipe in pairs(CraftingRecipes or {}) do
        preview[#preview + 1] = {
            id = recipeID,
            npc = recipe.npc,
            result = recipe.result,
            result_pool = recipe.result_pool,
            gold = recipe.gold or 0,
            requires = recipe.requires or {},
            role = recipe.role,
            unlock_quest = recipe.unlock_quest,
        }
    end
    return preview
end

function ShopSystem:Publish()
    CustomNetTables:SetTableValue("shop_data", "basic", {
        items = self:GetAvailableItems(),
        item_info = ShopConfig.item_info,
        premium_currency = ShopConfig.premium_currency,
        world_level = WorldLevelSystem and WorldLevelSystem.current_level or 1,
        progression = self:BuildProgressionCatalog(),
        recipes = self:BuildRecipePreview(),
        cosmetics = ShopConfig.cosmetics,
    })
end
