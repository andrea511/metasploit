(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/sessions-d19b88ac968f535e0fb745b5edb0324f851ad724afc6195c0f52fe260f6fc942.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, EventAggregator) {
    var SessionsLayout;
    return SessionsLayout = (function(_super) {

      __extends(SessionsLayout, _super);

      function SessionsLayout() {
        this._loadCompletedSessionsTable = __bind(this._loadCompletedSessionsTable, this);

        this._loadActiveSessionsTable = __bind(this._loadActiveSessionsTable, this);

        this._loadTables = __bind(this._loadTables, this);

        this._reRender = __bind(this._reRender, this);

        this.onRender = __bind(this.onRender, this);

        this.onDestroy = __bind(this.onDestroy, this);

        this.onShow = __bind(this.onShow, this);

        this.activeSessionsURL = __bind(this.activeSessionsURL, this);

        this.completedSessionsURL = __bind(this.completedSessionsURL, this);
        return SessionsLayout.__super__.constructor.apply(this, arguments);
      }

      SessionsLayout.prototype.template = HandlebarsTemplates['hosts/layouts/sessions'];

      SessionsLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      SessionsLayout.prototype.completedSessionsURL = function() {
        return "/hosts/" + this.host_id + "/show_dead_sessions.json";
      };

      SessionsLayout.prototype.activeSessionsURL = function() {
        return "/hosts/" + this.host_id + "/show_alive_sessions.json";
      };

      SessionsLayout.prototype.onShow = function() {
        return EventAggregator.on("tabs_layout:change:count", this.reRender);
      };

      SessionsLayout.prototype.onDestroy = function() {
        return EventAggregator.off("tabs_layout:change:count");
      };

      SessionsLayout.prototype.onRender = function() {
        return this._loadTables();
      };

      SessionsLayout.prototype._reRender = function(count) {
        if ($('#active_sessions_table table', this.el).dataTable().fnSettings().fnRecordsTotal() + $('#completed_sessions_table table', this.el).dataTable().fnSettings().fnRecordsTotal() !== count.get("captured_data")) {
          return this.render();
        }
      };

      SessionsLayout.prototype._sessionHistoryPath = function(id) {
        return "/workspaces/" + WORKSPACE_ID + "/session_history/" + id;
      };

      SessionsLayout.prototype._sessionPath = function(id) {
        return "/workspaces/" + WORKSPACE_ID + "/sessions/" + id;
      };

      SessionsLayout.prototype._shellPath = function(id) {
        return "/sessions/" + id + "/shell";
      };

      SessionsLayout.prototype._loadTables = function() {
        this._loadActiveSessionsTable();
        return this._loadCompletedSessionsTable();
      };

      SessionsLayout.prototype._loadActiveSessionsTable = function() {
        var _this = this;
        return helpers.loadRemoteTable({
          el: $('#active_sessions_table', this.el),
          tableName: 'activeSessions',
          bStateSave: true,
          columns: {
            id: {
              name: "Session",
              fnRender: function(o) {
                var shellUrl, url;
                url = _this._sessionPath(o.aData.id);
                shellUrl = _this._shellPath(o.aData.id);
                o.aData.history = o.aData.id;
                return ("<a href='" + (_.escape(url)) + "'>Session " + o.aData.id + "</a> ") + ("<a href='" + (_.escape(shellUrl)) + "' class='shell_icon'></a>");
              }
            },
            history: {
              name: "History",
              bSortable: false,
              mDataProp: null,
              fnRender: function(o) {
                var url;
                url = "" + (_this._sessionHistoryPath(o.aData.history));
                return "<a href='" + (_.escape(url)) + "'>History</a>";
              }
            },
            stype: {
              name: "Type",
              bSortable: true
            },
            opened_at: {
              name: "Opened at"
            },
            via_exploit: {
              name: "Attack Module"
            }
          },
          dataTable: {
            sPaginationType: "r7Style",
            oLanguage: {
              sEmptyTable: "No active sessions."
            },
            aaSorting: [[3, 'desc']],
            sAjaxSource: this.activeSessionsURL()
          }
        });
      };

      SessionsLayout.prototype._loadCompletedSessionsTable = function() {
        var _this = this;
        return helpers.loadRemoteTable({
          el: $('#completed_sessions_table', this.el),
          tableName: 'completedSessions',
          columns: {
            id: {
              name: "Session",
              fnRender: function(o) {
                o.aData.history = o.aData.id;
                return "Session " + o.aData.id;
              }
            },
            history: {
              name: "History",
              bSortable: false,
              mDataProp: null,
              fnRender: function(o) {
                var url;
                url = _this._sessionHistoryPath(o.aData.history);
                return "<a href='" + (_.escape(url)) + "'>History</a>";
              }
            },
            stype: {
              name: "Type",
              bSortable: true,
              fnRender: function(o) {
                return "" + o.aData.stype;
              }
            },
            opened_at: {
              name: "Opened at",
              fnRender: function(o) {
                return "" + o.aData.opened_at;
              }
            },
            via_exploit: {
              name: "Attack Module",
              fnRender: function(o) {
                return "" + o.aData.via_exploit;
              }
            }
          },
          dataTable: {
            sPaginationType: "r7Style",
            oLanguage: {
              sEmptyTable: "No completed sessions."
            },
            aaSorting: [[3, 'desc']],
            sAjaxSource: this.completedSessionsURL()
          }
        });
      };

      return SessionsLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
