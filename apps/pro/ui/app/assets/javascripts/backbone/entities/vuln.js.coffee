define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->


    class Entities.Vuln extends App.Entities.Model

      url: ->
        #If model has new_vuln_attempt status we update the status of the last vuln attempt on this vuln
        if @get('new_vuln_attempt_status')?
          Routes.update_last_vuln_attempt_status_workspace_vuln_path(@get('workspace_id'),@get('id'))
        else if @get('restore_vuln_attempt_status')?
          Routes.restore_last_vuln_attempt_status_workspace_vuln_path(@get('workspace_id'),@get('id'))
        else
          Routes.workspace_vuln_path(@get('workspace_id') ? WORKSPACE_ID, @id, format: 'json')

      updateLastVulnStatus: (status) ->
        #For now we send the whole model. When we move to Rails 4 we should use the patch option instead.
        @save({'new_vuln_attempt_status':status},
          success:(model) ->
            model.unset('new_vuln_attempt_status')

        )

      restoreLastVulnStatus: ->
        #For now we send the whole model. When we move to Rails 4 we should use the patch option instead.
        @save({'restore_vuln_attempt_status':true},
          success: (model) ->
            model.unset('restore_vuln_attempt_status')
        )

    #
    # A collection of vulns
    #
    class Entities.VulnsCollection extends App.Entities.Collection
      model: Entities.Vuln

      # @param opts [Object] the options hash
      # @option opts workspace_id [Number] the id of the workspace for which to fetch vulns
      initialize: (models, opts={}) ->
        _.defaults @, { workspace_id: WORKSPACE_ID }

      url: ->
        "#{Routes.workspace_vulns_path (workspace_id: @workspace_id)}.json"

    #
    # API
    #

    API =
      # @return [Collection] of all Vuln objects in a given workspace
      getVulns: (workspace_id) ->
        vulns = new Entities.VulnsCollection [], workspace_id: workspace_id
        vulns

      getVuln: (id) ->
        new Entities.Vuln(id: id)

      newVuln: (attributes = {}) ->
        new Entities.Vuln(attributes)

    #
    # REQUEST HANDLERS
    #

    # @param opts [Object] the options hash
    # @option opts workspace_id [Number] when set, the returned collection contains all Vulns in the
    #   workspace of the given ID. Defaults to workspace id in URL.
    # @option opts fetch [Boolean] When true, automatically fetches the collection as part
    #   of the request. Defaults to true.
    App.reqres.setHandler "vulns:entities", (opts={}) ->
      _.defaults opts, fetch: true

      vulns = API.getVulns opts
      vulns.fetch() if opts.fetch
      vulns

    App.reqres.setHandler "vuln:entity", (id) ->
      API.getVuln id

    App.reqres.setHandler "new:vuln:entity", (attributes) ->
      API.newVuln attributes