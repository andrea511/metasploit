(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["shared/modal"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return "<div class='bg'></div>\n";
},"3":function(container,depth0,helpers,partials,data) {
    return "<h1>"
    + container.escapeExpression(container.lambda((depth0 != null ? depth0.title : depth0), depth0))
    + "</h1>\n";
},"5":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<p>"
    + container.escapeExpression(((helper = (helper = helpers.description || (depth0 != null ? depth0.description : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"description","hash":{},"data":data,"loc":{"start":{"line":11,"column":3},"end":{"line":11,"column":18}}}) : helper)))
    + "</p>\n";
},"7":function(container,depth0,helpers,partials,data) {
    return "<a class='"
    + container.escapeExpression(container.lambda((depth0 != null ? depth0["class"] : depth0), depth0))
    + "' href='javascript:void(0)'>"
    + container.escapeExpression(container.lambda((depth0 != null ? depth0.name : depth0), depth0))
    + "</a>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return ((stack1 = helpers["if"].call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.bg : depth0),{"name":"if","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":1,"column":0},"end":{"line":3,"column":7}}})) != null ? stack1 : "")
    + "<div class='modal "
    + container.escapeExpression(((helper = (helper = helpers["class"] || (depth0 != null ? depth0["class"] : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"class","hash":{},"data":data,"loc":{"start":{"line":4,"column":18},"end":{"line":4,"column":27}}}) : helper)))
    + "'>\n<div class='header'>\n<a class='close small' href='javascript:void 0'>&times;</a>\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.title : depth0),{"name":"if_present","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":9,"column":15}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.description : depth0),{"name":"if_present","hash":{},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":10,"column":0},"end":{"line":12,"column":15}}})) != null ? stack1 : "")
    + "</div>\n<div class='padding'>\n<div class='content'></div>\n<div class='clearfix'></div>\n<div class='modal-actions'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.buttons : depth0),{"name":"each","hash":{},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":18,"column":0},"end":{"line":20,"column":9}}})) != null ? stack1 : "")
    + "</div>\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["shared/modal"];
}).call(this);
