(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["shared/item_views/inline_edit"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class='container'>\n<div class='input-container'></div>\n<div class='field-text'>\n"
    + container.escapeExpression(((helper = (helper = helpers.ref || (depth0 != null ? depth0.ref : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"ref","hash":{},"data":data,"loc":{"start":{"line":4,"column":0},"end":{"line":4,"column":9}}}) : helper)))
    + "\n</div>\n<div class='controls'>\n<a class='garbage' href='javascript:void(0)'></a>\n<a class='pencil' href='javascript:void(0)'></a>\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["shared/item_views/inline_edit"];
}).call(this);
