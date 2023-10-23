(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/vulns/index/components/push_status_cell/push_status_cell_view'], function() {
    return this.Pro.module("Components.PushStatusCell", function(PushStatusCell, App) {
      return PushStatusCell.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {};

        Controller.prototype.initialize = function(options) {
          var view;
          if (options == null) {
            options = {};
          }
          if (options.model.get('vuln.latest_nexpose_result.sent_to_nexpose')) {
            switch (options.model.get('vuln.latest_nexpose_result.type')) {
              case 'Nexpose::Result::Exception':
                options.model.set('vuln.latest_nexpose_result.icon', '/assets/icons/nxStatus-push-exception-0d7076f6793c3d2cb75d26c6cc22fabd2b852094a3e4c5f924ebced6d919f8e4.svg');
                options.model.set('vuln.latest_nexpose_result.hover_text', 'Pushed as Exception');
                break;
              case 'Nexpose::Result::Validation':
                options.model.set('vuln.latest_nexpose_result.icon', '/assets/icons/nxStatus-push-validation-d1a83ea53b310e03f40c6750d963d196bd86b648eda69624ff9894ae51b07e8b.svg');
                options.model.set('vuln.latest_nexpose_result.hover_text', 'Pushed as Validation');
            }
          } else {
            options.model.set('vuln.latest_nexpose_result.icon', '/assets/icons/nxStatus-header-e4342bb4dad4e3191f516bb82d0f92d73ba70673f968b2067703da20d46bf3df.svg');
            options.model.set('vuln.latest_nexpose_result.hover_text', 'Not Pushed');
          }
          view = new PushStatusCell.View({
            model: options.model
          });
          return this.setMainView(view);
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
