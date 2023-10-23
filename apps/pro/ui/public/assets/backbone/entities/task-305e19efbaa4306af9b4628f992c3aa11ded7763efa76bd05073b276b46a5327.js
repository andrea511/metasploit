(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_model', 'base_collection', 'entities/run_stat'], function($) {
    return this.Pro.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      return Entities.Task = (function(_super) {

        __extends(Task, _super);

        function Task() {
          this.fetch = __bind(this.fetch, this);

          this.fetch = __bind(this.fetch, this);

          this.stop = __bind(this.stop, this);

          this.resume = __bind(this.resume, this);

          this.pause = __bind(this.pause, this);

          this.isPaused = __bind(this.isPaused, this);

          this.isStopped = __bind(this.isStopped, this);

          this.isInterrupted = __bind(this.isInterrupted, this);

          this.isFailed = __bind(this.isFailed, this);

          this.isCompleted = __bind(this.isCompleted, this);

          this.url = __bind(this.url, this);

          this.initialize = __bind(this.initialize, this);
          return Task.__super__.constructor.apply(this, arguments);
        }

        Task.prototype.defaults = function() {
          return {
            workspace_id: null,
            schema: [],
            run_stats: new Entities.RunStatsCollection([], {
              task: this
            }),
            statDisplays: null
          };
        };

        Task.prototype.initialize = function(opts) {
          var _this = this;
          this.opts = opts != null ? opts : {};
          _.defaults(this.opts, {
            statDisplays: true
          });
          if (this.opts.statDisplays) {
            this.set('statDisplays', new Entities.StatDisplaysCollection([], {
              schema: this.get('schema'),
              run_stats: this.get('run_stats')
            }));
            return this.on('change:schema', function() {
              return _this.get('statDisplays').updateSchema(_this.get('schema'));
            });
          }
        };

        Task.prototype.url = function(ext) {
          if (ext == null) {
            ext = '.json';
          }
          return "/workspaces/" + (this.get('workspace_id')) + "/tasks/" + this.id + ext;
        };

        Task.prototype.isCompleted = function() {
          return this.get('state') === 'completed';
        };

        Task.prototype.isFailed = function() {
          return this.get('state') === 'failed';
        };

        Task.prototype.isInterrupted = function() {
          return this.get('state') === 'interrupted';
        };

        Task.prototype.isStopped = function() {
          return this.get('state') === 'stopped';
        };

        Task.prototype.isPaused = function() {
          return this.get('state') === 'paused';
        };

        Task.prototype.pause = function() {
          return $.post(Routes.pause_task_path(this.get('id')));
        };

        Task.prototype.resume = function() {
          return $.post(Routes.resume_task_path(this.get('id')));
        };

        Task.prototype.stop = function() {
          if (this.isPaused()) {
            return $.post(Routes.stop_paused_task_path(this.get('id')));
          } else {
            return $.post(Routes.stop_task_path({
              id: this.get('id')
            }));
          }
        };

        Task.prototype.fetch = function(opts) {
          if (opts == null) {
            opts = {};
          }
          if (this.get('now') != null) {
            opts.data || (opts.data = $.param({
              since: this.get('now')
            }));
          }
          return Task.__super__.fetch.call(this, opts);
        };

        Task.prototype.fetch = function(opts) {
          if (opts == null) {
            opts = {};
          }
          if (this.get('now') != null) {
            opts.data || (opts.data = $.param({
              since: this.get('now')
            }));
          }
          return Task.__super__.fetch.call(this, opts);
        };

        Task.prototype.set = function(key, val, options) {
          var stats,
            _this = this;
          if (key instanceof Object && (key.run_stats != null)) {
            this.set('run_stats', key.run_stats, options);
            delete key.run_stats;
          } else if (key === 'run_stats' && !(val instanceof Entities.RunStatsCollection)) {
            stats = this.get('run_stats') || new Entities.RunStatsCollection();
            _.each(val, function(stat) {
              var existingStat;
              existingStat = stats.findByName(stat.name);
              if (existingStat != null) {
                return existingStat.set('data', stat.data);
              } else {
                stat.task = _this;
                return stats.add(new Entities.RunStat(stat));
              }
            });
            val = stats;
          }
          return Task.__super__.set.apply(this, arguments);
        };

        return Task;

      })(App.Entities.Model);
    });
  });

}).call(this);
