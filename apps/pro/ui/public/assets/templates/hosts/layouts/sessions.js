(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["hosts/layouts/sessions"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<div class='sessions'>\n<h4>Active Sessions</h4>\n<div id='active_sessions_table'></div>\n<h4 style='margin-top: 35px'>Completed Sessions</h4>\n<div id='completed_sessions_table'></div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["hosts/layouts/sessions"];
}).call(this);
