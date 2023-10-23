(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["fuzzing/layouts/fuzzing_xss_attack_layout"] = Handlebars.template({"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    return "<h1>Fuzzing Frame Attack - XSS</h1>\n<div>\n<div class='row'>\n<div class='columns small-2'>Reference Request</div>\n<div class='columns small-10'>\n<button class='columns small-2'>Choose another request</button>\n<div class='columns small-10'></div>\n</div>\n</div>\n<div class='request'></div>\n</div>\n<div class='parameters'></div>\n<div class='target-browsers'></div>\n<div class='xss-crafter'></div>";
},"useData":true});
  return this.HandlebarsTemplates["fuzzing/layouts/fuzzing_xss_attack_layout"];
}).call(this);
