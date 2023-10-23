(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["apps/layouts/app_stat_modal_layout"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<div class='rollup-header'>\n<div class='max-width'></div>\n</div>\n<div class='app-stats max-width' style='padding: 0 20px;'>\n<ul class='rollup-tabs'>\n<li class='selected'>\n<a href='javascript:void(0)'>Statistics</a>\n</li>\n<li>\n<a href='javascript:void(0)'>Task Log</a>\n</li>\n</ul>\n<div class='rollup-page'>\n<div class='rollup-tab'>\n<div class='stats-region'>\n<div class='stats tab-loading'></div>\n</div>\n<div class='drilldown-padding'>\n<div class='drilldown-area tab-loading'></div>\n<div class='right exploit-continue-btn' style='display: none; position: absolute; top: 7px; right: 6px;'>\n<span class='btn'>\n<a class='continue-button' href='javascript:void(0)'>Continue Exploitation</a>\n</span>\n</div>\n</div>\n</div>\n<div class='rollup-tab' style='display: none'>\n<div class='console-area'></div>\n</div>\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["apps/layouts/app_stat_modal_layout"];
}).call(this);
