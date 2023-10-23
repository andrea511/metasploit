(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/pill/pill_controller', 'lib/components/pill/pill_views', 'css!css/components/pill'], function() {
    return this.Pro.module("Components.VulnAttemptStatusPill", function(VulnAttemptStatusPill, App) {
      return VulnAttemptStatusPill.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          options.color = (function() {
            switch (false) {
              case !options.model.isExploited():
                return 'green';
              case !options.model.isNotExploitable():
                return 'blue';
            }
          })();
          return Controller.__super__.initialize.call(this, options);
        };

        return Controller;

      })(Pro.Components.Pill.Controller);
    });
  });

}).call(this);
