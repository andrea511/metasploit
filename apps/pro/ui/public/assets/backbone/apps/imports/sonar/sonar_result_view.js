(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_itemview', 'apps/imports/sonar/templates/result_view', 'apps/imports/sonar/templates/empty_result_view'], function() {
    return this.Pro.module('ImportsApp.Sonar', function(Sonar, App, Backbone, Marionette, $, _) {
      Sonar.ResultView = (function(_super) {

        __extends(ResultView, _super);

        function ResultView() {
          return ResultView.__super__.constructor.apply(this, arguments);
        }

        ResultView.prototype.template = ResultView.prototype.templatePath('imports/sonar/result_view');

        ResultView.prototype.ui = {
          resultsTable: '#sonar-results-table'
        };

        ResultView.prototype.onShow = function(opts) {
          var collection, columns, tableController, tableOpts;
          if (opts == null) {
            opts = {};
          }
          columns = [
            {
              label: 'Address',
              attribute: 'address'
            }, {
              label: 'Host Name',
              attribute: 'name'
            }, {
              label: 'Service',
              attribute: 'host.service'
            }, {
              label: 'Last Updated',
              attribute: 'updated_at'
            }
          ];
          collection = new Backbone.Collection([
            {
              'address': '10.0.0.1',
              'name': 'hostname-01',
              'host.service': 'smb',
              'updated_at': '2015-10-21 09:38:26AM -06:00'
            }, {
              'address': '10.0.0.2',
              'name': 'hostname-02',
              'host.service': 'smb',
              'updated_at': '2015-10-21 09:38:26AM -06:00'
            }, {
              'address': '10.0.0.3',
              'name': 'hostname-03',
              'host.service': 'smb',
              'updated_at': '2015-10-21 09:38:26AM -06:00'
            }, {
              'address': '10.0.0.4',
              'name': 'hostname-04',
              'host.service': 'smb',
              'updated_at': '2015-10-21 09:38:26AM -06:00'
            }, {
              'address': '10.0.0.5',
              'name': 'hostname-05',
              'host.service': 'smb',
              'updated_at': '2015-10-21 09:38:26AM -06:00'
            }
          ]);
          tableOpts = {
            region: new Backbone.Marionette.Region({
              el: this.ui.resultsTable
            }),
            columns: columns,
            selectable: true,
            collection: collection
          };
          return tableController = App.request("table:component", tableOpts);
        };

        return ResultView;

      })(App.Views.ItemView);
      return Sonar.EmptyResultView = (function(_super) {

        __extends(EmptyResultView, _super);

        function EmptyResultView() {
          return EmptyResultView.__super__.constructor.apply(this, arguments);
        }

        EmptyResultView.prototype.template = EmptyResultView.prototype.templatePath('imports/sonar/empty_result_view');

        EmptyResultView.prototype.className = 'shared nexpose-sites';

        return EmptyResultView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
