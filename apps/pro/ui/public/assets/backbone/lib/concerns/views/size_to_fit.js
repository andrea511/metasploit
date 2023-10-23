(function() {

  define(['jquery'], function($) {
    return this.Pro.module("Concerns", function(Concerns, App) {
      var MAX_RECURSION, MIN_HEIGHT, RESIZE_EVENT;
      RESIZE_EVENT = 'resize.sizeToFit';
      MAX_RECURSION = 5;
      MIN_HEIGHT = 300;
      return Concerns.SizeToFit = {
        sizeToFit: true,
        resizeDisabled: false,
        _stopTheLoop: 0,
        initialize: function(opts) {
          if (opts == null) {
            opts = {};
          }
          opts = _.defaults(opts, {
            sizeToFit: true,
            resizeDisabled: false
          });
          this.sizeToFit = opts.sizeToFit;
          this.resizeDisabled = opts.resizeDisabled;
          this.onResize = _.bind(this.onResize, this);
          return this.inModal = false;
        },
        onShow: function() {
          this.inModal = this.$el.parents('#modals').length > 0;
          if (this.sizeToFit) {
            $(window).on(RESIZE_EVENT, this.onResize);
          }
          if (this.sizeToFit) {
            return this.onResize();
          }
        },
        onDestroy: function() {
          if (this.sizeToFit) {
            return $(window).off(RESIZE_EVENT, this.onResize);
          }
        },
        onResize: function() {
          var diff, resize, tryResize, _ref, _ref1,
            _this = this;
          if (this.inModal) {
            if ((_ref = this.ui.resizeEl) != null) {
              _ref.height(Math.max((_ref1 = this.ui.resizeEl) != null ? _ref1.height() : void 0, 600));
            }
            tryResize = function() {
              var height, _ref2;
              height = $(document.body).height() - 80 - _this.ui.resizeEl.offset().top;
              if (height < 100) {
                return _.delay(tryResize, 600);
              }
              if ((_ref2 = _this.ui.resizeEl) != null) {
                _ref2.height(height);
              }
              return _this.trigger('sizetofit:resized');
            };
            _.delay(tryResize, 600);
            return;
          }
          this._stopTheLoop++;
          if (this.resizeDisabled || !this.$el.is(':visible')) {
            this._stopTheLoop = 0;
            return;
          }
          if (this._stopTheLoop > MAX_RECURSION) {
            this._stopTheLoop = 0;
            this.trigger('sizetofit:resized');
            return;
          }
          resize = function() {
            var origHeight, _ref2, _ref3;
            origHeight = (_ref2 = _this.ui.resizeEl) != null ? _ref2.height() : void 0;
            if ((_ref3 = _this.ui.resizeEl) != null) {
              _ref3.height(Math.max(origHeight + diff, MIN_HEIGHT));
            }
            return _.defer(function() {
              return _this.onResize();
            });
          };
          diff = document.documentElement.scrollHeight - $(document.body).height();
          if (diff > 0) {
            return resize();
          }
          diff = $(window).height() - $(document.body).height();
          if (diff < 0) {
            return resize();
          }
          return this.trigger('sizetofit:resized');
        },
        setResizeDisabled: function(disabled) {
          var _ref;
          this.resizeDisabled = disabled;
          if (disabled) {
            return (_ref = this.ui.resizeEl) != null ? _ref.removeAttr('height').css({
              height: 'auto'
            }) : void 0;
          } else {
            return this.onResize();
          }
        }
      };
    });
  });

}).call(this);
