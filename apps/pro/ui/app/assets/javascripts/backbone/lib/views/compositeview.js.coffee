define [
  'base_view'
], ->
  @Pro.module "Views", (Views, App, Backbone, Marionette, jQuery, _) ->

    class Views.CompositeView extends Marionette.CompositeView
      itemViewEventPrefix: "childview"
