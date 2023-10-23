(function() {
  var $;

  $ = jQuery;

  beforeEach(function() {
    return this.addMatchers({
      toContainNodeWithText: function(needle, sel) {
        if (sel == null) {
          sel = '*';
        }
        return _.any($(this.actual).find(sel).andSelf(), function(child) {
          return $(child).clone().children().remove().end().text().indexOf(needle) > -1;
        });
      }
    });
  });

}).call(this);
