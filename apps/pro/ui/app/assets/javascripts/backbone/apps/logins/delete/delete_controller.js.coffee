define [
  'base_controller'
  'apps/logins/delete/delete_view'
  'lib/concerns/controllers/table_selections'
], ->
  @Pro.module "LoginsApp.Delete", (Delete, App, Backbone, Marionette, $, _) ->
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
      # @option opts :credID                    [Number]
      #   the ID of the cred for which logins are being deleted
      initialize: (opts) ->
        { @selectAllState, @selectedIDs, @deselectedIDs,
          @selectedVisibleCollection, @tableCollection, @credID } = opts
        @setMainView(new Delete.Layout)

      onFormSubmit: =>
        # jQuery Deffered Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)

        # TODO: Ewwww, this is awful. But we don't have client-side route generation,
        # for the moment, so it will have to suffice. Ew.
        destroyPath = gon.destroy_multiple_workspace_metasploit_credential_cores_path.split('/')
        destroyPath.splice(6, 0, @credID, "logins").shift()
        destroyPath = destroyPath.join('/')

        jQuery.ajax
          url: destroyPath
          type: 'DELETE'
          data:
            selections:
              select_all_state: ( @selectAllState || null )
              selected_ids:     @selectedIDs
              deselected_ids:   @deselectedIDs
            ignore_pagination: true

          success: =>
            @tableCollection.removeMultiple @selectedVisibleCollection.models
            defer.resolve()

            App.vent.trigger 'logins:deleted'

            App.execute 'flash:display',
              title:    "Login#{ @pluralizedMessage '', 's' }  deleted"
              message:  "The login#{ @pluralizedMessage ' was', 's were ' } successfully deleted."

          error: =>
            App.execute 'flash:display',
              title:   'An error occurred'
              style:   'error'
              message: 'There was a problem deleting the selected login(s).'

        formSubmit
