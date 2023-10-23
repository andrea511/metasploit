(function() {
  Handlebars.registerPartial("apps/views/stat_views/_stat", Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class='pie-chart-wrapper load-table' clickable='"
    + container.escapeExpression(((helper = (helper = helpers.clickable || (depth0 != null ? depth0.clickable : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"clickable","hash":{},"data":data,"loc":{"start":{"line":3,"column":53},"end":{"line":3,"column":66}}}) : helper)))
    + "' label='"
    + container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":3,"column":75},"end":{"line":3,"column":84}}}) : helper)))
    + "' name='"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":3,"column":92},"end":{"line":3,"column":100}}}) : helper)))
    + "'>\n<div class='pie-chart' name='"
    + container.escapeExpression(((helper = (helper = helpers.num || (depth0 != null ? depth0.num : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"num","hash":{},"data":data,"loc":{"start":{"line":4,"column":29},"end":{"line":4,"column":36}}}) : helper)))
    + "' total='"
    + container.escapeExpression(((helper = (helper = helpers.total || (depth0 != null ? depth0.total : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"total","hash":{},"data":data,"loc":{"start":{"line":4,"column":45},"end":{"line":4,"column":54}}}) : helper)))
    + "'></div>\n<label class='stat run-stat' name='"
    + container.escapeExpression(((helper = (helper = helpers.num || (depth0 != null ? depth0.num : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"num","hash":{},"data":data,"loc":{"start":{"line":5,"column":35},"end":{"line":5,"column":42}}}) : helper)))
    + "' total='"
    + container.escapeExpression(((helper = (helper = helpers.total || (depth0 != null ? depth0.total : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"total","hash":{},"data":data,"loc":{"start":{"line":5,"column":51},"end":{"line":5,"column":60}}}) : helper)))
    + "'></label>\n<label class='desc'>\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.label : depth0),{"name":"if_present","hash":{},"fn":container.program(2, data, 0),"inverse":container.program(4, data, 0),"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":11,"column":15}}})) != null ? stack1 : "")
    + "</label>\n</div>\n";
},"2":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":8,"column":0},"end":{"line":8,"column":9}}}) : helper)))
    + "\n";
},"4":function(container,depth0,helpers,partials,data) {
    return container.escapeExpression((helpers.humanize||(depth0 && depth0.humanize)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.name : depth0),{"name":"humanize","hash":{},"data":data,"loc":{"start":{"line":10,"column":0},"end":{"line":10,"column":17}}}))
    + "\n";
},"6":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class='big-stat center load-table' clickable='"
    + container.escapeExpression(((helper = (helper = helpers.clickable || (depth0 != null ? depth0.clickable : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"clickable","hash":{},"data":data,"loc":{"start":{"line":15,"column":51},"end":{"line":15,"column":64}}}) : helper)))
    + "' label='"
    + container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":15,"column":73},"end":{"line":15,"column":82}}}) : helper)))
    + "' name='"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":15,"column":90},"end":{"line":15,"column":98}}}) : helper)))
    + "'>\n<span class='run-stat stat' format='"
    + container.escapeExpression(((helper = (helper = helpers.format || (depth0 != null ? depth0.format : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"format","hash":{},"data":data,"loc":{"start":{"line":16,"column":36},"end":{"line":16,"column":46}}}) : helper)))
    + "' name='"
    + container.escapeExpression(((helper = (helper = helpers.num || (depth0 != null ? depth0.num : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"num","hash":{},"data":data,"loc":{"start":{"line":16,"column":54},"end":{"line":16,"column":61}}}) : helper)))
    + "'></span>\n<label>\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.label : depth0),{"name":"if_present","hash":{},"fn":container.program(7, data, 0),"inverse":container.program(9, data, 0),"data":data,"loc":{"start":{"line":18,"column":0},"end":{"line":22,"column":15}}})) != null ? stack1 : "")
    + "</label>\n</div>\n";
},"7":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<span>"
    + container.escapeExpression(((helper = (helper = helpers.label || (depth0 != null ? depth0.label : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"label","hash":{},"data":data,"loc":{"start":{"line":19,"column":6},"end":{"line":19,"column":15}}}) : helper)))
    + "</span>\n";
},"9":function(container,depth0,helpers,partials,data) {
    return "<span>"
    + container.escapeExpression((helpers.humanize||(depth0 && depth0.humanize)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.name : depth0),{"name":"humanize","hash":{},"data":data,"loc":{"start":{"line":21,"column":6},"end":{"line":21,"column":23}}}))
    + "</span>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class='generic-stat-wrapper' clickable='"
    + container.escapeExpression(((helper = (helper = helpers.clickable || (depth0 != null ? depth0.clickable : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"clickable","hash":{},"data":data,"loc":{"start":{"line":1,"column":45},"end":{"line":1,"column":58}}}) : helper)))
    + "'>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.type : depth0),{"name":"if_eq","hash":{"compare":"percentage"},"fn":container.program(1, data, 0),"inverse":container.program(6, data, 0),"data":data,"loc":{"start":{"line":2,"column":0},"end":{"line":25,"column":10}}})) != null ? stack1 : "")
    + "<div class='lil-nubster'></div>\n</div>";
},"useData":true}));
}).call(this);
