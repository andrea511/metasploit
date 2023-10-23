(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Error = (function(_super) {

    __extends(Error, _super);

    function Error(message) {
      this.name = "TeaspoonError";
      this.message = message || "";
    }

    return Error;

  })(Error);

}).call(this);
