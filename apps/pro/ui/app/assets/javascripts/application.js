// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//

//= require prototype

//= require common

//= require public/proto_application
//= require jquery.dataTables.min
//= require shared/lib/jquery_truncate
//= require public/jquery.table
//= require public/jquery.inputHint
//= require dataTables.fnReloadAjax
//= require dataTables.filteringDelay
//= require dataTables.hiddenTitle
//= require effects
//= require controls
//= require dragdrop
//= require livepipe
//= require jquery.ajax-retry

//= require shared/datatable_patches

//= require public/forms

//= require public/htmlutils
//= require public/jquery.plugintemplate
//= require public/jquery.multiDeleteConfirm


// fix an insanely annoying side effect of Prototype.js, where Array's
// #toJSON method is patched into a NONSTANDARD IMPLEMENTATION. wtf.
delete Array.prototype.toJSON;

// fix livepipe.js trying to call fire on SVGElement
SVGElement.prototype.fire = function(){return {}};

// <insert Prototype.js rage-face here>
Array.prototype.reduce = window.reduce;
