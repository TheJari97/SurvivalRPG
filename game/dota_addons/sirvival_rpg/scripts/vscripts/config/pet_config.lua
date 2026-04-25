PetConfig = {
    ["stone_cub"] = {
        name_es = "Cachorro de Piedra",
        role = "tanque",
        unit = "npc_sirv_pet_stone_cub",
        active = "taunt_guard",
        unlock_level = 20,
        rarity = "common",
        stats = {
            health = { 90, 160 },
            armor = { 2, 5 },
        },
    },
    ["moon_wisp"] = {
        name_es = "Brizna Lunar",
        role = "healer",
        unit = "npc_sirv_pet_moon_wisp",
        active = "periodic_heal",
        unlock_level = 20,
        rarity = "rare",
        stats = {
            heal_amp = { 4, 9 },
            mana = { 60, 140 },
        },
    },
    ["ember_imp"] = {
        name_es = "Diablillo de Brasa",
        role = "dps_magico",
        unit = "npc_sirv_pet_ember_imp",
        active = "periodic_magic_damage",
        unlock_level = 20,
        rarity = "rare",
        stats = {
            magic_damage = { 4, 11 },
        },
    },
    ["iron_hawk"] = {
        name_es = "Halcon de Hierro",
        role = "dps_fisico",
        unit = "npc_sirv_pet_iron_hawk",
        active = "periodic_physical_damage",
        unlock_level = 20,
        rarity = "epic",
        stats = {
            damage = { 8, 20 },
            crit = { 3, 8 },
        },
    },
}
