(function() {

  beforeEach(function() {
    return this.addMatchers({
      toBeAnInstanceOf: function(klass) {
        return this.actual instanceof klass;
      }
    });
  });

}).call(this);
