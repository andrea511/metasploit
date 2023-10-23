(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["apps/views/app_run_view"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data,blockParams,depths) {
    return "<div class='center' style='display: inline-block; margin-right: 15px; width: 100px;'>\n<span class='stat' title='"
    + container.escapeExpression((helpers.lookupStat||(depth0 && depth0.lookupStat)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depths[1] != null ? depths[1].statData : depths[1]),depth0,{"name":"lookupStat","hash":{},"data":data,"loc":{"start":{"line":9,"column":26},"end":{"line":9,"column":54}}}))
    + "'>"
    + container.escapeExpression((helpers.formatStat||(depth0 && depth0.formatStat)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depths[1] != null ? depths[1].statData : depths[1]),depth0,{"name":"formatStat","hash":{},"data":data,"loc":{"start":{"line":9,"column":56},"end":{"line":9,"column":84}}}))
    + "</span>\n<span class='sub'>"
    + container.escapeExpression((helpers.humanizeStat||(depth0 && depth0.humanizeStat)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depths[1] != null ? depths[1].app : depths[1]),depth0,{"name":"humanizeStat","hash":{},"data":data,"loc":{"start":{"line":10,"column":18},"end":{"line":10,"column":43}}}))
    + "</span>\n</div>\n";
},"3":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='tab-loading'></div>\n"
    + ((stack1 = helpers["if"].call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.app : depth0)) != null ? stack1.percentage : stack1),{"name":"if","hash":{},"fn":container.program(4, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":17,"column":0},"end":{"line":19,"column":7}}})) != null ? stack1 : "")
    + "<div class='progress-text'>\n<span class='sub'>Scan in progress</span>\n</div>\n";
},"4":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<span class='percentage'>"
    + container.escapeExpression((helpers.percentize||(depth0 && depth0.percentize)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.app : depth0)) != null ? stack1.percentage : stack1),(depth0 != null ? depth0.statData : depth0),{"name":"percentize","hash":{},"data":data,"loc":{"start":{"line":18,"column":25},"end":{"line":18,"column":63}}}))
    + "</span>\n";
},"6":function(container,depth0,helpers,partials,data) {
    return "<li>\n<a class='stop' href='#'>Stop</a>\n</li>\n";
},"8":function(container,depth0,helpers,partials,data) {
    return "<li>\n<a class='delete' href='#'>Delete</a>\n</li>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper;

  return "<div class='app-run-view row'>\n<div class='large-3 columns'>\n<h6>"
    + container.escapeExpression(container.lambda(((stack1 = (depth0 != null ? depth0.app : depth0)) != null ? stack1.name : stack1), depth0))
    + "</h6>\n<span class='sub' title='"
    + container.escapeExpression(((helper = (helper = helpers.created_at || (depth0 != null ? depth0.created_at : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"created_at","hash":{},"data":data,"loc":{"start":{"line":4,"column":25},"end":{"line":4,"column":39}}}) : helper)))
    + "'>Start Time: "
    + container.escapeExpression(((helper = (helper = helpers.started_at || (depth0 != null ? depth0.started_at : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"started_at","hash":{},"data":data,"loc":{"start":{"line":4,"column":53},"end":{"line":4,"column":67}}}) : helper)))
    + "</span>\n</div>\n<div class='large-3 columns center run-stats' style='padding-left: 0; padding-right: 0;'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.app : depth0)) != null ? stack1.row_stats : stack1),{"name":"each","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":12,"column":9}}})) != null ? stack1 : "")
    + "</div>\n<div class='large-4 columns center loading-wrapper'>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.status : depth0),{"name":"if_eq","hash":{"compare":"running"},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":15,"column":0},"end":{"line":23,"column":10}}})) != null ? stack1 : "")
    + "</div>\n<div class='large-2 columns findings'>\n<div class='status-text'>\n<label class='status "
    + container.escapeExpression(((helper = (helper = helpers.status || (depth0 != null ? depth0.status : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"status","hash":{},"data":data,"loc":{"start":{"line":27,"column":21},"end":{"line":27,"column":31}}}) : helper)))
    + "'>"
    + container.escapeExpression((helpers.humanize||(depth0 && depth0.humanize)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.status : depth0),{"name":"humanize","hash":{},"data":data,"loc":{"start":{"line":27,"column":33},"end":{"line":27,"column":52}}}))
    + "</label>\n</div>\n<ul class='actions'>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.status : depth0),{"name":"if_eq","hash":{"compare":"running"},"fn":container.program(6, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":30,"column":0},"end":{"line":34,"column":10}}})) != null ? stack1 : "")
    + "<li>\n<a class='findings' href='#'>Findings</a>\n</li>\n"
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.status : depth0),{"name":"unless_eq","hash":{"compare":"running"},"fn":container.program(8, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":38,"column":0},"end":{"line":42,"column":14}}})) != null ? stack1 : "")
    + "</ul>\n</div>\n</div>";
},"useData":true,"useDepths":true});
  return this.HandlebarsTemplates["apps/views/app_run_view"];
}).call(this);
