define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    class Entities.Loot extends App.Entities.Model

    class Entities.LootCollection extends App.Entities.Collection

      # @property accessLevels [Array<String>] a sorted list of unique values
      #   of the `access_level` property across the models in this collection

      initialize: (models, {@host_id, @index}) ->
        if @index
          @url = Routes.workspace_loots_path WORKSPACE_ID
        else
          @url = "/hosts/#{@host_id}/show_loots/json"

      model: Entities.Loot

    #
    # API
    #

    API =
      getLoots: (opts={}) ->
        new Entities.LootCollection([], opts)


      getLoot: (id) ->
        new Entities.Loot(id: id)

      newLoot: (attributes = {}) ->
        new Entities.Loot(attributes)

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "loots:entities", (opts={}) ->
      API.getLoots(opts)

    App.reqres.setHandler "loots:entity", (id) ->
      API.getLoot id

    App.reqres.setHandler "new:loot:entity", (attributes) ->
      API.newLoot attributes
