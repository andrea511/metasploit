(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Teaspoon.Jasmine2.Suite = (function(_super) {

    __extends(Suite, _super);

    function Suite(suite) {
      this.suite = suite;
      this.fullDescription = this.suite.fullName;
      this.description = this.suite.description;
      this.link = this.filterUrl(this.fullDescription);
      this.parent = this.suite.parent;
      this.viewId = this.suite.id;
    }

    return Suite;

  })(Teaspoon.Suite);

}).call(this);
