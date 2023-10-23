(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["task_chains/layouts/task_chains"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<div class='foundation'>\n<div class='header row'></div>\n<div class='row' id='task-chain-content'>\n<div class='columns small-12 container'>\n<div class='nav row'></div>\n<div class='content row'></div>\n<form class='row' enctype='multipart/form-data' id='hidden-form' method='post'>\n<input name='schedule_suspend' type='hidden' value='future'>\n<div class='hidden-inputs'></div>\n</form>\n</div>\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["task_chains/layouts/task_chains"];
}).call(this);
