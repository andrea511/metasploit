(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["tasks/new_nexpose_exception_push/item_views/vuln"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<option value='"
    + container.escapeExpression(((helper = (helper = helpers.value || (depth0 != null ? depth0.value : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"value","hash":{},"data":data,"loc":{"start":{"line":41,"column":15},"end":{"line":41,"column":24}}}) : helper)))
    + "'>\n"
    + container.escapeExpression(((helper = (helper = helpers.text || (depth0 != null ? depth0.text : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"text","hash":{},"data":data,"loc":{"start":{"line":42,"column":0},"end":{"line":42,"column":8}}}) : helper)))
    + "\n</option>\n";
},"3":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper, options, buffer = 
  "<tr class='";
  stack1 = ((helper = (helper = helpers["even_class?"] || (depth0 != null ? depth0["even_class?"] : depth0)) != null ? helper : container.hooks.helperMissing),(options={"name":"even_class?","hash":{},"fn":container.program(4, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":60,"column":11},"end":{"line":60,"column":53}}}),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),options) : helper));
  if (!helpers["even_class?"]) { stack1 = container.hooks.blockHelperMissing.call(depth0,stack1,options)}
  if (stack1 != null) { buffer += stack1; }
  buffer += "'>\n<td>\n<input class='host_checkbox' name='nexpose_result_exceptions["
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].itemIndex : depths[1]), depth0))
    + "]["
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":62,"column":79},"end":{"line":62,"column":89}}}) : helper)))
    + "][checkbox]' type='checkbox'>\n</td>\n<td>\n"
    + container.escapeExpression(((helper = (helper = helpers.host_address || (depth0 != null ? depth0.host_address : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"host_address","hash":{},"data":data,"loc":{"start":{"line":65,"column":0},"end":{"line":65,"column":16}}}) : helper)))
    + "\n</td>\n<td>\n<label>\nReason:\n</label>\n<div class='hidden-selection invisible' data-reason='"
    + container.escapeExpression(((helper = (helper = helpers.reason || (depth0 != null ? depth0.reason : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"reason","hash":{},"data":data,"loc":{"start":{"line":71,"column":53},"end":{"line":71,"column":63}}}) : helper)))
    + "'></div>\n<select id='reason_"
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":72,"column":19},"end":{"line":72,"column":29}}}) : helper)))
    + "' name='nexpose_result_exceptions["
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].itemIndex : depths[1]), depth0))
    + "]["
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":72,"column":81},"end":{"line":72,"column":91}}}) : helper)))
    + "][reason]'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depths[1] != null ? depths[1].reasons : depths[1]),{"name":"each","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":73,"column":0},"end":{"line":77,"column":9}}})) != null ? stack1 : "")
    + "</select>\n<span class='invisible'></span>\n</td>\n<td>\n<label>\nComment:\n</label>\n<input class='comment' id='comment_"
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":85,"column":35},"end":{"line":85,"column":45}}}) : helper)))
    + "' name='nexpose_result_exceptions["
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].itemIndex : depths[1]), depth0))
    + "]["
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":85,"column":97},"end":{"line":85,"column":107}}}) : helper)))
    + "][comments]' value='"
    + container.escapeExpression(((helper = (helper = helpers.comments || (depth0 != null ? depth0.comments : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"comments","hash":{},"data":data,"loc":{"start":{"line":85,"column":127},"end":{"line":85,"column":139}}}) : helper)))
    + "'>\n<span class='invisible'></span>\n</td>\n<td>\n<label>\nExpire:\n</label>\n<input class='datetime' id='expire_date_"
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].itemIndex : depths[1]), depth0))
    + "_"
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":92,"column":57},"end":{"line":92,"column":67}}}) : helper)))
    + "' name='nexpose_result_exceptions["
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].itemIndex : depths[1]), depth0))
    + "]["
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":92,"column":119},"end":{"line":92,"column":129}}}) : helper)))
    + "][expiration_date]' value='";
  stack1 = ((helper = (helper = helpers.utc_to_datepicker || (depth0 != null ? depth0.utc_to_datepicker : depth0)) != null ? helper : container.hooks.helperMissing),(options={"name":"utc_to_datepicker","hash":{},"fn":container.program(6, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":92,"column":156},"end":{"line":92,"column":219}}}),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),options) : helper));
  if (!helpers.utc_to_datepicker) { stack1 = container.hooks.blockHelperMissing.call(depth0,stack1,options)}
  if (stack1 != null) { buffer += stack1; }
  return buffer + "'>\n<input name='nexpose_result_exceptions["
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].itemIndex : depths[1]), depth0))
    + "]["
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":93,"column":57},"end":{"line":93,"column":67}}}) : helper)))
    + "][id]' type='hidden' value='"
    + container.escapeExpression(((helper = (helper = helpers.id || (depth0 != null ? depth0.id : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"id","hash":{},"data":data,"loc":{"start":{"line":93,"column":95},"end":{"line":93,"column":101}}}) : helper)))
    + "'>\n<input name='nexpose_result_exceptions["
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].itemIndex : depths[1]), depth0))
    + "]["
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":94,"column":57},"end":{"line":94,"column":67}}}) : helper)))
    + "][automatic_exploitation_match_result_id]' type='hidden' value='"
    + container.escapeExpression(((helper = (helper = helpers.automatic_exploitation_match_result_id || (depth0 != null ? depth0.automatic_exploitation_match_result_id : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"automatic_exploitation_match_result_id","hash":{},"data":data,"loc":{"start":{"line":94,"column":131},"end":{"line":94,"column":173}}}) : helper)))
    + "'>\n<input class='auto-approve' name='nexpose_result_exceptions["
    + container.escapeExpression(container.lambda((depths[1] != null ? depths[1].itemIndex : depths[1]), depth0))
    + "]["
    + container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":95,"column":78},"end":{"line":95,"column":88}}}) : helper)))
    + "][approve]' type='hidden' value='"
    + container.escapeExpression(((helper = (helper = helpers.approve || (depth0 != null ? depth0.approve : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"approve","hash":{},"data":data,"loc":{"start":{"line":95,"column":121},"end":{"line":95,"column":132}}}) : helper)))
    + "'>\n</td>\n<td>\n<div class='result_code'>\nResult Code: "
    + container.escapeExpression(((helper = (helper = helpers.result_code || (depth0 != null ? depth0.result_code : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"result_code","hash":{},"data":data,"loc":{"start":{"line":99,"column":13},"end":{"line":99,"column":28}}}) : helper)))
    + "\n</div>\n</td>\n</tr>\n";
},"4":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.index || (data && data.index)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"index","hash":{},"data":data,"loc":{"start":{"line":60,"column":27},"end":{"line":60,"column":37}}}) : helper)));
},"6":function(container,depth0,helpers,partials,data) {
    var helper;

  return container.escapeExpression(((helper = (helper = helpers.expiration_date || (depth0 != null ? depth0.expiration_date : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"expiration_date","hash":{},"data":data,"loc":{"start":{"line":92,"column":178},"end":{"line":92,"column":197}}}) : helper)));
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data,blockParams,depths) {
    var stack1, helper;

  return "<div class='vuln-exception columns'>\n<div class='header row'>\n<div class='left columns small-12'>\n<div class='row'>\n<div class='name columns small-8'>\n"
    + container.escapeExpression(((helper = (helper = helpers.module_detail || (depth0 != null ? depth0.module_detail : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"module_detail","hash":{},"data":data,"loc":{"start":{"line":6,"column":0},"end":{"line":6,"column":17}}}) : helper)))
    + "\n</div>\n<div class='columns small-4 spacer'></div>\n</div>\n<div class='row'>\n<div class='columns small-6'>\n<div class='row'>\n<div class='radios columns'>\n<input id='option_"
    + container.escapeExpression(((helper = (helper = helpers.itemIndex || (depth0 != null ? depth0.itemIndex : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"itemIndex","hash":{},"data":data,"loc":{"start":{"line":14,"column":18},"end":{"line":14,"column":31}}}) : helper)))
    + "_all' name='option_"
    + container.escapeExpression(((helper = (helper = helpers.itemIndex || (depth0 != null ? depth0.itemIndex : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"itemIndex","hash":{},"data":data,"loc":{"start":{"line":14,"column":50},"end":{"line":14,"column":63}}}) : helper)))
    + "' type='radio' value='all'>\n<label for='option_"
    + container.escapeExpression(((helper = (helper = helpers.itemIndex || (depth0 != null ? depth0.itemIndex : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"itemIndex","hash":{},"data":data,"loc":{"start":{"line":15,"column":19},"end":{"line":15,"column":32}}}) : helper)))
    + "_all'>\nAll Hosts with this Vulnerability\n</label>\n<input checked='checked' id='option_"
    + container.escapeExpression(((helper = (helper = helpers.itemIndex || (depth0 != null ? depth0.itemIndex : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"itemIndex","hash":{},"data":data,"loc":{"start":{"line":18,"column":36},"end":{"line":18,"column":49}}}) : helper)))
    + "_single' name='option_"
    + container.escapeExpression(((helper = (helper = helpers.itemIndex || (depth0 != null ? depth0.itemIndex : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"itemIndex","hash":{},"data":data,"loc":{"start":{"line":18,"column":71},"end":{"line":18,"column":84}}}) : helper)))
    + "' type='radio' value='single'>\n<label for='option_"
    + container.escapeExpression(((helper = (helper = helpers.itemIndex || (depth0 != null ? depth0.itemIndex : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"itemIndex","hash":{},"data":data,"loc":{"start":{"line":19,"column":19},"end":{"line":19,"column":32}}}) : helper)))
    + "_single'>\nIndividual Hosts with this Vulnerability\n</label>\n</div>\n</div>\n</div>\n</div>\n</div>\n</div>\n<div class='row hosts'>\n<div class='columns small-12'>\n<table border='1'>\n<tr>\n<th></th>\n<th></th>\n<th>\n<div class='mass-assign invisible'>\n<label>\nReason\n</label>\n<select name='group_reason'>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.reasons : depth0),{"name":"each","hash":{},"fn":container.program(1, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":40,"column":0},"end":{"line":44,"column":9}}})) != null ? stack1 : "")
    + "</select>\n</div>\n</th>\n<th>\n<div class='mass-assign invisible'>\n<label>\nComment:\n</label>\n<input name='group_comment'>\n</div>\n</th>\n<th></th>\n<th></th>\n</tr>\n"
    + ((stack1 = helpers.each.call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.result_exceptions : depth0),{"name":"each","hash":{},"fn":container.program(3, data, 0, blockParams, depths),"inverse":container.noop,"data":data,"loc":{"start":{"line":59,"column":0},"end":{"line":103,"column":9}}})) != null ? stack1 : "")
    + "</table>\n</div>\n</div>\n</div>";
},"useData":true,"useDepths":true});
  return this.HandlebarsTemplates["tasks/new_nexpose_exception_push/item_views/vuln"];
}).call(this);
