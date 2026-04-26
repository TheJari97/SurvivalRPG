ShopConfig = {
    premium_currency = {
        id = "titan_shards",
        name_es = "Fragmentos Titanicos",
        name_en = "Titan Shards",
        note_es = "Moneda premium futura para cosmeticos. No debe dar poder directo sin revisar reglas de Valve.",
    },
    world_items = {
        [1] = {
            "item_sirv_potion_small",
            "item_sirv_potion_mana",
            "item_sirv_shop_w1_guard_blade",
            "item_sirv_shop_w1_hunter_knife",
            "item_sirv_shop_w1_apprentice_wand",
            "item_sirv_shop_w1_padded_vest",
            "item_sirv_shop_w1_travel_boots",
            "item_sirv_shop_w1_field_charm",
        },
        [2] = {
            "item_sirv_shop_w2_guard_halberd",
            "item_sirv_shop_w2_quickblade",
            "item_sirv_shop_w2_spell_lantern",
            "item_sirv_shop_w2_mender_cloak",
        },
        [3] = {
            "item_sirv_shop_w3_frontline_plate",
            "item_sirv_shop_w3_shadow_edge",
            "item_sirv_shop_w3_runed_focus",
            "item_sirv_shop_w3_sage_wraps",
        },
    },
    item_info = {
        ["item_sirv_potion_small"] = { world = 1, role = "consumible", slot = "potion", source = "shop_only" },
        ["item_sirv_potion_mana"] = { world = 1, role = "consumible", slot = "potion", source = "shop_only" },

        ["item_sirv_shop_w1_guard_blade"] = { world = 1, role = "tank", slot = "weapon", source = "shop_only" },
        ["item_sirv_shop_w1_hunter_knife"] = { world = 1, role = "assassin", slot = "weapon", source = "shop_only" },
        ["item_sirv_shop_w1_apprentice_wand"] = { world = 1, role = "mage_healer", slot = "relic", source = "shop_only" },
        ["item_sirv_shop_w1_padded_vest"] = { world = 1, role = "all", slot = "chest", source = "shop_only" },
        ["item_sirv_shop_w1_travel_boots"] = { world = 1, role = "all", slot = "boots", source = "shop_only" },
        ["item_sirv_shop_w1_field_charm"] = { world = 1, role = "support", slot = "relic", source = "shop_only" },

        ["item_sirv_shop_w2_guard_halberd"] = { world = 2, role = "tank", slot = "weapon", source = "shop_only" },
        ["item_sirv_shop_w2_quickblade"] = { world = 2, role = "assassin_dps", slot = "weapon", source = "shop_only" },
        ["item_sirv_shop_w2_spell_lantern"] = { world = 2, role = "mage", slot = "relic", source = "shop_only" },
        ["item_sirv_shop_w2_mender_cloak"] = { world = 2, role = "healer_support", slot = "cape", source = "shop_only" },

        ["item_sirv_shop_w3_frontline_plate"] = { world = 3, role = "tank", slot = "chest", source = "shop_only" },
        ["item_sirv_shop_w3_shadow_edge"] = { world = 3, role = "assassin", slot = "weapon", source = "shop_only" },
        ["item_sirv_shop_w3_runed_focus"] = { world = 3, role = "mage", slot = "relic", source = "shop_only" },
        ["item_sirv_shop_w3_sage_wraps"] = { world = 3, role = "healer", slot = "head", source = "shop_only" },
    },
    cosmetics = {
        { id = "pet_skin_shadow_wolf_ember", name_es = "Skin Lobo de Brasa", premium_cost = 600, applies_to = "shadow_wolf" },
        { id = "pet_skin_moon_wisp_gold", name_es = "Skin Brizna Dorada", premium_cost = 750, applies_to = "moon_wisp" },
        { id = "hero_aura_founder", name_es = "Aura Fundador", premium_cost = 1200, applies_to = "account" },
    },
}

function ShopConfig:GetAvailableItems(worldLevel)
    local items = {}
    local level = tonumber(worldLevel or 1) or 1
    for world = 1, level do
        for _, itemName in ipairs(self.world_items[world] or {}) do
            items[#items + 1] = itemName
        end
    end
    return items
end
