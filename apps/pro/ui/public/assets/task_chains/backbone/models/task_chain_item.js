(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var TaskChainItem;
    return TaskChainItem = (function(_super) {

      __extends(TaskChainItem, _super);

      function TaskChainItem() {
        return TaskChainItem.__super__.constructor.apply(this, arguments);
      }

      return TaskChainItem;

    })(Backbone.Model);
  });

}).call(this);
