(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/shared/human_targets/human_targets_views', 'entities/social_engineering/human_target', 'lib/components/table/table_controller', 'lib/components/flash/flash_controller'], function() {
    return this.Pro.module("Shared.HumanTargets", function(HumanTargets, App, Backbone, Marionette, $) {
      return HumanTargets.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var humanTargets, show, targetListId,
            _this = this;
          _.defaults(options, {
            show: true
          });
          show = options.show, targetListId = options.targetListId;
          this.layout = new HumanTargets.Layout;
          this.setMainView(this.layout);
          humanTargets = App.request('socialEngineering:humanTarget:entities', {
            targetListId: targetListId
          });
          this.listenTo(this._mainView, 'show', function() {
            return _this.table = _this.renderTargetsTable(humanTargets, _this.layout.targetsRegion, {
              htmlID: 'target-list'
            });
          });
          this.loadingModal = $('<div class="loading"></div>').dialog({
            modal: true,
            title: 'Submitting...',
            autoOpen: false,
            closeOnEscape: false
          });
          if (show) {
            return this.show(this.layout, {
              region: this.region,
              loading: {
                loadingType: 'overlay'
              }
            });
          }
        };

        Controller.prototype.renderTargetsTable = function(humanTargets, region) {
          var columns, tableController,
            _this = this;
          columns = [
            {
              label: 'Email Address',
              attribute: 'email_address',
              sortable: true,
              defaultDirection: 'asc'
            }, {
              label: 'First Name',
              attribute: 'first_name',
              sortable: true
            }, {
              label: 'Last Name',
              attribute: 'last_name',
              sortable: true
            }
          ];
          return tableController = App.request("table:component", {
            htmlID: 'human-targets',
            region: region,
            taggable: true,
            selectable: true,
            "static": false,
            collection: humanTargets,
            perPage: 20,
            columns: columns,
            actionButtons: [
              {
                label: 'Remove',
                activateOn: 'any',
                click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                  _this.loadingModal.dialog('open');
                  return tableController.postTableState({
                    method: 'DELETE'
                  }).complete(function(r) {
                    _this.loadingModal.dialog('close');
                    if (r.responseJSON.success) {
                      tableCollection.removeMultiple(selectedVisibleCollection);
                      return App.execute('flash:display', {
                        title: 'Targets removed',
                        message: 'The targets have been successfully removed.'
                      });
                    } else {
                      return App.execute('flash:display', {
                        title: 'An error occurred',
                        style: 'error',
                        message: 'There was an error while removing targets from this list.'
                      });
                    }
                  });
                }
              }
            ]
          });
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
