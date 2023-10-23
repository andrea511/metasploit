(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/apps/backbone/models/app-7bc75214fb94c799b83f2cc24f4c76f8372dfba0268346bdc794b7b5e959a8a9.js', '/assets/apps/backbone/models/run_stat-484060e5f0117f5755324502b08e9e472d09306bde9ad8d89f93704b50c8da70.js', 'jquery'], function(App, RunStat, $) {
    var AppRun;
    return AppRun = (function(_super) {

      __extends(AppRun, _super);

      function AppRun() {
        this.abort = __bind(this.abort, this);

        this.url = __bind(this.url, this);

        this.runStatHash = __bind(this.runStatHash, this);
        return AppRun.__super__.constructor.apply(this, arguments);
      }

      AppRun.prototype.defaults = {
        app: {},
        started_at: null,
        stopped_at: null,
        status: 'preparing',
        tasks: []
      };

      AppRun.prototype.runStatHash = function() {
        var runStats, statData;
        statData = {};
        runStats = this.get('run_stats');
        _.each(runStats, function(stat) {
          return statData[_.str.underscored(stat.name)] = stat.data;
        });
        return statData;
      };

      AppRun.prototype.url = function(extension) {
        if (extension == null) {
          extension = '.json';
        }
        return "/workspaces/" + WORKSPACE_ID + "/apps/app_runs/" + this.id + extension;
      };

      AppRun.prototype.abort = function() {
        return $.ajax({
          url: this.url('') + '/abort',
          method: 'POST',
          data: {
            '_method': 'PUT'
          }
        });
      };

      return AppRun;

    })(Backbone.Model);
  });

}).call(this);
