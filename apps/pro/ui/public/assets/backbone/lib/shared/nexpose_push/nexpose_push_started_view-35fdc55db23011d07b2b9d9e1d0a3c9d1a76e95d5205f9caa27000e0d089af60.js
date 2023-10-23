(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_itemview', 'lib/shared/nexpose_push/templates/push_started_modal'], function() {
    return this.Pro.module('Shared.NexposePush', function(NexposePush, App) {
      return NexposePush.StartedView = (function(_super) {

        __extends(StartedView, _super);

        function StartedView() {
          return StartedView.__super__.constructor.apply(this, arguments);
        }

        StartedView.prototype.template = StartedView.prototype.templatePath('nexpose_push/push_started_modal');

        StartedView.prototype.templateHelpers = {
          linkToTask: function() {
            return this.redirectUrl || "tasks";
          }
        };

        return StartedView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
