(function () {
    var panel = $.GetContextPanel().FindChildTraverse("SeasonPanel");
    var list = $.GetContextPanel().FindChildTraverse("SeasonList");
    function render() { list.RemoveAndDeleteChildren(); var data = CustomNetTables.GetTableValue("season_data", "state") || {}; ["season_name", "current_season_id", "reset_type", "max_level"].forEach(function (key) { var row = $.CreatePanel("Label", list, ""); row.AddClass("srpg-text-row"); row.text = key + ": " + (data[key] || "-"); }); var note = $.CreatePanel("Label", list, ""); note.AddClass("srpg-text-row"); note.text = "Guardado: placeholder en memoria"; }
    $.GetContextPanel().FindChildTraverse("SeasonPanelClose").SetPanelEvent("onactivate", function () { panel.AddClass("srpg-hidden"); });
    CustomNetTables.SubscribeNetTableListener("season_data", render);
    $.Schedule(0.4, render);
})();
