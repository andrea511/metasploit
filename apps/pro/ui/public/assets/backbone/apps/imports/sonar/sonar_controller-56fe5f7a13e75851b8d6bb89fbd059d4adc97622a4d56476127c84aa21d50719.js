(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/imports/sonar/sonar_layout_view', 'lib/components/table/table_controller', 'entities/sonar/fdns', 'entities/sonar/import_run', 'lib/components/pro_search_filter/filter_controller', 'lib/concerns/pollable', 'entities/task'], function() {
    return this.Pro.module("ImportsApp.Sonar", function(Sonar, App, Backbone, Marionette, $, _) {
      Sonar.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this._rowsSelected = __bind(this._rowsSelected, this);

          this.poll = __bind(this.poll, this);

          this._renderErrors = __bind(this._renderErrors, this);

          this._importRunErrorCallback = __bind(this._importRunErrorCallback, this);

          this._importRunCallback = __bind(this._importRunCallback, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.include('Pollable');

        Controller.prototype.pollInterval = 2000;

        Controller.prototype.initialize = function(options) {
          var stateModel;
          stateModel = new Sonar.StateModel(options);
          this.importsIndexChannel = options.importsIndexChannel;
          this.layout = new Sonar.Layout({
            model: stateModel,
            importsIndexChannel: options.importsIndexChannel
          });
          this.setMainView(this.layout);
          this.listenTo(this.layout, 'show', function() {
            if (gon.licensed) {
              this.domainInputView = new Sonar.DomainInputView({
                model: stateModel
              });
              this.resultView = new Sonar.EmptyResultView({
                model: stateModel
              });
              this.listenTo(this.domainInputView, 'query:submit', function(domainUrl) {
                return this._submitQuery(domainUrl);
              });
              this.show(this.domainInputView, {
                region: this.layout.domainInputRegion
              });
              return this.show(this.resultView, {
                region: this.layout.resultsRegion
              });
            } else {
              return $('.mainContent').addDisableOverlay('MetasploitPro');
            }
          });
          return this.listenTo(this.layout, 'destroy', function() {
            return $('.mainContent').removeDisableOverlay('MetasploitPro');
          });
        };

        Controller.prototype.getDomainUrl = function() {
          return this.domainInputView.getInputText();
        };

        Controller.prototype.getLastSeen = function() {
          return this.domainInputView.getLastSeen();
        };

        Controller.prototype._submitQuery = function(domainUrl) {
          this.importRun = App.request('sonar:importRun:entity');
          return this.importRun.save({
            workspace_id: WORKSPACE_ID,
            domain: domainUrl,
            last_seen: parseInt(this.getLastSeen())
          }).success(this._importRunCallback).error(this._importRunErrorCallback);
        };

        Controller.prototype._importRunCallback = function(import_run) {
          $('.error', this.el).remove();
          this.task = new App.Entities.Task({
            workspace_id: WORKSPACE_ID,
            id: import_run.task_id
          });
          App.execute("loadingOverlay:show", {
            loadMsg: "<p>This query may take up to a minute to complete. </p>" + "<p>Do not navigate away from this page. You will lose your results and need to run the query again.</p>"
          });
          return this.startPolling();
        };

        Controller.prototype._importRunErrorCallback = function(response) {
          return this._renderErrors(response.responseJSON.errors);
        };

        Controller.prototype._renderErrors = function(errors) {
          var _this = this;
          $('.error', this.el).remove();
          if (!_.isEmpty(errors)) {
            return _.each(errors, function(v, k) {
              var $msg, error, name, _i, _len, _results;
              _results = [];
              for (_i = 0, _len = v.length; _i < _len; _i++) {
                error = v[_i];
                name = "imports[sonar][" + k + "]";
                $msg = $('<div />', {
                  "class": 'error'
                }).text(error);
                _results.push($("[name='" + name + "']", _this.el).addClass('invalid').after($msg));
              }
              return _results;
            });
          }
        };

        Controller.prototype.poll = function() {
          if (this.task.isCompleted()) {
            this.stopPolling();
            App.execute("loadingOverlay:hide");
            return this._showFdnsTable();
          } else {
            return this.task.fetch();
          }
        };

        Controller.prototype._showFdnsTable = function() {
          var collection, columns, filterOpts;
          columns = [
            {
              label: 'Hostname',
              attribute: 'hostname'
            }, {
              label: 'Address',
              attribute: 'address'
            }, {
              label: 'Last seen',
              attribute: 'last_seen'
            }
          ];
          collection = App.request("fdnss:entities", {
            workspace_id: WORKSPACE_ID,
            import_run_id: this.importRun.get('id')
          });
          filterOpts = {
            placeHolderText: 'Search Hosts',
            filterValuesEndpoint: Routes.filter_values_workspace_sonar_import_fdnss_index_path(WORKSPACE_ID, this.importRun.get('id')),
            keys: ['hostname', 'address']
          };
          this.tableController = App.request("table:component", {
            region: this.layout.resultsRegion,
            htmlID: 'sonar-table',
            taggable: true,
            selectable: true,
            "static": false,
            filterOpts: filterOpts,
            collection: collection,
            perPage: 20,
            defaultSort: 'last_seen',
            columns: columns
          });
          this.tableController.carpenterRadio.on('table:rows:selected', this._rowsSelected);
          this.tableController.carpenterRadio.on('table:rows:deselected', this._rowsSelected);
          this.tableController.carpenterRadio.on('table:row:selected', this._rowsSelected);
          return this.tableController.carpenterRadio.on('table:row:deselected', this._rowsSelected);
        };

        Controller.prototype._rowsSelected = function() {
          if (!this.tableController.tableSelections.selectAllState) {
            if (Object.keys(this.tableController.tableSelections.selectedIDs).length > 0) {
              return this.importsIndexChannel.command('enable:importButton');
            } else {
              return this.importsIndexChannel.command('disable:importButton');
            }
          } else {
            return this.importsIndexChannel.command('enable:importButton');
          }
        };

        Controller.prototype.submitImport = function() {
          var data, tags;
          App.execute("loadingOverlay:show");
          tags = this.importsIndexChannel.request('get:tags');
          data = {
            import_run_id: this.importRun.get('id'),
            tags: tags,
            workspace_id: WORKSPACE_ID
          };
          return this.tableController.postTableState({
            url: Routes.workspace_sonar_imports_path({
              workspace_id: WORKSPACE_ID
            }) + '.json',
            data: data,
            success: function(data) {
              return window.location.href = Routes.task_detail_path(WORKSPACE_ID, data.task_id);
            },
            error: function(data) {
              return App.execute('sonar:imports:display:error', {
                message: "Doge"
              });
            }
          });
        };

        return Controller;

      })(App.Controllers.Application);
      App.reqres.setHandler('sonar:imports', function(options) {
        if (options == null) {
          options = {};
        }
        return new Sonar.Controller(options);
      });
      return Sonar.StateModel = (function(_super) {

        __extends(StateModel, _super);

        function StateModel() {
          return StateModel.__super__.constructor.apply(this, arguments);
        }

        StateModel.prototype.defaults = {
          domainUrl: '',
          disableQuery: true
        };

        return StateModel;

      })(Backbone.Model);
    });
  });

}).call(this);
