
define [
  'base_controller'
  'lib/components/window_slider/window_slider_view'
], ->

  @Pro.module "Components.WindowSlider", (WindowSlider, App) ->

    class WindowSlider.WindowSliderController extends App.Controllers.Application

      defaults: ->
        proxy: false
        onBeforeSlide: ->
        onAfterSlide: ->
        show : true

      initialize: (options = {}) ->
        { @contentView} = options

        config = @getConfig options
        @showView = config.show

        @windowSliderLayout = @getWindowSliderLayout config
        @setMainView @windowSliderLayout

        @parseProxys config.proxy if config.proxy
        @createListeners config

        @show @windowSliderLayout

      getWindowSliderLayout: (config) ->
        new WindowSlider.WindowSliderLayout config


      createListeners: (config) ->
        #@listenTo @windowSliderLayout, "show", @showWindowSliderContentRegion if @showView
      ###
        @listenTo @windowSliderLayout, "before:slide", => @beforeSlide(config)
        @listenTo @windowSliderLayout, "after:slide", => @afterSlide(config)

      beforeSlide: (config) ->
        config.onBeforeSlide()
        @trigger "before:slide"

      afterSlide: (config) ->
        config.onAfterSlide()
        @trigger "after:slide"
      ###

      showWindowSliderContentRegion: (options={},showFunc=null, args) ->
        _.defaults options,
          show: @showView
          contentView: @contentView
          loading: false
        #When we need to pass a custom show function for pre BackboneRails Controllers
        slideToRegion = @windowSliderLayout.addSliderRegion()

        if showFunc
          showFunc.call({},args, slideToRegion)
        else
          @show options.contentView, {region: slideToRegion, loading: options.loading} if options.show

      ###
      #Good Canidates for Mixin
      ###

      #Merge Defaults with passed in config
      getConfig: (options) ->
        windowSlider = _.result @contentView, "windowSlider"
        config = @mergeDefaultsInto(windowSlider)

        _.extend config, _(options).omit("contentView", "model", "collection")

      parseProxys: (proxys) ->
        for proxy in _([proxys]).flatten()
          @windowSliderLayout[proxy] = _.result @contentView, proxy


    # Returns instance of a window Slider Controller
    App.reqres.setHandler "window_slider:component", (contentView, options={}) ->
      if contentView
      #throw new Error "Window Slider Component requires a contentView to be passed in" if not contentView
        options.contentView = contentView
        new WindowSlider.WindowSliderController options
      else
        WindowSlider.WindowSliderController


    # App exec handler for showing the next window slider pane
    App.commands.setHandler 'sliderRegion:show', (options={},showFunc=null, args) ->
      { contentView, show, loading } = options

      unless @windowSlider?
        windowSliderController = App.request "window_slider:component"
        @windowSlider = new windowSliderController(show: false)
      @windowSlider.showWindowSliderContentRegion({
          contentView: contentView
          show: show
          loading: loading
        },
        showFunc,
        args
      )
