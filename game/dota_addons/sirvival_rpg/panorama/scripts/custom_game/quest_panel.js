(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("QuestPanel");
    var list = $.GetContextPanel().FindChildTraverse("QuestList");
    function send(eventName, data) { data = data || {}; data.PlayerID = player; GameEvents.SendCustomGameEventToServer(eventName, data); }
    function text(value) { var l = $.CreatePanel("Label", list, ""); l.AddClass("srpg-text-row"); l.text = value; return l; }
    function render() {
        list.RemoveAndDeleteChildren();
        var data = CustomNetTables.GetTableValue("quest_data", String(player)) || {};
        var quests = data.quests || [];
        quests.forEach(function (quest) {
            var row = $.CreatePanel("Button", list, "");
            row.AddClass("srpg-row");
            if (quest.completed) row.AddClass("srpg-row-complete");
            var label = $.CreatePanel("Label", row, "");
            label.text = (quest.completed ? "[OK] " : "") + quest.title_es + " | " + quest.category;
            row.SetPanelEvent("onactivate", function () { send("complete_quest", { quest: quest.id }); });
            text(quest.description_es || "");
        });
    }
    $.GetContextPanel().FindChildTraverse("QuestPanelClose").SetPanelEvent("onactivate", function () { panel.AddClass("srpg-hidden"); });
    CustomNetTables.SubscribeNetTableListener("quest_data", render);
    $.Schedule(0.4, render);
})();
