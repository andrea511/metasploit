define [
  'jquery'
  'lib/utilities/uuid'
  'base_layout'
  'base_itemview'
  'lib/components/window_slider/templates/window_slider'
], ($, UUID) ->
  @Pro.module "Components.WindowSlider", (WindowSlider, App) ->

    class WindowSlider.WindowSliderLayout extends App.Views.Layout
      template: @::templatePath "window_slider/window_slider"

      className: 'window-slider-container'

      regions:
        windowSliderRegion: '#window-slider-region'

      initialize: ->
        @shown = false

      addSliderRegion: ->
        if $('.window-slider-pane',@el).length > 1
          $(".window-slider-pane:not(.#{@id})",@el).remove()

        @addNode()
        @addRegion(@id,".#{@id}")

        @listenTo @[@id], 'show', @animateSlider
        @[@id]

      addNode: ->
        @id = Pro.Utilities.createGuid()
        klass = if @shown then '' else 'show first'
        @shown = true
        @$el.append("<div class='#{@id} #{klass} window-slider-pane'></div>")

      removeNode:(e) =>
        klass = $(e.target).attr('class').split(" ")[0]

        if @[klass]?
          @removeRegion(klass)
          $(".#{klass}",@el).remove()

      animateSlider: ->
        _.delay(@animate,1)

      animate: =>
        if $('.window-slider-pane', @el).first().attr('class').indexOf(@id) == -1
          if $('.window-slider-pane', @el).length > 2
            $elem = $(".window-slider-pane:not(.#{@id})",@el)
            klass = $(e.target).attr('class').split(" ")[0]
            @removeRegion(klass)
            $elem.remove()

            $elem = $(".window-slider-pane:not(.#{@id})",@el)
            klass = $(e.target).attr('class').split(" ")[0]
            @removeRegion(klass)
            $elem.remove()
          else
            $('.window-slider-pane',@el).css(position: 'absolute')
            $('.window-slider-pane',@el).first().addClass('slideOutLeft')
            $('.window-slider-pane',@el).first().one('transitionEnd transitionend webkitTransitionEnd',@removeNode)

        _.defer(@showSlider)

      showSlider: =>
        $myEl = @$el
        $(".#{@id}",@el).addClass('show').one 'transitionEnd transitionend webkitTransitionEnd', ->
          $(@).css(position: 'relative')
          $myEl.css 'min-height', 0
        $myEl.css 'min-height', @$el.children().last().height()
