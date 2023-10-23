define [
  'base_layout'
  'base_view'
  'base_itemview'
  'lib/shared/nexpose_push/templates/push_modal_layout'
  'lib/shared/nexpose_push/templates/push_modal_no_console'
], () ->
  @Pro.module 'Shared.NexposePush', (NexposePush, App, Backbone, Marionette, $, _) ->

    #
    # The modal window containing the form for Pushing Vulns to Nexpose
    class NexposePush.ButtonView extends App.Views.ItemView
      template: -> "Push to Nexpose" # Must be the same as the actionButton label.

      # When row is selected, set button state
      # @param tableSelections [Object] the current table selections
      # @option tableSelections selectAllState [String] the state of select all button
      # @option tableSelections selectedIDs [Array<String>] the list of selected vuln id's
      # @option tableSelections deselectedIDs [Array<String>] the list of deselected vuln id's
      #
      onRowsSelected: (tableSelections) ->
        @selectAllState = tableSelections.selectAllState || null
        @selectedIDs = _.map(tableSelections.selectedIDs, (val,id)-> parseInt(id))
        @deselectedIDs = _.map(tableSelections.deselectedIDs, (val,id)-> parseInt(id))

        jQuery.ajax
          url: Routes.push_to_nexpose_status_workspace_vulns_path(workspace_id: WORKSPACE_ID)
          type: 'GET'
          data:
            selections:
              select_all_state: @selectAllState
              selected_ids:     @selectedIDs
              deselected_ids:   @deselectedIDs
            ignore_pagination: true

          # When row is selected, set button state based on response
          # @param data [Object] the response from push status
          # @option data status [Boolean] the status of the button
          # @option data reason [String] the reason for the status
          #
          success: (data) =>
            @_currentStatus = data.status
            if data.status then @enableButton(data.reason) else @disableButton(data.reason)
            @setTooltip(data.reason)

          error: (data) =>
            throw "Error with push_to_nexpose_status endpoint"

      getStatus: -> @_currentStatus

      disableButton: (reason)->
        @$el.parent().addClass 'disabled'

      enableButton: (reason)->
        @$el.parent().removeClass 'disabled'

      # Set tooltip on button
      # @param reason [String] the reason for the button status
      setTooltip: (reason)->
      # Carpenter actionButtons doesn't support adding html title attribute
      # and jquery-ui's tooltip needs one to initialize
        @$el.parent().attr('title', reason)
        @$el.parent().tooltip()

    class NexposePush.ModalView extends App.Views.Layout
      # Render template based on model options
      #
      initialize: ->
        @template = if @model.get('has_console_enabled')
          @templatePath 'nexpose_push/push_modal_layout'
        else
          @templatePath 'nexpose_push/push_modal_no_console'

      className: 'push-view'

      ui:
        datetime: '.datetime'

      onShow: ->
        @ui.datetime.datepicker({minDate:1})


      onBeforeDestroy: ->
        @ui.datetime.datepicker('destroy')

