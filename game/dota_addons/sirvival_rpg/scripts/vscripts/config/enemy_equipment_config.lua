EnemyEquipmentConfig = {
    zone_items = {
        [1] = {
            common = {
                { id = "enemy_w1_moss_claws", name_es = "Garras musgosas", damage = 3, health = 0, armor = 0, weight = 35 },
                { id = "enemy_w1_bark_wrap", name_es = "Vendas de corteza", damage = 0, health = 60, armor = 1, weight = 30 },
                { id = "enemy_w1_splinter_tip", name_es = "Punta astillada", damage = 5, health = 0, armor = 0, weight = 25 },
                { id = "enemy_w1_old_totem", name_es = "Totem viejo", damage = 2, health = 30, armor = 0, weight = 10 },
            },
            elite = {
                { id = "enemy_w1_alpha_charm", name_es = "Amuleto alfa", damage = 10, health = 180, armor = 2, weight = 60 },
                { id = "enemy_w1_grove_plate", name_es = "Placa del claro", damage = 4, health = 260, armor = 4, weight = 40 },
            },
            area_boss = {
                { id = "enemy_w1_keeper_root", name_es = "Raiz del guardian", damage = 12, health = 420, armor = 5, weight = 100 },
            },
            zone_boss = {
                { id = "enemy_w1_crown_of_roots", name_es = "Corona de raices", damage = 18, health = 700, armor = 7, weight = 100 },
            },
        },
    },
}

function EnemyEquipmentConfig:Pick(zone, category)
    local zoneCfg = self.zone_items[zone] or self.zone_items[1]
    local pool = zoneCfg and (zoneCfg[category] or zoneCfg.common) or {}
    local total = 0
    for _, item in pairs(pool) do total = total + (item.weight or 1) end
    if total <= 0 then return nil end

    local roll = RandomFloat(0, total)
    local cursor = 0
    for _, item in pairs(pool) do
        cursor = cursor + (item.weight or 1)
        if roll <= cursor then return item end
    end
    return pool[#pool]
end
