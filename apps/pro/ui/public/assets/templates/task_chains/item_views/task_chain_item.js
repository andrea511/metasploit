(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["task_chains/item_views/task_chain_item"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.type || (depth0 != null ? depth0.type : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"type","hash":{},"data":data,"loc":{"start":{"line":4,"column":13},"end":{"line":4,"column":21}}}) : helper)));
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, options, buffer = 
  "<div class='generic-stat-wrapper' clickable='true'>\n<canvas class='scan' height='80px' width='80px'></canvas>\n<div class='task'>\n";
  stack1 = ((helper = (helper = helpers.titleize || (depth0 != null ? depth0.titleize : depth0)) != null ? helper : container.hooks.helperMissing),(options={"name":"titleize","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":4,"column":0},"end":{"line":4,"column":34}}}),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),options) : helper));
  if (!helpers.titleize) { stack1 = container.hooks.blockHelperMissing.call(depth0,stack1,options)}
  if (stack1 != null) { buffer += stack1; }
  return buffer + "\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["task_chains/item_views/task_chain_item"];
}).call(this);
