(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var EventAggregator;
    EventAggregator = (function(_super) {

      __extends(EventAggregator, _super);

      function EventAggregator() {
        return EventAggregator.__super__.constructor.apply(this, arguments);
      }

      return EventAggregator;

    })(Backbone.Wreqr.EventAggregator);
    return new EventAggregator();
  });

}).call(this);
