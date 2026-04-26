PetSystem = PetSystem or {}

LinkLuaModifier("modifier_sirv_pet_companion", "systems/pet_system.lua", LUA_MODIFIER_MOTION_NONE)

function PetSystem:Init(gameMode)
    self.gameMode = gameMode
    self.players = {}
    self.pet_units = {}
    self:Publish()
end

function PetSystem:Open(keys)
    self:Publish()
end

function PetSystem:GetPlayerData(playerID)
    local data = self.players[playerID]
    if not data or data.heroes == nil then
        data = { heroes = {}, skins = {} }
        self.players[playerID] = data
    end
    data.skins = data.skins or {}
    return data
end

function PetSystem:GetHeroPetData(playerID, hero)
    local data = self:GetPlayerData(playerID)
    local heroName = "unknown"
    if hero and not hero:IsNull() and hero.GetUnitName then
        heroName = hero:GetUnitName()
    end
    data.heroes[heroName] = data.heroes[heroName] or { unlocked = {}, active = nil, levels = {} }
    return data.heroes[heroName], heroName
end

function PetSystem:EquipPet(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    local pet = tostring(keys.pet or "stone_cub")
    local cfg = PetConfig[pet]
    local hero = SirvUtils:GetPlayerHero(playerID)
    if not hero or not cfg then return end

    local heroPets = self:GetHeroPetData(playerID, hero)
    heroPets.unlocked[pet] = true
    heroPets.active = pet
    heroPets.levels[pet] = heroPets.levels[pet] or 1

    self:RemoveVisiblePet(playerID)
    self:SpawnVisiblePet(playerID, hero, pet, cfg)
    hero:RemoveModifierByName("modifier_sirv_pet_companion")
    hero:AddNewModifier(hero, nil, "modifier_sirv_pet_companion", {})

    SirvUtils:NotifyPlayer(playerID, "Mascota equipada: " .. cfg.name_es .. ".", "success")
    self:Publish()
end

function PetSystem:SpawnVisiblePet(playerID, hero, pet, cfg)
    local unit = CreateUnitByName(cfg.unit or "npc_sirv_pet_stone_cub", hero:GetAbsOrigin() + RandomVector(160), true, hero, hero, DOTA_TEAM_GOODGUYS)
    if not unit then return end
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID, false)
    unit.srpg_pet_owner = hero
    unit.srpg_pet_id = pet
    self.pet_units[playerID] = unit
    self:StartPetThink(playerID, unit, hero, pet)
end

function PetSystem:RemoveVisiblePet(playerID)
    local old = self.pet_units[playerID]
    if old and not old:IsNull() then
        old:ForceKill(false)
        UTIL_Remove(old)
    end
    self.pet_units[playerID] = nil
end

function PetSystem:StartPetThink(playerID, unit, hero, pet)
    Timers:CreateTimer(0.5, function()
        if not unit or unit:IsNull() or not hero or hero:IsNull() then return nil end
        if not hero:IsAlive() then return 1.0 end
        if (unit:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D() > 900 then
            FindClearSpaceForUnit(unit, hero:GetAbsOrigin() + RandomVector(180), true)
        else
            unit:MoveToNPC(hero)
        end
        self:CastPetSupport(playerID, unit, hero, pet)
        return 1.0
    end)
end

function PetSystem:CastPetSupport(playerID, unit, hero, pet)
    unit.srpg_next_pet_cast = unit.srpg_next_pet_cast or 0
    if GameRules:GetGameTime() < unit.srpg_next_pet_cast then return end
    unit.srpg_next_pet_cast = GameRules:GetGameTime() + 16

    local cfg = PetConfig[pet]
    if not cfg then return end

    if cfg.active == "periodic_heal" then
        local heroPets = self:GetHeroPetData(playerID, hero)
        hero:Heal(180 + 20 * (heroPets.levels[pet] or 1), unit)
        return
    end

    local enemies = FindUnitsInRadius(
        DOTA_TEAM_GOODGUYS,
        hero:GetAbsOrigin(),
        nil,
        650,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )
    local target = enemies[1]
    if not target then return end

    if cfg.active == "periodic_magic_damage" then
        ApplyDamage({ victim = target, attacker = hero, damage = 160, damage_type = DAMAGE_TYPE_MAGICAL, ability = nil })
    elseif cfg.active == "periodic_physical_damage" then
        ApplyDamage({ victim = target, attacker = hero, damage = 140, damage_type = DAMAGE_TYPE_PHYSICAL, ability = nil })
    elseif cfg.active == "taunt_guard" then
        target:MoveToTargetToAttack(unit)
    end
end

function PetSystem:UpgradePet(keys)
    local playerID = tonumber(keys.PlayerID or -1)
    local pet = tostring(keys.pet or "stone_cub")
    local hero = SirvUtils:GetPlayerHero(playerID)
    if not hero then return end
    local heroPets = self:GetHeroPetData(playerID, hero)
    heroPets.unlocked[pet] = true
    heroPets.levels[pet] = (heroPets.levels[pet] or 1) + 1
    SirvUtils:NotifyPlayer(playerID, "Mascota mejorada.", "success")
    self:Publish()
end

function PetSystem:Publish()
    CustomNetTables:SetTableValue("pet_data", "catalog", PetConfig)
    CustomNetTables:SetTableValue("pet_data", "players", self.players)
end

modifier_sirv_pet_companion = class({})
function modifier_sirv_pet_companion:IsHidden() return false end
function modifier_sirv_pet_companion:IsPurgable() return false end
function modifier_sirv_pet_companion:DeclareFunctions()
    return { MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE }
end
function modifier_sirv_pet_companion:GetModifierHealthBonus() return 120 end
function modifier_sirv_pet_companion:GetModifierPreAttack_BonusDamage() return 12 end
function modifier_sirv_pet_companion:GetModifierHPRegenAmplify_Percentage() return 8 end
