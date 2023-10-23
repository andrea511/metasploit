(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["loots/preview"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div class='loot_preview'>\n<textarea class='text_dump'></textarea>\n<div class='img_box' style='text-align:center'>\n<a href='"
    + container.escapeExpression(((helper = (helper = helpers.path || (depth0 != null ? depth0.path : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"path","hash":{},"data":data,"loc":{"start":{"line":4,"column":9},"end":{"line":4,"column":17}}}) : helper)))
    + "' target='_blank'>\n<img>\n</a>\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["loots/preview"];
}).call(this);
