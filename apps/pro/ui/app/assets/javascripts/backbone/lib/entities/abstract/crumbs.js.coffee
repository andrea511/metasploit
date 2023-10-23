define [
  'base_model'
  'base_collection'
  'lib/concerns/entities/chooser'
], ->
  @Pro.module "Entities", (Entities, App, Backbone, Marionette, jQuery, _) ->

    class Entities.Crumb extends Entities.Model
      defaults: {}


    class Entities.CrumbCollection extends Entities.Collection
      model: Entities.Crumb

      @include "SingleChooser"

    API =
      getCrumbs: (crumbs=[]) ->
        crumbCollection = new Entities.CrumbCollection crumbs
        crumbCollection.reset(crumbs)
        crumbCollection

    App.reqres.setHandler "crumbs:entities", (crumbs = []) ->
      API.getCrumbs crumbs
