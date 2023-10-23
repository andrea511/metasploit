(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.SingleTabPageView = (function(_super) {

      __extends(SingleTabPageView, _super);

      function SingleTabPageView() {
        return SingleTabPageView.__super__.constructor.apply(this, arguments);
      }

      SingleTabPageView.prototype.initialize = function() {
        return _.bindAll(this, 'render');
      };

      SingleTabPageView.prototype.template = _.template('<div class="cell loading"></div>');

      SingleTabPageView.prototype.render = function() {
        return $($.parseHTML(this.template(this))[0]).appendTo($(this.el));
      };

      return SingleTabPageView;

    })(Backbone.View);
  });

}).call(this);
