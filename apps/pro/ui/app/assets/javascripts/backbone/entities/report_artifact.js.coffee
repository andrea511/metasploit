define ['base_model', 'base_collection'], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    class Entities.ReportArtifact extends App.Entities.Model
      #urlRoot: -> Routes.report_artifact_index_path()

      # @return [Boolean] returns true if the file format is currently regenerating,
      #   false otherwise
      regenerating: ->
        @get('status') == 'regenerating'

    class Entities.ReportArtifactsCollection extends App.Entities.Collection
      model: Entities.ReportArtifact

      comparator: (artifact) ->
        artifact.get 'file_format'

      formats: ->
        _.collect @models, (artifact) -> artifact.get('file_format')

      url: gon.report_artifacts_path

    #
    # API
    #

    API =
      getReportArtifacts: ->
        reportArtifacts = new Entities.ReportArtifactsCollection
        reportArtifacts.fetch
          reset: true
        reportArtifacts

      getReportArtifact: (id) ->
        reportArtifact = new Entities.ReportArtifact
          id: id
        reportArtifact.fetch()
        reportArtifact

      newReportArtifact: (attributes = {}) ->
        new Entities.ReportArtifact(attributes)

      newReportArtifacts: (entities = []) ->
        new Entities.ReportArtifactsCollection entities

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "report_artifacts:entities", ->
      API.getReportArtifacts

    App.reqres.setHandler "report_artifacts:entity", (id) ->
      API.getReportArtifact id

    App.reqres.setHandler "new:report_artifact:entity", (attributes) ->
      API.newReportArtifact attributes

    App.reqres.setHandler "new:report_artifacts:entities", (entities) ->
      API.newReportArtifacts entities