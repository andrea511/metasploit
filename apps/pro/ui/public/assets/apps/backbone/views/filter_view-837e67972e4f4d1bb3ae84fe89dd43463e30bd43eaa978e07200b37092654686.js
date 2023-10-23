(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/templates/apps/views/filter_view-be21be83add7df1a9e0b6754278c71ac3a2bfdf2b7ad44dbc4f215cf4d23077f.js', '/assets/apps/backbone/models/app-7bc75214fb94c799b83f2cc24f4c76f8372dfba0268346bdc794b7b5e959a8a9.js', 'jquery'], function(Template, App, $) {
    var FilterView;
    return FilterView = (function(_super) {

      __extends(FilterView, _super);

      function FilterView() {
        this._buildSafetyRatings = __bind(this._buildSafetyRatings, this);

        this._buildCategories = __bind(this._buildCategories, this);

        this._minRating = __bind(this._minRating, this);

        this._toggleReset = __bind(this._toggleReset, this);

        this.updateCounts = __bind(this.updateCounts, this);

        this.resetClicked = __bind(this.resetClicked, this);

        this.ratingClicked = __bind(this.ratingClicked, this);

        this.updateFilters = __bind(this.updateFilters, this);

        this.initialize = __bind(this.initialize, this);
        return FilterView.__super__.constructor.apply(this, arguments);
      }

      FilterView.prototype.MAX_APP_RATING = 5;

      FilterView.prototype.collection = null;

      FilterView.prototype.collectionView = null;

      FilterView.prototype.categories = [];

      FilterView.prototype.safetyRatings = [];

      FilterView.prototype.template = HandlebarsTemplates['apps/views/filter_view'];

      FilterView.prototype._initialCollection = null;

      FilterView.prototype.events = {
        'change ul.categories input[type=checkbox]': 'updateFilters',
        'click ul.safety-ratings li a': 'ratingClicked',
        'click a.reset': 'resetClicked'
      };

      FilterView.prototype.initialize = function(_arg) {
        this.collectionView = _arg.collectionView, this.collection = _arg.collection;
        this.categories = this._buildCategories(this.collection);
        return this.safetyRatings = this._buildSafetyRatings(this.collection);
      };

      FilterView.prototype.updateFilters = function() {
        var $selectedCategories, categoryNames, collection, minRating, models;
        $selectedCategories = $('ul.categories input[type=checkbox]:checked~span span.name', this.el);
        categoryNames = _.map($selectedCategories, function(cat) {
          return $(cat).text();
        });
        collection = this.collection;
        models = collection.models;
        if ((categoryNames != null ? categoryNames.length : void 0) > 0) {
          models = _.filter(models, function(app) {
            return _.any(app.get('app_categories'), function(cat) {
              return _.contains(categoryNames, cat.name);
            });
          });
        }
        minRating = this._minRating();
        if (minRating > 0) {
          models = _.filter(models, function(app) {
            return app.get('rating') >= minRating;
          });
        }
        this.collectionView.collection = new Backbone.Collection(models, {
          model: App
        });
        this.collectionView.render();
        return this.updateCounts(this.collectionView.collection);
      };

      FilterView.prototype.ratingClicked = function(e) {
        var $li, $lis, $ul, newIdx, selIdx;
        e.preventDefault();
        $li = $(e.target).parents('li').first();
        $ul = $(e.target).parents('ul').first();
        $lis = $('>li', $ul);
        selIdx = $('>li.selected', $ul).index();
        newIdx = $li.index();
        $lis.removeClass('selected');
        if (selIdx !== newIdx) {
          $li.addClass('selected');
        }
        return this.updateFilters();
      };

      FilterView.prototype.resetClicked = function(e) {
        e.preventDefault();
        $('ul.categories input:checked', this.el).prop('checked', false);
        return this.updateFilters();
      };

      FilterView.prototype.updateCounts = function(collection) {
        var newCounts;
        this._toggleReset();
        newCounts = this._buildCategories(this.collection);
        $('ul.categories span.count', this.el).text('(0)');
        return _.each(newCounts, function(item) {
          var $count;
          $count = $('ul.categories span.name', this.el).filter(":contains('" + item.name + "')").siblings('.count');
          return $count.text("(" + item.count + ")");
        });
      };

      FilterView.prototype._toggleReset = function() {
        return $('span.reset', this.el).toggle($('ul.categories input:checked', this.el).length > 0);
      };

      FilterView.prototype._minRating = function() {
        var $selRating;
        $selRating = $('ul.safety-ratings li.selected a', this.el);
        if (($selRating != null ? $selRating.length : void 0) > 0) {
          return parseInt($selRating.attr('data-stars'));
        } else {
          return 0;
        }
      };

      FilterView.prototype._buildCategories = function(collection) {
        var categories, counts, minRating, models;
        if (collection == null) {
          collection = this.collection;
        }
        minRating = this._minRating();
        models = collection.models;
        if (minRating > 0) {
          models = _.filter(models, function(mod) {
            return mod.get('rating') >= minRating;
          });
        }
        categories = _.flatten(_.map(models, function(item) {
          return item.get('app_categories') || [];
        }));
        counts = _.countBy(categories, function(item) {
          return item.name;
        });
        categories = _.map(counts, function(v, k) {
          return {
            count: v,
            name: k
          };
        });
        return _.sortBy(categories, function(cat) {
          return cat.name;
        });
      };

      FilterView.prototype._buildSafetyRatings = function(collection) {
        var counts, safetyRatings;
        if (collection == null) {
          collection = this.collection;
        }
        counts = _.countBy(collection.models, function(item) {
          return item.get('rating');
        });
        safetyRatings = _.map(_.range(1, this.MAX_APP_RATING + 1), function(i) {
          var count;
          count = 0;
          _.each(counts, function(v, k) {
            if (parseFloat(k) >= i) {
              return count += parseInt(v);
            }
          });
          return {
            name: "" + i,
            count: "" + count
          };
        });
        return _.sortBy(safetyRatings, function(item) {
          return item.name;
        }).reverse();
      };

      FilterView.prototype.serializeData = function() {
        return this;
      };

      return FilterView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
