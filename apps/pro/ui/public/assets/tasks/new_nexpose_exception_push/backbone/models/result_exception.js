(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery'], function($) {
    var ResultException, ResultExceptionCollection;
    ResultException = (function(_super) {

      __extends(ResultException, _super);

      function ResultException() {
        this.url = __bind(this.url, this);
        return ResultException.__super__.constructor.apply(this, arguments);
      }

      ResultException.prototype.defaults = {
        result_exceptions: [],
        module_detail: {}
      };

      ResultException.prototype.url = function(extension) {
        if (extension == null) {
          extension = '.json';
        }
        return "/workspaces/" + WORKSPACE_ID + "/tasks/new_nexpose_exception_push" + extension;
      };

      return ResultException;

    })(Backbone.Model);
    ResultExceptionCollection = (function(_super) {

      __extends(ResultExceptionCollection, _super);

      function ResultExceptionCollection() {
        this.url = __bind(this.url, this);
        return ResultExceptionCollection.__super__.constructor.apply(this, arguments);
      }

      ResultExceptionCollection.prototype.model = ResultException;

      ResultExceptionCollection.prototype.url = function(extension) {
        if (extension == null) {
          extension = '.json';
        }
        return "/workspaces/" + WORKSPACE_ID + "/tasks/new_nexpose_exception_push" + extension;
      };

      return ResultExceptionCollection;

    })(Backbone.Collection);
    return {
      model: ResultException,
      collection: ResultExceptionCollection
    };
  });

}).call(this);
