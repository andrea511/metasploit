(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'apps/imports/sonar/templates/sonar_layout', 'apps/imports/sonar/sonar_domain_input_view', 'apps/imports/sonar/sonar_result_view'], function() {
    return this.Pro.module('ImportsApp.Sonar', function(Sonar, App, Backbone, Marionette, $, _) {
      Sonar.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('imports/sonar/sonar_layout');

        Layout.prototype.regions = {
          domainInputRegion: "#sonar-domain-input-region",
          resultsRegion: "#sonar-results-region"
        };

        Layout.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          return this.importsIndexChannel = opts.importsIndexChannel, opts;
        };

        return Layout;

      })(App.Views.Layout);
      return App.commands.setHandler("sonar:imports:display:error", function(opts) {
        opts = _.defaults(opts, {
          title: 'An error occurred',
          style: 'error',
          message: "There was a problem pushing the results to Nexpose."
        });
        return App.execute('flash:display', opts);
      });
    });
  });

}).call(this);
