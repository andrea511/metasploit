(function() {

  define([], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.RightSideScroll = {
        onShow: function() {
          var _this = this;
          return $(window).on(this._customEventName(), _.debounce(function(e) {
            var diff, myTop, top;
            _this.bindUIElements();
            top = $(window).scrollTop();
            myTop = Math.max(top - 120, 0);
            diff = (_this.ui.rightSide.height() + myTop + 20) - _this.ui.leftSide.height();
            if (diff < 0) {
              _this.ui.rightSide.css({
                top: myTop + "px"
              });
            } else {
              _this.ui.rightSide.css({
                top: _this.ui.leftSide.height() - _this.ui.rightSide.height() + 20
              });
            }
            return _this.adjustSize();
          }, 400));
        },
        adjustSize: function() {
          var h, h2, tableH;
          h = $(window).height() - this.$el.offset().top;
          h = Math.max(500, h);
          h2 = h - 150;
          tableH = this.ui.leftSide.height();
          if (tableH < h) {
            h = Math.max(500, tableH);
            h2 = h - 76;
          }
          this.ui.rightSide.height(h + 20);
          this.ui.rightSide.find('.border').height(h2);
          this.ui.rightSide.find('.nano').height(h2);
          return this.trigger('resized');
        },
        onDestroy: function() {
          return $(window).off(this._customEventName());
        },
        _customEventName: function() {
          var _ref, _ref1, _ref2;
          return "scroll.page-" + (((_ref = this.constructor) != null ? (_ref1 = _ref.prototype) != null ? (_ref2 = _ref1.attributes) != null ? _ref2["class"] : void 0 : void 0 : void 0) || '');
        }
      };
    });
  });

}).call(this);
