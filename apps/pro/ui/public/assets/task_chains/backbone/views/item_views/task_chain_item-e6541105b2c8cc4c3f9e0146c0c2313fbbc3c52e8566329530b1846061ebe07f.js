(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/shared/lib/pie_chart-1f6948c3f005ea1112050389be09f7c3d8a5dfb36e582cd1151673a5694fc2bd.js', '/assets/templates/task_chains/item_views/task_chain_item-03997b3d168bcd37752b35781f5082ce9afa54ed205951c2383016e943d33b2e.js'], function($, PieChart, Template) {
    var TaskChainItem;
    return TaskChainItem = (function(_super) {

      __extends(TaskChainItem, _super);

      function TaskChainItem() {
        this.pieSelected = __bind(this.pieSelected, this);

        this.onRender = __bind(this.onRender, this);
        return TaskChainItem.__super__.constructor.apply(this, arguments);
      }

      TaskChainItem.prototype.template = HandlebarsTemplates['task_chains/item_views/task_chain_item'];

      TaskChainItem.prototype.events = {
        'click canvas': 'pieSelected'
      };

      TaskChainItem.prototype.className = 'container';

      TaskChainItem.prototype.ui = {
        scan: '.scan'
      };

      TaskChainItem.prototype.modelEvents = {
        'change:selected': '_selectedChanged'
      };

      TaskChainItem.prototype._hoverColor = '#2C69A0';

      TaskChainItem.prototype._innerFill = 'grey';

      TaskChainItem.prototype._textFill = '#fff';

      TaskChainItem.prototype._textFillHover = '#fff';

      TaskChainItem.prototype._errorColor = '#A22B2E';

      TaskChainItem.prototype.onRender = function() {
        this._initPie();
        return this.model.set('cid', this.model.cid);
      };

      TaskChainItem.prototype._initPie = function() {
        return this.chart = new PieChart({
          canvas: this.ui.scan[0],
          innerFillHover: this._hoverColor,
          textFill: this._textFill,
          textFillHover: this._textFillHover,
          innerFill: this._innerFill
        });
      };

      TaskChainItem.prototype._selectedChanged = function(model, val) {
        if (!val) {
          return this.chart.setInnerFill(this._innerFill, true);
        } else {
          return this.chart.setInnerFill(this._hoverColor, true);
        }
      };

      TaskChainItem.prototype.flag = function() {
        return this.chart.setInnerFill(this._errorColor, true);
      };

      TaskChainItem.prototype.unflag = function() {
        if (this.chart.getInnerFill() === this._hoverColor) {
          return this.chart.setInnerFill(this._hoverColor, true);
        } else {
          return this.chart.setInnerFill(this._innerFill, true);
        }
      };

      TaskChainItem.prototype.active = function() {
        return this.chart.setInnerFill(this._hoverColor, true);
      };

      TaskChainItem.prototype.pieSelected = function() {
        return $(this.el).trigger('pieClicked', this);
      };

      return TaskChainItem;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
