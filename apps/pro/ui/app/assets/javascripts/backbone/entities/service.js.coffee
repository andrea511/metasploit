define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    class Entities.Service extends App.Entities.Model
        @PROTOS: ['tcp', 'udp']
        url: ->


    class Entities.ServiceCollection extends App.Entities.Collection

      # @property accessLevels [Array<String>] a sorted list of unique values
      #   of the `access_level` property across the models in this collection

      initialize: (models, {@host_id, @index}) ->
        if @index
          @url = Routes.workspace_services_path WORKSPACE_ID
        else
          @url = "/hosts/#{@host_id}/show_services/json"

      model: Entities.Service


    #
    # API
    #

    API =
      getServices: (opts={}) ->
        new Entities.ServiceCollection([], opts)


      getService: (id) ->
        new Entities.Service(id: id)

      newService: (attributes = {}) ->
        new Entities.Service(attributes)

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "services:entities", (opts={}) ->
      API.getServices(opts)

    App.reqres.setHandler "services:entity", (id) ->
      API.getService id

    App.reqres.setHandler "new:service:entity", (attributes) ->
      API.newService attributes
