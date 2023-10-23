(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["task_chains/item_views/scheduler/hourly_schedule"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return "<label>\n<input class='suspend' name='schedule_suspend' type='checkbox' value='manual'>\nSuspend\n</label>\n";
},"3":function(container,depth0,helpers,partials,data) {
    return "<label>\n<input checked class='suspend' name='schedule_suspend' type='checkbox' value='manual'>\nSuspend\n</label>\n";
},"5":function(container,depth0,helpers,partials,data) {
    return "<option selected value='week'>\n1 Week\n</option>\n";
},"7":function(container,depth0,helpers,partials,data) {
    return "<option value='week'>\n1 Week\n</option>\n";
},"9":function(container,depth0,helpers,partials,data) {
    return "<option selected value='month'>\n1 Month\n</option>\n";
},"11":function(container,depth0,helpers,partials,data) {
    return "<option value='month'>\n1 Month\n</option>\n";
},"13":function(container,depth0,helpers,partials,data) {
    return "<option selected value='year'>\n1 Year\n</option>\n";
},"15":function(container,depth0,helpers,partials,data) {
    return "<option value='year'>\n1 Year\n</option>\n";
},"17":function(container,depth0,helpers,partials,data) {
    return "<option selected value='never_expire'>\nNever Expire\n</option>\n";
},"19":function(container,depth0,helpers,partials,data) {
    return "<option value='never_expire'>\nNever Expire\n</option>\n";
},"21":function(container,depth0,helpers,partials,data) {
    return "<input checked name='task_chain[clear_workspace_before_run]' type='checkbox' value='1'>\n";
},"23":function(container,depth0,helpers,partials,data) {
    return "<input name='task_chain[clear_workspace_before_run]' type='checkbox' value='1'>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='toggle-container'>\n<div class='toggle'>\n"
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.state : stack1),{"name":"unless_eq","hash":{"compare":"suspended"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":8,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.state : stack1),{"name":"if_eq","hash":{"compare":"suspended"},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":0},"end":{"line":14,"column":10}}})) != null ? stack1 : "")
    + "</div>\n</div>\n<form action='javascript:void(0)' method='post'>\n<div class='option'>\n<label>\nRun Chain\n</label>\n<select id='schedule_type' name='schedule_recurrence[frequency]'>\n<option>\nOnce\n</option>\n<option selected value='hourly'>\nHourly\n</option>\n<option value='daily'>\nDaily\n</option>\n<option value='weekly'>\nWeekly\n</option>\n<option value='monthly'>\nMonthly\n</option>\n</select>\n<div class='hourly minute'>\n<span>\nat\n</span>\n<input name='schedule_recurrence[hourly][minute]' type='text' value='"
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.minute : stack1), depth0))
    + "'>\n<span>\nminutes past the hour\n</span>\n</div>\n</div>\n<div class='option'>\n<label>\nMax Duration\n</label>\n<select name='schedule_recurrence[hourly][max_duration]'>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.max_duration : stack1),{"name":"if_eq","hash":{"compare":"week"},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":54,"column":0},"end":{"line":58,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.max_duration : stack1),{"name":"unless_eq","hash":{"compare":"week"},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":59,"column":0},"end":{"line":63,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.max_duration : stack1),{"name":"if_eq","hash":{"compare":"month"},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":64,"column":0},"end":{"line":68,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.max_duration : stack1),{"name":"unless_eq","hash":{"compare":"month"},"fn":container.program(11, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":69,"column":0},"end":{"line":73,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.max_duration : stack1),{"name":"if_eq","hash":{"compare":"year"},"fn":container.program(13, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":74,"column":0},"end":{"line":78,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.max_duration : stack1),{"name":"unless_eq","hash":{"compare":"year"},"fn":container.program(15, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":79,"column":0},"end":{"line":83,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.max_duration : stack1),{"name":"if_eq","hash":{"compare":"never_expire"},"fn":container.program(17, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":84,"column":0},"end":{"line":88,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.hourly : stack1)) != null ? stack1.max_duration : stack1),{"name":"unless_eq","hash":{"compare":"never_expire"},"fn":container.program(19, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":89,"column":0},"end":{"line":93,"column":14}}})) != null ? stack1 : "")
    + "</select>\n</div>\n<div class='option skip-disable'>\n<label class='spacer'></label>\n<div class='delete-project-data'>\n<input name='task_chain[clear_workspace_before_run]' type='hidden' value='0'>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.clear_workspace_before_run : stack1),{"name":"if_eq","hash":{"compare":true},"fn":container.program(21, data, 0),"inverse":container.program(23, data, 0),"data":data,"loc":{"start":{"line":100,"column":0},"end":{"line":104,"column":10}}})) != null ? stack1 : "")
    + "Delete Previous project data (Recommended)\n</div>\n</div>\n</form>";
},"useData":true});
  return this.HandlebarsTemplates["task_chains/item_views/scheduler/hourly_schedule"];
}).call(this);
