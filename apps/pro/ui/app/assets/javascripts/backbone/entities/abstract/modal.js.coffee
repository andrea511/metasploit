define [
  'base_model'
], ->
  @Pro.module "Entities", (Entities, App, Backbone, Marionette, jQuery, _) ->

    class Entities.Modal extends Entities.Model
      defaults:
        title: "Default Title"
        description: ""

    API =
      getModal: (options= {}) ->
        new Entities.Modal options

    App.reqres.setHandler "component:modal:entities", (options = {}) ->
      API.getModal options
