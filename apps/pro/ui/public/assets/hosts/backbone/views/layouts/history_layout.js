(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/history-f02007cefe5dca2698592aec013d62d75527e67df7bb50dbf679b8b48316b07f.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, EventAggregator) {
    var HistoryLayout;
    return HistoryLayout = (function(_super) {

      __extends(HistoryLayout, _super);

      function HistoryLayout() {
        this._loadTable = __bind(this._loadTable, this);

        this.onRender = __bind(this.onRender, this);

        this.hostHistoryTableURL = __bind(this.hostHistoryTableURL, this);
        return HistoryLayout.__super__.constructor.apply(this, arguments);
      }

      HistoryLayout.prototype.template = HandlebarsTemplates['hosts/layouts/history'];

      HistoryLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      HistoryLayout.prototype.onShow = function() {
        return EventAggregator.on("tabs_layout:change:count", this.render);
      };

      HistoryLayout.prototype.onDestroy = function() {
        return EventAggregator.off("tabs_layout:change:count");
      };

      HistoryLayout.prototype.hostHistoryTableURL = function() {
        return "/hosts/" + this.host_id + "/show_history.json";
      };

      HistoryLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      HistoryLayout.prototype._loadTable = function() {
        var _this = this;
        return helpers.loadRemoteTable({
          el: $('#history_table', this.el),
          tableName: 'history',
          columns: {
            info: {
              bSortable: false,
              sClass: 'break-all info',
              sWidth: "50%",
              fnRender: function(o) {
                return JSON.stringify(o.aData.info);
              }
            },
            created_at: {
              sTitle: "Created",
              sWidth: "200px",
              sClass: 'time',
              fnRender: function(o) {
                var time, _ref;
                time = (_ref = o.aData) != null ? _ref.created_at : void 0;
                return "<span title='" + (_.escape(time)) + "'>" + (_.escape(moment(time).fromNow())) + "</span>";
              }
            }
          },
          dataTable: {
            aaSorting: [[3, 'desc']],
            sAjaxSource: this.hostHistoryTableURL(),
            fnDrawCallback: function() {
              _.each($('#history_table', _this.el).find('td.info'), function(td) {
                var node;
                node = new PrettyJSON.view.Node({
                  el: $(td),
                  level: 0,
                  data: JSON.parse($(td).text())
                });
                return $(td).find('.node-container').first().addClass('inline').click(function() {
                  return $(this).removeClass('inline');
                });
              });
              return $('table td.time', _this.el).tooltip();
            }
          }
        });
      };

      return HistoryLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
