(function() {

  define(['jquery', 'backbone_chooser'], function($) {
    return this.Pro.module("Concerns", function(Concerns, App) {
      return Concerns.FetchIDs = {
        fetchIDs: function(tableSelections, opts) {
          if (opts == null) {
            opts = {
              ignore_if_no_selections: false
            };
          }
          return $.getJSON(_.result(this, 'url'), {
            ids_only: 1,
            selections: {
              select_all_state: tableSelections.selectAllState || null,
              selected_ids: Object.keys(tableSelections.selectedIDs),
              deselected_ids: Object.keys(tableSelections.deselectedIDs),
              ignore_if_no_selections: opts.ignore_if_no_selections
            },
            search: this.server_api.search
          });
        }
      };
    });
  });

}).call(this);
