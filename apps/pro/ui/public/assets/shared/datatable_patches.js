(function() {
  var $;

  $ = jQuery;

  $.fn.dataTable = _.wrap($.fn.dataTable, function(dataTable, opts) {
    opts || (opts = {});
    opts.fnDrawCallback || (opts.fnDrawCallback = (function() {}));
    opts.fnDrawCallback = _.wrap(opts.fnDrawCallback, function(func) {
      $(this).addClass('loaded');
      return func.apply(this, _.toArray(arguments).slice(1));
    });
    return dataTable.apply(this, _.toArray(arguments).slice(1));
  });

}).call(this);
