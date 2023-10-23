define [
  'apps/reports/show/show_controller'
  'entities/report'
  'entities/report_artifact'
], ->

  @Pro.module 'ReportsApp', (ReportsApp, App) ->

    class ReportsApp.Router extends Marionette.AppRouter
      appRoutes:
        "reports/:id": "show"

    API =
      show: (id, report, reportArtifacts) ->
        # TODO: Do we need an id? How should we handle it?

        report ?= App.request 'new:reports:entity', gon.report
        reportArtifacts ?= App.request 'new:report_artifacts:entities', gon.report.report_artifacts

        new ReportsApp.Show.Controller
          id: report.id
          report: report
          reportArtifacts: reportArtifacts # TODO: Should these be accessible from the report?

    App.vent.on 'show:report', (report, reportArtifacts) ->
      API.show report.id, report, reportArtifacts

    App.addInitializer ->
      new ReportsApp.Router
        controller: API

    # We're only running show, for the moment.
    App.addInitializer ->
      API.show()

    App.addRegions
      mainRegion:   "#reports-main-region"

    App.addInitializer ->
      @module("ReportsApp").start()
