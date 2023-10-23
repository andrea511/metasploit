(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/web_vulnerabilities-956f17bc73768b38033f6de8829c165ed3cfd5473fe55059d3f2611f1d975c67.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, EventAggregator) {
    var WebVulnerabilitiesLayout;
    return WebVulnerabilitiesLayout = (function(_super) {

      __extends(WebVulnerabilitiesLayout, _super);

      function WebVulnerabilitiesLayout() {
        this._initDataTable = __bind(this._initDataTable, this);

        this._reRender = __bind(this._reRender, this);

        this.hostWebVulnsURL = __bind(this.hostWebVulnsURL, this);
        return WebVulnerabilitiesLayout.__super__.constructor.apply(this, arguments);
      }

      WebVulnerabilitiesLayout.prototype.template = HandlebarsTemplates['hosts/layouts/web_vulnerabilities'];

      WebVulnerabilitiesLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      WebVulnerabilitiesLayout.prototype.hostWebVulnsURL = function() {
        return "/hosts/" + this.host_id + "/web_vulns";
      };

      WebVulnerabilitiesLayout.prototype.onShow = function() {
        EventAggregator.on("redrawTable", this.render);
        return EventAggregator.on("tabs_layout:change:count", this._reRender);
      };

      WebVulnerabilitiesLayout.prototype._reRender = function(count) {
        var settings;
        settings = $('#web-vulns-table table', this.el).dataTable().fnSettings();
        return this.render();
      };

      WebVulnerabilitiesLayout.prototype.isEditMode = function() {
        return $('.edit-table-row .save', this.el).length > 0;
      };

      WebVulnerabilitiesLayout.prototype.onDestroy = function() {
        return EventAggregator.off("redrawTable", this.render);
      };

      WebVulnerabilitiesLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      WebVulnerabilitiesLayout.prototype._loadTable = function() {
        var _this = this;
        return $.get(this.hostWebVulnsURL(), function(data) {
          $('.web-vulns', _this.el).html(data);
          return _this._initDataTable();
        });
      };

      WebVulnerabilitiesLayout.prototype._initDataTable = function() {
        var $table;
        $('.control-bar', this.el).remove();
        $table = $('#web-vulns-table', this.el).dataTable({
          oSettings: {
            sInstance: "web-vulns"
          },
          sDom: 'ft<"list-table-footer clearfix"ip <"sel" l>>r',
          aoColumns: [
            {}, {}, {}, {}, {}, {
              bSortable: false
            }, {
              bSortable: false
            }
          ],
          sPaginationType: "r7Style"
        });
        return $(this.el).trigger('tabload');
      };

      return WebVulnerabilitiesLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
