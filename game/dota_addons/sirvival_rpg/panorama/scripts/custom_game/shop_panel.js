(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("ShopPanel");
    var list = $.GetContextPanel().FindChildTraverse("ShopList");
    function send(eventName, data) { data = data || {}; data.PlayerID = player; GameEvents.SendCustomGameEventToServer(eventName, data); }
    function close() { panel.AddClass("srpg-hidden"); }
    function row(text, cb) { var b = $.CreatePanel("Button", list, ""); b.AddClass("srpg-row"); var l = $.CreatePanel("Label", b, ""); l.text = text; b.SetPanelEvent("onactivate", cb); }
    function render() { list.RemoveAndDeleteChildren(); var data = CustomNetTables.GetTableValue("shop_data", "basic") || {}; (data.items || []).forEach(function (item) { row($.Localize("#DOTA_Tooltip_ability_" + item), function () { send("buy_shop_item", { item: item }); }); }); }
    $.GetContextPanel().FindChildTraverse("ShopPanelClose").SetPanelEvent("onactivate", close);
    CustomNetTables.SubscribeNetTableListener("shop_data", render);
    $.Schedule(0.4, render);
})();
