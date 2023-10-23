(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/templates/fuzzing/layouts/fuzzing_frame_layout-0210f67c13bc66466372c0d04d7c12aa3793faa8a81201fe942723e5327c917e.js'], function(Template) {
    var FuzzingFrameLayout;
    return FuzzingFrameLayout = (function(_super) {

      __extends(FuzzingFrameLayout, _super);

      function FuzzingFrameLayout() {
        return FuzzingFrameLayout.__super__.constructor.apply(this, arguments);
      }

      FuzzingFrameLayout.prototype.template = HandlebarsTemplates['fuzzing/layouts/fuzzing_frame_layout'];

      FuzzingFrameLayout.prototype.regions = {
        top_row: '.top-row',
        middle_row: '.middle-row',
        bottom_row: '.bottom-row'
      };

      return FuzzingFrameLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
