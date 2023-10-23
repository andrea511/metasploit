(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["apps/app_stat_modal_header"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<h3>"
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.appRun : depth0)) != null ? stack1.attributes : stack1)) != null ? stack1.app : stack1)) != null ? stack1.name : stack1), depth0))
    + "</h3>\n<label class='status "
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = (depth0 != null ? depth0.appRun : depth0)) != null ? stack1.attributes : stack1)) != null ? stack1.status : stack1), depth0))
    + "'>\n"
    + container.escapeExpression((helpers.humanize||(depth0 && depth0.humanize)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = (depth0 != null ? depth0.appRun : depth0)) != null ? stack1.attributes : stack1)) != null ? stack1.status : stack1),{"name":"humanize","hash":{},"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":3,"column":37}}}))
    + "\n</label>\n<div class='right nexpose-push'>\n<!-- todo: move this business somewhere better -->\n<span class='push_exceptions'></span>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["apps/app_stat_modal_header"];
}).call(this);
