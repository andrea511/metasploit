jQueryInWindow ($) ->
  # extract singular tab page functionality into its own
  # view class so that it can be rendered separately
  class @SingleTabPageView extends Backbone.View
    initialize: -> _.bindAll(this, 'render')
    template: _.template('<div class="cell loading"></div>')
    render: ->
      $($.parseHTML(@template(this))[0]).appendTo $(@el)
