define [
  'lib/components/filter/templates/help'
  'base_itemview'
], ->

  @Pro.module "Filters", (Filters, App) ->

    class Filters.HelpView extends App.Views.ItemView

      template: @::templatePath 'filter/help'

      className: 'tab-loading filter-help'

      initialize: (opts={}) ->
        @whitelist = opts.whitelist || []
        @model.fetch().done @render

      onRender: ->
        return if _.isEmpty(_.keys(@model.attributes))
        @$el.removeClass('tab-loading')

      serializeData: -> @
