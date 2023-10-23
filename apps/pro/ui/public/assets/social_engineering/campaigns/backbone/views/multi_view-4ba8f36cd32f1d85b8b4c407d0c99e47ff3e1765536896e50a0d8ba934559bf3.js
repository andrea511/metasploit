(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.MultiView = (function(_super) {

      __extends(MultiView, _super);

      function MultiView() {
        return MultiView.__super__.constructor.apply(this, arguments);
      }

      MultiView.prototype.initialize = function(opts) {
        this.subviews = [];
        this.options = opts;
        this.subviewClasses = opts['subviews'] || [];
        return MultiView.__super__.initialize.apply(this, arguments);
      };

      MultiView.prototype.addSubview = function(subview) {
        this.subviews.push(subview);
        return subview;
      };

      MultiView.prototype.render = function() {
        var el,
          _this = this;
        el = MultiView.__super__.render.apply(this, arguments);
        return this.subviewClasses.each(function(subview) {
          var opts;
          opts = _.extend(_this.options, {
            el: el
          });
          return _this.addSubview(new subview(opts)).render();
        });
      };

      return MultiView;

    })(SingleTabPageView);
  });

}).call(this);
