(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["reports/views/report_form"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return container.escapeExpression((helpers.hidden||(depth0 && depth0.hidden)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"_method","create",{"name":"hidden","hash":{},"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":3,"column":29}}}))
    + "\n<ul>\n<li class='file'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"report_custom_resource[file_data]","Resource file",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":6,"column":0},"end":{"line":6,"column":61}}}))
    + "\n"
    + container.escapeExpression((helpers.file||(depth0 && depth0.file)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"report_custom_resource[file_data]",{"name":"file","hash":{},"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":7,"column":44}}}))
    + "\n</li>\n<li class='name'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"report_custom_resource[name]","Resource name",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":10,"column":0},"end":{"line":10,"column":56}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"report_custom_resource[name]","",{"name":"input","hash":{},"data":data,"loc":{"start":{"line":11,"column":0},"end":{"line":11,"column":43}}}))
    + "\n</li>\n</ul>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='report-form'>\n"
    + ((stack1 = (helpers.form||(depth0 && depth0.form)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"/",{"name":"form","hash":{"class":"form formtastic"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":0},"end":{"line":14,"column":9}}})) != null ? stack1 : "")
    + "</div>";
},"useData":true});
  return this.HandlebarsTemplates["reports/views/report_form"];
}).call(this);
