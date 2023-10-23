(function() {
  var $,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  $ = jQuery;

  this.RollupModalView = (function(_super) {

    __extends(RollupModalView, _super);

    function RollupModalView() {
      this.render = __bind(this.render, this);
      return RollupModalView.__super__.constructor.apply(this, arguments);
    }

    RollupModalView.prototype.initialize = function(opts) {
      this.options = opts;
      this.content || (this.content = this.options['content'] || '');
      this.buttons || (this.buttons = this.options['buttons'] || []);
      _.bindAll(this, 'load', 'closeClicked', 'close');
      this.opened = false;
      this.$el.addClass('rollup-modal');
      window.origConfirm || (window.origConfirm = window.confirm);
      return this.render();
    };

    RollupModalView.prototype.stubCustomConfirm = function() {
      var _this = this;
      return window.confirm = function() {
        if (_this.opened) {
          _this.escEnabled = false;
          _.delay((function() {
            return _this.escEnabled = true;
          }), 300);
          return origConfirm.apply(window, arguments);
        } else {
          return origConfirm.apply(window, arguments);
        }
      };
    };

    RollupModalView.prototype.open = function() {
      var _this = this;
      if (this.opened) {
        return;
      }
      if ($('#modals>div').size()) {
        return;
      }
      $('#modals').removeClass('empty');
      this.opened = true;
      this.openingDelayComplete = false;
      this.stubCustomConfirm();
      if (!$('#modals').parent('body').size()) {
        $('#modals').appendTo($('body'));
      }
      this.$el.appendTo($('#modals'));
      _.defer(function() {
        return _this.$el.addClass('up') && _this.onOpen();
      });
      return _.delay((function() {
        $('body').css({
          height: '100%',
          'overflow-y': 'hidden'
        });
        $('div.rollup-modal.up').click(function(e) {
          if (!$(e.target).hasClass('rollup-modal')) {
            return;
          }
          e.preventDefault();
          return _this.close();
        });
        _this.initScroll = [window.scrollX, window.scrollY];
        _this.escEnabled = true;
        $(window).on('keyup.rollup_modal_esc', function(e) {
          var $dialog;
          if (e.keyCode === 27 && _this.escEnabled) {
            $dialog = $('.ui-dialog:visible');
            if ($dialog.size() > 0) {
              if (!($('.loading:visible', $dialog).size() > 0)) {
                $('.ui-dialog-content', $dialog).dialog('close');
              }
              return;
            }
            return _this.close();
          }
        });
        return _this.openingDelayComplete = true;
      }), 300);
    };

    RollupModalView.prototype.close = function(opts) {
      var _ref;
      if (opts == null) {
        opts = {};
      }
      if (!this.opened) {
        return;
      }
      if ((_ref = opts['confirm']) == null) {
        opts['confirm'] = this.options['confirm'];
      }
      if (opts['confirm'] && !confirm(opts['confirm'])) {
        return false;
      }
      this.escEnabled = true;
      this.opened = false;
      this.$el.removeClass('up');
      this.onClose();
      $('body').css({
        height: 'auto',
        'overflow-y': 'auto'
      });
      _.delay((function() {
        $('#modals').html('');
        if (opts['callback']) {
          return opts['callback'].call(this);
        }
      }), 320);
      $(window).unbind('keyup.rollup_modal_esc');
      $('body').css({
        height: 'auto',
        'overflow-y': 'auto'
      });
      return _.delay((function() {
        $('#modals').html('');
        $('#modals').addClass('empty');
        if (opts['callback']) {
          return opts['callback'].call(this);
        }
      }), 320);
    };

    RollupModalView.prototype.events = {
      'click a.close': 'closeClicked'
    };

    RollupModalView.prototype.closeClicked = function(e) {
      this.close();
      return false;
    };

    RollupModalView.prototype.template = _.template($('#rollup-modal').html());

    RollupModalView.prototype.load = function(url, cb) {
      var $content,
        _this = this;
      if (cb == null) {
        cb = function() {};
      }
      $content = $('.content', this.$el).addClass('loading');
      $content.html('');
      this.open();
      return $.ajax({
        url: url,
        dataType: "html",
        success: function(data) {
          var loadit;
          loadit = function() {
            $content.removeClass('loading');
            $content.html(data);
            cb.apply(_this, arguments);
            if (_this.onLoad) {
              return _this.onLoad.call(_this);
            }
          };
          if (!_this.openingDelayComplete) {
            return _.delay(loadit, 300);
          } else {
            return loadit.call(_this, data);
          }
        }
      });
    };

    RollupModalView.prototype.onClose = function() {
      if (this.options['onClose']) {
        return this.options['onClose'].call(this);
      }
    };

    RollupModalView.prototype.onOpen = function() {
      if (this.options['onOpen']) {
        return this.options['onOpen'].call(this);
      }
    };

    RollupModalView.prototype.onLoad = function() {
      if (this.options['onLoad']) {
        return this.options['onLoad'].call(this);
      }
    };

    RollupModalView.prototype.render = function() {
      var $btn,
        _this = this;
      RollupModalView.__super__.render.apply(this, arguments);
      this.$el.html(this.template(this));
      $btn = null;
      _.each(this.buttons || [], function(btn) {
        var $span;
        $span = $('<span />', {
          "class": 'btn'
        });
        if (btn["class"] != null) {
          $span.addClass(btn["class"]);
        }
        $btn = $('<a />', {
          "class": 'btn'
        });
        $btn.text(btn.name);
        if (btn["class"] != null) {
          $btn.addClass(btn["class"]);
        }
        $span.append($btn);
        return _.defer(function() {
          return $('div.actions', _this.el).append($span);
        });
      });
      return this.el;
    };

    return RollupModalView;

  })(Backbone.View);

}).call(this);
