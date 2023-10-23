define ['base_model', 'base_collection'], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    class Entities.Report extends App.Entities.Model
      #urlRoot: -> Routes.report_index_path()

    class Entities.ReportCollection extends App.Entities.Collection
      model: Entities.Report

      #url: -> Routes.report_index_path()

    #
    # API
    #

    API =
      getReports: ->
        reports = new Entities.ReportsCollection
        reports.fetch
          reset: true
        reports

      getReport: (id) ->
        report = new Entities.Report
          id: id
        report.fetch()
        report

      newReport: (attributes = {}) ->
        new Entities.Report(attributes)

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "reports:entities", ->
      API.getReports

    App.reqres.setHandler "reports:entity", (id) ->
      API.getReport id

    App.reqres.setHandler "new:reports:entity", (attributes) ->
      API.newReport attributes