(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/shared/nexpose_sites/nexpose_sites_views', 'css!css/shared/nexpose_sites'], function() {
    return this.Pro.module("Shared.NexposeSites", function(NexposeSites, App) {
      NexposeSites.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this._triggerRowsSelected = __bind(this._triggerRowsSelected, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var _this = this;
          this.layout = new NexposeSites.Layout({
            collection: options.collection
          });
          this.setMainView(this.layout);
          return this.listenTo(this.layout, 'table:initialized', function() {
            _this.layout.table.carpenterRadio.on('table:rows:selected', _this._triggerRowsSelected);
            _this.layout.table.carpenterRadio.on('table:rows:deselected', _this._triggerRowsSelected);
            _this.layout.table.carpenterRadio.on('table:row:selected', _this._triggerRowsSelected);
            return _this.layout.table.carpenterRadio.on('table:row:deselected', _this._triggerRowsSelected);
          });
        };

        Controller.prototype.onDestroy = function() {
          this.layout.table.carpenterRadio.off('table:rows:selected');
          this.layout.table.carpenterRadio.off('table:rows:deselected');
          this.layout.table.carpenterRadio.off('table:row:selected');
          return this.layout.table.carpenterRadio.off('table:row:deselected');
        };

        Controller.prototype._triggerRowsSelected = function() {
          return this.layout.$el.trigger('site:rows:changed', this.layout.table);
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler("nexposeSites:shared", function(options) {
        if (options == null) {
          options = {};
        }
        return new NexposeSites.Controller(options);
      });
    });
  });

}).call(this);
