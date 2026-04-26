UIEventSystem = UIEventSystem or {}

function UIEventSystem:Init(gameMode)
    self.gameMode = gameMode
    CustomGameEventManager:RegisterListener("open_shop", function(_, keys) ShopSystem:OpenShop(keys) end)
    CustomGameEventManager:RegisterListener("buy_shop_item", function(_, keys) ShopSystem:BuyItem(keys) end)
    CustomGameEventManager:RegisterListener("open_crafting", function(_, keys) CraftingSystem:Open(keys) end)
    CustomGameEventManager:RegisterListener("craft_item", function(_, keys) CraftingSystem:CraftItem(keys) end)
    CustomGameEventManager:RegisterListener("open_artifacts", function(_, keys) ArtifactSystem:Open(keys) end)
    CustomGameEventManager:RegisterListener("upgrade_artifact", function(_, keys) ArtifactSystem:UpgradeArtifact(keys) end)
    CustomGameEventManager:RegisterListener("open_pets", function(_, keys) PetSystem:Open(keys) end)
    CustomGameEventManager:RegisterListener("equip_pet", function(_, keys) PetSystem:EquipPet(keys) end)
    CustomGameEventManager:RegisterListener("upgrade_pet", function(_, keys) PetSystem:UpgradePet(keys) end)
    CustomGameEventManager:RegisterListener("open_quests", function(_, keys) QuestSystem:Publish(tonumber(keys.PlayerID or -1)) end)
    CustomGameEventManager:RegisterListener("complete_quest", function(_, keys) QuestSystem:CompleteQuest(keys) end)
    CustomGameEventManager:RegisterListener("open_world_level", function(_, keys) WorldLevelSystem:Publish() end)
    CustomGameEventManager:RegisterListener("select_world_level", function(_, keys) WorldLevelSystem:Select(keys) end)
    CustomGameEventManager:RegisterListener("open_season_panel", function(_, keys) SeasonSystem:Open(keys) end)
    CustomGameEventManager:RegisterListener("request_player_progress", function(_, keys) PlayerProgressionSystem:Publish(tonumber(keys.PlayerID or -1)) end)
    CustomGameEventManager:RegisterListener("reset_skill_points", function(_, keys) PlayerProgressionSystem:ResetSkillPoints(tonumber(keys.PlayerID or -1), false) end)
    CustomGameEventManager:RegisterListener("request_zone_entry", function(_, keys) ZoneSystem:RequestZoneEntry(keys) end)

    CustomGameEventManager:RegisterListener("sirv_buy_basic_item", function(_, keys) ShopSystem:BuyItem(keys) end)
    CustomGameEventManager:RegisterListener("sirv_craft_item", function(_, keys) CraftingSystem:CraftItem(keys) end)
    CustomGameEventManager:RegisterListener("sirv_request_save", function(_, keys) SaveSystem:RequestSave(keys) end)
    CustomGameEventManager:RegisterListener("sirv_complete_quest", function(_, keys) QuestSystem:CompleteQuest(keys) end)
    CustomGameEventManager:RegisterListener("sirv_request_zone_unlock", function(_, keys) ZoneSystem:RequestZoneUnlock(keys) end)
end
