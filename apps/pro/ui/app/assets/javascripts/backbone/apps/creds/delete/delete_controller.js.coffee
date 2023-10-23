define [
  'base_controller'
  'apps/creds/delete/delete_view'
  'lib/concerns/controllers/table_selections'
], ->
  @Pro.module "CredsApp.Delete", (Delete, App, Backbone, Marionette, $, _) ->
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
          url: gon.destroy_multiple_workspace_metasploit_credential_cores_path
          type: 'DELETE'
          data:
            selections:
              select_all_state: ( @selectAllState || null )
              selected_ids:     @selectedIDs
              deselected_ids:   @deselectedIDs
            search:
              @tableCollection.server_api.search
            ignore_pagination: true

          success: =>
            @tableCollection.removeMultiple @selectedVisibleCollection.models
            defer.resolve()

            App.vent.trigger 'creds:deleted'

            App.execute 'flash:display',
              title:    "Credential#{ @pluralizedMessage '', 's' } deleting"
              message:  "Your credentials are being deleted, this may take a while. A notification will appear when done."

        formSubmit
