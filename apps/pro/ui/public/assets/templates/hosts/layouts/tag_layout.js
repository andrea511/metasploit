(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["hosts/layouts/tag_layout"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var helper;

  return "<a class='tag' href='/workspaces/"
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].workspace_id : depths[1]), depth0))
    + "/hosts?search=%23"
    + container.escapeExpression((helpers.encodeURIComponent||(depth0 && depth0.encodeURIComponent)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.name : depth0),{"name":"encodeURIComponent","hash":{},"data":data,"loc":{"start":{"line":3,"column":69},"end":{"line":3,"column":96}}}))
    + "'>\n<span class='name'>"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":4,"column":19},"end":{"line":4,"column":27}}}) : helper)))
    + "</span>\n</a>\n<a class='tag-close' data-id='"
    + container.escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"id","hash":{},"data":data,"loc":{"start":{"line":6,"column":30},"end":{"line":6,"column":36}}}) : helper)))
    + "' href='javascript:void(0)'>\n&times;\n</a>\n";
},"3":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper;

  return "<a class='more' href='javascript:void(0)'>\n"
    + container.escapeExpression(((helper = (helper = helpers.moreTagCount || (depth0 != null ? depth0.moreTagCount : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"moreTagCount","hash":{},"data":data,"loc":{"start":{"line":12,"column":0},"end":{"line":12,"column":16}}}) : helper)))
    + " more…\n</a>\n<div class='under'>\n<div class='white'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.otherTags : depth0),{"name":"each","hash":{},"fn":container.program(4, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":16,"column":0},"end":{"line":25,"column":9}}})) != null ? stack1 : "")
    + "</div>\n</div>\n";
},"4":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var helper;

  return "<div class='wrap'>\n<a class='tag' href='/workspaces/"
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].workspace_id : depths[1]), depth0))
    + "/hosts?search=%23"
    + container.escapeExpression((helpers.encodeURIComponent||(depth0 && depth0.encodeURIComponent)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.name : depth0),{"name":"encodeURIComponent","hash":{},"data":data,"loc":{"start":{"line":18,"column":69},"end":{"line":18,"column":96}}}))
    + "'>\n<span class='name'>"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":19,"column":19},"end":{"line":19,"column":27}}}) : helper)))
    + "</span>\n</a>\n<a class='tag-close' data-id='"
    + container.escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"id","hash":{},"data":data,"loc":{"start":{"line":21,"column":30},"end":{"line":21,"column":36}}}) : helper)))
    + "' href='javascript:void(0)'>\n&times;\n</a>\n</div>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1;

  return "<label class='tags'>Tags</label>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.lastTags : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":0},"end":{"line":9,"column":9}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_gt||(depth0 && depth0.if_gt)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.tagCount : depth0),{"name":"if_gt","hash":{"compare":3},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":10,"column":0},"end":{"line":28,"column":10}}})) != null ? stack1 : "")
    + "<a class='green-add' href='javascript:void(0);' title='Add tags to this host'>+</a>";
},"useData":true,"useDepths":true});
  return this.HandlebarsTemplates["hosts/layouts/tag_layout"];
}).call(this);
