(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("ArtifactPanel");
    var list = $.GetContextPanel().FindChildTraverse("ArtifactList");
    function send(eventName, data) { data = data || {}; data.PlayerID = player; GameEvents.SendCustomGameEventToServer(eventName, data); }
    function render() { list.RemoveAndDeleteChildren(); var data = CustomNetTables.GetTableValue("artifact_data", "catalog") || {}; Object.keys(data).forEach(function (id) { var b = $.CreatePanel("Button", list, ""); b.AddClass("srpg-row"); var l = $.CreatePanel("Label", b, ""); l.text = data[id].name_es + " | " + data[id].role; b.SetPanelEvent("onactivate", function () { send("upgrade_artifact", { artifact: id }); }); }); }
    $.GetContextPanel().FindChildTraverse("ArtifactPanelClose").SetPanelEvent("onactivate", function () { panel.AddClass("srpg-hidden"); });
    CustomNetTables.SubscribeNetTableListener("artifact_data", render);
    $.Schedule(0.4, render);
})();
