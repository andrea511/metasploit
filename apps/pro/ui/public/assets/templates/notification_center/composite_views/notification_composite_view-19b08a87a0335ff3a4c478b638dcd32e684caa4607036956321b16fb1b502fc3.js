(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["notification_center/composite_views/notification_composite_view"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<div class='notification-type'>\n<div class='type-title'>\n<span>\nLatest Notifications\n</span>\n</div>\n<div class='sort-options'>\n<span>\nShow\n</span>\n<span>\n<select name='notification_type'>\n<option value=''>\nAll\n</option>\n<option value='minion_notification'>\nMinions\n</option>\n<option value='system_notification'>\nSystem\n</option>\n</select>\n</span>\n</div>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["notification_center/composite_views/notification_composite_view"];
}).call(this);
