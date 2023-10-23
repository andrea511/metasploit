define [
  'base_itemview'
], () ->


  @Pro.module "Components.Loading", (Loading, App, Backbone, Marionette, $, _) ->

    class Loading.LoadingView extends App.Views.ItemView
      template: false
      className: "loading-container"

      onShow: ->
        $(@el).addClass('tab-loading')

