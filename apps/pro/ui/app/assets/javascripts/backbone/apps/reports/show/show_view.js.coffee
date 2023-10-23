define [
  'jquery'
  'base_view'
  'base_itemview'
  'base_layout'
  'base_compositeview'
  'apps/reports/show/templates/_file_format'
  'apps/reports/show/templates/show_actions'
  'apps/reports/show/templates/show_display'
  'apps/reports/show/templates/show_email_form'
  'apps/reports/show/templates/show_formats'
  'apps/reports/show/templates/show_header'
  'apps/reports/show/templates/show_info'
  'apps/reports/show/templates/show_info_dialog'
  'apps/reports/show/templates/show_layout'
  'apps/reports/preload_images'
  'entities/report_artifact'
  'entities/report'
],  ($)->

  @Pro.module 'ReportsApp.Show', (Show, App, Backbone, Marionette, jQuery, _) ->

    class Show.Layout extends App.Views.Layout
      # TODO: We could use the custom renderer with our own global template lookup.
      template: @::templatePath 'reports/show/show_layout'

      regions:
        headerRegion:  '#report-header-region'
        infoRegion:    '#report-info-region'
        formatsRegion: '#report-formats-region'
        actionsRegion: '#report-actions-region'
        displayRegion: '#report-display-region'

    # Header displaying basic report information.
    class Show.Header extends App.Views.ItemView
      template: @::templatePath 'reports/show/show_header'

    # Report information panel.
    class Show.Info extends App.Views.ItemView
      template: @::templatePath 'reports/show/show_info'
      className: 'info-wrapper'

      events:
        'click #report-info-button': 'showReportInfo'

      showReportInfo: ->
        @showDialog new Show.InfoDialog(model: @model),
          title: 'Report Information'
          class: 'report-info-dialog'
          buttons: [
            {name: 'Close', class: 'close'}
          ]

    class Show.InfoDialog extends App.Views.ItemView
      template: @::templatePath 'reports/show/show_info_dialog'

    # A single report format.
    class Show.Format extends App.Views.ItemView
      template: @::templatePath 'reports/show/_file_format'
      tagName: 'li'
      className: 'file-format'
      ui: {
        regenerate_button: '.regenerate-button',
        format_button: '.format-button'
      }

      events:
        'click @ui.regenerate_button': 'regenerateFormat',
        'click @ui.format_button': 'handleFormatClick'

      modelEvents:
        'change': 'render'

# Initiate the display or regeneration of the selected format.
      handleFormatClick: ->
        unless @model.get('displayed') || @model.get('not_generated')
          App.execute 'report:formats:display', @model

      # Initiate regeneration of the format.
      regenerateFormat: ->
        if @model.get('artifact_file_exists')
          alert('Please delete existing report type before generating')
        else if !@model.get('artifact_file_exists') && !@model.get('not_generated')
          alert('Report artifact not found on filesystem. Please delete this format and regenerate it.')
        else if !@model.regenerating()
          # For the moment, only allow one format to be regenerated at a time.
          regeneratingFormat = App.request 'report:formats:regenerating'

          if regeneratingFormat
            alert "Please wait until the #{regeneratingFormat.get('file_format')} format is done generating."
            return false

          @model.set('status', 'regenerating')
          App.vent.trigger 'report:formats:regenerating', @model

          @addTooltip()

          file_format = @model.get('file_format')
          # TODO: Since this is doing communication with the back-end, it belongs
          # on the collection object.
          $.ajax
            url: gon.regenerate_format_path,
            type: 'POST'
            data: {file_format}
            success: =>
              @poll()
            error: =>
              @model.set 'status', 'error'
              # TODO: Set a tooltip.

      pollingInterval: 5000

      # Poll for the status of the regenerating format.
      poll: =>
        fetchStatus = =>
          file_format = @model.get('file_format')
          $.ajax
            url: gon.regeneration_status_path,
            type: 'POST'
            data: { file_format }
            success: (data) =>
              if data.status == 'complete'
                @model.set data
                @addTooltip()
                App.vent.trigger 'report:formats:regenerated', @model
              else
                @model.set 'status', data.status
                @_poller = setTimeout((=> fetchStatus()), @pollingInterval)
            error: =>
              @model.set 'status', 'error'
              # TODO: Set a tooltip

        fetchStatus()

      startPoll: ->
        # If the format is currently regenerating, kick off a status poller.
        if @model.regenerating()
          @poll()

      # Stop polling for format regeneration status.
      stopPoll: =>
        clearTimeout(@_poller)

      # Add tooltip data for the format button.
      # TODO: The accessed date does not update when the user
      # accesses this themselves.
      addTooltip: ->
        if @model.regenerating()
          @ui.format_button.tooltip content: 'Regenerating.'
        else if @model.get 'not_generated'
          @ui.format_button.tooltip content: 'Not yet generated.'
        else if !@model.get 'artifact_file_exists'
          @ui.format_button.tooltip content: 'Error finding report artifact on filesystem. '
        else
          tip = "Created #{@model.get('pretty_created_at')}"
          tip += "<br />Accessed #{@model.get('pretty_accessed_at')}" if @model.get('pretty_accessed_at')

          @ui.format_button.tooltip content: tip

      # Be sure to stop polling if we close the view.
      onDestroy: => @stopPoll()

      onShow: ->
        @startPoll()
        @addTooltip()

    # The list of report formats.
    class Show.Formats extends App.Views.CompositeView
      template: @::templatePath 'reports/show/show_formats'
      childView: Show.Format
      childViewContainer: 'ul'
      className: 'info-wrapper'

      initialize: (options) ->
        App.vent.on 'report:formats:destroyed', (reportArtifact) =>
          @handleFormatDestruction reportArtifact
        App.vent.on 'report:formats:displayed', (reportArtifact) =>
          @handleArtifactDisplay reportArtifact

        @report = options.report
        super(options)

      regeneratingFormats: =>
        @collection.findWhere status: 'regenerating'

      # Display the next format in the list when an artifact is destroyed.
      #
      # @param reportArtifact [Entity.ReportArtifact] the artifact that was destroyed
      handleFormatDestruction: (reportArtifact) =>
        @render()

        # Trigger the display of a new format if the currently displayed one has
        # been deleted, or if no formats remain.
        if reportArtifact.get 'displayed'
          nextArtifact = App.request 'report:formats:next', @collection
          App.execute 'report:formats:display', nextArtifact, @collection
        else if @collection.where(not_generated: true).size() == @collection.size()
          App.execute 'report:formats:display', null, @collection

      # Hide the indicator for the currently displayed report format.
      handleArtifactDisplay: (reportArtifact) ->
        if reportArtifact
          displayed = @collection.findWhere(displayed: true)
          displayed.set(displayed: false) if displayed
          reportArtifact.set 'displayed', true

      # Fetch the currently selected report formats.
      #
      # @return [Array<Entity.ReportArtifact>] the selected formats
      selectedFormats: =>
        currentlySelectedFormats = []

        @children.each (formatView) ->
          if formatView.$el.find('input[type=checkbox]').prop('checked')
            currentlySelectedFormats.push(formatView.model)

        currentlySelectedFormats

      # Generate a collection of all report artifacts, both those that are allowed
      # and those that have already been generated.
      #
      # @return [Entities.ReportArtifactsCollection] the allowed and generated artifacts
      allReportFormats: ->
        reportArtifactsAndFormats = new App.Entities.ReportArtifactsCollection

        _.each @report.get('allowed_file_formats'), (format) =>
          existingArtifact = @collection.where file_format: format

          if existingArtifact.size() > 0
            existingArtifact = existingArtifact.first()
            unless existingArtifact.get('artifact_file_exists') || existingArtifact.get('not_generated')
              existingArtifact.set('status','error')
            reportArtifactsAndFormats.add existingArtifact
          else
            reportArtifactsAndFormats.add file_format: format, not_generated: true

        # Mark any formats that are currently regenerating as such.
        if @report.get('state') == 'regenerating'
          regeneratingFormats = @report.get('file_formats')

          _.each regeneratingFormats, (fileFormat) ->
            regeneratingArtifact = new App.Entities.ReportArtifact
              file_format: fileFormat
              status: 'regenerating'

            # Use `remove` rather than `destroy`, to avoid potentially deleting
            # existing artifacts.
            reportArtifactsAndFormats.remove(reportArtifactsAndFormats.findWhere(file_format: fileFormat))
            reportArtifactsAndFormats.add regeneratingArtifact

        reportArtifactsAndFormats

      onBeforeRender: ->
        @collection = @allReportFormats()

    # The list of report actions.
    class Show.Actions extends App.Views.ItemView
      template: @::templatePath 'reports/show/show_actions'
      className: 'info-wrapper'

      events:
        'click #download-report': 'downloadReportArtifact'
        'click #destroy-report': 'destroyReportArtifacts'
        'click #email-report': 'emailReportArtifacts'

      # Download a single selected report artifact.
      # TODO: make both of these 'download/destroy format' instead of 'report'
      downloadReportArtifact: ->
        selectedFormats = App.request 'report:formats:selected'

        switch
          when selectedFormats.size() == 0 then alert 'Please select a report format to download.'
          when selectedFormats.size() > 1 then alert 'Please select a single report format for downloading.'
          else
            $('<iframe/>').attr(src: selectedFormats[0].get('download_url'), style: 'display: none;').appendTo(@$el)

      # Destroy multiple selected report artifacts.
      destroyReportArtifacts: =>
        selectedFormats = App.request 'report:formats:selected'

        if selectedFormats.size() == 0
          alert 'Please select at least one report format to destroy.'
          return false
        else if selectedFormats.size() == 1
          selectedFormatsIndicator = 'format'
        else if selectedFormats.size() > 1
          selectedFormatsIndicator = 'formats'

        if confirm "Are you sure you want to destroy the selected #{selectedFormatsIndicator}?"
          _.each selectedFormats, (format) ->
            format.destroy(silent: true)
            App.vent.trigger 'report:formats:destroyed', format

      # Prompt for addresses, then email multiple report artifacts.
      emailReportArtifacts: ->
        selectedFormats = App.request 'report:formats:selected'

        if selectedFormats.size() == 0
          alert 'Please select at least one report format to email.'
          return false

        @showDialog new Show.EmailForm,
          title: 'Email Report'
          height: 200
          class: 'report-email-dialog'
          buttons: [
            {name: 'Cancel', class: 'close'},
            {name: 'Send', class: 'btn primary'}
          ]

    class Show.EmailForm extends App.Views.ItemView
      template: @::templatePath 'reports/show/show_email_form'

      ui:
        reportEmailAddressesTextarea: '#report-email-addresses'

      onDialogButtonPrimaryClicked: ->
        @sendEmail()

      # Send the selected report formats in an email to the specified users.
      sendEmail: ->
        emailAddresses = @ui.reportEmailAddressesTextarea.val()

        selectedFormats = App.request 'report:formats:selected'
        reportArtifactIDs = _.collect selectedFormats, (format) ->
          format.id

        # TODO: Since this is doing communication with the back-end, it belongs
        # on the collection object.
        $.post(
          gon.email_report_artifacts_path,
          {
            recipients: emailAddresses,
            report_artifact_ids: reportArtifactIDs
          }
        )

    class Show.Display extends App.Views.ItemView
      template: @::templatePath 'reports/show/show_display'

      ui:
        displayPanel:           '#report-display-panel'
        messages:               '.report-display-panel-message'
        unembeddableMessage:    '#unembeddable-message'
        noArtifactsMessage:     '#no-artifacts-message'
        brokenArtifactMessage:  '#broken-artifact-message'

      initialize: (options) ->
        @reportArtifacts = options.reportArtifacts
        super(options)

      # Display the report artifact correctly, based on its format.
      displayArtifact: ->
        if @reportArtifacts && (@reportArtifacts.size() == 0 || @reportArtifacts.where(not_generated: true).size() == @reportArtifacts.size())
          @ui.noArtifactsMessage.css 'display', 'table'
        else if !@model.get('artifact_file_exists')
          @ui.brokenArtifactMessage.css 'display', 'table'
        else
          @ui.messages.hide()
          switch @model.get 'file_format'
            when 'pdf'  then @displayPDF()
            when 'html' then @displayHTML()
            when 'rtf'  then @ui.unembeddableMessage.css 'display', 'table'
            when 'word' then @ui.unembeddableMessage.css 'display', 'table'

      # Display the HTML version of the report in the display panel.
      displayHTML: ->
        @$el.html "<iframe src='#{@model.get('url')}' seamless='seamless'></iframe>"

      # Display the PDF version of the report in the display panel.
      displayPDF: ->
        pdfEmbed = "
        <object width=\"100%\" height=\"100%\" type=\"application/pdf\" data=\"#{@model.get('url')}\" id=\"pdf\">
          <div id=\"report-pdf-embed-error-message\" class=\"report-display-panel-message\">
            <p>It appears you don't have Adobe Reader or PDF support in this web browser.
            <a href=\"#{@model.get('download_url')}\">Click here to download the PDF.</a></p>
          </div>
       </object>"

        @ui.displayPanel.append pdfEmbed

      onShow: ->
        @displayArtifact()
