define [
  'base_model'
  'base_collection'
  'lib/concerns/entities/fetch_ids'
], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    #
    # A single Related Module
    #
    class Entities.RelatedModules extends App.Entities.Model

    class Entities.WorkspaceRelatedModules extends App.Entities.Model

    defaults:{}



    # Contains all Related Modules that are accessible to a specific workspace
    class Entities.RelatedModulesCollection extends App.Entities.Collection

      model: Entities.RelatedModules

      # @param opts [Object] the options hash
      # @option opts workspace_id [Number] the id of the host to look up accessing creds on
      initialize: (models, opts={}) ->
        @workspace_id = opts.workspace_id || WORKSPACE_ID
        @vuln_id = opts.vuln_id || VULN_ID

      url: =>
        Routes.related_modules_workspace_vuln_path(@workspace_id,@vuln_id)

    # Contains all Related Modules that are accessible to a specific workspace
    class Entities.WorkspaceRelatedModulesCollection extends App.Entities.Collection

      model: Entities.WorkspaceRelatedModules

      # @param opts [Object] the options hash
      # @option opts workspace_id [Number] the id of the host to look up accessing creds on
      initialize: (models, opts={}) ->
        @workspace_id = opts.workspace_id || WORKSPACE_ID

      url: =>
        Routes.workspace_related_modules_path(@workspace_id)


    #
    # API
    #

    API =
    # @return [Collection] of all Related Module objects in a given workspace
      getRelatedModules: (workspace_id, vuln_id) ->
       new Entities.RelatedModulesCollection(
          [],
          {
            workspace_id: workspace_id
            vuln_id: vuln_id
          }
        )

      getWorkspaceRelatedModules: (workspace_id) ->
        new Entities.WorkspaceRelatedModulesCollection(
          [],
          {
            workspace_id: workspace_id
          }
        )


    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "relatedModules:entities", (opts={}) ->
      wid = if opts.workspace_id then opts.workspace_id else WORKSPACE_ID
      vid = if opts.vuln_id then opts.vuln_id else VULN_ID
      API.getRelatedModules(wid)

    App.reqres.setHandler "workspaceRelatedModules:entities", (opts={}) ->
      wid = if opts.workspace_id then opts.workspace_id else WORKSPACE_ID
      API.getWorkspaceRelatedModules(wid)


