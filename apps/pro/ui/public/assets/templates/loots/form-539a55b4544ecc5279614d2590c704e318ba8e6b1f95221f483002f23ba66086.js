(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["loots/form"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return "<ul>\n<li class='data file input'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"loot[data]","File",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":6,"column":0},"end":{"line":6,"column":29}}}))
    + "\n"
    + container.escapeExpression((helpers.file||(depth0 && depth0.file)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"loot[data]",{"name":"file","hash":{},"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":7,"column":21}}}))
    + "\n</li>\n<li class='name'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"loot[name]","Name*",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":10,"column":0},"end":{"line":10,"column":30}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"loot[name]",(depth0 != null ? depth0.name : depth0),{"name":"input","hash":{},"data":data,"loc":{"start":{"line":11,"column":0},"end":{"line":11,"column":27}}}))
    + "\n</li>\n<li class='content_type'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"loot[content_type]","Content type",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":14,"column":0},"end":{"line":14,"column":45}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"loot[content_type]","text/plain",{"name":"input","hash":{},"data":data,"loc":{"start":{"line":15,"column":0},"end":{"line":15,"column":43}}}))
    + "\n</li>\n<li class='info'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"loot[info]","Info",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":18,"column":0},"end":{"line":18,"column":29}}}))
    + "\n"
    + container.escapeExpression((helpers.textarea||(depth0 && depth0.textarea)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"loot[info]",(depth0 != null ? depth0.info : depth0),{"name":"textarea","hash":{},"data":data,"loc":{"start":{"line":19,"column":0},"end":{"line":19,"column":30}}}))
    + "\n</li>\n</ul>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='loot_form'>\n<div class='errors' style='display: none'></div>\n"
    + ((stack1 = (helpers.form||(depth0 && depth0.form)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"/",{"name":"form","hash":{"class":"form formtastic"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":22,"column":9}}})) != null ? stack1 : "")
    + "</div>";
},"useData":true});
  return this.HandlebarsTemplates["loots/form"];
}).call(this);
