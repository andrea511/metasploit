define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->

    #
    # ENTITY CLASSES
    #

    class Entities.Origin extends App.Entities.Model

    #
    # API
    #

    API =
      getOrigin: (id, url) ->
        origin = new Entities.Origin
          id: id
        origin.url = url
        origin

      newOrigin: (attributes = {}) ->
        new Entities.Origin(attributes)

    #
    # REQUEST HANDLERS
    #

    App.reqres.setHandler "origin:entity", (id, url) ->
      API.getOrigin id, url

    App.reqres.setHandler "new:origin:entity", (attributes) ->
      API.newOrigin attributes