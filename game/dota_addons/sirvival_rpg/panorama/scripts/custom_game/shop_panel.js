(function () {
    var player = Players.GetLocalPlayer();
    var panel = $.GetContextPanel().FindChildTraverse("ShopPanel");
    var list = $.GetContextPanel().FindChildTraverse("ShopList");
    function send(eventName, data) { data = data || {}; data.PlayerID = player; GameEvents.SendCustomGameEventToServer(eventName, data); }
    function close() { panel.AddClass("srpg-hidden"); }
    function title(text) { var l = $.CreatePanel("Label", list, ""); l.AddClass("srpg-text-row"); l.text = text; }
    function row(text, cb) { var b = $.CreatePanel("Button", list, ""); b.AddClass("srpg-row"); var l = $.CreatePanel("Label", b, ""); l.text = text; b.SetPanelEvent("onactivate", cb); }
    function itemName(item) { return $.Localize("#DOTA_Tooltip_ability_" + item); }
    function render() {
        list.RemoveAndDeleteChildren();
        var data = CustomNetTables.GetTableValue("shop_data", "basic") || {};
        title("Tienda basica - compra con oro");
        (data.items || []).forEach(function (item) { row(itemName(item), function () { send("buy_shop_item", { item: item }); }); });
        title("Crafteos visibles - se fabrican con el NPC correcto");
        (data.recipes || []).forEach(function (recipe) {
            var result = recipe.result || ((recipe.result_pool || [])[0]) || recipe.id;
            row(itemName(result) + " | oro: " + recipe.gold + (recipe.role ? " | " + recipe.role : ""), function () {});
        });
        title("Catalogo de progreso - drops y crecimiento");
        (data.progression || []).slice(0, 42).forEach(function (item) { row(itemName(item), function () {}); });
        title("Cosmeticos premium - pendiente de backend/moneda");
        (data.cosmetics || []).forEach(function (cosmetic) { row(cosmetic.name_es + " | moneda: " + cosmetic.premium_cost, function () {}); });
    }
    $.GetContextPanel().FindChildTraverse("ShopPanelClose").SetPanelEvent("onactivate", close);
    CustomNetTables.SubscribeNetTableListener("shop_data", render);
    $.Schedule(0.4, render);
})();
