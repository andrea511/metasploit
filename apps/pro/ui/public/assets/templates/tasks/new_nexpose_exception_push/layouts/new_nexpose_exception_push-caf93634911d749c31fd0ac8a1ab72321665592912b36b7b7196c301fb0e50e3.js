(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["tasks/new_nexpose_exception_push/layouts/new_nexpose_exception_push"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<form id='exception-push-form'>\n<div class='row exception-settings-line'>\n<div class='columns exception-settings'>\n<div class='header columns small-12'>\n<div class='small-2 columns'>\nEXCEPTION SETTINGS\n</div>\n<div class='console-field small-8 columns'>\n<label class='hide-console-field'>\nNexponse Console\n</label>\n"
    + container.escapeExpression((helpers.select||(depth0 && depth0.select)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"console",((stack1 = (depth0 != null ? depth0.console : depth0)) != null ? stack1.consoles : stack1),((stack1 = (depth0 != null ? depth0.console : depth0)) != null ? stack1.console : stack1),{"name":"select","hash":{},"data":data,"loc":{"start":{"line":12,"column":0},"end":{"line":12,"column":53}}}))
    + "\n"
    + container.escapeExpression((helpers.checkbox||(depth0 && depth0.checkbox)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"auto_approve","yes",true,{"name":"checkbox","hash":{},"data":data,"loc":{"start":{"line":13,"column":0},"end":{"line":13,"column":38}}}))
    + "\n<label>\nAutomatically Approve\n</label>\n</div>\n<div class='push-exceptions small-2 columns'>\n<div class='btnRow'>\n<span class='btn'>\n<a class='nexpose' href='javascript:void(0)'>\nPush Exceptions\n</a>\n</span>\n</div>\n</div>\n</div>\n</div>\n</div>\n<div class='tabs'></div>\n</form>";
},"useData":true});
  return this.HandlebarsTemplates["tasks/new_nexpose_exception_push/layouts/new_nexpose_exception_push"];
}).call(this);
