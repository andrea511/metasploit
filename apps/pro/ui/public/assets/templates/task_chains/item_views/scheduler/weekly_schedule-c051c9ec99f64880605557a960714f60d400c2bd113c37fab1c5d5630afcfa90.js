(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["task_chains/item_views/scheduler/weekly_schedule"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    return "<label>\n<input class='suspend' name='schedule_suspend' type='checkbox' value='manual'>\nSuspend\n</label>\n";
},"3":function(container,depth0,helpers,partials,data) {
    return "<label>\n<input checked class='suspend' name='schedule_suspend' type='checkbox' value='manual'>\nSuspend\n</label>\n";
},"5":function(container,depth0,helpers,partials,data) {
    return "<input checked name='schedule_recurrence[weekly][days][]' type='checkbox' value='0'>\n";
},"7":function(container,depth0,helpers,partials,data) {
    return "<input name='schedule_recurrence[weekly][days][]' type='checkbox' value='0'>\n";
},"9":function(container,depth0,helpers,partials,data) {
    return "<input checked name='schedule_recurrence[weekly][days][]' type='checkbox' value='1'>\n";
},"11":function(container,depth0,helpers,partials,data) {
    return "<input name='schedule_recurrence[weekly][days][]' type='checkbox' value='1'>\n";
},"13":function(container,depth0,helpers,partials,data) {
    return "<input checked name='schedule_recurrence[weekly][days][]' type='checkbox' value='2'>\n";
},"15":function(container,depth0,helpers,partials,data) {
    return "<input name='schedule_recurrence[weekly][days][]' type='checkbox' value='2'>\n";
},"17":function(container,depth0,helpers,partials,data) {
    return "<input checked name='schedule_recurrence[weekly][days][]' type='checkbox' value='3'>\n";
},"19":function(container,depth0,helpers,partials,data) {
    return "<input name='schedule_recurrence[weekly][days][]' type='checkbox' value='3'>\n";
},"21":function(container,depth0,helpers,partials,data) {
    return "<input checked name='schedule_recurrence[weekly][days][]' type='checkbox' value='4'>\n";
},"23":function(container,depth0,helpers,partials,data) {
    return "<input name='schedule_recurrence[weekly][days][]' type='checkbox' value='4'>\n";
},"25":function(container,depth0,helpers,partials,data) {
    return "<input checked name='schedule_recurrence[weekly][days][]' type='checkbox' value='5'>\n";
},"27":function(container,depth0,helpers,partials,data) {
    return "<input name='schedule_recurrence[weekly][days][]' type='checkbox' value='5'>\n";
},"29":function(container,depth0,helpers,partials,data) {
    return "<input checked name='schedule_recurrence[weekly][days][]' type='checkbox' value='6'>\n";
},"31":function(container,depth0,helpers,partials,data) {
    return "<input name='schedule_recurrence[weekly][days][]' type='checkbox' value='6'>\n";
},"33":function(container,depth0,helpers,partials,data) {
    return "<input name='schedule_recurrence[weekly][interval]' type='text' value='1'>\n";
},"35":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<input name='schedule_recurrence[weekly][interval]' type='text' value='"
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.interval : stack1), depth0))
    + "'>\n";
},"37":function(container,depth0,helpers,partials,data) {
    return "<option selected value='week'>\n1 Week\n</option>\n";
},"39":function(container,depth0,helpers,partials,data) {
    return "<option value='week'>\n1 Week\n</option>\n";
},"41":function(container,depth0,helpers,partials,data) {
    return "<option selected value='month'>\n1 Month\n</option>\n";
},"43":function(container,depth0,helpers,partials,data) {
    return "<option value='month'>\n1 Month\n</option>\n";
},"45":function(container,depth0,helpers,partials,data) {
    return "<option selected value='year'>\n1 Year\n</option>\n";
},"47":function(container,depth0,helpers,partials,data) {
    return "<option value='year'>\n1 Year\n</option>\n";
},"49":function(container,depth0,helpers,partials,data) {
    return "<option selected value='never_expire'>\nNever Expire\n</option>\n";
},"51":function(container,depth0,helpers,partials,data) {
    return "<option value='never_expire'>\nNever Expire\n</option>\n";
},"53":function(container,depth0,helpers,partials,data) {
    return "<input checked name='task_chain[clear_workspace_before_run]' type='checkbox' value='1'>\n";
},"55":function(container,depth0,helpers,partials,data) {
    return "<input name='task_chain[clear_workspace_before_run]' type='checkbox' value='1'>\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='toggle-container'>\n<div class='toggle'>\n"
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.state : stack1),{"name":"unless_eq","hash":{"compare":"suspended"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":3,"column":0},"end":{"line":8,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.state : stack1),{"name":"if_eq","hash":{"compare":"suspended"},"fn":container.program(3, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":9,"column":0},"end":{"line":14,"column":10}}})) != null ? stack1 : "")
    + "</div>\n</div>\n<form action='javascript:void(0)' method='post'>\n<div class='option'>\n<label for='schedule_type'>\nRun Chain\n</label>\n<select id='schedule_type' name='schedule_recurrence[frequency]'>\n<option value='once'>\nOnce\n</option>\n<option value='hourly'>\nHourly\n</option>\n<option value='daily'>\nDaily\n</option>\n<option selected='true' value='weekly'>\nWeekly\n</option>\n<option value='monthly'>\nMonthly\n</option>\n</select>\n<span>\non\n</span>\n<div class='weekdays'>\n<div class='toggle-button'>\n<label>\n"
    + ((stack1 = (helpers.if_arrContains||(depth0 && depth0.if_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"if_arrContains","hash":{"compare":"0"},"fn":container.program(5, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":45,"column":0},"end":{"line":47,"column":19}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_arrContains||(depth0 && depth0.unless_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"unless_arrContains","hash":{"compare":"0"},"fn":container.program(7, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":48,"column":0},"end":{"line":50,"column":23}}})) != null ? stack1 : "")
    + "<div class='button'>\nS\n</div>\n</label>\n<label>\n"
    + ((stack1 = (helpers.if_arrContains||(depth0 && depth0.if_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"if_arrContains","hash":{"compare":"1"},"fn":container.program(9, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":56,"column":0},"end":{"line":58,"column":19}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_arrContains||(depth0 && depth0.unless_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"unless_arrContains","hash":{"compare":"1"},"fn":container.program(11, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":59,"column":0},"end":{"line":61,"column":23}}})) != null ? stack1 : "")
    + "<div class='button'>\nM\n</div>\n</label>\n</div>\n<div class='toggle-button'>\n<label>\n"
    + ((stack1 = (helpers.if_arrContains||(depth0 && depth0.if_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"if_arrContains","hash":{"compare":"2"},"fn":container.program(13, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":69,"column":0},"end":{"line":71,"column":19}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_arrContains||(depth0 && depth0.unless_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"unless_arrContains","hash":{"compare":"2"},"fn":container.program(15, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":72,"column":0},"end":{"line":74,"column":23}}})) != null ? stack1 : "")
    + "<div class='button'>\nT\n</div>\n</label>\n</div>\n<div class='toggle-button'>\n<label>\n"
    + ((stack1 = (helpers.if_arrContains||(depth0 && depth0.if_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"if_arrContains","hash":{"compare":"3"},"fn":container.program(17, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":82,"column":0},"end":{"line":84,"column":19}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_arrContains||(depth0 && depth0.unless_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"unless_arrContains","hash":{"compare":"3"},"fn":container.program(19, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":85,"column":0},"end":{"line":87,"column":23}}})) != null ? stack1 : "")
    + "<div class='button'>\nW\n</div>\n</label>\n</div>\n<div class='toggle-button'>\n<label>\n"
    + ((stack1 = (helpers.if_arrContains||(depth0 && depth0.if_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"if_arrContains","hash":{"compare":"4"},"fn":container.program(21, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":95,"column":0},"end":{"line":97,"column":19}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_arrContains||(depth0 && depth0.unless_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"unless_arrContains","hash":{"compare":"4"},"fn":container.program(23, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":98,"column":0},"end":{"line":100,"column":23}}})) != null ? stack1 : "")
    + "<div class='button'>\nT\n</div>\n</label>\n</div>\n<div class='toggle-button'>\n<label>\n"
    + ((stack1 = (helpers.if_arrContains||(depth0 && depth0.if_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"if_arrContains","hash":{"compare":"5"},"fn":container.program(25, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":108,"column":0},"end":{"line":110,"column":19}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_arrContains||(depth0 && depth0.unless_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"unless_arrContains","hash":{"compare":"5"},"fn":container.program(27, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":111,"column":0},"end":{"line":113,"column":23}}})) != null ? stack1 : "")
    + "<div class='button'>\nF\n</div>\n</label>\n</div>\n<div class='toggle-button'>\n<label>\n"
    + ((stack1 = (helpers.if_arrContains||(depth0 && depth0.if_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"if_arrContains","hash":{"compare":"6"},"fn":container.program(29, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":121,"column":0},"end":{"line":123,"column":19}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_arrContains||(depth0 && depth0.unless_arrContains)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.days : stack1),{"name":"unless_arrContains","hash":{"compare":"6"},"fn":container.program(31, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":124,"column":0},"end":{"line":126,"column":23}}})) != null ? stack1 : "")
    + "<div class='button'>\nS\n</div>\n</label>\n</div>\n</div>\n</div>\n<div class='option'>\n<div class='weekly start-date'>\n<label for='weekday-date'>\nStart on\n</label>\n<input id='weekday-date' name='schedule_recurrence[weekly][start_date]' readonly='readonly' type='text' value='"
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.start_date : stack1), depth0))
    + "'>\n</div>\n<div class='weekly start-time'>\n<label class='start-time-label' for='weekday-time'>\n<span>\n@\n</span>\n<input id='weekday-time' name='schedule_recurrence[weekly][start_time]' readonly='readonly' type='text' value='"
    + container.escapeExpression(container.lambda(((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.start_time : stack1), depth0))
    + "'>\n</label>\n</div>\n</div>\n<div class='option'>\n<div class='interval'>\n<label>\nRun Every\n</label>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.interval : stack1),{"name":"if_eq","hash":{},"fn":container.program(33, data, 0),"inverse":container.program(35, data, 0),"data":data,"loc":{"start":{"line":155,"column":0},"end":{"line":159,"column":10}}})) != null ? stack1 : "")
    + "</div>\n<span>\nweek(s)\n</span>\n</div>\n<div class='option'>\n<label>\nMax Duration\n</label>\n<select name='schedule_recurrence[weekly][max_duration]'>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.max_duration : stack1),{"name":"if_eq","hash":{"compare":"week"},"fn":container.program(37, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":170,"column":0},"end":{"line":174,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.max_duration : stack1),{"name":"unless_eq","hash":{"compare":"week"},"fn":container.program(39, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":175,"column":0},"end":{"line":179,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.max_duration : stack1),{"name":"if_eq","hash":{"compare":"month"},"fn":container.program(41, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":180,"column":0},"end":{"line":184,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.max_duration : stack1),{"name":"unless_eq","hash":{"compare":"month"},"fn":container.program(43, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":185,"column":0},"end":{"line":189,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.max_duration : stack1),{"name":"if_eq","hash":{"compare":"year"},"fn":container.program(45, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":190,"column":0},"end":{"line":194,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.max_duration : stack1),{"name":"unless_eq","hash":{"compare":"year"},"fn":container.program(47, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":195,"column":0},"end":{"line":199,"column":14}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.max_duration : stack1),{"name":"if_eq","hash":{"compare":"never_expire"},"fn":container.program(49, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":200,"column":0},"end":{"line":204,"column":10}}})) != null ? stack1 : "")
    + ((stack1 = (helpers.unless_eq||(depth0 && depth0.unless_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = ((stack1 = ((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.schedule_hash : stack1)) != null ? stack1.weekly : stack1)) != null ? stack1.max_duration : stack1),{"name":"unless_eq","hash":{"compare":"never_expire"},"fn":container.program(51, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":205,"column":0},"end":{"line":209,"column":14}}})) != null ? stack1 : "")
    + "</select>\n</div>\n<div class='option skip-disable'>\n<label class='spacer'></label>\n<div class='delete-project-data'>\n<input name='task_chain[clear_workspace_before_run]' type='hidden' value='0'>\n"
    + ((stack1 = (helpers.if_eq||(depth0 && depth0.if_eq)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),((stack1 = (depth0 != null ? depth0.task_chain : depth0)) != null ? stack1.clear_workspace_before_run : stack1),{"name":"if_eq","hash":{"compare":true},"fn":container.program(53, data, 0),"inverse":container.program(55, data, 0),"data":data,"loc":{"start":{"line":216,"column":0},"end":{"line":220,"column":10}}})) != null ? stack1 : "")
    + "Delete Previous project data (Recommended)\n</div>\n</div>\n</form>";
},"useData":true});
  return this.HandlebarsTemplates["task_chains/item_views/scheduler/weekly_schedule"];
}).call(this);