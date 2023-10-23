define ['jquery'], ($) ->

  @Pro.module "Concerns", (Concerns, App) ->

    # Jquery event specification to allow tight unbinding
    RESIZE_EVENT = 'resize.sizeToFit'

    # You can only try so hard. After this many attempts we give up on perfection.
    MAX_RECURSION = 5

    # We never want to be smaller than this amount
    MIN_HEIGHT = 300

    # The SizeToFit mixin can be added to a Layout or View to ensure
    # that a certain element is resized to take up the entirety of the
    # vertical window space.
    #
    # To use, just include it in your View and set the resizeEl option
    # of the UI hash to point to the selector of the element you wish
    # to resize the window by.
    #
    #   class MyView extends Marionette.ItemView
    #     @include "SizeToFit"
    #     ui:
    #       resizeEl: '.address-card'
    #
    Concerns.SizeToFit =

      # @property [Boolean] should resize to fit
      sizeToFit: true

      # @property [Boolean] temporarily disable the resizing behavior
      resizeDisabled: false

      _stopTheLoop: 0

      # @param [Object] opts the options hash
      # @option opts sizeToFit [Boolean] the view will auto-resize with window (true)
      initialize: (opts={}) ->
        opts = _.defaults opts,
          sizeToFit: true
          resizeDisabled: false

        @sizeToFit = opts.sizeToFit
        @resizeDisabled = opts.resizeDisabled
        @onResize = _.bind(@onResize, @)
        @inModal = false

      onShow: ->
        @inModal = @$el.parents('#modals').length > 0
        $(window).on(RESIZE_EVENT, @onResize) if @sizeToFit
        @onResize() if @sizeToFit

      # Unbind all our events
      onDestroy: ->
        $(window).off(RESIZE_EVENT, @onResize) if @sizeToFit

      # Window was resized. Let's increase our height until the window overflows
      onResize: ->
        if @inModal
          @ui.resizeEl?.height(Math.max(@ui.resizeEl?.height(), 600))
          tryResize = =>
            height = $(document.body).height() - 80 - @ui.resizeEl.offset().top
            if height < 100
              return _.delay tryResize, 600
            @ui.resizeEl?.height(height)
            @trigger('sizetofit:resized')
          _.delay tryResize, 600
          return

        @_stopTheLoop++
        if @resizeDisabled or !@$el.is(':visible')
          @_stopTheLoop = 0
          return

        if @_stopTheLoop > MAX_RECURSION
          @_stopTheLoop = 0
          @trigger('sizetofit:resized')
          return

        resize = =>
          origHeight = @ui.resizeEl?.height()
          @ui.resizeEl?.height(Math.max(origHeight+diff, MIN_HEIGHT))
          _.defer => @onResize()

        # Check if we have overflown the visible window
        diff = document.documentElement.scrollHeight - $(document.body).height()
        return resize() if diff > 0

        diff = $(window).height() - $(document.body).height()
        return resize() if diff < 0

        @trigger('sizetofit:resized')

      # Temporarily disables the resizing behavior and removes a hardcoded height attr
      # @param disabled [Boolean] whether or not to disable the resizing behavior
      setResizeDisabled: (disabled) ->
        @resizeDisabled = disabled
        if disabled
          @ui.resizeEl?.removeAttr('height').css(height: 'auto')
        else
          @onResize()