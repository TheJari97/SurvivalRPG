require("addon_init")

if SurvivalRPG == nil then
    SurvivalRPG = class({})
end

SirvivalRPG = SurvivalRPG

function Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context)
    PrecacheResource("particle", "particles/items_fx/black_king_bar_avatar.vpcf", context)
    PrecacheUnitByNameSync("npc_sirv_shop_basic", context)
    PrecacheUnitByNameSync("npc_sirv_crafting_master", context)
    PrecacheUnitByNameSync("npc_sirv_artifact_master", context)
    PrecacheUnitByNameSync("npc_sirv_pet_keeper", context)
    PrecacheUnitByNameSync("npc_sirv_season_keeper", context)
    PrecacheUnitByNameSync("npc_sirv_cosmetic_vendor", context)
    PrecacheUnitByNameSync("npc_sirv_pet_stone_cub", context)
    PrecacheUnitByNameSync("npc_sirv_pet_moon_wisp", context)
    PrecacheUnitByNameSync("npc_sirv_pet_ember_imp", context)
    PrecacheUnitByNameSync("npc_sirv_pet_iron_hawk", context)
    PrecacheUnitByNameSync("npc_sirv_pet_shadow_wolf", context)
    PrecacheUnitByNameSync("npc_sirv_pet_ember_cat", context)
    PrecacheUnitByNameSync("npc_sirv_pet_mini_roshan", context)
    PrecacheUnitByNameSync("npc_sirv_pet_grove_sprite", context)
    PrecacheUnitByNameSync("npc_sirv_pet_runic_turtle", context)
    PrecacheUnitByNameSync("npc_sirv_pet_clockwork_beetle", context)
end

function Activate()
    GameRules.SurvivalRPG = SurvivalRPG()
    GameRules.SirvivalRPG = GameRules.SurvivalRPG
    GameRules.SurvivalRPG:InitGameMode()
end

function SurvivalRPG:InitGameMode()
    print("[SurvivalRPG] InitGameMode v" .. SurvivalConfig.VERSION)

    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, SurvivalConfig.MAX_PLAYERS)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
    GameRules:SetHeroRespawnEnabled(false)
    GameRules:SetUseUniversalShopMode(true)
    GameRules:SetStartingGold(SurvivalConfig.STARTING_GOLD or 0)
    GameRules:SetPreGameTime(15)
    GameRules:SetPostGameTime(30)
    GameRules:SetTreeRegrowTime(120)

    local mode = GameRules:GetGameModeEntity()
    mode:SetRecommendedItemsDisabled(true)
    mode:SetBuybackEnabled(false)
    mode:SetLoseGoldOnDeath(false)
    mode:SetFixedRespawnTime(SurvivalConfig.RESPAWN_DELAY)
    mode:SetCameraDistanceOverride(SurvivalConfig.CAMERA_DISTANCE)
    mode:SetThink("OnThink", self, "SurvivalThink", 1.0)

    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(SurvivalRPG, "OnGameRulesStateChange"), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(SurvivalRPG, "OnNPCSpawned"), self)
    ListenToGameEvent("entity_killed", Dynamic_Wrap(SurvivalRPG, "OnEntityKilled"), self)

    PlayerProgressionSystem:Init(self)
    PlayerLifeSystem:Init(self)
    ThreatSystem:Init(self)
    SafeZoneSystem:Init(self)
    WorldLevelSystem:Init(self)
    ZoneSystem:Init(self)
    RespawnSystem:Init(self)
    EnemySpawnSystem:Init(self)
    BossSystem:Init(self)
    DropSystem:Init(self)
    ShopSystem:Init(self)
    CraftingSystem:Init(self)
    QuestSystem:Init(self)
    ArtifactSystem:Init(self)
    PetSystem:Init(self)
    SeasonSystem:Init(self)
    SaveSystem:Init(self)
    UIEventSystem:Init(self)

    SirvUtils:PublishGameState()
end

function SurvivalRPG:OnGameRulesStateChange()
    local state = GameRules:State_Get()
    if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        PlayerLifeSystem:InitializePlayers()
        EnemySpawnSystem:SpawnHubNPCs()
        EnemySpawnSystem:StartZone(1)
        SirvUtils:NotifyAll("SurvivalRPG iniciado. Zona 1 activa.", "success")
    end
end

function SurvivalRPG:OnNPCSpawned(event)
    local unit = EntIndexToHScript(event.entindex)
    if not unit then return end
    if unit:IsRealHero() and not unit.srpg_initialized then
        unit.srpg_initialized = true
        local playerID = unit:GetPlayerOwnerID()
        PlayerProgressionSystem:InitializePlayer(playerID)
        QuestSystem:OnPlayerInitialized(playerID)
        SaveSystem:RequestLoad(playerID)
        local spawnName = "spawn_player_" .. tostring(playerID + 1)
        local origin = SirvUtils:FindEntityOrigin(spawnName, unit:GetAbsOrigin())
        FindClearSpaceForUnit(unit, origin, true)
    end
end

function SurvivalRPG:OnEntityKilled(event)
    local killed = EntIndexToHScript(event.entindex_killed or -1)
    local attacker = EntIndexToHScript(event.entindex_attacker or -1)
    if not killed then return end

    if killed:IsRealHero() then
        PlayerLifeSystem:OnHeroKilled(killed)
        return
    end

    if killed:GetTeamNumber() == DOTA_TEAM_BADGUYS then
        BossSystem:OnUnitKilled(killed, attacker)
        DropSystem:RollDrop(killed, attacker)
        if attacker and attacker.GetPlayerOwnerID then
            QuestSystem:OnEnemyKilled(attacker:GetPlayerOwnerID(), killed)
        end
    end
end

function SurvivalRPG:OnThink()
    SirvUtils:PublishGameState()
    return 1.0
end
