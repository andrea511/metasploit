(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["task_chains/item_views/scheduler/once_schedule"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return "<label>\n<input class='suspend' name='schedule_suspend' type='checkbox' value='manual'>\nSuspend\n</label>\n";
},"3":function(container,depth0,helpers,partials,data) {
    return "<label>\n<label></label>\n<input checked class='suspend' name='schedule_suspend' type='checkbox' value='manual'>\nSuspend\n</label>\n";
},"5":function(container,depth0,helpers,partials,data) {
    return "<input checked name='task_chain[clear_workspace_before_run]' type='checkbox' value='1'>\n";
},"7":function(container,depth0,helpers,partials,data) {
    return "<input name='task_chain[clear_workspace_before_run]' type='checkbox' value='1'>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='toggle-container'>\n<div class='toggle'>\n"
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.state : stack1),{"name":"unless_eq","hash":{"compare":"suspended"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":8,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.state : stack1),{"name":"if_eq","hash":{"compare":"suspended"},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":0},"end":{"line":15,"column":10}}})) != null ? stack1 : "")
    + "</div>\n</div>\n<form action='javascript:void(0)' method='post'>\n<div class='option'>\n<label for='schedule_type'>\nRun Chain\n</label>\n<select id='schedule_type' name='schedule_recurrence[frequency]'>\n<option selected='true' value='once'>\nOnce\n</option>\n<option value='hourly'>\nHourly\n</option>\n<option value='daily'>\nDaily\n</option>\n<option value='weekly'>\nWeekly\n</option>\n<option value='monthly'>\nMonthly\n</option>\n</select>\n</div>\n<div class='option'>\n<div class='once start-date'>\n<label for='weekday-date'>\nStart on\n</label>\n<input id='weekday-date' name='schedule_recurrence[once][start_date]' readonly='readonly' type='text' value='"
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.once : stack1)) != null ? stack1.start_date : stack1), depth0))
    + "'>\n<div class='once start-time'>\n<label class='start-time-label' for='weekday-time'>\n<span>\n@\n</span>\n<input id='weekday-time' name='schedule_recurrence[once][start_time]' readonly='readonly' type='text' value='"
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.once : stack1)) != null ? stack1.start_time : stack1), depth0))
    + "'>\n</label>\n</div>\n</div>\n</div>\n<div class='option skip-disable'>\n<label class='spacer'></label>\n<div class='delete-project-data'>\n<input name='task_chain[clear_workspace_before_run]' type='hidden' value='0'>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.clear_workspace_before_run : stack1),{"name":"if_eq","hash":{"compare":true},"fn":container.program(5, data, 0),"inverse":container.program(7, data, 0),"data":data,"loc":{"start":{"line":61,"column":0},"end":{"line":65,"column":10}}})) != null ? stack1 : "")
    + "Delete Previous project data (Recommended)\n</div>\n</div>\n</form>";
},"useData":true});
  return this.HandlebarsTemplates["task_chains/item_views/scheduler/once_schedule"];
}).call(this);
