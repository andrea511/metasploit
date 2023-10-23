(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["hosts/item_views/service_form"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<ul>\n<li class='name'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[name]","Name",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":5,"column":0},"end":{"line":5,"column":31}}}))
    + "\n<div>\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[name]","",{"name":"input","hash":{},"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":7,"column":27}}}))
    + "\n</div>\n</li>\n<li class='port'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[port]","Port",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":11,"column":0},"end":{"line":11,"column":31}}}))
    + "\n<div>\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[port]","",{"name":"input","hash":{},"data":data,"loc":{"start":{"line":13,"column":0},"end":{"line":13,"column":27}}}))
    + "\n</div>\n</li>\n<li class='proto'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[proto]","Protocol",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":17,"column":0},"end":{"line":17,"column":36}}}))
    + "\n<div>\n"
    + container.escapeExpression((helpers.select||(depth0 && depth0.select)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[proto]",((stack1 = (depth0 != null ? depth0.protocols : depth0)) != null ? stack1.protocols : stack1),((stack1 = (depth0 != null ? depth0.protocols : depth0)) != null ? stack1.selected : stack1),{"name":"select","hash":{},"data":data,"loc":{"start":{"line":19,"column":0},"end":{"line":19,"column":65}}}))
    + "\n</div>\n</li>\n<li class='state'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[state]","State",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":23,"column":0},"end":{"line":23,"column":33}}}))
    + "\n<div>\n"
    + container.escapeExpression((helpers.select||(depth0 && depth0.select)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[state]",((stack1 = (depth0 != null ? depth0.states : depth0)) != null ? stack1.states : stack1),((stack1 = (depth0 != null ? depth0.states : depth0)) != null ? stack1.selected : stack1),{"name":"select","hash":{},"data":data,"loc":{"start":{"line":25,"column":0},"end":{"line":25,"column":56}}}))
    + "\n</div>\n</li>\n<li class='info'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[info]","Info",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":29,"column":0},"end":{"line":29,"column":31}}}))
    + "\n<div>\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[info]","",{"name":"input","hash":{},"data":data,"loc":{"start":{"line":31,"column":0},"end":{"line":31,"column":27}}}))
    + "\n</div>\n</li>\n</ul>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='services-form'>\n"
    + ((stack1 = (helpers.form||(depth0 && depth0.form)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"/",{"name":"form","hash":{"class":"form formtastic"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":0},"end":{"line":35,"column":9}}})) != null ? stack1 : "")
    + "</div>";
},"useData":true});
  return this.HandlebarsTemplates["hosts/item_views/service_form"];
}).call(this);
