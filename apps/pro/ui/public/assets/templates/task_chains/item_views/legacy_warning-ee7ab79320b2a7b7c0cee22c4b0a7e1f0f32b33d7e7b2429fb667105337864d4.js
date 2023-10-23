(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["task_chains/item_views/legacy_warning"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<div>\nThe Nexpose and import configuration pages have been recently updated.\nBoth tasks now have a new workflow, which streamlines the import of data from Nexpose, Metasploit,\nand third-party vendors. Due to these changes, you must reconfigure any task chain that contains a legacy Nexpose\nor import task. For more information on these changes, see the release notes.\n<a href='https://community.rapid7.com/docs/DOC-3105' target='_blank'>\nhttps://community.rapid7.com/docs/DOC-3105\n</a>\n</div>";
},"useData":true});
  return this.HandlebarsTemplates["task_chains/item_views/legacy_warning"];
}).call(this);
