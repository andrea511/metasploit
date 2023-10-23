(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      return helpers.loadRemoteTable({
        el: $('#sites_table table'),
        additionalCols: ["id"],
        columns: {
          id: {
            name: "<input type='checkbox' name='sel-all' />",
            bSortable: false,
            mData: null,
            mDataProp: null,
            sWidth: "20px",
            sClass: "less-padding",
            fnRender: function() {
              return "<input type='checkbox' name='sel-all' />";
            }
          }
        },
        dataTable: {
          sAjaxSource: 'web.json'
        }
      });
    });
  });

}).call(this);
