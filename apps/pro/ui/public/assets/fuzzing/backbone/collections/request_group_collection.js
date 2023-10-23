(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/fuzzing/backbone/models/request_group_model-b785de01c976c17cc198a6264e9ee31cfa922cdb7b7ddb6e7814b780ec2f722c.js'], function(RequestGroupModel) {
    var RequestGroupCollection;
    RequestGroupCollection = (function(_super) {

      __extends(RequestGroupCollection, _super);

      function RequestGroupCollection() {
        return RequestGroupCollection.__super__.constructor.apply(this, arguments);
      }

      RequestGroupCollection.prototype.model = RequestGroupModel;

      RequestGroupCollection.prototype.url = function() {
        return '/workspaces/' + this.workspace_id + '/fuzzing/fuzzing/' + this.fuzzing_id + '/request_groups';
      };

      return RequestGroupCollection;

    })(Backbone.Collection);
    return new RequestGroupCollection;
  });

}).call(this);
