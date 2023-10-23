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
