(function() {

  jQuery(function($) {
    return $(function() {
      var $servicesDataTable, $servicesTable, servicesCombinedPath;
      servicesCombinedPath = $('#services-combined-path').html();
      $servicesTable = $('#services-table');
      return $servicesDataTable = $servicesTable.table({
        analysisTab: true,
        searchInputHint: "Search Services",
        datatableOptions: {
          "oLanguage": {
            "sEmptyTable": "No services are associated with this project."
          },
          "aaSorting": [[4, 'desc']],
          "sAjaxSource": servicesCombinedPath,
          "aoColumns": [
            {
              "mDataProp": "name",
              "sWidth": "125px"
            }, {
              "mDataProp": "protocol",
              "sWidth": "60px"
            }, {
              "mDataProp": "port",
              "sWidth": "50px"
            }, {
              "mDataProp": "info",
              "fnRender": function(o) {
                return _.escapeHTML(_.unescapeHTML(o.aData));
              }
            }, {
              "mDataProp": "host_count",
              "sWidth": "150px"
            }
          ]
        }
      });
    });
  });

}).call(this);
