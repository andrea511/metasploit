define [ 
  'base_controller',
  'entities/report_artifact'
  'entities/report'
  'apps/reports/show/show_view'
], ->
  @Pro.module "ReportsApp.Show", (Show, App) ->
    class Show.Controller extends App.Controllers.Application

      initialize: (options) ->
        { report, id, reportArtifacts } = options
        report or= App.request 'report:entity', id
        reportArtifacts or= App.request 'report_artifacts:entities'

        selectedReportArtifact = App.request 'report:formats:next', reportArtifacts

        @listenTo report, 'updated', ->
          App.vent.trigger 'report:updated', report
          # TODO: Do we need to listen to artifact updates? Likely not, I suppose.

        # TODO: figure out how to activate this when we load with gon
        # Will also need it to coordinate fetching of multiple objects
        #App.execute "when:fetched", report, =>
        @layout = @getLayoutView()

        @listenTo @layout, "show", =>
          @headerRegion report
          @infoRegion report
          @formatsRegion report, reportArtifacts
          @actionsRegion()
          @displayRegion selectedReportArtifact, reportArtifacts

        @show @layout

      # Display the most recently selected report artifact.
      #
      # @param reportArtifact [Entities.ReportArtifact] the selected report artifact
      showReportArtifact: (reportArtifact) ->
        @layout.displayRegion.reset()
        @displayRegion reportArtifact

      #
      # REGION INITIALIZERS
      #
      headerRegion: (report) ->
        headerView = @getHeaderView report
        @layout.headerRegion.show headerView

      infoRegion: (report) ->
        infoView = @getInfoView report
        @layout.infoRegion.show infoView

      formatsRegion: (report, reportArtifacts) ->
        formatsView = @getFormatsView report, reportArtifacts
        @layout.formatsRegion.show formatsView

      actionsRegion: ->
        actionsView = @getActionsView()
        @layout.actionsRegion.show actionsView

      displayRegion: (reportArtifactToDisplay, reportArtifacts) ->
        displayView = @getDisplayView reportArtifactToDisplay, reportArtifacts
        @layout.displayRegion.show displayView

      #
      # VIEW ACCESSORS
      #
      getLayoutView: ->
        new Show.Layout

      getHeaderView: (report) ->
        new Show.Header
          model: report

      getInfoView: (report) ->
        new Show.Info
          model: report

      getFormatsView: (report, reportArtifacts) ->
        new Show.Formats
          collection: reportArtifacts
          report: report

      getActionsView: ->
        new Show.Actions

      # Instantiate a new artifact display view.
      #
      # @param reportArtifact  [Entities.ReportArtifact] the artifact to display
      # @param reportArtifacts [Entities.ReportArtifactsCollection] the collection
      #   of all artifacts
      #
      # @return [Show.Display] the instantiated view
      getDisplayView: (reportArtifact, reportArtifacts) ->
        new Show.Display
          model: reportArtifact
          reportArtifacts: reportArtifacts

    API =
      # @return [Array<Entities.ReportArtifact>] the currently selected report formats
      selectedFormatCheckboxes: ->
        Pro.mainRegion.currentView.formatsRegion.currentView.selectedFormats()

      # @return [Entities.ReportArtifact] the currently regenerating report format
      regeneratingFormats: ->
        Pro.mainRegion.currentView.formatsRegion.currentView.regeneratingFormats()

      displayReportArtifact: (reportArtifact, reportArtifacts) ->
        # TODO: Is there a better way to do this without replicating the
        # displayRegion function?
        Pro.mainRegion.currentView.displayRegion.reset()
        displayView = new Show.Display model: reportArtifact, reportArtifacts: reportArtifacts
        Pro.mainRegion.currentView.displayRegion.show displayView

      # Pick the first report artifact to display.
      #
      # @param reportArtifacts [Entities.ReportArtifactsCollection] the report artifacts
      #   for this report
      #
      # @return [Entities.ReportArtifact] the report artifact to display next
      nextFormatToDisplay: (reportArtifacts) ->
        getNextArtifact = () ->
          return pdf  if pdf  = reportArtifacts.findWhere file_format: 'pdf',  not_generated: false
          return html if html = reportArtifacts.findWhere file_format: 'html', not_generated: false
          return rtf  if rtf  = reportArtifacts.findWhere file_format: 'rtf',  not_generated: false
          return word if word = reportArtifacts.findWhere file_format: 'word', not_generated: false

        initialArtifact = getNextArtifact()

        initialArtifact.set 'displayed', true if initialArtifact

        initialArtifact

    # Fetch the report artifact entities for the currently selected artifacts.
    App.reqres.setHandler 'report:formats:selected', API.selectedFormatCheckboxes

    # Fetch the report artifact entity that is currently regenerating.
    App.reqres.setHandler 'report:formats:regenerating', API.regeneratingFormats

    App.commands.setHandler 'report:formats:display', (reportArtifact, reportArtifacts) ->
      App.vent.trigger 'report:formats:displayed', reportArtifact
      API.displayReportArtifact(reportArtifact, reportArtifacts)

    App.reqres.setHandler 'report:formats:next', API.nextFormatToDisplay

