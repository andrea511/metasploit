jQuery ($) ->
  class MyPlugin
    defaults:
      hidableClass: 'hidable'

    constructor: (@$element, options) ->
      @config = $.extend {}, @defaults, options, true
      # Store the object for later retrieval.
      @$element.data('MyPlugin', this)
      @init()

    foo: () ->
      console.log(this);

    init: () ->
      if @$element.hasClass @config.hidableClass
        @$element.hover ->
          @$element.hide()

  # The first time the plugin method is called, the object is created and the
  # init() method is run. Any subsequent calls to the plugin method for the same
  # element return the created MyPlugin object.
  $.fn.myPlugin = (options) ->
    object = $(this).data 'MyPlugin'
    object || this.each -> new MyPlugin($(this), options)
