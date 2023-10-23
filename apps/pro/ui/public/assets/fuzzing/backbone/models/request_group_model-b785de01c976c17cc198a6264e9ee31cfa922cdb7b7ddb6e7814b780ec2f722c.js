(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define([], function() {
    var RequestGroupModel;
    return RequestGroupModel = (function(_super) {

      __extends(RequestGroupModel, _super);

      function RequestGroupModel() {
        return RequestGroupModel.__super__.constructor.apply(this, arguments);
      }

      RequestGroupModel.prototype.url = function() {
        return '/workspaces/' + this.get("workspace_id") + '/fuzzing/fuzzing/' + this.get("fuzzing_id") + '/request_groups';
      };

      return RequestGroupModel;

    })(Backbone.Model);
  });

}).call(this);
