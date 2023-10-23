define [], ->
  @Pro.module "Concerns", (Concerns, App, Backbone, Marionette, $, _) ->

    Concerns.RightSideScroll =

      onShow: ->
        $(window).on @_customEventName(), _.debounce((e) =>
          @bindUIElements()
          top = $(window).scrollTop()
          myTop = Math.max(top-120, 0)

          diff = (@ui.rightSide.height()+myTop+20) - @ui.leftSide.height()
          if diff < 0
            @ui.rightSide.css top: myTop+"px"
          else
            @ui.rightSide.css top: @ui.leftSide.height()-@ui.rightSide.height()+20
          @adjustSize()
        , 400)

      adjustSize: ->
        h = $(window).height() - @$el.offset().top
        h = Math.max(500, h)
        h2 = h-150
        tableH = @ui.leftSide.height()
        if tableH < h
          h = Math.max(500, tableH)
          h2 = h-76

        @ui.rightSide.height(h+20)
        @ui.rightSide.find('.border').height(h2)
        @ui.rightSide.find('.nano').height(h2)
        @trigger('resized')

      onDestroy: ->
        $(window).off @_customEventName()

      _customEventName: ->
        "scroll.page-#{this.constructor?.prototype?.attributes?.class||''}"
