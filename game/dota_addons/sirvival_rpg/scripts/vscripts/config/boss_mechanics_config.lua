BossMechanicsConfig = {
    weak = {
        { id = "minor_slam", name_es = "Golpe menor", type = "aoe_damage", damage = 70, radius = 260, cooldown = 8, weight = 32 },
        { id = "crippling_shout", name_es = "Grito debilitante", type = "slow", damage = 35, radius = 420, cooldown = 12, weight = 25 },
        { id = "bone_spikes", name_es = "Espinas oseas", type = "aoe_damage", damage = 55, radius = 320, cooldown = 10, weight = 28 },
        { id = "thornhide", name_es = "Piel de espinas", type = "reflect_damage", reflect_pct = 8, duration = 5, cooldown = 18, weight = 15 },
    },
    common = {
        { id = "summon_adds", name_es = "Invocar esbirros", type = "summon", count = 2, cooldown = 18, weight = 24 },
        { id = "corrupt_pulse", name_es = "Pulso corrupto", type = "aoe_damage", damage = 130, radius = 430, cooldown = 14, weight = 30 },
        { id = "armor_break", name_es = "Ruptura de armadura", type = "armor_break", damage = 80, radius = 380, cooldown = 16, weight = 26 },
        { id = "mirror_ward", name_es = "Guardia reflectante", type = "reflect_damage", reflect_pct = 14, duration = 6, cooldown = 22, weight = 20 },
    },
    strong = {
        { id = "enrage", name_es = "Enfurecer", type = "enrage", cooldown = 25, duration = 8, weight = 28 },
        { id = "titan_nova", name_es = "Nova titanica", type = "aoe_damage", damage = 260, radius = 560, cooldown = 24, weight = 32 },
        { id = "demonic_call", name_es = "Llamado demoniaco", type = "summon", count = 4, cooldown = 28, weight = 22 },
        { id = "titan_reflection", name_es = "Reflejo titanico", type = "reflect_damage", reflect_pct = 22, duration = 7, cooldown = 28, weight = 18 },
    },
}
