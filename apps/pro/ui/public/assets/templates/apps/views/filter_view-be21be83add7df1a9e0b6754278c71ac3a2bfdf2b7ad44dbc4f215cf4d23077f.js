(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["apps/views/filter_view"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<li>\n<label>\n<input type='checkbox'>\n<span href='#'>\n<span class='name'>"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":18,"column":19},"end":{"line":18,"column":27}}}) : helper)))
    + "</span>\n<span class='count'>("
    + container.escapeExpression(((helper = (helper = helpers.count || (depth0 != null ? depth0.count : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"count","hash":{},"data":data,"loc":{"start":{"line":19,"column":21},"end":{"line":19,"column":30}}}) : helper)))
    + ")</span>\n</span>\n</label>\n</li>\n";
},"3":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<li>\n<a data-stars='"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":33,"column":15},"end":{"line":33,"column":23}}}) : helper)))
    + "' href='#' title='"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":33,"column":41},"end":{"line":33,"column":49}}}) : helper)))
    + "/5 stars'>\n<span class='rating-stars star"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":34,"column":30},"end":{"line":34,"column":38}}}) : helper)))
    + "'>\n<span></span>\n</span>\n<span class='and-up'>&amp; up</span>\n("
    + container.escapeExpression(((helper = (helper = helpers.count || (depth0 != null ? depth0.count : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"count","hash":{},"data":data,"loc":{"start":{"line":38,"column":1},"end":{"line":38,"column":10}}}) : helper)))
    + ")\n</a>\n</li>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<h3 class='orange-text'>\nMetaModules\n</h3>\n<ul class='filter-sections'>\n<li>\n<h6>\nCategories:\n<span class='reset'>\n<a class='reset' href='#'>Reset</a>\n</span>\n</h6>\n<ul class='categories'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.categories : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":13,"column":0},"end":{"line":23,"column":9}}})) != null ? stack1 : "")
    + "</ul>\n</li>\n<li>\n<h6>\nSafety Rating:\n</h6>\n<ul class='safety-ratings'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.safetyRatings : depth0),{"name":"each","hash":{},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":31,"column":0},"end":{"line":41,"column":9}}})) != null ? stack1 : "")
    + "</ul>\n</li>\n</ul>";
},"useData":true});
  return this.HandlebarsTemplates["apps/views/filter_view"];
}).call(this);
