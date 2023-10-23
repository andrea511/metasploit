(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      $("table#attack-list").table({
        searchable: false,
        controlBarLocation: $('.control-bar'),
        datatableOptions: {
          "oLanguage": {
            "sEmptyTable": "No target lists are associated with this project. Click 'Create Target List' above to create a new one."
          },
          "aaSorting": [[0, 'asc']],
          "aoColumns": [
            {
              "bSortable": false
            }, {}, {}, {}
          ]
        }
      });
      $('#search').inputHint({
        fadeOutSpeed: 300,
        padding: '2px',
        paddingLeft: '5px'
      });
      return $('.button a.export_data').click(function(e) {
        var id;
        id = $("table.list tbody tr td input[type='checkbox']").filter(':checked').attr('value');
        window.location.href += '/' + id + '/export.csv';
        return e.preventDefault();
      });
    });
  });

}).call(this);
