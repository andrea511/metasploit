(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["task_chains/item_views/task_chain_header"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<div class='name columns small-6'>\n<div class='container'>\n<label for='name'>\nTask Chain Name:\n</label>\n<div class='field-container'>\n<input id='name' name='task_chain[name]' type='text'>\n</div>\n</div>\n</div>\n<div class='columns small-3 schedule-container'>\n<div class='schedule-wrapper'>\n<div class='schedule-state schedule'></div>\n</div>\n<a class='schedule' href='javascript:void(0)'>\nSchedule Now\n</a>\n</div>\n<div class='actions columns small-3'>\n<ul>\n<li class='cancel'>\n<span class='btn cancel link'>\n<a href='javascript:void(0)'>\nCancel\n</a>\n</span>\n</li>\n<li class='save-and-run'>\n<span class='btn save-run disabled'>\n<a class='disabled' href='javascript:void(0)'>\nSave and Run Now\n</a>\n</span>\n</li>\n<li class='save'>\n<span class='btn save disabled'>\n<a class='disabled' href='javascript:void(0)'>\nSave\n</a>\n</span>\n</li>\n</ul>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["task_chains/item_views/task_chain_header"];
}).call(this);
