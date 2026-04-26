(function () {
    var player = Players.GetLocalPlayer();
    function id(name) { return $.GetContextPanel().FindChildTraverse(name); }
    function rootFind(name) {
        var panel = $.GetContextPanel();
        while (panel.GetParent()) panel = panel.GetParent();
        return panel.FindChildTraverse(name);
    }
    function send(eventName, data) {
        data = data || {};
        data.PlayerID = player;
        GameEvents.SendCustomGameEventToServer(eventName, data);
    }
    function openPanel(panelID, eventName) {
        var panel = rootFind(panelID);
        if (panel) panel.RemoveClass("srpg-hidden");
        if (eventName) send(eventName, {});
    }
    function updateState() {
        var state = CustomNetTables.GetTableValue("game_state", "global") || {};
        var lives = CustomNetTables.GetTableValue("game_state", "lives") || {};
        var text = "Zona " + (state.current_zone || 1) + " | Mundo " + (state.world_level || 1) + " | Vidas " + (lives[String(player)] || "-");
        id("SRPGState").text = text;
    }
    function toast(data) {
        var holder = id("SRPGToastPanel");
        var label = $.CreatePanel("Label", holder, "");
        label.text = data.message || "";
        label.AddClass("srpg-toast");
        label.AddClass(data.style || "info");
        $.Schedule(4.0, function () { if (label && label.IsValid()) label.DeleteAsync(0); });
    }
    id("OpenShop").SetPanelEvent("onactivate", function () { openPanel("ShopPanel", "open_shop"); });
    id("OpenCrafting").SetPanelEvent("onactivate", function () { openPanel("CraftingPanel", "open_crafting"); });
    id("OpenArtifacts").SetPanelEvent("onactivate", function () { openPanel("ArtifactPanel", "open_artifacts"); });
    id("OpenPets").SetPanelEvent("onactivate", function () { openPanel("PetPanel", "open_pets"); });
    id("OpenQuests").SetPanelEvent("onactivate", function () { openPanel("QuestPanel", "open_quests"); });
    id("OpenWorldLevel").SetPanelEvent("onactivate", function () { openPanel("WorldLevelPanel", "open_world_level"); });
    id("OpenSeason").SetPanelEvent("onactivate", function () { openPanel("SeasonPanel", "open_season_panel"); });
    id("SaveProgress").SetPanelEvent("onactivate", function () { send("sirv_request_save", {}); });
    GameEvents.Subscribe("srpg_toast", toast);
    CustomNetTables.SubscribeNetTableListener("game_state", updateState);
    $.Schedule(0.2, updateState);
    $.Schedule(1.0, function tick() { updateState(); $.Schedule(1.0, tick); });
})();
