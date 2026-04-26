(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("CraftingPanel");
    var list = $.GetContextPanel().FindChildTraverse("CraftingList");
    function send(eventName, data) { data = data || {}; data.PlayerID = player; GameEvents.SendCustomGameEventToServer(eventName, data); }
    function render() {
        list.RemoveAndDeleteChildren();
        var data = CustomNetTables.GetTableValue("crafting_data", "recipes") || {};
        Object.keys(data).sort().forEach(function (id) {
            var recipe = data[id] || {};
            var b = $.CreatePanel("Button", list, "");
            b.AddClass("srpg-row");
            var l = $.CreatePanel("Label", b, "");
            var name = recipe.display_es || id;
            var result = recipe.result ? $.Localize("#DOTA_Tooltip_ability_" + recipe.result) : "resultado aleatorio";
            l.text = name + " -> " + result + " | Oro " + (recipe.gold || 0);
            b.SetPanelEvent("onactivate", function () { send("craft_item", { recipe: id }); });
        });
    }
    $.GetContextPanel().FindChildTraverse("CraftingPanelClose").SetPanelEvent("onactivate", function () { panel.AddClass("srpg-hidden"); });
    CustomNetTables.SubscribeNetTableListener("crafting_data", render);
    $.Schedule(0.4, render);
})();
