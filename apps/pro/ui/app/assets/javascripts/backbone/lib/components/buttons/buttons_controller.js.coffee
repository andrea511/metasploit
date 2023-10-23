define [
  'base_controller'
  'lib/components/buttons/buttons_view'
  'entities/abstract/buttons'
], ->
  @Pro.module "Components.Buttons" , (Buttons, App, Backbone, Marionette, $, _) ->

    #
    # Contains the buttons
    #
    class Buttons.ButtonsController extends App.Controllers.Application

      # Hash of default options for controller
      # @option opts buttons      [Object] the default button set
      #
      defaults: ->
        buttons: [
          {name: 'Cancel', class: 'close'}
          {name: 'Submit', class: 'btn primary'}
        ]

      # Create a new instance of the Button Controller and adds it to the
      # region passed in through the options hash
      #
      # @param [Object] options the option hash
      # @option opts buttons   [Object] the config options to create the ActionButtons Model
      initialize: (options = {}) ->
        #Set default key/values if key not defined in options hash
        @config = _.defaults options, @_getDefaults()

        # Get Buttons Model and View and set as controller's view
        buttons = @getButtons(@config.buttons)
        @collectionView = @getCollectionView(buttons)
        @setMainView(@collectionView)

      # Create collection view of buttons
      #
      # @param [Backbone.Collection] buttons a collection of ActionButton Models
      # @return [Views.CollectionView] a collection view of buttons
      getCollectionView: (buttons) ->
        new Buttons.ButtonCollectionView
          collection: buttons


      # Request to create a collection of ActionButtons
      #
      # @param [Array<Object>] buttons an array of button config hashes
      # @return [Backbone.Collection] a collection of ActionButton Models
      getButtons: (buttons) ->
        App.request "buttons:entities", buttons


      # Disable Button based on button name
      #
      # @param [Object] options configuration hash
      # @option options [String] the name of the button
      disableBtn: (btnName) ->
        @findBtn(btnName).addClass('disabled')

      # Enable Button based on button name
      #
      # @param [Object] options configuration hash
      # @option options [String] the name of the button
      enableBtn: (btnName) ->
        @findBtn(btnName).removeClass('disabled')

      # Find button by name
      #
      # @param  [String] btnName the name of the button
      # @return [Object] the jQuery selector for the btn
      #                  throws error if btn not found
      #
      findBtn: (btnName) ->
        btn = _.findWhere @config.buttons, {name:btnName}
        throw "Button '#{btnName}' not found in modal" unless btn
        selector = ".#{btn.class.replace(' ','.')}"
        $(selector,@el)



    # Reqres Handler to create the Buttons Component Controller
    App.reqres.setHandler "buttons:component", (options={})->
      new Buttons.ButtonsController options