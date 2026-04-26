ShopSystem = ShopSystem or {}

function ShopSystem:Init(gameMode)
    self.gameMode = gameMode
    self.items = {
        "item_sirv_potion_small",
        "item_sirv_potion_mana",
        "item_sirv_basic_weapon",
        "item_sirv_basic_head",
        "item_sirv_basic_chest",
        "item_sirv_basic_boots",
        "item_sirv_basic_backpack",
        "item_sirv_material_iron_fragment",
    }
    self.cosmetics = {
        { id = "pet_skin_shadow_wolf_ember", name_es = "Skin Lobo de Brasa", premium_cost = 600, applies_to = "shadow_wolf" },
        { id = "pet_skin_moon_wisp_gold", name_es = "Skin Brizna Dorada", premium_cost = 750, applies_to = "moon_wisp" },
        { id = "hero_aura_founder", name_es = "Aura Fundador", premium_cost = 1200, applies_to = "account" },
    }
    self:Publish()
end

function ShopSystem:OpenShop(keys)
    self:Publish()
end

function ShopSystem:BuyItem(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    local itemName = tostring(keys.item or "")
    local hero = SirvUtils:GetPlayerHero(playerID)
    if not hero then return end
    local allowed = false
    for _, item in pairs(self.items) do if item == itemName then allowed = true end end
    if not allowed then
        SirvUtils:NotifyPlayer(playerID, "La tienda básica no vende ese objeto.", "warning")
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
            gold = recipe.gold or 0,
            requires = recipe.requires or {},
        }
    end
    return preview
end

function ShopSystem:Publish()
    CustomNetTables:SetTableValue("shop_data", "basic", {
        items = self.items,
        progression = self:BuildProgressionCatalog(),
        recipes = self:BuildRecipePreview(),
        cosmetics = self.cosmetics,
    })
end
