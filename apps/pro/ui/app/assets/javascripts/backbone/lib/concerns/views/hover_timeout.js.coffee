define [], ->
  @Pro.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->

    Concerns.HoverTimeout =

      ui:
        hoverContainer: '.hover-container'

      events:
        'mouseenter @ui.hoverContainer': 'setHoverTimeout'
        'mouseleave @ui.hoverContainer': 'clearHoverTimeout'
        'mouseleave @ui.hoverContainer' : 'setHideHoverTimeout'
        'mouseleave' : 'setHideHoverTimeout'

      #
      # Show View on hover after time delay
      #
      setHoverTimeout: ->
        @hoverTimeout = setTimeout((()=>@triggerHover()), 100)


      #
      # Prevent hover from appearing
      #
      clearHoverTimeout: ->
        clearTimeout(@hoverTimeout)

      #
      # Hide hover after time delay
      #
      setHideHoverTimeout: ->
        @hideHoverTimeout = setTimeout((()=>@triggerHideHover()),200)

      #
      # Prevent hover from being hidden
      #
      clearHideHoverTimeout: ->
        clearTimeout(@hideHoverTimeout)

      #
      # Callback for hover
      #
      triggerHover: ->
        @trigger('show:hover')

      #
      # Callback for hide hover
      #
      triggerHideHover: ->
        @trigger('hide:hover')