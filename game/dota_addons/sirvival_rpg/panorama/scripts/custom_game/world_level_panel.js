(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("WorldLevelPanel");
    var list = $.GetContextPanel().FindChildTraverse("WorldLevelList");
    function send(eventName, data) { data = data || {}; data.PlayerID = player; GameEvents.SendCustomGameEventToServer(eventName, data); }
    function render() { list.RemoveAndDeleteChildren(); var data = CustomNetTables.GetTableValue("world_level_data", "state") || {}; var cfg = data.config || {}; Object.keys(cfg).forEach(function (lvl) { var b = $.CreatePanel("Button", list, ""); b.AddClass("srpg-row"); var l = $.CreatePanel("Label", b, ""); l.text = "Mundo " + lvl + " | Vida x" + cfg[lvl].enemy_health + " | XP x" + cfg[lvl].xp; b.SetPanelEvent("onactivate", function () { send("select_world_level", { level: Number(lvl) }); }); }); }
    $.GetContextPanel().FindChildTraverse("WorldLevelPanelClose").SetPanelEvent("onactivate", function () { panel.AddClass("srpg-hidden"); });
    CustomNetTables.SubscribeNetTableListener("world_level_data", render);
    $.Schedule(0.4, render);
})();
