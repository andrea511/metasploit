(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['/assets/apps/backbone/views/card_view-2b418aa93ca3bc876a6e19f85d25c3a86b72d55e4a1ec59e9c1f49648b8756e4.js', '/assets/templates/apps/views/no_cards_found_view-190c347d2a3cb58052b6ef432f29ba64e44032d66128705152fc0cca217aff9f.js', 'jquery'], function(CardView, NoCardsTemplate, $) {
    var CardsCollectionView, NoItemsView;
    NoItemsView = (function(_super) {

      __extends(NoItemsView, _super);

      function NoItemsView() {
        return NoItemsView.__super__.constructor.apply(this, arguments);
      }

      NoItemsView.prototype.template = HandlebarsTemplates['apps/views/no_cards_found_view'];

      return NoItemsView;

    })(Backbone.Marionette.ItemView);
    return CardsCollectionView = (function(_super) {

      __extends(CardsCollectionView, _super);

      function CardsCollectionView() {
        this._updateCardsPerRow = __bind(this._updateCardsPerRow, this);

        this.onRender = __bind(this.onRender, this);

        this.onBeforeRender = __bind(this.onBeforeRender, this);

        this.initialize = __bind(this.initialize, this);
        return CardsCollectionView.__super__.constructor.apply(this, arguments);
      }

      CardsCollectionView.prototype.cardsPerRow = 3;

      CardsCollectionView.prototype.childView = CardView;

      CardsCollectionView.prototype.emptyView = NoItemsView;

      CardsCollectionView.prototype.initialize = function() {
        var _this = this;
        return $(window).resize(function() {
          var cardsPerRow;
          cardsPerRow = _this.cardsPerRow;
          if (_this._updateCardsPerRow() !== cardsPerRow) {
            return _this.render();
          }
        });
      };

      CardsCollectionView.prototype.onBeforeRender = function() {
        return $(this.el).html('');
      };

      CardsCollectionView.prototype.onRender = function() {
        var $cols, $wrapper, width,
          _this = this;
        $cols = $('div.columns', this.el).parent();
        $wrapper = null;
        this._updateCardsPerRow();
        _.each($cols, function(col, idx) {
          if (idx % _this.cardsPerRow === 0) {
            $wrapper = $('<div class="row" />').appendTo(_this.el);
          }
          return $(col).appendTo($wrapper);
        });
        width = "" + (100 / this.cardsPerRow) + "%";
        _.each($('.card', this.el), function(card) {
          return $(card).parent().css({
            width: width
          });
        });
        return _.defer(function() {
          return $('.card p.description', _this.el).truncate({
            maxLines: 5
          });
        });
      };

      CardsCollectionView.prototype._updateCardsPerRow = function() {
        return this.cardsPerRow = $(window).width() > 1180 ? 4 : 3;
      };

      return CardsCollectionView;

    })(Backbone.Marionette.CollectionView);
  });

}).call(this);
