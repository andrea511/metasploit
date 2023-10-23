(function() {
  var $;

  $ = jQuery;

  beforeEach(function() {
    return this.addMatchers({
      toHaveNodes: function($nodeArr) {
        var actualNode, matches, node, _i, _j, _len, _len1, _ref;
        matches = 0;
        for (_i = 0, _len = $nodeArr.length; _i < _len; _i++) {
          node = $nodeArr[_i];
          _ref = this.actual;
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            actualNode = _ref[_j];
            if (actualNode === node) {
              matches = matches + 1;
            }
          }
        }
        return matches === this.actual.length;
      }
    });
  });

}).call(this);
