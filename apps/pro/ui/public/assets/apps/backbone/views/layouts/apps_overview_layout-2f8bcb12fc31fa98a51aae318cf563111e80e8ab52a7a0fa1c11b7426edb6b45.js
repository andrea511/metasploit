(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/templates/apps/layouts/apps_overview_layout-2c2642d37e145a35a698f49e621fb7b337b931d21fe347ea8de550d9e2ed721c.js', '/assets/apps/backbone/views/layouts/apps_overview_collection_layout-92eb88ceed406dfcf4d79481a8419dcf0c3c3b8704a9c5e69b485d4e4da9c136.js', 'jquery', '/assets/apps/backbone/views/generic_stats_view-2f48b530a3c8ef4e2a013c321ce9ec891ca098d16ce732da94c990b157c8cd7f.js', '/assets/apps/backbone/models/app_run-b01dfd5be9374d25d3eec5cf47fd005e5e1a790866141c147aee85c43af9b864.js'], function(Template, AppsOverviewCollectionLayout, $, GenericStatsView, AppRun) {
    var AppsOverviewLayout;
    return AppsOverviewLayout = (function(_super) {

      __extends(AppsOverviewLayout, _super);

      function AppsOverviewLayout() {
        this.serializeData = __bind(this.serializeData, this);

        this.statClicked = __bind(this.statClicked, this);

        this.renderStats = __bind(this.renderStats, this);

        this.renderRegions = __bind(this.renderRegions, this);

        this.initialize = __bind(this.initialize, this);
        return AppsOverviewLayout.__super__.constructor.apply(this, arguments);
      }

      AppsOverviewLayout.prototype.template = HandlebarsTemplates['apps/layouts/apps_overview_layout'];

      AppsOverviewLayout.prototype.regions = {
        lastStatArea: '.last-stat',
        appsArea: '.apps-area'
      };

      AppsOverviewLayout.prototype.events = {
        'click .generic-stat-wrapper': 'statClicked'
      };

      AppsOverviewLayout.prototype.initialize = function() {
        this.numAppRuns = $('meta[name=num_app_runs]').attr('content');
        this.lastAppRunId = $('meta[name=last_app_run_id]').attr('content');
        return AppsOverviewLayout.__super__.initialize.apply(this, arguments);
      };

      AppsOverviewLayout.prototype.renderRegions = function() {
        this.collectionLayout = new AppsOverviewCollectionLayout;
        this.appsArea.show(this.collectionLayout);
        this.collectionLayout.renderRegions();
        return this.renderStats();
      };

      AppsOverviewLayout.prototype.renderStats = function() {
        var _this = this;
        if ((this.lastAppRunId != null) && this.lastAppRunId.length > 0) {
          this.appRun = new AppRun({
            id: this.lastAppRunId
          });
          this.appRun.fetch({
            success: function() {
              _this.statsView = new GenericStatsView({
                model: _this.appRun,
                showHeader: true
              });
              return _this.lastStatArea.show(_this.statsView);
            }
          });
        }
        if (this.numAppRuns < 1) {
          return $('.stats-area', this.el).hide();
        }
      };

      AppsOverviewLayout.prototype.statClicked = function() {
        return window.location = "./app_runs/" + this.lastAppRunId;
      };

      AppsOverviewLayout.prototype.serializeData = function() {
        return this;
      };

      return AppsOverviewLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
