(function() {
  Handlebars.registerPartial("shared/layouts/_tabs", Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":1,"column":24},"end":{"line":1,"column":32}}}) : helper)));
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class='count'>\n"
    + container.escapeExpression(((helper = (helper = helpers.count || (depth0 != null ? depth0.count : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"count","hash":{},"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":7,"column":9}}}) : helper)))
    + "\n</div>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper, options, buffer = 
  "<li id='";
  stack1 = ((helper = (helper = helpers.underscored || (depth0 != null ? depth0.underscored : depth0)) != null ? helper : container.hooks.helperMissing),(options={"name":"underscored","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":1,"column":8},"end":{"line":1,"column":48}}}),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),options) : helper));
  if (!helpers.underscored) { stack1 = container.hooks.blockHelperMissing.call(depth0,stack1,options)}
  if (stack1 != null) { buffer += stack1; }
  buffer += "_tab'>\n<div class='name ";
  stack1 = ((helper = (helper = helpers.underscored || (depth0 != null ? depth0.underscored : depth0)) != null ? helper : container.hooks.helperMissing),(options={"name":"underscored","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":17},"end":{"line":2,"column":57}}}),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),options) : helper));
  if (!helpers.underscored) { stack1 = container.hooks.blockHelperMissing.call(depth0,stack1,options)}
  if (stack1 != null) { buffer += stack1; }
  return buffer + "' hideOnZero='"
    + container.escapeExpression(((helper = (helper = helpers.hideOnZero || (depth0 != null ? depth0.hideOnZero : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"hideOnZero","hash":{},"data":data,"loc":{"start":{"line":2,"column":71},"end":{"line":2,"column":85}}}) : helper)))
    + "'>\n"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":3,"column":8}}}) : helper)))
    + "\n</div>\n"
    + ((stack1 = helpers["if"].call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.count : depth0),{"name":"if","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":5,"column":0},"end":{"line":9,"column":7}}})) != null ? stack1 : "")
    + "</li>";
},"useData":true}));
}).call(this);
