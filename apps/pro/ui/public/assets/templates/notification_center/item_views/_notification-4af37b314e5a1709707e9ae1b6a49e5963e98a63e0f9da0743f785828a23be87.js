(function() {
  Handlebars.registerPartial("notification_center/item_views/_notification", Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return "<span class='system-badge'>\nSystem\n</span>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class='table-container'>\n<div class='status-bar'>\n<div class='status-block'></div>\n</div>\n<div class='content-cell'>\n<div class='message'>\n<b>\n"
    + container.escapeExpression(((helper = (helper = helpers.title || (depth0 != null ? depth0.title : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"title","hash":{},"data":data,"loc":{"start":{"line":8,"column":0},"end":{"line":8,"column":9}}}) : helper)))
    + "\n</b>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.kind : depth0),{"name":"if_eq","hash":{"compare":"system_notification"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":10,"column":0},"end":{"line":14,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.kind : depth0),{"name":"if_eq","hash":{"compare":"update_notification"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":15,"column":0},"end":{"line":19,"column":10}}})) != null ? stack1 : "")
    + "</div>\n<div class='details'>\n<div class='text'>\n"
    + container.escapeExpression(((helper = (helper = helpers.content || (depth0 != null ? depth0.content : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"content","hash":{},"data":data,"loc":{"start":{"line":23,"column":0},"end":{"line":23,"column":11}}}) : helper)))
    + "\n</div>\n<div class='humanized'>\n<b>\n"
    + container.escapeExpression(((helper = (helper = helpers.humanized_created_at || (depth0 != null ? depth0.humanized_created_at : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"humanized_created_at","hash":{},"data":data,"loc":{"start":{"line":27,"column":0},"end":{"line":27,"column":24}}}) : helper)))
    + "\n</b>\nago\n</div>\n</div>\n</div>\n</div>\n<div class='action-bar'>\n<span class='close'>\n&times;\n</span>\n</div>";
},"useData":true}));
}).call(this);
