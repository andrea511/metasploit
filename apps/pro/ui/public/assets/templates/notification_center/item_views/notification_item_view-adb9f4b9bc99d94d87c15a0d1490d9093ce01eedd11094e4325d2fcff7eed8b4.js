(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["notification_center/item_views/notification_item_view"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),true,{"name":"if_eq","hash":{"compare":(depth0 != null ? depth0.read : depth0)},"fn":container.program(2, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":0},"end":{"line":6,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),false,{"name":"if_eq","hash":{"compare":(depth0 != null ? depth0.read : depth0)},"fn":container.program(4, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":11,"column":10}}})) != null ? stack1 : "");
},"2":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='notification-message message-read'>\n"
    + ((stack1 = container.invokePartial(partials["notification_center/item_views/_notification"],depth0,{"name":"notification_center/item_views/_notification","data":data,"helpers":helpers,"partials":partials,"decorators":container.decorators})) != null ? stack1 : "")
    + "</div>\n";
},"4":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class='notification-message "
    + container.escapeExpression(((helper = (helper = helpers.kind || (depth0 != null ? depth0.kind : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"kind","hash":{},"data":data,"loc":{"start":{"line":8,"column":33},"end":{"line":8,"column":41}}}) : helper)))
    + "'>\n"
    + ((stack1 = container.invokePartial(partials["notification_center/item_views/_notification"],depth0,{"name":"notification_center/item_views/_notification","data":data,"helpers":helpers,"partials":partials,"decorators":container.decorators})) != null ? stack1 : "")
    + "</div>\n";
},"6":function(container,depth0,helpers,partials,data) {
    return "<div class='no-new-notifications'>\nNo new notifications\n</div>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = helpers["if"].call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.title : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(6, data, 0),"data":data,"loc":{"start":{"line":1,"column":0},"end":{"line":16,"column":7}}})) != null ? stack1 : "");
},"usePartial":true,"useData":true});
  return this.HandlebarsTemplates["notification_center/item_views/notification_item_view"];
}).call(this);
