define [
  'base_view'
], ->
  @Pro.module "Views", (Views, App) ->

    class Views.CollectionView extends Marionette.CollectionView

    # A collection view that allows for sortable collections.
    # See https://github.com/marionettejs/backbone.marionette/wiki/Adding-support-for-sorted-collections
    class Views.SortableCollectionView extends Marionette.CollectionView

