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
    # A single Related Module
    #
    class Entities.RelatedHosts extends App.Entities.Model
      @include 'VulnAttemptStatuses'

      defaults:{}

      #
      # Fetches tags for the related host
      #
      # @param successCallback [object Function] success callback for fetching tags
      fetchTags: (successCallback) ->
        @fetch
          success:successCallback
          url: Routes.host_tags_path(@id)



    # Contains all Related Modules that are accessible to a specific workspace
    class Entities.RelatedHostsCollection extends App.Entities.Collection

      model: Entities.RelatedHosts

      # @param opts [Object] the options hash
      # @option opts workspace_id [Number] the id of the host to look up accessing creds on
      initialize: (models, opts={}) ->
        @workspace_id = opts.workspace_id || WORKSPACE_ID
        @vuln_id = opts.vuln_id || VULN_ID

      url: =>
        Routes.related_hosts_workspace_vuln_path(@workspace_id,@vuln_id)


    #
    # API
    #

    API =
    # @return [Collection] of all Related Module objects in a given workspace
      getRelatedHosts: (workspace_id, vuln_id) ->
        new Entities.RelatedHostsCollection(
          [],
          {
            workspace_id: workspace_id
            vuln_id: vuln_id
          }
        )


    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "relatedHosts:entities", (opts={}) ->
      wid = if opts.workspace_id then opts.workspace_id else WORKSPACE_ID
      vid = if opts.vuln_id then opts.vuln_id else VULN_ID
      API.getRelatedHosts(wid)


