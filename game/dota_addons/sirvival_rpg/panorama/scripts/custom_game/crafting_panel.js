(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("CraftingPanel");
    var list = $.GetContextPanel().FindChildTraverse("CraftingList");
    function send(eventName, data) { data = data || {}; data.PlayerID = player; GameEvents.SendCustomGameEventToServer(eventName, data); }
    function render() { list.RemoveAndDeleteChildren(); var data = CustomNetTables.GetTableValue("crafting_data", "recipes") || {}; Object.keys(data).forEach(function (id) { var b = $.CreatePanel("Button", list, ""); b.AddClass("srpg-row"); var l = $.CreatePanel("Label", b, ""); l.text = id + " -> " + $.Localize("#DOTA_Tooltip_ability_" + data[id].result); b.SetPanelEvent("onactivate", function () { send("craft_item", { recipe: id }); }); }); }
    $.GetContextPanel().FindChildTraverse("CraftingPanelClose").SetPanelEvent("onactivate", function () { panel.AddClass("srpg-hidden"); });
    CustomNetTables.SubscribeNetTableListener("crafting_data", render);
    $.Schedule(0.4, render);
})();
