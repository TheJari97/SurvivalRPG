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
}
