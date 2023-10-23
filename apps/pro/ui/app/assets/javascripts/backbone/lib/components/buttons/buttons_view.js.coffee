define [
  'base_collectionview'
  'base_itemview'
  'lib/components/buttons/templates/button'
], ($) ->
  @Pro.module "Components.Buttons", (Buttons, App) ->

    #
    # An individual Button
    #
    class Buttons.ButtonView extends App.Views.ItemView
      template: @::templatePath "buttons/button"
      className: 'inline-block'

    #
    # A collection of Button Views
    #
    class Buttons.ButtonCollectionView extends App.Views.CollectionView
      childView: Buttons.ButtonView
