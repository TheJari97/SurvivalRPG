(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("SeasonPanel");
    var list = $.GetContextPanel().FindChildTraverse("SeasonList");
    function render() { list.RemoveAndDeleteChildren(); var data = CustomNetTables.GetTableValue("season_data", "state") || {}; var save = CustomNetTables.GetTableValue("sirvival_save", String(player)) || {}; ["season_name", "current_season_id", "reset_type", "max_level"].forEach(function (key) { var row = $.CreatePanel("Label", list, ""); row.AddClass("srpg-text-row"); row.text = key + ": " + (data[key] || "-"); }); var note = $.CreatePanel("Label", list, ""); note.AddClass("srpg-text-row"); note.text = "Guardado: " + (save.message || "modo local sin backend"); }
    $.GetContextPanel().FindChildTraverse("SeasonPanelClose").SetPanelEvent("onactivate", function () { panel.AddClass("srpg-hidden"); });
    $.GetContextPanel().FindChildTraverse("SeasonManualSave").SetPanelEvent("onactivate", function () { GameEvents.SendCustomGameEventToServer("sirv_request_save", { PlayerID: player }); });
    CustomNetTables.SubscribeNetTableListener("season_data", render);
    CustomNetTables.SubscribeNetTableListener("sirvival_save", render);
    $.Schedule(0.4, render);
})();
