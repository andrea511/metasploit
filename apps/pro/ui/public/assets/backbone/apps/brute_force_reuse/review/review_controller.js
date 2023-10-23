(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/brute_force_reuse/review/review_views', 'lib/shared/targets/targets_views'], function() {
    return this.Pro.module("BruteForceReuseApp.Review", function(Review, App) {
      return Review.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {};

        Controller.prototype.initialize = function(options) {
          var config;
          if (options == null) {
            options = {};
          }
          this.workspace_id = options.workspace_id || WORKSPACE_ID;
          config = _.defaults(options, this._getDefaults());
          this.targetListCollection = options.targetListCollection, this.workingGroup = options.workingGroup, this.reuseOptions = options.reuseOptions;
          this.setMainView(new Review.Layout({
            model: this.reuseOptions
          }));
          this.listenTo(this._mainView, 'form:changed', function() {
            var changed, data;
            data = Backbone.Syphon.serialize(this._mainView);
            changed = false;
            _.each(['service_seconds', 'overall_hours', 'overall_seconds', 'overall_minutes'], function(o) {
              var newData;
              newData = (data[o] + '').replace(/[^0-9]/g, '');
              if (newData !== data[o]) {
                changed = true;
                return data[o] = newData;
              }
            });
            this.reuseOptions.set(data);
            if (changed) {
              return Backbone.Syphon.deserialize(this._mainView, data);
            }
          });
          this.listenTo(this._mainView, 'show', function() {
            Backbone.Syphon.deserialize(this._mainView, this.reuseOptions.toJSON());
            this.targetList = new App.Shared.TargetList.Controller({
              targetListCollection: this.targetListCollection
            });
            this.groups = new App.BruteForceReuseApp.CredSelection.GroupsContainer(_.pick(options, 'workingGroup'));
            this.listenTo(this.groups, 'show', function() {
              return this.groups.selectionUpdated();
            });
            this.show(this.targetList, {
              region: this._mainView.targetRegion
            });
            return this.show(this.groups, {
              region: this._mainView.credRegion
            });
          });
          this.listenTo(this.targetListCollection, 'remove', function() {
            if (this.targetListCollection.length === 0) {
              return this._mainView.disableLaunch();
            }
          });
          this.listenTo(this.workingGroup.get('creds'), 'remove', function() {
            if (this.workingGroup.get('creds').length === 0) {
              return this._mainView.disableLaunch();
            }
          });
          this.listenTo(this.getMainView(), 'targets:back', function() {
            return App.vent.trigger('crumb:targets');
          });
          return this.listenTo(this.getMainView(), 'credentials:back', function() {
            return App.vent.trigger('crumb:credentials');
          });
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
