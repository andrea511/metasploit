(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["apps/layouts/apps_overview_layout"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<div>\n<div class='stats-area stats row'>\n<div class='cell' style='width: 24%;'>\n<a class='view-all-runs' href='./app_runs'>\n<div class='wrap'>\n<div class='all'>View All</div>\n<div class='sub'>"
    + container.escapeExpression(((helper = (helper = helpers.numAppRuns || (depth0 != null ? depth0.numAppRuns : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"numAppRuns","hash":{},"data":data,"loc":{"start":{"line":7,"column":17},"end":{"line":7,"column":31}}}) : helper)))
    + " recently launched metamodules</div>\n</div>\n</a>\n</div>\n<div class='cell' style='width: 1%;'>\n&nbsp;\n</div>\n<div class='cell' style='width: 75%;'>\n<div class='last-stat' style='position:relative'></div>\n</div>\n</div>\n<div class='apps-area'></div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["apps/layouts/apps_overview_layout"];
}).call(this);
