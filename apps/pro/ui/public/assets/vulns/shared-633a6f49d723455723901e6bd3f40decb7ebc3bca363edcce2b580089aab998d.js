(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var cloneReferenceFields;
      cloneReferenceFields = function() {
        return $('#references tr:last').clone().css('display', 'none').appendTo('#references tbody');
      };
      cloneReferenceFields();
      $('#add-reference').click(function(e) {
        cloneReferenceFields();
        $('#references tr').eq(-2).show();
        return e.preventDefault();
      });
      return $('td.delete a').on('click', null, function(e) {
        $(this).parents('tr').remove();
        return e.preventDefault();
      });
    });
  });

}).call(this);
