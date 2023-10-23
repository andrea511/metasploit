(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'task_console', 'base_controller', 'lib/components/modal/modal_controller', 'lib/components/table/table_controller', 'apps/tasks/show/show_view', 'entities/task', 'lib/concerns/pollable', 'jquery.ajax-retry'], function($, TaskConsole) {
    return this.Pro.module('TasksApp.Show', function(Show, App) {
      return Show.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.poll = __bind(this.poll, this);

          this.setTabIndex = __bind(this.setTabIndex, this);

          this.selectStat = __bind(this.selectStat, this);

          this._loadClientSideCode = __bind(this._loadClientSideCode, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.include("Pollable");

        Controller.prototype.task = null;

        Controller.prototype.layout = null;

        Controller.prototype.headerView = null;

        Controller.prototype.consoleView = null;

        Controller.prototype.statsView = null;

        Controller.prototype.table = null;

        Controller.prototype.pollInterval = 3000;

        Controller.prototype.initialize = function(opts) {
          var debouncedRefresh,
            _this = this;
          if (opts == null) {
            opts = {};
          }
          _.defaults(opts, {
            fetch: true
          });
          this.task = opts.task;
          this.layout = new Show.Layout();
          this.headerView = new Show.Header({
            model: this.task
          });
          this.consoleView = new TaskConsole({
            task: this.task.id
          });
          this.drilldownView = new Show.Drilldown({
            task: this.task.id
          });
          this.listenTo(this.layout, 'show', function() {
            var grabFirst;
            _this.statsView = new Show.Stats({
              collection: _this.task.get('statDisplays')
            });
            _this.region.$el.removeClass('tab-loading');
            _this.layout.headerRegion.show(_this.headerView);
            _this.layout.consoleRegion.show(_this.consoleView);
            _this.layout.statsRegion.show(_this.statsView);
            _this.layout.drilldownRegion.show(_this.drilldownView);
            grabFirst = function() {
              var firstStat;
              firstStat = _this.task.get('statDisplays').findFirstClickable();
              if (firstStat != null) {
                return _this.selectStat(firstStat);
              }
            };
            _this.task.get('statDisplays').on('add', grabFirst);
            grabFirst();
            if (_this.task.isPaused()) {
              _this.consoleView.refreshLog();
            } else {
              _this.consoleView.startUpdating();
            }
            _this.startPolling();
            _this.listenTo(_this.statsView, 'childview:stat:clicked', function(statView) {
              if (statView.model.get('clickable') && !statView.model.get('selected')) {
                return _this.selectStat(statView.model);
              }
            });
            return _this.listenTo(_this.statsView, 'childview:stat:updated', function(statView) {
              if (statView.model.get('selected')) {
                return debouncedRefresh();
              }
            });
          });
          debouncedRefresh = _.debounce((function() {
            var _ref;
            return (_ref = _this.table) != null ? _ref.refresh() : void 0;
          }), 200);
          this.listenTo(this.layout, 'tasksApp:show:tabClicked', function(idx) {
            var _ref;
            if ((_ref = _this.controller) != null) {
              if (typeof _ref.tabClicked === "function") {
                _ref.tabClicked(idx);
              }
            }
            return _this.setTabIndex(idx);
          });
          this.listenTo(this.headerView, 'tasksApp:resume', function() {
            return _this.consoleView.resumeUpdating();
          });
          if (opts.fetch) {
            return this.task.fetch().retry({
              times: 9999,
              timeout: 4000
            }).done(this._loadClientSideCode);
          } else {
            return this._loadClientSideCode();
          }
        };

        Controller.prototype._loadClientSideCode = function() {
          var classLoaded, presenterCamel, presenterClass,
            _this = this;
          if (this.task.get('run_stats').length === 0) {
            this.region.show(new Backbone.Marionette.ItemView({
              template: function() {
                return '';
              }
            }));
            this.region.$el.addClass('tab-loading');
            return _.delay((function() {
              return _this.task.fetch().done(_this._loadClientSideCode);
            }), 1000);
          }
          presenterCamel = _.chain(this.task.get('presenter')).camelize().capitalize().value();
          presenterClass = function() {
            var _ref, _ref1;
            return (_ref = App.TasksApp) != null ? (_ref1 = _ref.Findings) != null ? _ref1[presenterCamel] : void 0 : void 0;
          };
          classLoaded = function() {
            _this.task.set('schema', presenterClass());
            return _this.show(_this.layout, {
              preventDestroy: true
            });
          };
          if (presenterClass() == null) {
            return initProRequire(["apps/tasks/findings/" + (this.task.get('presenter'))], classLoaded);
          } else {
            return classLoaded();
          }
        };

        Controller.prototype.selectStat = function(stat) {
          var collection, collectionURL, view,
            _this = this;
          _.each(this.statsView.collection.models, function(m) {
            if (m !== stat) {
              return m.set('selected', false);
            }
          });
          stat.set('selected', true);
          _.defer(function() {
            var _ref, _ref1, _ref2;
            return (_ref = _this.layout) != null ? (_ref1 = _ref.drilldownRegion) != null ? (_ref2 = _ref1.$el) != null ? typeof _ref2.removeClass === "function" ? _ref2.removeClass('tab-loading') : void 0 : void 0 : void 0 : void 0;
          });
          this.controller = this.table = null;
          if (stat.get('controller') != null) {
            return this.controller = new (stat.get('controller'))({
              task: this.task,
              region: this.drilldownView.tableRegion
            });
          } else if (stat.get('view') != null) {
            view = new stat.get('view')({
              task: this.task
            });
            return this.drilldownView.tableRegion.show(view);
          } else if (stat.get('table') != null) {
            collectionURL = stat.collectionURL(this.task);
            collection = new Backbone.Collection.extend({}, {
              url: collectionURL,
              model: Backbone.Model
            });
            return this.table = App.request("table:component", _.extend({
              actionButtons: [
                {
                  label: 'Export',
                  click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                    var $btn, $iframe, getParams, url;
                    url = _this.table.collection.url + '.csv';
                    getParams = _.map(_this.table.collection.server_api, function(v, k) {
                      v = _.isFunction(v) ? v.call(_this.table.collection) : v;
                      v = _.isObject(v) ? JSON.stringify(v) : v;
                      if (k === 'json') {
                        v = 'csv';
                      }
                      return "" + (encodeURIComponent(k)) + "=" + (encodeURIComponent(v));
                    }).join('&');
                    _.each(_this.table.columns, function(column) {
                      return getParams += "&columns[]=" + (encodeURIComponent(column.attribute));
                    });
                    url = "" + url + "?" + getParams;
                    $iframe = $('<iframe />', {
                      src: url,
                      style: 'display:none'
                    }).appendTo($('body'));
                    _.delay((function() {
                      return $iframe.remove();
                    }), 30000);
                    $btn = _this.layout.$el.find('.action-button');
                    $btn.addClass('disabled');
                    return _.delay((function() {
                      return $btn.removeClass('disabled');
                    }), 3000);
                  }
                }
              ],
              htmlID: "findings_table_" + (_.str.underscored(stat.get('title'))),
              title: stat.get('title'),
              region: this.drilldownView.tableRegion,
              taggable: false,
              selectable: false,
              "static": false,
              collection: collection,
              perPage: 10
            }, stat.get('table')));
          }
        };

        Controller.prototype.setTabIndex = function(idx) {
          return this.layout.setTabIndex(idx);
        };

        Controller.prototype.poll = function() {
          if (this.task.isCompleted()) {
            _.defer(this.stopPolling, this.pollInterval);
          }
          return this.task.fetch();
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
