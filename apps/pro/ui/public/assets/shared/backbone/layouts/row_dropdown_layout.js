(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/shared/layouts/row_dropdown-f76b4d9f27b6c8ffe590e428e3912f526e442ebdae5b8960b08c93ec28758e30.js'], function($, Template) {
    var RowDropdownLayout;
    return RowDropdownLayout = (function(_super) {

      __extends(RowDropdownLayout, _super);

      function RowDropdownLayout() {
        this.toggleDropdown = __bind(this.toggleDropdown, this);

        this.initialize = __bind(this.initialize, this);
        return RowDropdownLayout.__super__.constructor.apply(this, arguments);
      }

      RowDropdownLayout.prototype.template = HandlebarsTemplates['shared/layouts/row_dropdown'];

      RowDropdownLayout.prototype.events = {
        'click .header': 'toggleDropdown'
      };

      RowDropdownLayout.prototype.regions = {
        header: '.header',
        dropdown: '.dropdown'
      };

      RowDropdownLayout.prototype.initialize = function(_arg) {
        this.enabled = _arg.enabled;
      };

      RowDropdownLayout.prototype.toggleDropdown = function() {
        if (this.enabled) {
          return $('.dropdown', this.el).slideToggle(200);
        }
      };

      return RowDropdownLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
