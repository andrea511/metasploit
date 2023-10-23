(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['/assets/templates/apps/views/no_app_runs_view-dd4c9ba3eecff572367038cc01a94fe9f37d12330883e3cb0c4bcff78115a659.js', '/assets/templates/apps/views/app_run_view-32430089f0f133b872428cc815e1bc56a28f015efbf964143f20842ab9fb7747.js', '/assets/apps/backbone/views/layouts/app_stat_modal_layout-5c1838717f3af27537ebed7967861c6c969a7fe54228fbc2f54f6428fc8601ca.js', 'jquery', '/assets/apps/backbone/models/app_run-b01dfd5be9374d25d3eec5cf47fd005e5e1a790866141c147aee85c43af9b864.js'], function(NoRunsTemplate, AppRunViewTemplate, AppStatModalLayout, $, AppRun) {
    var ABORT_CONFIRM_MSG, AppRunView, AppRunsCollectionView, NoItemsView;
    ABORT_CONFIRM_MSG = 'Are you sure you want to abort this MetaModule? You will ' + 'not be able to start it again.';
    NoItemsView = (function(_super) {

      __extends(NoItemsView, _super);

      function NoItemsView() {
        return NoItemsView.__super__.constructor.apply(this, arguments);
      }

      NoItemsView.prototype.template = HandlebarsTemplates['apps/views/no_app_runs_view'];

      return NoItemsView;

    })(Backbone.Marionette.ItemView);
    AppRunView = (function(_super) {

      __extends(AppRunView, _super);

      function AppRunView() {
        this.deleteClicked = __bind(this.deleteClicked, this);

        this.stopClicked = __bind(this.stopClicked, this);

        this.serializeData = __bind(this.serializeData, this);

        this.tasksChanged = __bind(this.tasksChanged, this);
        return AppRunView.__super__.constructor.apply(this, arguments);
      }

      AppRunView.prototype.template = HandlebarsTemplates['apps/views/app_run_view'];

      AppRunView.prototype.modelEvents = {
        "change:run_stats": 'tasksChanged',
        "change:status": 'render'
      };

      AppRunView.prototype.events = {
        'click a.delete': 'deleteClicked',
        'click a.stop': 'stopClicked'
      };

      AppRunView.prototype.tasksChanged = function() {
        return this.render();
      };

      AppRunView.prototype.serializeData = function() {
        return _.extend(AppRunView.__super__.serializeData.apply(this, arguments), {
          statData: this.model.runStatHash()
        });
      };

      AppRunView.prototype.stopClicked = function(e) {
        var _this = this;
        if (e) {
          e.preventDefault();
        }
        if ($(e.currentTarget).hasClass('ui-disabled')) {
          return;
        }
        if (!confirm(ABORT_CONFIRM_MSG)) {
          return;
        }
        this.model.abort().complete(function() {
          return _this.model.fetch({
            success: function() {
              return setTimeout((function() {
                return _this.model.fetch();
              }), 4000);
            }
          });
        });
        return $(e.currentTarget).addClass('ui-disabled').fadeTo(.1, .5);
      };

      AppRunView.prototype.deleteClicked = function(e) {
        e.preventDefault();
        if (!confirm('Are you sure you want to delete the results' + ' from this App Run?')) {
          return;
        }
        $(this.el).click(function(e) {
          return e.stopImmediatePropagation();
        });
        $(this.el).fadeTo(0, .6);
        return this.model.destroy();
      };

      return AppRunView;

    })(Backbone.Marionette.ItemView);
    return AppRunsCollectionView = (function(_super) {

      __extends(AppRunsCollectionView, _super);

      function AppRunsCollectionView() {
        this.onRender = __bind(this.onRender, this);

        this._showStatsForAppRun = __bind(this._showStatsForAppRun, this);

        this._findAppRunFromEvent = __bind(this._findAppRunFromEvent, this);

        this.findingsClicked = __bind(this.findingsClicked, this);

        this.appendHtml = __bind(this.appendHtml, this);

        this.initialize = __bind(this.initialize, this);
        return AppRunsCollectionView.__super__.constructor.apply(this, arguments);
      }

      AppRunsCollectionView.prototype.childView = AppRunView;

      AppRunsCollectionView.prototype.emptyView = NoItemsView;

      AppRunsCollectionView.prototype.events = {
        'click a.findings': 'findingsClicked'
      };

      AppRunsCollectionView.prototype.initialize = function() {
        var $selMeta,
          _this = this;
        this.$el.addClass('tab-loading');
        this.collection.on('sync', function() {
          return _this.$el.removeClass('tab-loading');
        });
        $selMeta = $('meta[name=selected_app_run]');
        this.selId = $selMeta.attr('content');
        return $selMeta.remove();
      };

      AppRunsCollectionView.prototype.appendHtml = function(collectionView, itemView) {
        var itemIndex;
        itemIndex = collectionView.collection.indexOf(itemView.model);
        return collectionView.$el.insertAt(itemIndex, itemView.$el);
      };

      AppRunsCollectionView.prototype.findingsClicked = function(e) {
        var appRun;
        if (e) {
          e.preventDefault();
        }
        appRun = this._findAppRunFromEvent(e);
        return this._showStatsForAppRun(appRun);
      };

      AppRunsCollectionView.prototype._findAppRunFromEvent = function(e) {
        var idx;
        idx = $(e.currentTarget).parents('.row').first().parent().index();
        return this.collection.models[idx];
      };

      AppRunsCollectionView.prototype._showStatsForAppRun = function(appRun) {
        var region, _ref, _ref1, _ref2,
          _this = this;
        if ((_ref = appRun.get('tasks')) != null ? (_ref1 = _ref[0]) != null ? (_ref2 = _ref1.presenter) != null ? _ref2.length : void 0 : void 0 : void 0) {
          return initProRequire(['apps/tasks/show/show_controller', 'entities/task'], function() {
            var controller, region, task;
            controller = null;
            _this.rollupModal = new RollupModalView({
              buttons: [
                {
                  name: 'Close',
                  "class": 'primary close'
                }
              ],
              onClose: function() {
                return controller.destroy();
              }
            });
            _this.rollupModal.open();
            region = new Backbone.Marionette.Region({
              el: $('.content', _this.rollupModal.el)
            });
            task = new Pro.Entities.Task({
              id: appRun.get('tasks')[0].id,
              workspace_id: WORKSPACE_ID
            });
            return controller = new Pro.TasksApp.Show.Controller({
              task: task,
              region: region
            });
          });
        } else {
          this.rollupLayout = new AppStatModalLayout({
            appRun: appRun
          });
          this.rollupModal = new RollupModalView({
            buttons: [
              {
                name: 'Close',
                "class": 'primary close'
              }
            ],
            onClose: function() {
              return _this.rollupLayout.onClose();
            }
          });
          this.rollupModal.open();
          region = new Backbone.Marionette.Region({
            el: $('.content', this.rollupModal.el)
          });
          return region.show(this.rollupLayout);
        }
      };

      AppRunsCollectionView.prototype.onRender = function() {
        var appRun,
          _this = this;
        if (this.selId && this.selId.length > 0) {
          appRun = new AppRun({
            id: parseInt(this.selId)
          });
          this.selId = null;
          return appRun.fetch({
            success: function() {
              return _this._showStatsForAppRun(appRun);
            }
          });
        }
      };

      return AppRunsCollectionView;

    })(Backbone.Marionette.CollectionView);
  });

}).call(this);
