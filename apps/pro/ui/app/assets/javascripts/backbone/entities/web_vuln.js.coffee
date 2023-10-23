define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->


    class Entities.WebVuln extends App.Entities.Model

      url: ->
          Routes.workspace_web_vuln_path(@get('workspace_id') ? WORKSPACE_ID, @id, format: 'json')

    #
    # A collection of vulns
    #
    class Entities.WebVulnsCollection extends App.Entities.Collection
      model: Entities.WebVuln

      # @param opts [Object] the options hash
      # @option opts workspace_id [Number] the id of the workspace for which to fetch vulns
      initialize: (models, opts={}) ->
        _.defaults @, { workspace_id: WORKSPACE_ID }

      url: ->
        "#{Routes.workspace_web_vulns_path (workspace_id: @workspace_id)}.json"

    #
    # API
    #

    API =
      # @return [Collection] of all WebVuln objects in a given workspace
      getWebVulns: (workspace_id) ->
        vulns = new Entities.WebVulnsCollection [], workspace_id: workspace_id
        vulns

      getWebVuln: (id) ->
        new Entities.WebVuln(id: id)

      newWebVuln: (attributes = {}) ->
        new Entities.WebVuln(attributes)

    #
    # REQUEST HANDLERS
    #

    # @param opts [Object] the options hash
    # @option opts workspace_id [Number] when set, the returned collection contains all WebVulns in the
    #   workspace of the given ID. Defaults to workspace id in URL.
    # @option opts fetch [Boolean] When true, automatically fetches the collection as part
    #   of the request. Defaults to true.
    App.reqres.setHandler "web_vulns:entities", (opts={}) ->
      _.defaults opts, fetch: true

      vulns = API.getWebVulns opts
      vulns.fetch() if opts.fetch
      vulns

    App.reqres.setHandler "web_vuln:entity", (id) ->
      API.getWebVuln id
