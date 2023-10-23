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
    # A single Fdns (Forward DNS)
    #
    class Entities.Fdns extends App.Entities.Model

      #
      # Url for updating or creating a Fdns. Prototype tweaks the content-types so we need to be explicit with .json
      #
      # @return [String] url for updating/creating a cred
      url: ->
        Routes.workspace_sonar_fdnss_index_path(WORKSPACE_ID)+'.json'


    #
    # A collection of credentials
    #

    # Contains all Creds that are accessible to a specific workspace
    class Entities.FdnsCollection extends App.Entities.Collection

      @include 'FetchIDs'

      model: Entities.Fdns

      initialize: (models,opts) ->
        @import_run_id = opts.import_run_id

      url: =>
        Routes.workspace_sonar_import_fdnss_index_path(WORKSPACE_ID,@import_run_id)+'.json'


    API =
      # @return [Collection] of all Cred objects in a given workspace
      getFdnss: (opts) ->
        new Entities.FdnsCollection([], opts)

    #
    # REQUEST HANDLERS
    #

    # @param opts [Object] the options hash
    # @option opts workspace_id [Number] when set, the returned collection contains all Fdnss in the
    #   workspace of the given ID
    App.reqres.setHandler "fdnss:entities", (opts={}) ->
      API.getFdnss(opts)

