define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App, Backbone, Marionette, jQuery, _) ->

    class Entities.Button extends Entities.Model
      defaults:
        buttonType: "button"

    class Entities.ButtonCollection extends Entities.Collection
      model: Entities.Button

    API =
      getFormButtons: (buttons) ->
        buttonCollection = new Entities.ButtonCollection []
        buttonCollection.reset(buttons)
        buttonCollection

    App.reqres.setHandler "buttons:entities", (buttons = {}) ->
      API.getFormButtons buttons
