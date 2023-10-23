(function($) {
  var compare = function(x, y) {
    return ((x < y) ?  1 : ((x > y) ? -1 : 0));
  };

  var parseTitleFloat = function(x) {
    return parseFloat(x.match(/title="*(-?[0-9]+)/)[1]);
  };

  var parseTitleString = function(x) {
    return (x.match(/title=['"](.*?)['"]/) || ['',''])[1];
  };

  $.fn.dataTableExt.oSort['title-numeric-asc']  = function(a,b) {
    return compare(parseTitleFloat(a), parseTitleFloat(b));
  };

  $.fn.dataTableExt.oSort['title-numeric-desc'] = function(a,b) {
    return -compare(parseTitleFloat(a), parseTitleFloat(b));
  };

  $.fn.dataTableExt.oSort['title-string-asc']  = function(a,b) {
    return compare(parseTitleString(a), parseTitleString(b));
  };

  $.fn.dataTableExt.oSort['title-string-desc'] = function(a,b) {
    return -compare(parseTitleString(a), parseTitleString(b));
  };
})(jQuery);
