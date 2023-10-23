(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["apps/views/generic_stats_view"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class='center app-runs'>\n<div class='overview-header'>\nlast launched metamodule:\n<span class='app-name'>\n"
    + container.escapeExpression(container.lambda(((stack1 = (depth0 != null ? depth0.app : depth0)) != null ? stack1.name : stack1), depth0))
    + "\n</span>\n<label class='status finished'>"
    + container.escapeExpression(((helper = (helper = helpers.status || (depth0 != null ? depth0.status : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"status","hash":{},"data":data,"loc":{"start":{"line":8,"column":31},"end":{"line":8,"column":43}}}) : helper)))
    + "</label>\n</div>\n</div>\n";
},"3":function(container,depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = container.invokePartial(partials["apps/views/stat_views/_stat"],depth0,{"name":"apps/views/stat_views/_stat","data":data,"helpers":helpers,"partials":partials,"decorators":container.decorators})) != null ? stack1 : "");
},"5":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<a class='show-stats' href='./app_runs/"
    + container.escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"id","hash":{},"data":data,"loc":{"start":{"line":20,"column":39},"end":{"line":20,"column":45}}}) : helper)))
    + "'>\nView Findings &rarr;\n</a>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = helpers["if"].call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.showHeader : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":1,"column":0},"end":{"line":11,"column":7}}})) != null ? stack1 : "")
    + "<div class='stat-row "
    + container.escapeExpression(container.lambda(((stack1 = (depth0 != null ? depth0.app : depth0)) != null ? stack1.symbol : stack1), depth0))
    + "'>\n<div class='center'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.app : depth0)) != null ? stack1.stats : stack1),{"name":"each","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":14,"column":0},"end":{"line":16,"column":9}}})) != null ? stack1 : "")
    + "</div>\n</div>\n"
    + ((stack1 = helpers["if"].call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.showHeader : depth0),{"name":"if","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":19,"column":0},"end":{"line":23,"column":7}}})) != null ? stack1 : "");
},"usePartial":true,"useData":true});
  return this.HandlebarsTemplates["apps/views/generic_stats_view"];
}).call(this);
