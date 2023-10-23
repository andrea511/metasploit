define [
  'jquery'
  'backbone_chooser'
], ($) ->
  @Pro.module "Concerns", (Concerns, App) ->

    # Adds a #fetchIDs method to a collection that fetches all IDs from the server
    Concerns.FetchIDs =

      # Does an AJAX GET on the collection's URL, adding a "ids_only" paramater
      #  to tell the server to only return all the IDs.
      #
      # @param tableSelections [Object] data about the current state of the table's selections
      #
      # @return [Deferred] jquery deferred object
      fetchIDs: (tableSelections,opts={ignore_if_no_selections:false}) ->
        # TODO: We really need a common way to extract params out of the tableSelections object.
        $.getJSON _.result(@, 'url'),
          ids_only: 1
          selections:
            select_all_state: ( tableSelections.selectAllState || null )
            selected_ids:     Object.keys tableSelections.selectedIDs
            deselected_ids:   Object.keys tableSelections.deselectedIDs
            ignore_if_no_selections: opts.ignore_if_no_selections
          search: @server_api.search