(function() {
  var $;

  $ = jQuery;

  beforeEach(function() {
    return this.addMatchers({
      toContainText: function(needle) {
        return $(this.actual).text().indexOf(needle) > -1;
      }
    });
  });

}).call(this);
