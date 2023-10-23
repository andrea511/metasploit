define [
  'base_controller'
  'apps/notes/delete/delete_view'
  'lib/concerns/controllers/table_selections'
  'lib/components/flash/flash_controller'
], ->
  @Pro.module "NotesApp.Delete", (Delete, App, Backbone, Marionette, $, _) ->
    class Delete.Controller extends App.Controllers.Application
      @include 'TableSelections'

      # @param [Object] opts the options hash
      # @option opts :selectAllState            [Boolean]
      #   the current state of the select all checkbox
      # @option opts :selectedIDs               [Array<Number>]
      #   the array of currently selected IDs
      # @option opts :deselectedIDs             [Array<Number>]
      #   the array of currently deselected IDs
      # @option opts :selectedVisibleCollection [Entities.Collection]
      #   the collection of currently selected visible records
      # @option opts :tableCollection           [Entities.Collection]
      #   the paginated collection of records for the table
      initialize: (opts) ->
        {
          selectAllState:            @selectAllState
          selectedIDs:               @selectedIDs
          deselectedIDs:             @deselectedIDs
          selectedVisibleCollection: @selectedVisibleCollection
          tableCollection:           @tableCollection
        } = opts
        @setMainView(new Delete.Layout)

      onFormSubmit: ->
        # jQuery Deffered Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)

        jQuery.ajax
          url: Routes.destroy_multiple_workspace_notes_path(workspace_id: WORKSPACE_ID)
          type: 'DELETE'
          data:
            selections:
              select_all_state: ( @selectAllState || null )
              selected_ids:     @selectedIDs
              deselected_ids:   @deselectedIDs
            search: @tableCollection.server_api.search
            ignore_pagination: true

          success: =>
            @tableCollection.removeMultiple @selectedVisibleCollection
            defer.resolve()

            App.vent.trigger 'notes:deleted'

            App.execute 'flash:display',
              title:    "Note#{ @pluralizedMessage '', 's' } deleted"
              message:  "The note#{ @pluralizedMessage ' was', 's were ' } successfully deleted."

          error: =>
            App.execute 'flash:display',
              title:   'An error occurred'
              style:   'error'
              message: "There was a problem deleting the selected note#{ if @multipleSelected() then 's' }"

        formSubmit