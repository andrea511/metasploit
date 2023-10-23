(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/task_chains/index/index_view', 'lib/components/modal/modal_controller'], function() {
    return this.Pro.module('TaskChainsApp.Index', function(Index, App, Backbone, Marionette, jQuery, _) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var taskChains,
            _this = this;
          taskChains = options.taskChains, this.legacyChains = options.legacyChains;
          taskChains || (taskChains = App.request('task_chains:entities'));
          this.layout = this.getLayoutView();
          this.listenTo(this.layout, "show", function() {
            _this.listRegion(taskChains);
            return _this._showLegacyWarning();
          });
          return this.show(this.layout);
        };

        Controller.prototype._showLegacyWarning = function() {
          var view;
          if (this.legacyChains.length > 0) {
            view = new Index.LegacyWarningView({
              model: new Backbone.Model({
                legacyChains: this.legacyChains
              })
            });
            return App.execute('showModal', view, {
              modal: {
                title: 'Task Chain Warning',
                description: '',
                width: 600,
                height: 218 + 22 * this.legacyChains.length
              },
              buttons: [
                {
                  name: 'OK',
                  "class": 'btn primary'
                }
              ]
            });
          }
        };

        Controller.prototype.listRegion = function(taskChains) {
          var listView;
          listView = this.getListView(taskChains);
          return this.layout.listRegion.show(listView);
        };

        Controller.prototype.getLayoutView = function() {
          return new Index.Layout;
        };

        Controller.prototype.getListView = function(taskChains) {
          return new Index.List({
            collection: taskChains
          });
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
