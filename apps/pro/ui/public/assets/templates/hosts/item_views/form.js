(function() {
  this.HandlebarsTemplates || (this.HandlebarsTemplates = {});
  this.HandlebarsTemplates["hosts/item_views/form"] = Handlebars.template({"1":function(container,depth0,helpers,partials,data) {
    var stack1, helper;

  return "<h5>Name & Address</h5>\n<ul>\n<li class='address'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[address]","Address",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":6,"column":0},"end":{"line":6,"column":35}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[address]",(depth0 != null ? depth0.address : depth0),{"name":"input","hash":{},"data":data,"loc":{"start":{"line":7,"column":0},"end":{"line":7,"column":33}}}))
    + "\n<a class='edit' for='host[address]' href='javascript:void(0)'>"
    + container.escapeExpression(((helper = (helper = helpers.address || (depth0 != null ? depth0.address : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"address","hash":{},"data":data,"loc":{"start":{"line":8,"column":62},"end":{"line":8,"column":73}}}) : helper)))
    + "</a>\n<div class='btns'>\n<a class='pencil edit' for='host[address]' href='javascript:void(0)'></a>\n<div class='actions'>\n<a class='save' for='host[address]' href='javascript:void(0)'>Save</a>\n<a class='cancel' for='host[address]' href='javascript:void(0)'>Cancel</a>\n</div>\n</div>\n</li>\n<li class='name'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[name]","Name",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":18,"column":0},"end":{"line":18,"column":29}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[name]",(depth0 != null ? depth0.name : depth0),{"name":"input","hash":{},"data":data,"loc":{"start":{"line":19,"column":0},"end":{"line":19,"column":27}}}))
    + "\n<a class='edit' for='host[name]' href='javascript:void(0)'>"
    + container.escapeExpression(((helper = (helper = helpers.name || (depth0 != null ? depth0.name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"name","hash":{},"data":data,"loc":{"start":{"line":20,"column":59},"end":{"line":20,"column":67}}}) : helper)))
    + "</a>\n<div class='btns'>\n<a class='pencil edit' for='host[name]' href='javascript:void(0)'></a>\n<div class='actions'>\n<a class='save' for='host[name]' href='javascript:void(0)'>Save</a>\n<a class='cancel' for='host[name]' href='javascript:void(0)'>Cancel</a>\n</div>\n</div>\n</li>\n<li class='mac'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[mac]","MAC Address",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":30,"column":0},"end":{"line":30,"column":35}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[mac]",(depth0 != null ? depth0.mac : depth0),{"name":"input","hash":{},"data":data,"loc":{"start":{"line":31,"column":0},"end":{"line":31,"column":25}}}))
    + "\n<a class='edit' for='host[mac]' href='javascript:void(0)'>"
    + container.escapeExpression(((helper = (helper = helpers.mac || (depth0 != null ? depth0.mac : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"mac","hash":{},"data":data,"loc":{"start":{"line":32,"column":58},"end":{"line":32,"column":65}}}) : helper)))
    + "</a>\n<div class='btns'>\n<a class='pencil edit' for='host[mac]' href='javascript:void(0)'></a>\n<div class='actions'>\n<a class='save' for='host[mac]' href='javascript:void(0)'>Save</a>\n<a class='cancel' for='host[mac]' href='javascript:void(0)'>Cancel</a>\n</div>\n</div>\n</li>\n</ul>\n<h5>Operating System</h5>\n<ul>\n<li class='os_name'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[os_name]","Name",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":45,"column":0},"end":{"line":45,"column":32}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[os_name]",(depth0 != null ? depth0.os_name : depth0),{"name":"input","hash":{},"data":data,"loc":{"start":{"line":46,"column":0},"end":{"line":46,"column":33}}}))
    + "\n<a class='edit' for='host[os_name]' href='javascript:void(0)'>"
    + container.escapeExpression(((helper = (helper = helpers.os_name || (depth0 != null ? depth0.os_name : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"os_name","hash":{},"data":data,"loc":{"start":{"line":47,"column":62},"end":{"line":47,"column":73}}}) : helper)))
    + "</a>\n<div class='btns'>\n<a class='pencil edit' for='host[os_name]' href='javascript:void(0)'></a>\n<div class='actions'>\n<a class='save' for='host[os_name]' href='javascript:void(0)'>Save</a>\n<a class='cancel' for='host[os_name]' href='javascript:void(0)'>Cancel</a>\n</div>\n</div>\n</li>\n<li class='os_flavor'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[os_flavor]","Flavor",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":57,"column":0},"end":{"line":57,"column":36}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[os_flavor]",(depth0 != null ? depth0.os_flavor : depth0),{"name":"input","hash":{},"data":data,"loc":{"start":{"line":58,"column":0},"end":{"line":58,"column":37}}}))
    + "\n<a class='edit' for='host[os_flavor]' href='javascript:void(0)'>"
    + container.escapeExpression(((helper = (helper = helpers.os_flavor || (depth0 != null ? depth0.os_flavor : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"os_flavor","hash":{},"data":data,"loc":{"start":{"line":59,"column":64},"end":{"line":59,"column":77}}}) : helper)))
    + "</a>\n<div class='btns'>\n<a class='pencil edit' for='host[os_flavor]' href='javascript:void(0)'></a>\n<div class='actions'>\n<a class='save' for='host[os_flavor]' href='javascript:void(0)'>Save</a>\n<a class='cancel' for='host[os_flavor]' href='javascript:void(0)'>Cancel</a>\n</div>\n</div>\n</li>\n<li class='os_version'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[os_sp]","SP",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":69,"column":0},"end":{"line":69,"column":28}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[os_sp]",(depth0 != null ? depth0.os_sp : depth0),{"name":"input","hash":{},"data":data,"loc":{"start":{"line":70,"column":0},"end":{"line":70,"column":29}}}))
    + "\n<a class='edit' for='host[os_sp]' href='javascript:void(0)'>"
    + container.escapeExpression(((helper = (helper = helpers.os_sp || (depth0 != null ? depth0.os_sp : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"os_sp","hash":{},"data":data,"loc":{"start":{"line":71,"column":60},"end":{"line":71,"column":69}}}) : helper)))
    + "</a>\n<div class='btns'>\n<a class='pencil edit' for='host[os_sp]' href='javascript:void(0)'></a>\n<div class='actions'>\n<a class='save' for='host[os_sp]' href='javascript:void(0)'>Save</a>\n<a class='cancel' for='host[os_sp]' href='javascript:void(0)'>Cancel</a>\n</div>\n</div>\n</li>\n<li class='purpose'>\n"
    + container.escapeExpression((helpers.label||(depth0 && depth0.label)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[purpose]","Purpose",{"name":"label","hash":{},"data":data,"loc":{"start":{"line":81,"column":0},"end":{"line":81,"column":35}}}))
    + "\n"
    + container.escapeExpression((helpers.input||(depth0 && depth0.input)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"host[purpose]",(depth0 != null ? depth0.purpose : depth0),{"name":"input","hash":{},"data":data,"loc":{"start":{"line":82,"column":0},"end":{"line":82,"column":33}}}))
    + "\n<a class='edit' for='host[purpose]' href='javascript:void(0)'>"
    + container.escapeExpression(((helper = (helper = helpers.purpose || (depth0 != null ? depth0.purpose : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"purpose","hash":{},"data":data,"loc":{"start":{"line":83,"column":62},"end":{"line":83,"column":73}}}) : helper)))
    + "</a>\n<div class='btns'>\n<a class='pencil edit' for='host[purpose]' href='javascript:void(0)'></a>\n<div class='actions'>\n<a class='save' for='host[purpose]' href='javascript:void(0)'>Save</a>\n<a class='cancel' for='host[purpose]' href='javascript:void(0)'>Cancel</a>\n</div>\n</div>\n</li>\n</ul>\n<h5>\nComments\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.comments : depth0),{"name":"if_present","hash":{},"fn":container.program(2, data, 0),"inverse":container.program(4, data, 0),"data":data,"loc":{"start":{"line":95,"column":0},"end":{"line":99,"column":15}}})) != null ? stack1 : "")
    + "</h5>\n<textarea name='host[comments]'></textarea>\n<div class='actions comments'>\n<a class='save' for='host[comments]' href='javascript:void(0)'>Save</a>\n<a class='cancel' for='host[comments]' href='javascript:void(0)'>Cancel</a>\n</div>\n<p class='comments'>\n"
    + ((stack1 = (helpers.if_present||(depth0 && depth0.if_present)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),(depth0 != null ? depth0.comments : depth0),{"name":"if_present","hash":{},"fn":container.program(6, data, 0),"inverse":container.program(8, data, 0),"data":data,"loc":{"start":{"line":107,"column":0},"end":{"line":111,"column":15}}})) != null ? stack1 : "")
    + "</p>\n";
},"2":function(container,depth0,helpers,partials,data) {
    return "<a class='edit comments' for='host[comments]' href='javascript:void(0)'>Edit Comments</a>\n";
},"4":function(container,depth0,helpers,partials,data) {
    return "<a class='edit comments' for='host[comments]' href='javascript:void(0)'>Add Comments</a>\n";
},"6":function(container,depth0,helpers,partials,data) {
    var helper;

  return "<span>"
    + container.escapeExpression(((helper = (helper = helpers.comments || (depth0 != null ? depth0.comments : depth0)) != null ? helper : container.hooks.helperMissing),(typeof helper === "function" ? helper.call(depth0 != null ? depth0 : (container.nullContext || {}),{"name":"comments","hash":{},"data":data,"loc":{"start":{"line":108,"column":6},"end":{"line":108,"column":18}}}) : helper)))
    + "</span>\n";
},"8":function(container,depth0,helpers,partials,data) {
    return "No Comments\n";
},"compiler":[8,">= 4.3.0"],"main":function(container,depth0,helpers,partials,data) {
    var stack1;

  return "<div class='host_form'>\n"
    + ((stack1 = (helpers.form||(depth0 && depth0.form)||container.hooks.helperMissing).call(depth0 != null ? depth0 : (container.nullContext || {}),"/",{"name":"form","hash":{"class":"form toggle-edit"},"fn":container.program(1, data, 0),"inverse":container.noop,"data":data,"loc":{"start":{"line":2,"column":0},"end":{"line":113,"column":9}}})) != null ? stack1 : "")
    + "</div>";
},"useData":true});
  return this.HandlebarsTemplates["hosts/item_views/form"];
}).call(this);
