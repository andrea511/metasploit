define [
  'base_model'
  'base_collection'
  'lib/concerns/entities/fetch_ids'
  'lib/concerns/entities/vuln_attempt_statuses'
], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    #
    # A single credential core.
    #
    class Entities.VulnHistory extends App.Entities.Model
      @include 'VulnAttemptStatuses'

    # Contains all Creds that are accessible to a specific workspace
    class Entities.VulnHistoryCollection extends App.Entities.Collection

      model: Entities.VulnHistory

      # @param opts [Object] the options hash
      # @option opts workspace_id [Number] the id of the host to look up accessing creds on
      initialize: (models, opts={}) ->
        @workspace_id = opts.workspace_id || WORKSPACE_ID
        @vuln_id = opts.vuln_id || VULN_ID

      url: =>
        Routes.history_workspace_vuln_path(@workspace_id,@vuln_id)


    #
    # API
    #

    API =
    # @return [Collection] of all Vuln History objects in a given workspace
      getVulnHistory: (workspace_id, vuln_id) ->
        new Entities.VulnHistoryCollection(
          [],
          {
            workspace_id: workspace_id
            vuln_id: vuln_id
          }
        )

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "vulnHistory:entities", (opts={}) ->
      wid = if opts.workspace_id then opts.workspace_id else WORKSPACE_ID
      vid = if opts.vuln_id then opts.vuln_id else VULN_ID
      API.getVulnHistory(wid)


