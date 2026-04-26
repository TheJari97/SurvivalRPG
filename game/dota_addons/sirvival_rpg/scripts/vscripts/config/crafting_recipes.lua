CraftingRecipes = {
    ["forge_common_weapon_t1"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["result"] = "item_sirv_common_weapon",
        ["gold"] = 180,
        ["requires"] = {
            ["item_sirv_basic_weapon"] = 1,
            ["item_sirv_material_iron_fragment"] = 3,
        },
    },
    ["forge_rare_weapon_t1"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["result"] = "item_sirv_rare_weapon",
        ["gold"] = 420,
        ["requires"] = {
            ["item_sirv_common_weapon"] = 1,
            ["item_sirv_material_iron_fragment"] = 5,
            ["item_sirv_material_elite_core"] = 1,
        },
    },
    ["forge_epic_chest_t1"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["result"] = "item_sirv_epic_chest",
        ["gold"] = 850,
        ["requires"] = {
            ["item_sirv_rare_chest"] = 1,
            ["item_sirv_material_boss_mark"] = 1,
            ["item_sirv_material_ancient_gem"] = 1,
        },
    },
    ["upgrade_artifact_wall_heart"] = {
        ["npc"] = "npc_artifact_master_spawn",
        ["result"] = "item_sirv_artifact_wall_heart",
        ["gold"] = 650,
        ["requires"] = {
            ["item_sirv_material_boss_mark"] = 1,
            ["item_sirv_material_ancient_gem"] = 2,
        },
    },
    ["pet_basic_collar"] = {
        ["npc"] = "npc_pet_keeper_spawn",
        ["result"] = "item_sirv_pet_collar",
        ["gold"] = 220,
        ["requires"] = {
            ["item_sirv_material_wild_essence"] = 3,
        },
    },
    ["craft_w1_tank_oak_guard"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["role"] = "tank",
        ["result_pool"] = { "item_sirv_common_chest", "item_sirv_common_head", "item_sirv_common_cape" },
        ["gold"] = 260,
        ["unlock_quest"] = "intro_first_forge",
        ["requires"] = {
            ["item_sirv_material_iron_fragment"] = 5,
            ["item_sirv_material_wild_essence"] = 1,
        },
    },
    ["craft_w1_assassin_fox_edge"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["role"] = "assassin",
        ["result_pool"] = { "item_sirv_common_weapon", "item_sirv_common_boots", "item_sirv_common_relic" },
        ["gold"] = 270,
        ["unlock_quest"] = "intro_first_forge",
        ["requires"] = {
            ["item_sirv_material_iron_fragment"] = 4,
            ["item_sirv_material_arcane_dust"] = 1,
        },
    },
    ["craft_w1_dps_hunter_mark"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["role"] = "dps",
        ["result_pool"] = { "item_sirv_common_weapon", "item_sirv_common_relic", "item_sirv_common_backpack" },
        ["gold"] = 270,
        ["unlock_quest"] = "intro_first_forge",
        ["requires"] = {
            ["item_sirv_material_iron_fragment"] = 4,
            ["item_sirv_material_wild_essence"] = 2,
        },
    },
    ["craft_w1_healer_mender_seed"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["role"] = "healer",
        ["result_pool"] = { "item_sirv_common_relic", "item_sirv_common_cape", "item_sirv_common_head" },
        ["gold"] = 250,
        ["unlock_quest"] = "intro_first_forge",
        ["requires"] = {
            ["item_sirv_material_wild_essence"] = 3,
            ["item_sirv_material_arcane_dust"] = 1,
        },
    },
    ["craft_w1_mage_spark_focus"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["role"] = "mage",
        ["result_pool"] = { "item_sirv_common_relic", "item_sirv_common_weapon", "item_sirv_common_cape" },
        ["gold"] = 260,
        ["unlock_quest"] = "intro_first_forge",
        ["requires"] = {
            ["item_sirv_material_arcane_dust"] = 2,
            ["item_sirv_material_iron_fragment"] = 3,
        },
    },
    ["craft_w1_special_rush_boots"] = {
        ["npc"] = "npc_crafting_master_spawn",
        ["role"] = "special",
        ["result_pool"] = { "item_sirv_rare_boots", "item_sirv_rare_cape" },
        ["gold"] = 520,
        ["unlock_quest"] = "timed_zone_1_clean",
        ["requires"] = {
            ["item_sirv_common_boots"] = 1,
            ["item_sirv_material_elite_core"] = 1,
            ["item_sirv_material_boss_mark"] = 1,
        },
    },
}

local function AddCraftingRecipe(id, data)
    CraftingRecipes[id] = data
end

local function AddWorldOneCraft(spec)
    AddCraftingRecipe("craft_w1_" .. spec.id, {
        ["npc"] = "npc_crafting_master_spawn",
        ["display_es"] = spec.name_es,
        ["role"] = spec.role,
        ["slot"] = spec.slot,
        ["tier"] = 1,
        ["source"] = "craft",
        ["result"] = spec.result,
        ["gold"] = spec.gold,
        ["unlock_quest"] = "intro_first_forge",
        ["stat_focus"] = ItemTierConfig.role_stat_focus[spec.role] or {},
        ["requires"] = spec.requires,
    })
end

local WorldOneCraftables = {
    { id = "tank_iron_bulwark", name_es = "Baluarte de Hierro", role = "tank", slot = "chest", result = "item_sirv_common_chest", gold = 250, requires = { item_sirv_material_iron_fragment = 5, item_sirv_material_wild_essence = 1 } },
    { id = "tank_oak_helm", name_es = "Yelmo de Roble", role = "tank", slot = "head", result = "item_sirv_common_head", gold = 245, requires = { item_sirv_material_iron_fragment = 4, item_sirv_material_wild_essence = 2 } },
    { id = "tank_guard_cape", name_es = "Capa de Guardia", role = "tank", slot = "cape", result = "item_sirv_common_cape", gold = 235, requires = { item_sirv_material_iron_fragment = 3, item_sirv_material_arcane_dust = 1, item_sirv_material_wild_essence = 1 } },
    { id = "tank_anchor_mace", name_es = "Maza Ancla", role = "tank", slot = "weapon", result = "item_sirv_common_weapon", gold = 270, requires = { item_sirv_material_iron_fragment = 6 } },
    { id = "tank_rooted_boots", name_es = "Botas Enraizadas", role = "tank", slot = "boots", result = "item_sirv_common_boots", gold = 230, requires = { item_sirv_material_iron_fragment = 3, item_sirv_material_wild_essence = 2 } },

    { id = "melee_dps_duelist_blade", name_es = "Hoja de Duelista", role = "melee_dps", slot = "weapon", result = "item_sirv_common_weapon", gold = 270, requires = { item_sirv_material_iron_fragment = 5, item_sirv_material_arcane_dust = 1 } },
    { id = "melee_dps_frenzy_band", name_es = "Brazal de Frenesi", role = "melee_dps", slot = "relic", result = "item_sirv_common_relic", gold = 255, requires = { item_sirv_material_iron_fragment = 3, item_sirv_material_wild_essence = 2 } },
    { id = "melee_dps_duel_vest", name_es = "Peto de Duelo", role = "melee_dps", slot = "chest", result = "item_sirv_common_chest", gold = 250, requires = { item_sirv_material_iron_fragment = 4, item_sirv_material_wild_essence = 1 } },
    { id = "melee_dps_rush_boots", name_es = "Botas de Embate", role = "melee_dps", slot = "boots", result = "item_sirv_common_boots", gold = 245, requires = { item_sirv_material_iron_fragment = 3, item_sirv_material_arcane_dust = 1 } },
    { id = "melee_dps_blood_cape", name_es = "Capa Sangrienta", role = "melee_dps", slot = "cape", result = "item_sirv_common_cape", gold = 255, requires = { item_sirv_material_wild_essence = 3, item_sirv_material_iron_fragment = 2 } },

    { id = "ranged_dps_hunter_bow", name_es = "Arco de Cazador", role = "ranged_dps", slot = "weapon", result = "item_sirv_common_weapon", gold = 270, requires = { item_sirv_material_iron_fragment = 4, item_sirv_material_wild_essence = 2 } },
    { id = "ranged_dps_cadence_glove", name_es = "Guante de Cadencia", role = "ranged_dps", slot = "relic", result = "item_sirv_common_relic", gold = 255, requires = { item_sirv_material_iron_fragment = 3, item_sirv_material_arcane_dust = 1, item_sirv_material_wild_essence = 1 } },
    { id = "ranged_dps_branch_scope", name_es = "Mira de Rama", role = "ranged_dps", slot = "head", result = "item_sirv_common_head", gold = 250, requires = { item_sirv_material_wild_essence = 3, item_sirv_material_arcane_dust = 1 } },
    { id = "ranged_dps_position_boots", name_es = "Botas de Posicion", role = "ranged_dps", slot = "boots", result = "item_sirv_common_boots", gold = 240, requires = { item_sirv_material_iron_fragment = 2, item_sirv_material_wild_essence = 3 } },
    { id = "ranged_dps_light_quiver", name_es = "Carcaj Ligero", role = "ranged_dps", slot = "backpack", result = "item_sirv_common_backpack", gold = 235, requires = { item_sirv_material_iron_fragment = 2, item_sirv_material_wild_essence = 2 } },

    { id = "assassin_fox_dagger", name_es = "Daga del Zorro", role = "assassin", slot = "weapon", result = "item_sirv_common_weapon", gold = 275, requires = { item_sirv_material_iron_fragment = 4, item_sirv_material_arcane_dust = 2 } },
    { id = "assassin_silent_boots", name_es = "Botas Silenciosas", role = "assassin", slot = "boots", result = "item_sirv_common_boots", gold = 250, requires = { item_sirv_material_iron_fragment = 2, item_sirv_material_arcane_dust = 1, item_sirv_material_wild_essence = 1 } },
    { id = "assassin_shadow_cloak", name_es = "Manto de Sombra", role = "assassin", slot = "cape", result = "item_sirv_common_cape", gold = 255, requires = { item_sirv_material_arcane_dust = 2, item_sirv_material_wild_essence = 2 } },
    { id = "assassin_venom_ring", name_es = "Anillo Venenoso", role = "assassin", slot = "relic", result = "item_sirv_common_relic", gold = 260, requires = { item_sirv_material_arcane_dust = 2, item_sirv_material_iron_fragment = 2 } },
    { id = "assassin_stalker_hood", name_es = "Capucha del Acecho", role = "assassin", slot = "head", result = "item_sirv_common_head", gold = 245, requires = { item_sirv_material_wild_essence = 2, item_sirv_material_arcane_dust = 1 } },

    { id = "mage_spark_staff", name_es = "Baston de Chispas", role = "mage", slot = "weapon", result = "item_sirv_common_weapon", gold = 265, requires = { item_sirv_material_arcane_dust = 3, item_sirv_material_iron_fragment = 2 } },
    { id = "mage_ember_focus", name_es = "Foco de Brasa", role = "mage", slot = "relic", result = "item_sirv_common_relic", gold = 260, requires = { item_sirv_material_arcane_dust = 3, item_sirv_material_wild_essence = 1 } },
    { id = "mage_clear_mantle", name_es = "Manto Claro", role = "mage", slot = "cape", result = "item_sirv_common_cape", gold = 245, requires = { item_sirv_material_arcane_dust = 2, item_sirv_material_wild_essence = 2 } },
    { id = "mage_runic_crown", name_es = "Corona Runica", role = "mage", slot = "head", result = "item_sirv_common_head", gold = 250, requires = { item_sirv_material_arcane_dust = 2, item_sirv_material_iron_fragment = 2 } },
    { id = "mage_mana_pack", name_es = "Morral de Mana", role = "mage", slot = "backpack", result = "item_sirv_common_backpack", gold = 240, requires = { item_sirv_material_arcane_dust = 2, item_sirv_material_wild_essence = 1 } },

    { id = "healer_mender_seed", name_es = "Semilla del Sanador", role = "healer", slot = "relic", result = "item_sirv_common_relic", gold = 250, requires = { item_sirv_material_wild_essence = 3, item_sirv_material_arcane_dust = 1 } },
    { id = "healer_life_thread", name_es = "Hilo de Vida", role = "healer", slot = "cape", result = "item_sirv_common_cape", gold = 245, requires = { item_sirv_material_wild_essence = 4 } },
    { id = "healer_soft_circlet", name_es = "Diadema Serena", role = "healer", slot = "head", result = "item_sirv_common_head", gold = 245, requires = { item_sirv_material_wild_essence = 2, item_sirv_material_arcane_dust = 2 } },
    { id = "healer_grace_staff", name_es = "Baston de Gracia", role = "healer", slot = "weapon", result = "item_sirv_common_weapon", gold = 255, requires = { item_sirv_material_iron_fragment = 2, item_sirv_material_wild_essence = 2, item_sirv_material_arcane_dust = 1 } },
    { id = "healer_calm_sandals", name_es = "Sandalias Calmas", role = "healer", slot = "boots", result = "item_sirv_common_boots", gold = 235, requires = { item_sirv_material_wild_essence = 2, item_sirv_material_arcane_dust = 1 } },

    { id = "support_field_charm", name_es = "Amuleto de Campo", role = "support", slot = "relic", result = "item_sirv_common_relic", gold = 250, requires = { item_sirv_material_wild_essence = 2, item_sirv_material_arcane_dust = 2 } },
    { id = "support_low_threat_cloak", name_es = "Capa de Bajo Perfil", role = "support", slot = "cape", result = "item_sirv_common_cape", gold = 245, requires = { item_sirv_material_arcane_dust = 2, item_sirv_material_iron_fragment = 2 } },
    { id = "support_signal_hood", name_es = "Capucha de Senales", role = "support", slot = "head", result = "item_sirv_common_head", gold = 245, requires = { item_sirv_material_wild_essence = 2, item_sirv_material_iron_fragment = 2 } },
    { id = "support_runner_boots", name_es = "Botas de Mensajero", role = "support", slot = "boots", result = "item_sirv_common_boots", gold = 235, requires = { item_sirv_material_wild_essence = 2, item_sirv_material_arcane_dust = 1 } },
    { id = "support_supply_pack", name_es = "Mochila de Suministros", role = "support", slot = "backpack", result = "item_sirv_common_backpack", gold = 240, requires = { item_sirv_material_iron_fragment = 2, item_sirv_material_wild_essence = 2 } },
}

for _, spec in ipairs(WorldOneCraftables) do
    AddWorldOneCraft(spec)
end

local WorldOneUpgradeRecipes = {
    { id = "tank_rare_bastion", name_es = "Bastion Reforzado", role = "tank", result = "item_sirv_rare_chest", gold = 520, requires = { item_sirv_common_chest = 1, item_sirv_common_head = 1, item_sirv_material_elite_core = 1 } },
    { id = "melee_dps_rare_warbrand", name_es = "Marca de Guerra", role = "melee_dps", result = "item_sirv_rare_weapon", gold = 530, requires = { item_sirv_common_weapon = 1, item_sirv_common_relic = 1, item_sirv_material_elite_core = 1 } },
    { id = "ranged_dps_rare_hawkmark", name_es = "Marca de Halcon", role = "ranged_dps", result = "item_sirv_rare_relic", gold = 530, requires = { item_sirv_common_weapon = 1, item_sirv_common_backpack = 1, item_sirv_material_elite_core = 1 } },
    { id = "assassin_rare_nightcut", name_es = "Corte Nocturno", role = "assassin", result = "item_sirv_rare_weapon", gold = 535, requires = { item_sirv_common_weapon = 1, item_sirv_common_boots = 1, item_sirv_material_elite_core = 1 } },
    { id = "mage_rare_arcane_focus", name_es = "Foco Arcano", role = "mage", result = "item_sirv_rare_relic", gold = 520, requires = { item_sirv_common_relic = 1, item_sirv_common_head = 1, item_sirv_material_elite_core = 1 } },
    { id = "healer_rare_lifebloom", name_es = "Flor de Vida", role = "healer", result = "item_sirv_rare_cape", gold = 510, requires = { item_sirv_common_relic = 1, item_sirv_common_cape = 1, item_sirv_material_elite_core = 1 } },
    { id = "support_rare_quiet_banner", name_es = "Estandarte Silencioso", role = "support", result = "item_sirv_rare_backpack", gold = 510, requires = { item_sirv_common_backpack = 1, item_sirv_common_cape = 1, item_sirv_material_elite_core = 1 } },

    { id = "tank_epic_fortress_shell", name_es = "Coraza Fortaleza", role = "tank", result = "item_sirv_epic_chest", gold = 900, requires = { item_sirv_rare_chest = 1, item_sirv_material_boss_mark = 1, item_sirv_material_ancient_gem = 1 } },
    { id = "melee_dps_epic_red_wake", name_es = "Estela Roja", role = "melee_dps", result = "item_sirv_epic_weapon", gold = 920, requires = { item_sirv_rare_weapon = 1, item_sirv_material_boss_mark = 1, item_sirv_material_ancient_gem = 1 } },
    { id = "ranged_dps_epic_sun_quiver", name_es = "Carcaj Solar", role = "ranged_dps", result = "item_sirv_epic_backpack", gold = 900, requires = { item_sirv_rare_relic = 1, item_sirv_material_boss_mark = 1, item_sirv_material_ancient_gem = 1 } },
    { id = "assassin_epic_black_step", name_es = "Paso Negro", role = "assassin", result = "item_sirv_epic_boots", gold = 915, requires = { item_sirv_rare_weapon = 1, item_sirv_material_boss_mark = 1, item_sirv_material_ancient_gem = 1 } },
    { id = "mage_epic_star_lantern", name_es = "Farol Estelar", role = "mage", result = "item_sirv_epic_relic", gold = 900, requires = { item_sirv_rare_relic = 1, item_sirv_material_boss_mark = 1, item_sirv_material_ancient_gem = 1 } },
    { id = "healer_epic_grace_mantle", name_es = "Manto de Gracia", role = "healer", result = "item_sirv_epic_cape", gold = 890, requires = { item_sirv_rare_cape = 1, item_sirv_material_boss_mark = 1, item_sirv_material_ancient_gem = 1 } },
    { id = "support_epic_calm_pack", name_es = "Morral de Calma", role = "support", result = "item_sirv_epic_backpack", gold = 890, requires = { item_sirv_rare_backpack = 1, item_sirv_material_boss_mark = 1, item_sirv_material_ancient_gem = 1 } },
}

for _, spec in ipairs(WorldOneUpgradeRecipes) do
    AddCraftingRecipe("upgrade_w1_" .. spec.id, {
        ["npc"] = "npc_crafting_master_spawn",
        ["display_es"] = spec.name_es,
        ["role"] = spec.role,
        ["source"] = "craft_upgrade",
        ["result"] = spec.result,
        ["gold"] = spec.gold,
        ["unlock_quest"] = "optional_zone_1_elite",
        ["stat_focus"] = ItemTierConfig.role_stat_focus[spec.role] or {},
        ["requires"] = spec.requires,
    })
end
