(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["shared/layouts/tabs"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.hideOnZero : depth0),{"name":"if_eq","hash":{},"fn":container.program(2, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":4,"column":0},"end":{"line":6,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.hideOnZero : depth0),{"name":"if_eq","hash":{"compare":true},"fn":container.program(4, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":11,"column":10}}})) != null ? stack1 : "");
},"2":function(container,depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = container.invokePartial(partials["shared/layouts/_tabs"],depth0,{"name":"shared/layouts/_tabs","data":data,"helpers":helpers,"partials":partials,"decorators":container.decorators})) != null ? stack1 : "");
},"4":function(container,depth0,helpers,partials,data) {
    var stack1;

  return ((stack1 = (helpers.if_gt||(depth0 && depth0.if_gt)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.count : depth0),{"name":"if_gt","hash":{"compare":0},"fn":container.program(2, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":8,"column":0},"end":{"line":10,"column":10}}})) != null ? stack1 : "");
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='foundation row columns backbone-tabs'>\n<ul class='nav'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.tabs : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":12,"column":9}}})) != null ? stack1 : "")
    + "</ul>\n<div class='content tab-loading'></div>\n</div>";
},"usePartial":true,"useData":true});
  return this.HandlebarsTemplates["shared/layouts/tabs"];
}).call(this);
