jQueryInWindow ($) ->
  # MultiView: combines multiple Backbone.Views
  # mv = new MultiView([
  #   new Backbone.View(),    // concatenates the views  
  #   new Backbone.View()
  # ])  
  class @MultiView extends SingleTabPageView
    initialize: (opts) ->
      @subviews = []
      @options = opts
      @subviewClasses = opts['subviews'] || []
      super
    addSubview: (subview) ->
      @subviews.push(subview)
      subview
    render: ->
      el = super
      @subviewClasses.each (subview) => 
        opts = _.extend @options, el: el
        @addSubview(new subview(opts)).render()