(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.TabView = (function(_super) {

      __extends(TabView, _super);

      function TabView() {
        return TabView.__super__.constructor.apply(this, arguments);
      }

      TabView.prototype.initialize = function(opts) {
        var pageWrap, _ref;
        this.touchEnabled = false;
        this.index = (_ref = typeof JUMP_TO_COMPONENT !== "undefined" && JUMP_TO_COMPONENT !== null ? JUMP_TO_COMPONENT : opts['index']) != null ? _ref : 0;
        this.tabs || (this.tabs = []);
        this.size || (this.size = this.tabs.length);
        this.render();
        pageWrap = $($.parseHTML($('#tab-pages').html())).appendTo(this.el);
        this.tabs.each(function(tab) {
          tab.setElement($('.pages', pageWrap));
          return tab.render();
        });
        return this.enableTouchAfter(0.2);
      };

      TabView.prototype.template = _.template($('#tab-header', TabView.el).html());

      TabView.prototype.enableTouchAfter = function(seconds) {
        var _this = this;
        return _.delay((function() {
          return _this.touchEnabled = true;
        }), seconds * 1000);
      };

      TabView.prototype.disableTouch = function() {
        return this.touchEnabled = false;
      };

      TabView.prototype.setTabIndex = function(index) {
        var $allPages, $page, oldIndex,
          _this = this;
        if (index < 0 || index >= this.tabs.length) {
          return;
        }
        if (this.oldDelay) {
          window.clearTimeout(this.oldDelay);
        }
        oldIndex = this.index;
        this.index = index;
        $(this.tabs[oldIndex]).trigger('willHide');
        $(this.tabs[this.index]).trigger('willDisplay');
        $('.tab-header>.cell', this.el).removeClass('selected');
        $('.tab-header>.cell', this.el).eq(index).addClass('selected');
        $allPages = $('.slider .pages>.cell', this.el);
        $page = $('.slider .pages>.cell', this.el).eq(index);
        $allPages.css({
          height: 'auto'
        });
        this.oldDelay = _.delay((function() {
          _this.oldDelay = null;
          return $('.slider .pages>.cell', _this.el).not(':eq(' + index + ')').css({
            height: '1px',
            overflow: 'hidden',
            visibility: 'hidden'
          });
        }), 200);
        $page.css({
          height: 'auto',
          overflow: 'visible',
          visibility: 'visible'
        });
        $('.slider .pages', this.el).css('left', (index * -100) + '%');
        if (index === 0) {
          if ($page.hasClass('loading')) {
            return $page.removeClass('loading');
          }
        } else if ($page.hasClass('loading')) {
          if (this.animatable) {
            return _.delay((function() {
              return $page.removeClass('loading');
            }), 300);
          } else {
            return $page.removeClass('loading');
          }
        }
      };

      TabView.prototype.events = {
        'click .tab-header>.cell': 'tabClicked'
      };

      TabView.prototype.tabClicked = function(e) {
        var $target, idx;
        $target = $(e.target).parentsUntil('.tab-header', '.cell');
        if (!$target.length) {
          $target = $(e.target);
        }
        if ($target) {
          idx = $('.tab-header>.cell', this.el).index($target);
          return this.userClickedTab(idx);
        }
      };

      TabView.prototype.userClickedTab = function(idx) {
        if (!this.touchEnabled) {
          return;
        }
        if (this.index === idx) {
          return;
        }
        this.disableTouch();
        this.enableTouchAfter(0.2);
        return this.setTabIndex(idx);
      };

      TabView.prototype.render = function(opts) {
        var _this = this;
        if (this.dom) {
          this.dom.remove();
        }
        this.dom = $($.parseHTML(this.template(this))[1]).prependTo($(this.el));
        return _.delay((function() {
          _this.setTabIndex(_this.index);
          if (_this.animatable) {
            return;
          }
          return _.defer(function() {
            _this.animatable = true;
            return $('.slider .pages', _this.el).addClass('animatable');
          });
        }), 0);
      };

      return TabView;

    })(Backbone.View);
  });

}).call(this);
