(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.WebScanStats = (function(_super) {

    __extends(WebScanStats, _super);

    function WebScanStats() {
      return WebScanStats.__super__.constructor.apply(this, arguments);
    }

    WebScanStats.prototype.defaults = {
      web_pages: {
        display: "Web pages",
        value: 0
      },
      web_forms: {
        display: "Web forms",
        value: 0
      },
      web_vulns: {
        display: "Web vulns",
        value: 0
      }
    };

    WebScanStats.prototype.initialize = function(options) {
      this.workspaceId = options.workspaceId;
      this.taskId = options.taskId;
      return WebScanStats.__super__.initialize.apply(this, arguments);
    };

    WebScanStats.prototype.objectsForDisplay = function() {
      return [this.get('web_pages'), this.get('web_forms'), this.get('web_vulns')];
    };

    WebScanStats.prototype.url = function() {
      return "/workspaces/" + this.workspaceId + "/web_scans/" + this.taskId + ".json";
    };

    return WebScanStats;

  })(Backbone.Model);

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var pollForModel;
    _.templateSettings = {
      evaluate: /\{%([\s\S]+?)%\}/g,
      escape: /\{\{([\s\S]+?)\}\}/g
    };
    pollForModel = function(model) {
      model.fetch();
      return window.setInterval((function() {
        return model.fetch();
      }), 2000);
    };
    this.CircleStatsView = (function(_super) {

      __extends(CircleStatsView, _super);

      function CircleStatsView() {
        this.render = __bind(this.render, this);

        this.setStats = __bind(this.setStats, this);
        return CircleStatsView.__super__.constructor.apply(this, arguments);
      }

      CircleStatsView.prototype.template = _.template($("#stats-circles").html());

      CircleStatsView.prototype.setStats = function(stats) {
        this.stats = stats;
        this.stats.bind('change', this.render);
        this.attributes = this.stats.objectsForDisplay();
        return pollForModel(this.stats);
      };

      CircleStatsView.prototype.render = function() {
        return this.$el.html(this.template({
          statSet: this.stats,
          cellWidth: 100 / this.attributes.length
        }));
      };

      return CircleStatsView;

    })(Backbone.View);
    return this.WebScanStatsView = (function(_super) {

      __extends(WebScanStatsView, _super);

      function WebScanStatsView() {
        return WebScanStatsView.__super__.constructor.apply(this, arguments);
      }

      WebScanStatsView.prototype.initialize = function(opts) {
        var optsForStat;
        if (opts == null) {
          opts = {};
        }
        WebScanStatsView.__super__.initialize.apply(this, arguments);
        optsForStat = {
          workspaceId: opts['workspaceId'],
          taskId: opts['taskId']
        };
        return this.setStats(new WebScanStats(optsForStat));
      };

      return WebScanStatsView;

    })(CircleStatsView);
  });

}).call(this);


window.jQuery(document).ready(function($) {
  new WebScanStatsView({ el: jQuery('#stats-container'),
                         workspaceId: $("meta[value='msp:workspace_id']").content,
                         taskId: $("meta[value='task_id']").content }).render()
});
