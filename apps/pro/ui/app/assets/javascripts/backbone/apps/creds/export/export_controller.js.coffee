define [
  'base_controller'
  'lib/components/flash/flash_controller'
  'apps/creds/export/export_view'
], ->
  @Pro.module "CredsApp.Export", (Export, App, Backbone, Marionette, $, _) ->
    class Export.Controller extends App.Controllers.Application
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
        @setMainView(new Export.Layout(opts))

      # Interface method required by {Components.Modal}
      onFormSubmit: () ->
        # jQuery Deferred Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)

        inputs = @_mainView.$el.find('input')
        selections =
          selections:
            select_all_state: ( @selectAllState || null )
            selected_ids:     @selectedIDs
            deselected_ids:   @deselectedIDs
        # TODO: This could run up against the limits of the length of a GET request URL, if
        # too many IDs are selected or deselected in the table.
        data = inputs.serialize() + '&' + $.param(selections)

        requestURL = gon.export_workspace_metasploit_credential_cores_path + '?' + data

        $('<iframe/>').attr(src: requestURL, style: 'display: none;').appendTo('body')

        defer.resolve()

        App.execute 'flash:display',
          title:   'Export requested'
          message: 'Your credentials export will begin downloading momentarily.'

        formSubmit

    App.reqres.setHandler 'creds:export', (options={})->
      new Export.Controller options