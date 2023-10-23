(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["hosts/item_views/host_stats_overview_item_view"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.address || (depth0 != null ? depth0.address : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"address","hash":{},"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":7,"column":11}}}) : helper)))
    + "\n";
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div style='line-height: 47px;'>\n"
    + container.escapeExpression(((helper = (helper = helpers.address || (depth0 != null ? depth0.address : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"address","hash":{},"data":data,"loc":{"start":{"line":10,"column":0},"end":{"line":10,"column":11}}}) : helper)))
    + "\n</div>\n";
},"5":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class='name'>\n["
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":16,"column":1},"end":{"line":16,"column":9}}}) : helper)))
    + "]\n</div>\n";
},"7":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<label>Flavor</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.os_flavor || (depth0 != null ? depth0.os_flavor : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"os_flavor","hash":{},"data":data,"loc":{"start":{"line":39,"column":19},"end":{"line":39,"column":32}}}) : helper)))
    + "</div>\n";
},"9":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<label>SP</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.os_sp || (depth0 != null ? depth0.os_sp : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"os_sp","hash":{},"data":data,"loc":{"start":{"line":43,"column":19},"end":{"line":43,"column":28}}}) : helper)))
    + "</div>\n";
},"11":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<li class='pivot' title='VPN pivot running in Task #"
    + container.escapeExpression(container.lambda(((stack1 = (depth0 != null ? depth0.vpn_pivot : depth0)) != null ? stack1.task_id : stack1), depth0))
    + "'>\n<div class='bottom_pin'>\nVPN Pivot\n</div>\n</li>\n";
},"13":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<li class='nexpose'>\n<div class='bottom_pin'>\nSource\n</div>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.host_details : depth0),{"name":"each","hash":{},"fn":container.program(14, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":60,"column":0},"end":{"line":77,"column":9}}})) != null ? stack1 : "")
    + "</li>\n";
},"14":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class='menu'>\n<div class='padding'>\n<label>Site Name</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.nx_site_name || (depth0 != null ? depth0.nx_site_name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"nx_site_name","hash":{},"data":data,"loc":{"start":{"line":64,"column":19},"end":{"line":64,"column":35}}}) : helper)))
    + "</div>\n<label>Site Importance</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.nx_site_importance || (depth0 != null ? depth0.nx_site_importance : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"nx_site_importance","hash":{},"data":data,"loc":{"start":{"line":66,"column":19},"end":{"line":66,"column":41}}}) : helper)))
    + "</div>\n<label>Scan Template</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.nx_scan_template || (depth0 != null ? depth0.nx_scan_template : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"nx_scan_template","hash":{},"data":data,"loc":{"start":{"line":68,"column":19},"end":{"line":68,"column":39}}}) : helper)))
    + "</div>\n<label>Risk Score</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.nx_risk_score || (depth0 != null ? depth0.nx_risk_score : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"nx_risk_score","hash":{},"data":data,"loc":{"start":{"line":70,"column":19},"end":{"line":70,"column":36}}}) : helper)))
    + "</div>\n<label>Console ID</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.nx_console_id || (depth0 != null ? depth0.nx_console_id : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"nx_console_id","hash":{},"data":data,"loc":{"start":{"line":72,"column":19},"end":{"line":72,"column":36}}}) : helper)))
    + "</div>\n<label>Device ID</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.nx_device_id || (depth0 != null ? depth0.nx_device_id : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"nx_device_id","hash":{},"data":data,"loc":{"start":{"line":74,"column":19},"end":{"line":74,"column":35}}}) : helper)))
    + "</div>\n</div>\n</div>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class='container hosts-stats-overview'>\n<ul>\n<li class='host'>\n<div class='inline-block'>\n<div class='ip'>\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.name : depth0),{"name":"if_present","hash":{},"fn":container.program(1, data, 0),"inverse":container.program(3, data, 0),"data":data,"loc":{"start":{"line":6,"column":0},"end":{"line":12,"column":15}}})) != null ? stack1 : "")
    + "</div>\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.name : depth0),{"name":"if_present","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":14,"column":0},"end":{"line":18,"column":15}}})) != null ? stack1 : "")
    + "</div>\n<a class='edit-info' href='javascript:void(0)' title='View and edit host information'></a>\n</li>\n<li class='state "
    + container.escapeExpression(((helper = (helper = helpers.status || (depth0 != null ? depth0.status : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"status","hash":{},"data":data,"loc":{"start":{"line":22,"column":17},"end":{"line":22,"column":27}}}) : helper)))
    + "'>\n"
    + container.escapeExpression((helpers.upcase||(depth0 && depth0.upcase)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.status : depth0),{"name":"upcase","hash":{},"data":data,"loc":{"start":{"line":23,"column":0},"end":{"line":23,"column":17}}}))
    + "\n</li>\n<li class='os'>\n<div class='icons'>\n"
    + ((stack1 = ((helper = (helper = helpers.virtual_host || (depth0 != null ? depth0.virtual_host : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"virtual_host","hash":{},"data":data,"loc":{"start":{"line":27,"column":0},"end":{"line":27,"column":18}}}) : helper))) != null ? stack1 : "")
    + "\n"
    + ((stack1 = ((helper = (helper = helpers.os_icon || (depth0 != null ? depth0.os_icon : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"os_icon","hash":{},"data":data,"loc":{"start":{"line":28,"column":0},"end":{"line":28,"column":13}}}) : helper))) != null ? stack1 : "")
    + "\n</div>\n<div class='os_name bottom_pin'>\n"
    + container.escapeExpression(((helper = (helper = helpers.os || (depth0 != null ? depth0.os : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"os","hash":{},"data":data,"loc":{"start":{"line":31,"column":0},"end":{"line":31,"column":6}}}) : helper)))
    + "\n</div>\n<div class='menu'>\n<div class='padding'>\n<label>Name</label>\n<div class='value'>"
    + container.escapeExpression(((helper = (helper = helpers.os_name || (depth0 != null ? depth0.os_name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"os_name","hash":{},"data":data,"loc":{"start":{"line":36,"column":19},"end":{"line":36,"column":30}}}) : helper)))
    + "</div>\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.os_flavor : depth0),{"name":"if_present","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":37,"column":0},"end":{"line":40,"column":15}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.os_sp : depth0),{"name":"if_present","hash":{},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":41,"column":0},"end":{"line":44,"column":15}}})) != null ? stack1 : "")
    + "</div>\n</div>\n</li>\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.vpn_pivot : depth0),{"name":"if_present","hash":{},"fn":container.program(11, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":48,"column":0},"end":{"line":54,"column":15}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.host_details : depth0),{"name":"if_present","hash":{},"fn":container.program(13, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":55,"column":0},"end":{"line":79,"column":15}}})) != null ? stack1 : "")
    + "</ul>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["hosts/item_views/host_stats_overview_item_view"];
}).call(this);
