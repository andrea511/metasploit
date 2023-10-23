(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/shared/targets/targets_views', 'lib/shared/target_list/target_list_controller', 'entities/target', 'lib/components/table/cell_views', 'lib/components/filter/filter_controller'], function() {
    return this.Pro.module("Shared.Targets", function(Targets, App) {
      Targets.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.refreshNextButton = __bind(this.refreshNextButton, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var config, targets, targetsView,
            _this = this;
          if (options == null) {
            options = {};
          }
          this.workspace_id = options.workspace_id || WORKSPACE_ID;
          config = _.defaults(options, this._getDefaults());
          targets = App.request('targets:entities', [], {
            workspace_id: this.workspace_id
          });
          this.targetListCollection || (this.targetListCollection = options.collection);
          targetsView = new Targets.Layout();
          this.setMainView(targetsView);
          this.listenTo(this.getMainView(), 'show', function() {
            _this.targetList = new App.Shared.TargetList.Controller({
              targetListCollection: _this.targetListCollection
            });
            _this.show(_this.targetList, {
              region: _this._mainView.targetListRegion
            });
            _this.table = _this.renderTargetsTable(targets, _this._mainView.targetsRegion, {
              filterOpts: {
                filterValuesEndpoint: window.gon.filter_values_workspace_brute_force_reuse_targets_path,
                keys: [
                  'host.name', 'host.address', 'host.os_name', {
                    value: 'name',
                    label: 'service.name'
                  }, {
                    value: 'info',
                    label: 'service.info'
                  }, {
                    value: 'port',
                    label: 'service.port'
                  }, {
                    value: 'proto',
                    label: 'service.proto'
                  }
                ],
                staticFacets: {
                  'proto': Pro.Entities.Service.PROTOS.map(function(name) {
                    return {
                      value: name,
                      label: name
                    };
                  })
                }
              }
            });
            _this.listenTo(_this.table.collection, 'all', _.debounce((function() {
              _this._mainView.adjustSize();
              return _this.targetList.lazyList.resize();
            }), 50));
            return _this.listenTo(_this.targetList.lazyList.collection, 'all', _.debounce(_this.refreshNextButton, 50));
          });
          this.listenTo(this.getMainView(), 'resized', function() {
            return _this.targetList.lazyList.resize();
          });
          this.listenTo(this.getMainView(), 'targets:addToCart', function() {
            if (_this.table.tableSelections.selectAllState) {
              return _this.table.collection.fetchIDs(_this.table.tableSelections).done(function(ids) {
                ids = _.difference(ids, _.keys(_this.table.tableSelections.deselectedIds));
                return _this.targetList.lazyList.addIDs(ids);
              });
            } else {
              return _this.targetList.lazyList.addIDs(_.keys(_this.table.tableSelections.selectedIDs));
            }
          });
          this.listenTo(this.getMainView(), 'filter:query:new', function(query) {
            return this.table.applyCustomFilter(query);
          });
          return _.defer(function() {
            return _this.refreshNextButton();
          });
        };

        Controller.prototype.refreshNextButton = function() {
          return this._mainView.toggleNext(!_.isEmpty(this.targetList.lazyList.collection.ids));
        };

        Controller.prototype.renderTargetsTable = function(collection, region, opts) {
          var columns, extraColumns, tableController;
          if (opts == null) {
            opts = {};
          }
          extraColumns = opts.extraColumns || [];
          columns = _.union([
            {
              label: 'Host',
              attribute: 'host.name',
              sortable: true,
              view: Targets.HostnameCellView
            }, {
              label: 'IP',
              attribute: 'host.address',
              sortable: true
            }, {
              label: 'OS',
              attribute: 'host.os_name',
              view: Backbone.Marionette.ItemView.extend({
                template: function(model) {
                  return _.escape((model['host.os_name'] || '').replace('Microsoft ', ''));
                }
              }),
              sortable: true
            }, {
              label: 'Service',
              attribute: 'name',
              sortable: true
            }, {
              label: 'Port',
              attribute: 'port',
              sortable: true
            }, {
              label: 'Proto',
              attribute: 'proto',
              sortable: true
            }, {
              label: 'Info',
              attribute: 'info',
              sortable: true,
              view: Pro.Components.Table.CellViews.TruncateView({
                max: 14,
                attribute: 'info'
              })
            }
          ], extraColumns);
          if (opts.withoutColumns != null) {
            columns = _.reject(columns, function(col) {
              return _.contains(opts.withoutColumns, col.attribute);
            });
          }
          return tableController = App.request("table:component", _.extend({
            htmlID: 'targets',
            region: region,
            taggable: true,
            selectable: true,
            "static": false,
            collection: collection,
            perPage: 20,
            columns: columns
          }, opts));
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler("targets:shared", function(options) {
        if (options == null) {
          options = {};
        }
        return new Targets.Controller(options);
      });
    });
  });

}).call(this);
