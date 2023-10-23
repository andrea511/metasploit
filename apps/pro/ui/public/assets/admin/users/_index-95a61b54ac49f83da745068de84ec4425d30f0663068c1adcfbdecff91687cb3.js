(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      $('table#users').table({
        searchInputHint: "Search Users",
        datatableOptions: {
          "aaSorting": [[1, 'desc']],
          "aoColumns": [
            {
              "bSortable": false
            }, {}, {}, {}, {}, {}
          ]
        }
      });
      return $('#user-delete-submit').multiDeleteConfirm({
        tableSelector: '#users',
        pluralObjectName: 'users'
      });
    });
  });

}).call(this);
