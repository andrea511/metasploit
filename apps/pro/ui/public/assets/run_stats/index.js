(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    return this.RunStats = (function(_super) {

      __extends(RunStats, _super);

      function RunStats(workspaceId, taskId) {
        this.workspaceId = workspaceId;
        this.taskId = taskId;
      }

      RunStats.prototype.url = function() {
        return "/workspaces/" + this.workspaceId + "/run_stats/" + this.taskId;
      };

      return RunStats;

    })(Backbone.Model);
  });

}).call(this);
