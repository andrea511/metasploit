define [
  'base_controller'
  'base_model'
  'lib/components/modal/modal_view'
  'lib/components/buttons/buttons_controller'
  'entities/abstract/modal'
  'lib/regions/dialog_region'
], ->
  @Pro.module "Components.Modal", (Modal, App) ->

    class Modal.ModalController extends App.Controllers.Application

      # Hash of default options for controller
      # @option opts proxy      [Boolean] proxy view methods through the controller
      #
      defaults: ()  ->
        proxy: false
        loading:false

      # Create a new instance of the ModalController and adds it to the
      # dialog-region
      #
      # @param [Object] opts the option hash
      # @option opts contentView    [Marionette.View,Marionette.Controller] view/controller to render
      # @option opts modal          [Object] a hash of config opts used to create backbone model to be consumed by the modal
      # @option opts buttons        [Object] a hash of opts for the buttons controller
      # @option opts loading        [Boolean] whether or not to show the loading state until the model is fetched
      #
      initialize: (options= {}) ->
        {@contentView, @modal, @buttons, @doneCallback, @closeCallback, @loading} = options
        # Merge in controller default options with passed in options
        config = @getConfig options
        # Create Backbone.Model for modal containing description and title
        modal = App.request "component:modal:entities", @modal
        # Set the current view to be the modal layout
        @setMainView(new Modal.ModalLayout(model: modal))

        # If config.proxy a string of method names, make the nested view/controller
        # methods accessible from the modal controller
        #
        # Since the modal component wraps a nested view/controller, we still want nested
        # methods to be accessible from the controller that creates the modal component.
        @parseProxys config.proxy if config.proxy

        # After the modal is displayed, display inner content, center it, and show buttons
        @listenTo @_mainView, "show", =>
          @modalRegion()
          @_mainView.center()

          @buttons = App.request "buttons:component", buttons: @buttons
          @show @buttons, region: @_mainView.buttons

        # When the submit button is clicked, call the submit method in the nested controller
        # Also enforce Form Submit Interface on Content Controller/View
        #
        # It is assumed that the onFormSubmit method returns a jquery Deferred object
        # The form does not close until the Defer object is resolved. This ensures
        # the modal only closes when we are done handling the form submit event.
        #
        @listenTo @_mainView, "primaryClicked", (e) =>
          unless @contentView.onFormSubmit?
            throw new Error("onFormSubmit method not defined on Content Region View/Controller")
          else
            formSubmit = @contentView.onFormSubmit(e)

            formSubmit?.done =>
              @doneCallback?()
              @region.reset()
            formSubmit?()

        # Call callback if user cancels modal
        @listenTo @_mainView, "closeClicked", (e) =>
          @closeCallback?()

        @listenTo @contentView, "btn:disable:modal", (btnName) =>
          @buttons.disableBtn(btnName)

        @listenTo @contentView, "btn:enable:modal", (btnName) =>
          @buttons.enableBtn(btnName)


        @show @_mainView

      # Show Content in Modal
      #
      modalRegion: ->
        @listenTo @contentView, 'center', =>
          @_mainView.center()

        @show @contentView, region: @getMainView().content, loading: @loading


      # Merge Controller Defaults into View except ones omitted by the omit method
      # @param [Object] options the options hash passed into the controller init method
      #
      getConfig: (options) ->
        modalView = _.result @contentView, "_mainView"
        config = @mergeDefaultsInto(modalView)

        _.extend config, _(options).omit("contentView", "model", "collection", "proxy")

      # Proxy specified Nested View/Controller Methods to be available via the modal controller
      # @param [Array<String>] proxys array of method names to proxy
      #
      parseProxys: (proxys) ->
        for proxy in _([proxys]).flatten()
          @_mainView[proxy] = _.result @contentView, proxy




    # Reqres Handler to create the Modal Component Controller
    App.reqres.setHandler "modal:component", (contentView, options={}) ->
      throw new Error "Modal Component requires a contentView to be passed in" unless contentView

      options.contentView = contentView
      new Modal.ModalController options


    # View can be view or controller
    App.commands.setHandler 'showModal', (contentView, options={}) ->
      unless localStorage.getItem(options.modal.title) == "false"
        options = _.defaults(options, region: App.dialogRegion)

        unless options.region?
          # lazily create the region in case the App was never started (SingleHostView)
          App.addRegions dialogRegion: { selector: "#dialog-region", regionType: App.Regions.Dialog }
          options.region = App.dialogRegion

        App.request "modal:component", contentView, options


    # App exec handler for closing the modal
    App.commands.setHandler 'closeModal', ->
      App.dialogRegion?.reset()

    # App initializer to add the region if this module is required
    App.on "initialize:after", (options) ->
      # create our specialized dialog region
      @addRegions dialogRegion: { selector: "#dialog-region", regionType: App.Regions.Dialog }

