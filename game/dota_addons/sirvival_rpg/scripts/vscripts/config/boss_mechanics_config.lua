BossMechanicsConfig = {
    weak = {
        { id = "minor_slam", name_es = "Golpe menor", type = "aoe_damage", damage = 70, radius = 260, cooldown = 8 },
        { id = "crippling_shout", name_es = "Grito debilitante", type = "slow", damage = 35, radius = 420, cooldown = 12 },
        { id = "bone_spikes", name_es = "Espinas oseas", type = "aoe_damage", damage = 55, radius = 320, cooldown = 10 },
    },
    common = {
        { id = "summon_adds", name_es = "Invocar esbirros", type = "summon", count = 2, cooldown = 18 },
        { id = "corrupt_pulse", name_es = "Pulso corrupto", type = "aoe_damage", damage = 130, radius = 430, cooldown = 14 },
        { id = "armor_break", name_es = "Ruptura de armadura", type = "armor_break", damage = 80, radius = 380, cooldown = 16 },
    },
    strong = {
        { id = "enrage", name_es = "Enfurecer", type = "enrage", cooldown = 25, duration = 8 },
        { id = "titan_nova", name_es = "Nova titanica", type = "aoe_damage", damage = 260, radius = 560, cooldown = 24 },
        { id = "demonic_call", name_es = "Llamado demoniaco", type = "summon", count = 4, cooldown = 28 },
    },
}
