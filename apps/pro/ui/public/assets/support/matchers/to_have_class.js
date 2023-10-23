(function() {
  var $;

  $ = jQuery;

  beforeEach(function() {
    return this.addMatchers({
      toHaveClass: function(klass) {
        return _.all($(this.actual), function(el) {
          return $(el).hasClass(klass);
        });
      }
    });
  });

}).call(this);
