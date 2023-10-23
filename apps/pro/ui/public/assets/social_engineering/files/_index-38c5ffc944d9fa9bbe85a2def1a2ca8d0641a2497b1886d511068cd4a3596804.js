(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      $("table#files").table({
        searchable: false,
        controlBarLocation: $('.control-bar'),
        datatableOptions: {
          "oLanguage": {
            "sEmptyTable": "No files have been added.  Click 'Add new file' above to add a new one."
          },
          "aaSorting": [[0, 'asc']],
          "aoColumns": [
            {
              "bSortable": false
            }, {}, {}, {}
          ]
        }
      });
      return $('#search').inputHint({
        fadeOutSpeed: 300,
        padding: '2px',
        paddingLeft: '5px'
      });
    });
  });

}).call(this);
