(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var PollPresenter;
    return PollPresenter = (function(_super) {

      __extends(PollPresenter, _super);

      function PollPresenter() {
        return PollPresenter.__super__.constructor.apply(this, arguments);
      }

      PollPresenter.prototype.urlRoot = "" + (Routes.poll_notifications_messages_path()) + ".json?workspace_id=" + WORKSPACE_ID;

      return PollPresenter;

    })(Backbone.Model);
  });

}).call(this);
