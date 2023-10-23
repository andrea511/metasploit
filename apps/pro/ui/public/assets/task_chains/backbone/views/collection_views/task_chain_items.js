(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/task_chains/backbone/views/item_views/task_chain_item-e6541105b2c8cc4c3f9e0146c0c2313fbbc3c52e8566329530b1846061ebe07f.js'], function($, TaskChainItem) {
    var TaskChainItems;
    return TaskChainItems = (function(_super) {

      __extends(TaskChainItems, _super);

      function TaskChainItems() {
        this._updateNumbering = __bind(this._updateNumbering, this);

        this._initDraggableAndSortable = __bind(this._initDraggableAndSortable, this);

        this._initTaskCount = __bind(this._initTaskCount, this);
        return TaskChainItems.__super__.constructor.apply(this, arguments);
      }

      TaskChainItems.prototype.childView = TaskChainItem;

      TaskChainItems.prototype.className = 'task-chain-items';

      TaskChainItems.prototype.events = {
        'pieClicked *': 'selectPie'
      };

      TaskChainItems.prototype.collectionEvents = {
        'remove': '_setEmptyState',
        'reset': '_resetState',
        'add': '_addState'
      };

      TaskChainItems.prototype.ui = {
        el: "" + TaskChainItems.className
      };

      TaskChainItems.prototype._hoverColor = '#2C69A0';

      TaskChainItems.prototype._innerFill = 'grey';

      TaskChainItems.prototype.onRender = function() {
        this.collection.each(this._initTaskCount);
        this.collection.comparator = function(model) {
          return model.get('index');
        };
        return this._initDraggableAndSortable();
      };

      TaskChainItems.prototype.onAddChild = function(item) {
        this._reinit();
        if (item.model.get('cloned')) {
          return this.selectPie(true, item);
        } else {
          return this.selectPie(null, item);
        }
      };

      TaskChainItems.prototype.onRemoveChild = function() {
        return this._reinit();
      };

      TaskChainItems.prototype._addState = function(item, collection) {
        return $(this.el).trigger('showAddState', collection);
      };

      TaskChainItems.prototype._resetState = function() {
        return $(this.el).trigger('showEmptyState');
      };

      TaskChainItems.prototype._setEmptyState = function(item, collection, options) {
        var index, view;
        if (collection.length === 0) {
          $(this.el).trigger('showEmptyState');
        }
        if (collection.length > 0) {
          if (options.index >= collection.length) {
            index = options.index - 1;
          } else {
            index = options.index;
          }
          view = this.children.findByModel(collection.at(index));
          return this.selectPie(true, view);
        }
      };

      TaskChainItems.prototype._reinit = function() {
        this.collection.each(this._initTaskCount);
        this._destroyDraggableAndSortable();
        return this._initDraggableAndSortable();
      };

      TaskChainItems.prototype._initTaskCount = function(task_chain_item, index) {
        var view;
        view = this.children.findByModel(task_chain_item);
        return view.chart.setText(index + 1, true);
      };

      TaskChainItems.prototype._destroyDraggableAndSortable = function() {
        $(this.el).draggable('destroy');
        return $(this.el).sortable('destroy');
      };

      TaskChainItems.prototype._initDraggableAndSortable = function() {
        $(this.el).sortable({
          revert: true,
          update: this._updateNumbering,
          containment: '.vertical-nav'
        });
        return $(this.el).draggable({
          connectToSortable: "." + this.el.className,
          helper: 'clone',
          revert: 'invalid'
        });
      };

      TaskChainItems.prototype._updateCollection = function() {
        var _this = this;
        this.collection.each(function(task_chain_item) {
          var index, view;
          view = _this.children.findByModel(task_chain_item);
          index = $(view.el).data('index');
          view.chart.setText(index, true);
          return task_chain_item.set('index', index);
        });
        return this.collection.sort();
      };

      TaskChainItems.prototype._updateNumbering = function(e, ui) {
        var pies;
        pies = $('canvas', this.el);
        _.each(pies, function(pieChart, index) {
          return $(pieChart).closest('.container').data('index', index + 1);
        });
        return this._updateCollection();
      };

      TaskChainItems.prototype.selectPie = function(e, task_chain_item) {
        var _this = this;
        this.collection.each(function(task_chain_item) {
          return task_chain_item.set('selected', false);
        });
        task_chain_item.model.set('selected', true);
        if (e != null) {
          return $(task_chain_item.el).trigger('pieChanged', task_chain_item);
        }
      };

      return TaskChainItems;

    })(Backbone.Marionette.CollectionView);
  });

}).call(this);
