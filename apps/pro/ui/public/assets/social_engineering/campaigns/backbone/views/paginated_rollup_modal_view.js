(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.PaginatedRollupModalView = (function(_super) {

      __extends(PaginatedRollupModalView, _super);

      function PaginatedRollupModalView() {
        return PaginatedRollupModalView.__super__.constructor.apply(this, arguments);
      }

      PaginatedRollupModalView.prototype.PREV_BUTTON = ['prev', 'Previous'];

      PaginatedRollupModalView.prototype.NEXT_BUTTON = ['next', 'Next'];

      PaginatedRollupModalView.prototype.initialize = function() {
        this.idx || (this.idx = -1);
        this.length = 1;
        _.bindAll(this, 'next', 'prev', 'page', 'resetPaging');
        return PaginatedRollupModalView.__super__.initialize.apply(this, arguments);
      };

      PaginatedRollupModalView.prototype.actionButtons = function() {
        return [];
      };

      PaginatedRollupModalView.prototype.onLoad = function() {
        this.resetPaging();
        if (this.initPage) {
          this.page(this.initPage);
          this.initPage = null;
        } else {
          this.page(0);
        }
        return PaginatedRollupModalView.__super__.onLoad.apply(this, arguments);
      };

      PaginatedRollupModalView.prototype.resetPaging = function() {
        var $cells;
        $cells = $('div.content div.row.page>div.cell', this.$el);
        this.length = $cells.size() || 1;
        $('div.content div.page.row', this.$el).css('width', 100 * this.length + '%');
        return $cells.css('width', 100 / this.length + '%').scrollTop(0);
      };

      PaginatedRollupModalView.prototype.renderActionButtons = function() {
        var $actions, $outerBtn, btn, btns, idx, _i, _len, _ref, _results;
        $actions = $('>div.actions', this.$el);
        try {
          $actions.html('');
          btns = this.actionButtons();
          idx = this.idx < 0 ? 0 : this.idx;
          _ref = btns[idx];
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            btn = _ref[_i];
            if (btn[0].match(/no-span/)) {
              $outerBtn = $("<a href='#' class='" + btn[0] + "'>" + btn[1] + "</a>");
            } else {
              $outerBtn = $("<span class='btn " + btn[0] + "'></span>");
              $outerBtn.html("<a href='#' class='" + btn[0] + "'>" + btn[1] + "</a>");
            }
            _results.push($outerBtn.appendTo($actions));
          }
          return _results;
        } catch (e) {

        }
      };

      PaginatedRollupModalView.prototype.page = function(idx) {
        var $cells,
          _this = this;
        if (idx === this.idx || idx >= this.length || idx < 0) {
          return;
        }
        this.idx = idx;
        $cells = $('div.content div.page.row>div.cell', this.$el);
        $cells.eq(idx).css({
          height: 'auto',
          visibility: 'visible',
          'overflow-y': 'visible'
        });
        $('div.content div.page.row', this.$el).css('left', -this.idx * 100 + '%');
        _.delay((function() {
          $cells = $('div.content div.page.row>div.cell', _this.$el);
          return $cells.not(":eq(" + idx + ")").css({
            height: '1px',
            'overflow-y': 'hidden',
            visibility: 'hidden'
          });
        }), 200);
        return this.renderActionButtons();
      };

      PaginatedRollupModalView.prototype.events = _.extend({
        'click .actions a.next': 'next',
        'click .actions a.prev': 'prev'
      }, RollupModalView.prototype.events);

      PaginatedRollupModalView.prototype.next = function(e) {
        this.page(this.idx + 1);
        if (e) {
          return e.preventDefault();
        }
      };

      PaginatedRollupModalView.prototype.prev = function(e) {
        this.page(this.idx - 1);
        if (e) {
          return e.preventDefault();
        }
      };

      return PaginatedRollupModalView;

    })(this.RollupModalView);
  });

}).call(this);
