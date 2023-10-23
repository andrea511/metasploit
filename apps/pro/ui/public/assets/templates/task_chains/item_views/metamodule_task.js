(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["task_chains/item_views/metamodule_task"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<option value=\""
    + container.escapeExpression(((helper = (helper = helpers.symbol || (depth0 != null ? depth0.symbol : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"symbol","hash":{},"data":data,"loc":{"start":{"line":12,"column":15},"end":{"line":12,"column":25}}}) : helper)))
    + "\">"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":12,"column":27},"end":{"line":12,"column":35}}}) : helper)))
    + "</option>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='columns small-12'>\n<div class='errors'></div>\n<div class='columns small-12'>\n<div class='row spacer'></div>\n<div class='columns small-6'></div>\n<div class='columns small-6 mm-select-container'>\n<label for='mm-select'>\nMetamodule:\n</label>\n<select class='mm-select' id='mm-select'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.metamodules : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":11,"column":0},"end":{"line":13,"column":9}}})) != null ? stack1 : "")
    + "</select>\n</div>\n</div>\n<div class='config'>\n<div class='tab-loading'></div>\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["task_chains/item_views/metamodule_task"];
}).call(this);
