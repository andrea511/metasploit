define [
  'jquery'
  'base_layout'
  'base_itemview'
  'base_collectionview'
  'base_compositeview'
], ($) ->

  @Pro.module "Components.Table", (Table, App, Backbone, Marionette, $, _) ->



    #
    # Shown when the collection is empty
    #
    class Table.Empty extends App.Views.ItemView

      tagName: 'tr'

      attributes:
        class: 'empty'

    #
    # Show a loading animation. Used as the EmptyView for non-static collections
    # until something is fetched.
    #
    class Table.Loading extends App.Views.ItemView

      tagName: 'tr'

