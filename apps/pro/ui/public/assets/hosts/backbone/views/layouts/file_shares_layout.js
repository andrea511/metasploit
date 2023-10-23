(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/file_shares-d61b5eabbd63989da4756b9511ea04f62f5e57486885d888901233d681608651.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, EventAggregator) {
    var FileSharesLayout;
    return FileSharesLayout = (function(_super) {

      __extends(FileSharesLayout, _super);

      function FileSharesLayout() {
        this._loadTable = __bind(this._loadTable, this);

        this.hostSharesURL = __bind(this.hostSharesURL, this);

        this.onRender = __bind(this.onRender, this);

        this.initialize = __bind(this.initialize, this);
        return FileSharesLayout.__super__.constructor.apply(this, arguments);
      }

      FileSharesLayout.prototype.template = HandlebarsTemplates['hosts/layouts/file_shares'];

      FileSharesLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
        return EventAggregator.on("tabs_layout:change:count", this.render);
      };

      FileSharesLayout.prototype.onDestroy = function() {
        return EventAggregator.off("tabs_layout:change:count");
      };

      FileSharesLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      FileSharesLayout.prototype.hostSharesURL = function() {
        return "/hosts/" + this.host_id + "/shares";
      };

      FileSharesLayout.prototype._loadTable = function() {
        var _this = this;
        return $.ajax({
          type: 'GET',
          url: this.hostSharesURL(),
          success: function(data) {
            $('.shares', _this.el).html(data);
            $('.shares table#shares_smb', _this.el).dataTable({
              oSettings: {
                sInstance: 'smb'
              },
              sPaginationType: "r7Style",
              bStateSave: true,
              aoColumns: [null, null, null, null]
            });
            $('.shares table#shares_nfs', _this.el).dataTable({
              oSettings: {
                sInstance: 'nfsExports'
              },
              sPaginationType: "r7Style",
              bStateSave: true,
              aoColumns: [null, null, null]
            });
            return $(_this.el).trigger('tabload');
          }
        });
      };

      return FileSharesLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
