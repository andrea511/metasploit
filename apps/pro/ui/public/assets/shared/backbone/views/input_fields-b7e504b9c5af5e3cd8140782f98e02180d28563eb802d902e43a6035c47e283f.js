(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/shared/item_views/input_fields-d8f061fd88f4e87071fcb6970079ecf9d88eab6797bb21f36f9c8839ff519f75.js'], function($, Template) {
    var InputFields;
    return InputFields = (function(_super) {

      __extends(InputFields, _super);

      function InputFields() {
        this.initialize = __bind(this.initialize, this);
        return InputFields.__super__.constructor.apply(this, arguments);
      }

      InputFields.prototype.template = HandlebarsTemplates['shared/item_views/input_fields'];

      InputFields.prototype.initialize = function(opts) {
        if (opts == null) {
          opts = {};
        }
        this["class"] = '';
        return $.extend(this, opts);
      };

      return InputFields;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
