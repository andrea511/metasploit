(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["hosts/item_views/cred_form"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<ul>\n<li class='name'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[service]","Service",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":5,"column":0},"end":{"line":5,"column":37}}}))
    + "\n"
    + container.escapeExpression((helpers.select||(depth0 && depth0.select)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[service]",((stack1 = (depth0 != null ? depth0.services : depth0)) != null ? stack1.services : stack1),((stack1 = (depth0 != null ? depth0.services : depth0)) != null ? stack1.selected : stack1),{"name":"select","hash":{},"data":data,"loc":{"start":{"line":6,"column":0},"end":{"line":6,"column":64}}}))
    + "\n</li>\n<li class='ptype'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[ptype]","Type",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":9,"column":0},"end":{"line":9,"column":32}}}))
    + "\n"
    + container.escapeExpression((helpers.select||(depth0 && depth0.select)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[ptype]",((stack1 = (depth0 != null ? depth0.ptypes : depth0)) != null ? stack1.ptypes : stack1),((stack1 = (depth0 != null ? depth0.ptypes : depth0)) != null ? stack1.selected : stack1),{"name":"select","hash":{},"data":data,"loc":{"start":{"line":10,"column":0},"end":{"line":10,"column":56}}}))
    + "\n</li>\n<li class='user'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[user]","User",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":13,"column":0},"end":{"line":13,"column":31}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[user]","",{"name":"input","hash":{},"data":data,"loc":{"start":{"line":14,"column":0},"end":{"line":14,"column":27}}}))
    + "\n</li>\n<li class='port'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[pass]","Password",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":17,"column":0},"end":{"line":17,"column":35}}}))
    + "\n"
    + container.escapeExpression((helpers.textarea||(depth0 && depth0.textarea)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"aaData[pass]","",{"name":"textarea","hash":{},"data":data,"loc":{"start":{"line":18,"column":0},"end":{"line":18,"column":30}}}))
    + "\n</li>\n</ul>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='cred-form'>\n"
    + ((stack1 = (helpers.form||(depth0 && depth0.form)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"/",{"name":"form","hash":{"class":"form formtastic"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":0},"end":{"line":21,"column":9}}})) != null ? stack1 : "")
    + "</div>";
},"useData":true});
  return this.HandlebarsTemplates["hosts/item_views/cred_form"];
}).call(this);
