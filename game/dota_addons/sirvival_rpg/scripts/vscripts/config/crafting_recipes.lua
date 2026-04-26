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
