define [
  'jquery'
  'base_view'
], ($) ->
  @Pro.module "Components.Table.CellViews" , (CellViews, App) ->

    CellViews.TruncateView = ({max, attribute}) =>
      Backbone.Marionette.ItemView.extend
        template: (model) ->
          max ||= 16
          text = model[attribute] || ''
          if text.length > max
            text = text.substring(0, max)+'…'
            "<span title='#{model[attribute]}'>#{_.escape(text)}</span>"
          else
            _.escape text

        onRender: ->
          @$el.tooltip()


