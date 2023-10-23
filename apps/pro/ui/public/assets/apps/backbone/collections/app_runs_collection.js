(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/apps/backbone/models/app_run-b01dfd5be9374d25d3eec5cf47fd005e5e1a790866141c147aee85c43af9b864.js', 'jquery'], function(AppRun, $) {
    var AppRunsCollection;
    return AppRunsCollection = (function(_super) {

      __extends(AppRunsCollection, _super);

      function AppRunsCollection() {
        return AppRunsCollection.__super__.constructor.apply(this, arguments);
      }

      AppRunsCollection.prototype.url = function() {
        return "/workspaces/" + WORKSPACE_ID + "/apps/app_runs.json";
      };

      AppRunsCollection.prototype.model = AppRun;

      AppRunsCollection.prototype.comparator = function(model) {
        return -model.get('id');
      };

      return AppRunsCollection;

    })(Backbone.Collection);
  });

}).call(this);
