define [
  'jquery'
  'base_collectionview'
  'base_itemview'
  'lib/components/breadcrumbs/templates/crumb'
  'lib/concerns/views/chooseable'
], ($) ->
  @Pro.module "Components.Breadcrumbs", (Breadcrumbs, App) ->

    #
    # An individual Crumb
    #
    class Breadcrumbs.Crumb extends App.Views.ItemView
      template: @::templatePath "breadcrumbs/crumb"
      tagName: 'li'

      ui:
        crumb: 'a'

      events:
        'click' : 'choose'


      modelEvents:
        'change:launchable' : 'launchableChanged'

      launchableChanged: (model, value) ->
        if value
          @ui.crumb.addClass('launchable')
        else
          @ui.crumb.removeClass('launchable')

      @include "Chooseable"
    #
    # A collection of Crumbviews Views
    #
    class Breadcrumbs.CrumbCollection extends App.Views.CollectionView
      childView: Breadcrumbs.Crumb
      tagName: 'ul'
      className: 'breadcrumbs'





