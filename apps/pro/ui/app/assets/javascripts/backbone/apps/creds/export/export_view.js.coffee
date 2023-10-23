define [
  'base_view'
  'base_layout'
  'apps/creds/export/templates/export_layout'
], () ->
  @Pro.module 'CredsApp.Export', (Export, App) ->
    class Export.Layout extends App.Views.Layout
      template: @::templatePath 'creds/export/export_layout'

      ui:
        filenameInput:       '#filename'
        csvRadioButton:      '#csv'
        pwdumpRadioButton:   '#pwdump'
        selectedRadioButton: '#selected'
        allRadioButton:      '#all'
        formatOption:        'input[name="export_format"]'
        rowOptions:          '.row-options'
        pwdumpWarning:       '.pwdump-warning'

      events:
        'change @ui.formatOption':    'toggleFormatDisplay'

      initialize: (opts) ->
        {
          selectAllState:            @selectAllState
          selectedIDs:               @selectedIDs
          deselectedIDs:             @deselectedIDs
          selectedVisibleCollection: @selectedVisibleCollection
          tableCollection:           @tableCollection
        } = opts
        super(opts)

      onShow: ->
        @setRowOptions()
        @setFilename()

      #
      # Display the row selection options based on how many creds have been selected
      # in the table.
      #
      # @return [void]
      setRowOptions: ->
        unless @selectAllState or @selectedIDs?.length > 0
          @ui.selectedRadioButton.attr 'disabled', true
          @ui.selectedRadioButton.siblings('label').addClass 'disabled'
          @ui.allRadioButton.prop 'checked', true

      #
      # Set an initial filename for the export based on the current timestamp.
      #
      # @return [void]
      setFilename: ->
        filename = 'credentials-' + (new Date().getTime())

        @ui.filenameInput.val filename
        @ui.filenameInput.select()

      #
      # Display the 'selected/all' row options only if the CSV export option is
      # selected. Display the pwdump warning only if pwdump export option is
      # selected.
      #
      # @return [void]
      toggleFormatDisplay: (e) ->
        @ui.rowOptions.toggle    !@ui.pwdumpRadioButton.prop('checked')
        @ui.pwdumpWarning.toggle  @ui.pwdumpRadioButton.prop('checked')




