define [
  'base_model'
  'base_collection'
  'lib/concerns/entities/fetch_ids'
], ->
  @Pro.module "Entities.SocialEngineering", (SocialEngineering, App) ->

    #
    # ENTITY CLASSES
    #

    #
    # A single EmailTarget
    #
    class SocialEngineering.HumanTarget extends App.Entities.Model

      #
      # Url for updating or creating a SocialEngineering::HumanTarget. Prototype tweaks the content-types so we need to be explicit with .json
      #
      # @return [String] url for updating/creating a cred
      url: ->
        Routes.workspace_social_engineering_target_list_human_targets_path(WORSKSPACE_ID, @targetListIds)+'.json'


    #
    # A collection of HumanTargets
    #

    # Contains all Creds that are accessible to a specific workspace
    class SocialEngineering.HumanTargetCollection extends App.Entities.Collection

      @include 'FetchIDs'

      model: SocialEngineering.HumanTarget
      initialize: (models,opts) ->
        @targetListId = opts.targetListId

      url: =>
        Routes.workspace_social_engineering_target_list_human_targets_path(WORKSPACE_ID,@targetListId)+'.json'


    API =
    # @return [Collection] of all HumanTargets in a given SocialEngineering::TargetList
      getHumanTargets: (opts) ->
        new SocialEngineering.HumanTargetCollection([], opts)

    #
    # REQUEST HANDLERS
    #

    # @param opts [Object] the options hash
    # @option opts workspace_id [Number] when set, the returned collection contains all SocialEngineering::HumanTargets in the
    #   workspace and SocialEngineering::TargetList of the given IDs
    App.reqres.setHandler "socialEngineering:humanTarget:entities", (opts={}) ->
      API.getHumanTargets(opts)

