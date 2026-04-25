(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("PetPanel");
    var list = $.GetContextPanel().FindChildTraverse("PetList");
    function send(eventName, data) { data = data || {}; data.PlayerID = player; GameEvents.SendCustomGameEventToServer(eventName, data); }
    function render() { list.RemoveAndDeleteChildren(); var data = CustomNetTables.GetTableValue("pet_data", "catalog") || {}; Object.keys(data).forEach(function (id) { var b = $.CreatePanel("Button", list, ""); b.AddClass("srpg-row"); var l = $.CreatePanel("Label", b, ""); l.text = data[id].name_es + " | " + data[id].role; b.SetPanelEvent("onactivate", function () { send("equip_pet", { pet: id }); }); }); }
    $.GetContextPanel().FindChildTraverse("PetPanelClose").SetPanelEvent("onactivate", function () { panel.AddClass("srpg-hidden"); });
    CustomNetTables.SubscribeNetTableListener("pet_data", render);
    $.Schedule(0.4, render);
})();
