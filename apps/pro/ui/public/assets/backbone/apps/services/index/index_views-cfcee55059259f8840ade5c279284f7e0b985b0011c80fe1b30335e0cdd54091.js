(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_itemview'], function() {
    return this.Pro.module('ServicesApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      Index.InfoCellView = (function(_super) {

        __extends(InfoCellView, _super);

        function InfoCellView() {
          this.template = __bind(this.template, this);
          return InfoCellView.__super__.constructor.apply(this, arguments);
        }

        InfoCellView.prototype.initialize = function() {
          this.attribute = 'info';
          return this.idAttribute = 'id';
        };

        InfoCellView.prototype.template = function(data) {
          var id, maxLength, text, truncatedText;
          maxLength = 50;
          id = data[this.idAttribute];
          text = data[this.attribute] || '';
          truncatedText = text.length > maxLength ? text.substring(0, maxLength) + '…' : text;
          return _.escapeHTML(_.unescapeHTML(truncatedText));
        };

        return InfoCellView;

      })(Pro.Views.ItemView);
      return Index.StateCellView = (function(_super) {

        __extends(StateCellView, _super);

        function StateCellView() {
          this.template = __bind(this.template, this);
          return StateCellView.__super__.constructor.apply(this, arguments);
        }

        StateCellView.prototype.template = function(data) {
          return "<div class='pill'> <div class='" + data.state + "'> " + (data.state.toUpperCase()) + " </div></div>";
        };

        return StateCellView;

      })(Pro.Views.ItemView);
    });
  });

}).call(this);
