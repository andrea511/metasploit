(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["shared/item_views/empty_view"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class='empty-message'>\n"
    + container.escapeExpression(((helper = (helper = helpers.message || (depth0 != null ? depth0.message : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"message","hash":{},"data":data,"loc":{"start":{"line":2,"column":0},"end":{"line":2,"column":11}}}) : helper)))
    + "\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["shared/item_views/empty_view"];
}).call(this);
