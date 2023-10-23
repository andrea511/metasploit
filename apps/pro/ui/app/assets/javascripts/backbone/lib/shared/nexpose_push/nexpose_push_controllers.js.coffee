define [
  'entities/vuln'
  'base_controller'
  'apps/vulns/vulns_app'
  'entities/nexpose/exception'
  'apps/vulns/index/index_views'
  'lib/components/modal/modal_controller'
  'lib/concerns/controllers/table_selections'
  'lib/components/analysis_tab/analysis_tab_controller'
  'lib/shared/nexpose_push/nexpose_push_started_controller'
], ->
  @Pro.module "Shared.NexposePush", (NexposePush, App, Backbone, Marionette, $, _) ->
    class NexposePush.ButtonController extends App.Controllers.Application
      # Controller for Nexpose Push Button Component
      #
      #
      # @param opts [Object] the options hash
      # @options opts redirectToTaskLog       [Boolean] navigate to task log after push started
      #   when true, no new modal message will show up but rather navigate to task log directly
      #   when false, a modal message shows after push, with a link to task log
      #
      initialize: (opts) ->
        _.defaults opts,
          redirectToTaskLog: false

        {
          @redirectToTaskLog
        } = opts

        vulns = App.request 'vulns:entities', fetch: false

      getButton: ->
        redirectToTaskLog = @redirectToTaskLog
        return {
          label: 'Push to Nexpose'
          class: 'nexpose nexpose-push disabled'
          click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) =>
            if !(jQuery("a.nexpose-push").hasClass("disabled"))
              request_message = jQuery.ajax
                url: Routes.push_to_nexpose_message_workspace_vulns_path(workspace_id: WORKSPACE_ID)
                type: 'GET'
                selections: {selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection}
                data:
                  selections:
                    select_all_state: selectAllState || null
                    selected_ids:     selectedIDs
                    deselected_ids:   deselectedIDs
                  ignore_pagination: true

              request_message.then (data)->
                opts = {
                  message: data.message
                  has_console: data.has_console
                  has_console_enabled: data.has_console_enabled
                  has_validations: data.has_validations
                  has_exceptions: data.has_exceptions
                  selectAllState: @selections.selectAllState
                  selectedIDs: @selections.selectedIDs
                  deselectedIDs: @selections.deselectedIDs
                  tableCollection: @selections.tableCollection
                  selectedVisibleCollection: @selections.selectedVisibleCollection
                  redirectToTaskLog: redirectToTaskLog
                }
                controller = new App.Shared.NexposePush.ModalController opts
                controller.showModal()
        }


    class NexposePush.ModalController extends App.Controllers.Application
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
      # @option opts :message [String]
      #   the message retrieved from push_to_nexpose_message server endpoint
      # @option opts :title [String]
      #   the title to show in the modal
      # @option opts :pushButtonText [String]
      #   the text of the push button action on modal
      # @options opts :redirectToTaskLog       [Boolean] navigate to task log after push started
      #   when true, no new modal message will show up but rather navigate to task log directly
      #   when false, a modal message shows after push, with a link to task log
      #
      initialize: (opts) ->
        _.defaults opts,
          title: 'Push To Nexpose'
          pushButtonText: 'PUSH'
          redirectToTaskLog: false

        {
          @selectAllState
          @selectedIDs
          @deselectedIDs
          @selectedVisibleCollection
          @tableCollection
          @message
          @has_console
          @has_console_enabled
          @has_validations
          @has_exceptions
          @title
          @pushButtonText
          @redirectToTaskLog
        } = opts

        @_getButtons()
        @setMainView(@_getModalView())

      #
      # Return Array of button config for modal component used by #showModal
      # @see Modal.ModalController
      #
      _getButtons: ->
        return @buttons if @buttons
        # Buttons for modal dependent on has_console_enabled
        @buttons = [ { name: 'Cancel', class: 'close' } ]
        @buttons.push({ name: @pushButtonText, class: 'btn primary' }) if @has_console_enabled

      # Get the proper Modal View
      # Get the view by initializing a Push view with @options passed to the model.
      # @options are used in the template to render based on message, has_console,
      # has_validations, and has_exceptions.
      #
      _getModalView: ->
        @options.reasons = App.Entities.Nexpose.Exception.REASON
        @modalView = @modalView || new NexposePush.ModalView(model: new Backbone.Model(@options))

      # Convert form values to hash
      #
      parseExceptionInfo: ->
        exception_info = {}
        for param in $("#exception-info").serializeArray()
          exception_info[param.name] = param.value
        return exception_info

      _disablePushButton: ->
        @trigger 'btn:disable:modal', @pushButtonText

      # Submit form values to create endpoint on ExportRunsController.
      # Redirect to corresponding task page on success.
      #
      onFormSubmit: ->
      # jQuery Deffered Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)

        exceptionInfo = @parseExceptionInfo()
        @_disablePushButton()
        jQuery.ajax
          url: Routes.workspace_nexpose_result_export_runs_path(workspace_id: WORKSPACE_ID)
          type: 'POST'
          data:
            selections:
              select_all_state: ( @selectAllState || null )
              selected_ids:     @selectedIDs
              deselected_ids:   @deselectedIDs
            reason: exceptionInfo.reason
            expiration_date: exceptionInfo.expiration_date
            approve: exceptionInfo.approve
            comments: exceptionInfo.comments
            ignore_pagination: true

          # Depending on @redirectToTaskLog option, will either shows the push started modal
          #   or redirect to task log
          # @param data [Object] the response from created Export Run
          # @option data redirect_url [String] the url for the new task
          #
          success: (data)=>
            defer.resolve()
            App.vent.trigger 'vulns:push:completed'
            if @redirectToTaskLog
              window.location.href = data.redirect_url
            else
              @_showPushStartedModal(data.redirect_url)

          error: =>
            App.execute 'flash:display',
              title:   'An error occurred'
              style:   'error'
              message: "There was a problem pushing the results to Nexpose."

        formSubmit

      #
      # Shows the Modal for this controller
      #
      showModal: ->
        App.execute "showModal", @,
          modal:
            title: @title
            description: @message
            hideBorder:true
            width:  400
          closeCallback: () =>
            @trigger("modal:close")
          buttons: @buttons
        , (data)->
          throw "Error with push_to_nexpose_message endpoint"

      #
      # Shows (replaces) the modal with the Push Started modal
      #
      _showPushStartedModal: (redirectUrl)->
        controller = new App.Shared.NexposePush.StartedController
          redirectUrl: redirectUrl
        controller.showModal()
