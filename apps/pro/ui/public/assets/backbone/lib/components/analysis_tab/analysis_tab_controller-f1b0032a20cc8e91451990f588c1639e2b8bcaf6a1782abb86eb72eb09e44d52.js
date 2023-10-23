(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/vulns/index/index_views', 'apps/web_vulns/index/index_views', 'lib/components/table/table_controller', 'lib/shared/cve_cell/cve_cell_controller', 'lib/shared/nexpose_push/nexpose_push_views', 'lib/components/analysis_tab/analysis_tab_view', 'lib/shared/nexpose_push/nexpose_push_controllers', 'lib/components/pro_search_filter/filter_controller'], function() {
    return this.Pro.module("Components.AnalysisTab", function(AnalysisTab, App, Backbone, Marionette, $, _) {
      AnalysisTab.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var _this = this;
          this.layout = this.getLayoutView();
          this.setMainView(this.layout);
          this.listenTo(this._mainView, 'show', function() {
            _this.table = _this._renderTable(options);
            if (options.enableNexposePushButton) {
              _this.table.collection.on('select_all_toggled', function() {
                return _this._triggerRowsSelected(_this.pushButtonRegion());
              });
              _this.table.carpenterRadio.on('table:row:selected', function() {
                return _this._triggerRowsSelected(_this.pushButtonRegion());
              });
              _this.table.carpenterRadio.on('table:row:deselected', function() {
                return _this._triggerRowsSelected(_this.pushButtonRegion());
              });
            }
            return _this.table.collection.on('reset', function() {
              return _this.table.collection.trigger('select_all_toggled');
            });
          });
          return this.layout;
        };

        Controller.prototype.onDestroy = function() {
          this.table.carpenterRadio.off('table:rows:selected');
          this.table.carpenterRadio.off('table:rows:deselected');
          this.table.carpenterRadio.off('table:row:selected');
          this.table.carpenterRadio.off('table:row:deselected');
          return this.table.collection.off('reset');
        };

        Controller.prototype.pushButtonRegion = function() {
          var pushButtonView;
          pushButtonView = this.getPushButtonView();
          this.layout.pushButtonRegion.show(pushButtonView);
          return pushButtonView;
        };

        Controller.prototype.getLayoutView = function() {
          return new AnalysisTab.Layout;
        };

        Controller.prototype.getPushButtonView = function() {
          return this.layout._currentPushButtonView = new Pro.Shared.NexposePush.ButtonView;
        };

        Controller.prototype._renderTable = function(options) {
          var tableController;
          return tableController = App.request("table:component", {
            region: this.layout.analysisTabsRegion,
            buttonsRegion: this.layout.buttonsRegion,
            selectable: true,
            taggable: true,
            "static": false,
            perPage: 20,
            columns: options.columns,
            defaultSort: options.defaultSort || null,
            actionButtons: options.actionButtons,
            collection: options.collection,
            filterOpts: options.filterOpts,
            emptyView: options.emptyView || AnalysisTab.TableEmptyView
          });
        };

        Controller.prototype._triggerRowsSelected = function(pushButtonView) {
          return pushButtonView.triggerMethod('rowsSelected', this.table.tableSelections);
        };

        Controller.prototype.postSelections = function(path, tableState) {
          var CSRF_TOKEN, field, finalParams, form, key, value;
          CSRF_TOKEN = $('meta[name=csrf-token]').attr('content');
          form = $('<form></form>');
          form.attr("method", "post");
          form.attr("action", path);
          finalParams = {
            "class": 'vuln',
            'selections[deselected_ids]': tableState.deselectedIDs,
            'selections[selected_ids]': tableState.selectedIDs,
            'selections[select_all_state]': tableState.selectAllState,
            authenticity_token: CSRF_TOKEN
          };
          for (key in finalParams) {
            value = finalParams[key];
            field = $('<input></input>');
            field.attr("type", "hidden");
            field.attr("name", key);
            field.attr("value", value);
            form.append(field);
          }
          $(document.body).append(form);
          return form.submit();
        };

        return Controller;

      })(App.Controllers.Application);
      App.reqres.setHandler('analysis_tab:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new AnalysisTab.Controller(options);
      });
      return App.commands.setHandler('analysis_tab:post', function(klass, path, tableState) {
        var CSRF_TOKEN, field, finalParams, form, key, value;
        CSRF_TOKEN = $('meta[name=csrf-token]').attr('content');
        form = $('<form></form>');
        form.attr("method", "post");
        form.attr("action", path);
        finalParams = {
          "class": klass,
          'selections[deselected_ids]': tableState.deselectedIDs,
          'selections[selected_ids]': tableState.selectedIDs,
          'selections[select_all_state]': tableState.selectAllState,
          authenticity_token: CSRF_TOKEN,
          ignore_pagination: true
        };
        for (key in finalParams) {
          value = finalParams[key];
          field = $('<input></input>');
          field.attr("type", "hidden");
          field.attr("name", key);
          field.attr("value", value);
          form.append(field);
        }
        $(document.body).append(form);
        return form.submit();
      });
    });
  });

}).call(this);
