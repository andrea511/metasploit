(function() {

  jQuery(function($) {
    return $(function() {
      return $(document).ready(function() {
        var t;
        return t = $("#visits-table").table({
          searchable: false,
          controlBarLocation: $('.analysis-control-bar'),
          datatableOptions: {
            "oLanguage": {
              "sEmptyTable": "No visits associated with this campaign yet"
            },
            "aaSorting": [[1, 'asc']],
            "bFilter": false,
            "aoColumns": [{}, {}, {}]
          }
        });
      });
    });
  });

}).call(this);
