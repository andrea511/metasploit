(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["apps/views/card_view"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<span class='category'>\n"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":11,"column":0},"end":{"line":11,"column":8}}}) : helper)))
    + "\n</span>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<div class='large-4 columns'>\n<div class='card'>\n<a class='title' href='#'>\n<h6>\n"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":5,"column":0},"end":{"line":5,"column":10}}}) : helper)))
    + "\n</h6>\n</a>\n<div class='categories'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.app_categories : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":0},"end":{"line":13,"column":9}}})) != null ? stack1 : "")
    + "</div>\n<div class='wrap-description'>\n<p class='description'>\n"
    + container.escapeExpression(((helper = (helper = helpers.description || (depth0 != null ? depth0.description : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"description","hash":{},"data":data,"loc":{"start":{"line":17,"column":0},"end":{"line":17,"column":15}}}) : helper)))
    + "\n</p>\n</div>\n<a class='launch btn primary'>\nLaunch\n</a>\n<div class='safety-rating'>\nSafety Rating:\n<span class='rating-stars star"
    + container.escapeExpression(((helper = (helper = helpers.rating || (depth0 != null ? depth0.rating : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"rating","hash":{},"data":data,"loc":{"start":{"line":25,"column":30},"end":{"line":25,"column":40}}}) : helper)))
    + "' title='"
    + container.escapeExpression(((helper = (helper = helpers.rating || (depth0 != null ? depth0.rating : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"rating","hash":{},"data":data,"loc":{"start":{"line":25,"column":49},"end":{"line":25,"column":59}}}) : helper)))
    + "/5 stars'>\n<span></span>\n</span>\n</div>\n<div class='clearfix' style='clear:both'></div>\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["apps/views/card_view"];
}).call(this);
