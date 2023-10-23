(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      Entities.RunStat = (function(_super) {

        __extends(RunStat, _super);

        function RunStat() {
          this.set = __bind(this.set, this);
          return RunStat.__super__.constructor.apply(this, arguments);
        }

        RunStat.prototype.defaults = {
          task_id: null,
          name: null,
          data: null,
          id: null
        };

        RunStat.prototype.set = function(key, val, opts) {
          if (key === 'name') {
            val = _.str.underscored(val);
          } else if (key instanceof Object && (key.name != null)) {
            this.set('name', key.name, opts);
            delete key.name;
          }
          return RunStat.__super__.set.apply(this, arguments);
        };

        return RunStat;

      })(App.Entities.Model);
      Entities.RunStatsCollection = (function(_super) {

        __extends(RunStatsCollection, _super);

        function RunStatsCollection() {
          this.findByName = __bind(this.findByName, this);

          this.initialize = __bind(this.initialize, this);
          return RunStatsCollection.__super__.constructor.apply(this, arguments);
        }

        RunStatsCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          return this.task = opts.task;
        };

        RunStatsCollection.prototype.findByName = function(name) {
          name = _.str.underscored(name.toString());
          return _.find(this.models, function(m) {
            return m.get('name') === name;
          });
        };

        return RunStatsCollection;

      })(App.Entities.Collection);
      Entities.StatDisplay = (function(_super) {

        __extends(StatDisplay, _super);

        function StatDisplay() {
          this.collectionURL = __bind(this.collectionURL, this);

          this.percentageStroke = __bind(this.percentageStroke, this);

          this.stroke = __bind(this.stroke, this);

          this.bgColor = __bind(this.bgColor, this);

          this.color = __bind(this.color, this);

          this.shouldShowPieChart = __bind(this.shouldShowPieChart, this);

          this.isPercentage = __bind(this.isPercentage, this);

          this.initialize = __bind(this.initialize, this);
          return StatDisplay.__super__.constructor.apply(this, arguments);
        }

        StatDisplay.prototype.defaults = function() {
          return {
            schema: {},
            run_stats: null,
            numStat: null,
            totalStat: null,
            clickable: true,
            selected: false,
            table: null,
            title: null,
            task: null
          };
        };

        StatDisplay.prototype.initialize = function() {
          this.set('numStat', this.get('run_stats').findByName(this.get('schema').num));
          if (this.isPercentage()) {
            this.set('totalStat', this.get('run_stats').findByName(this.get('schema').total));
          }
          if (this.get('schema').clickable != null) {
            this.set('clickable', this.get('schema').clickable);
          }
          return this.set('title', this.get('schema').title || _.str.humanize(this.get('numStat').get('name')));
        };

        StatDisplay.prototype.isPercentage = function() {
          return this.get('schema').type === 'percentage';
        };

        StatDisplay.prototype.shouldShowPieChart = function() {
          return !(this.get('schema').pie === false);
        };

        StatDisplay.prototype.color = function() {
          return this.get('schema').color || '#2b2b2b';
        };

        StatDisplay.prototype.bgColor = function() {
          return this.get('schema').bg_color || 'white';
        };

        StatDisplay.prototype.stroke = function() {
          return this.get('schema').stroke || '#c5c5c5';
        };

        StatDisplay.prototype.percentageStroke = function() {
          return this.get('schema').percentage_stroke || '#ea5709';
        };

        StatDisplay.prototype.collectionURL = function(task) {
          return ("/workspaces/" + (task.get('workspace_id')) + "/tasks/" + (task.get('id')) + "/") + ("stats/" + (_.str.underscored(this.get('title'))));
        };

        return StatDisplay;

      })(App.Entities.Model);
      return Entities.StatDisplaysCollection = (function(_super) {

        __extends(StatDisplaysCollection, _super);

        function StatDisplaysCollection() {
          this.updateSchema = __bind(this.updateSchema, this);

          this.findFirstClickable = __bind(this.findFirstClickable, this);

          this.initialize = __bind(this.initialize, this);
          return StatDisplaysCollection.__super__.constructor.apply(this, arguments);
        }

        StatDisplaysCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          this.schema = opts.schema, this.run_stats = opts.run_stats;
          if (this.schema == null) {
            throw new Error('schema attribute must be present in the options for a StatDisplaysCollection');
          }
          if (!((this.run_stats != null) && this.run_stats instanceof Entities.RunStatsCollection)) {
            throw new Error('run_stats attribute must be present in the options for a StatDisplaysCollection');
          }
          return this.updateSchema(this.schema);
        };

        StatDisplaysCollection.prototype.findFirstClickable = function() {
          return _.find(this.models, function(m) {
            return m.get('clickable');
          });
        };

        StatDisplaysCollection.prototype.updateSchema = function(schema) {
          var _this = this;
          this.schema = schema;
          return _.each(_.result(this.schema, 'stats'), function(statistic) {
            var _ref, _ref1, _ref2;
            return _this.add(new Entities.StatDisplay({
              run_stats: _this.run_stats,
              schema: statistic,
              table: (_ref = _.result(_this.schema, 'tables')) != null ? _ref[_.str.underscored(statistic.title)] : void 0,
              view: (_ref1 = _.result(_this.schema, 'views')) != null ? _ref1[_.str.underscored(statistic.title)] : void 0,
              controller: (_ref2 = _.result(_this.schema, 'controllers')) != null ? _ref2[_.str.underscored(statistic.title)] : void 0
            }));
          });
        };

        return StatDisplaysCollection;

      })(App.Entities.Collection);
    });
  });

}).call(this);
