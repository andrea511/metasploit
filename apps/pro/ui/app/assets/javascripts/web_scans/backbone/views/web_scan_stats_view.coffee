jQueryInWindow ($) ->
  # set _.templates to use {{ handlebars-style }} template interpolation
  # TODO: this is a DRY violation... Put in some common spot
  _.templateSettings = {
    evaluate: /\{%([\s\S]+?)%\}/g,
    escape: /\{\{([\s\S]+?)\}\}/g
  }

  # Simple polling for the model -- don't need anything fancy here.
  pollForModel = (model) ->
    model.fetch()
    window.setInterval((->
      model.fetch()
    ), 2000)

  # CircleStatsView can take a Stat Object and render a dash
  #  view with pie charts
  class @CircleStatsView extends Backbone.View
    template: _.template $("#stats-circles").html()

    setStats: (@stats) =>
      @stats.bind 'change', @render
      @attributes = @stats.objectsForDisplay()
      pollForModel(@stats)
      

    render: =>
      @$el.html @template(
        statSet: @stats
        cellWidth: 100/@attributes.length
      )


  class @WebScanStatsView extends CircleStatsView
    initialize: (opts={}) ->
      super
      optsForStat = { workspaceId: opts['workspaceId'], taskId: opts['taskId'] }
      @setStats(new WebScanStats(optsForStat))



