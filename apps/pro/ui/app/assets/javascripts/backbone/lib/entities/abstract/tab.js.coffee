define [
  'base_model'
  'base_collection'
  'lib/concerns/entities/chooser'
], ->
  @Pro.module "Entities", (Entities, App, Backbone, Marionette, jQuery, _) ->

    class Entities.Tab extends Entities.Model
      defaults:
        title: "Tab"

    class Entities.TabCollection extends Entities.Collection
      model: Entities.Tab

      @include "SingleChooser"


    API =
      getTab: (options= {}) ->
        new Entities.Tab options
      getTabs: (models=[]) ->
        new Entities.TabCollection(models)

    App.reqres.setHandler "component:tab:entity", (options = {}) ->
      API.getTab options

    App.reqres.setHandler "component:tab:entities", (models=[]) ->
      API.getTabs models