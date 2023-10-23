define [
  'jquery'
  'base_controller'
  # growl.js temporarily moved to common.js for banner alerts.
  #'growl'
], () ->
  @Pro.module "Components.Flash" , (Flash, App, Backbone, Marionette, $, _) ->

    #
    # Handles display of flash messages. Acts as an interface class to whichever
    # third-party flash message display lib we happen to use.
    #
    class Flash.FlashController extends App.Controllers.Application
      # Display a new flash message.
      #
      # @param [Object] opts the options hash
      # @option opts :location [String]
      #   one of `tl`, `tr`, `bl`, or `br` (top left, bottom right, etc.) - the position
      #   of the growl message (default: br)
      # @option opts :style    [String]
      #   one of `error`, `notice`, or `warning`
      # @option opts :duration [Number]
      #   the amount of time that the message should remain visible
      # @option opts :close    [Boolean]
      #   the character to use for the close icon
      # @option opts :size     [String]
      #   one of `small`, `medium`, or `large` (default: medium)
      # @option opts :message  [String]
      #   the message to display
      # @option opts :title    [String]
      #   the (optional) title of the flash message
      initialize: (opts = {}) ->
        _.defaults opts,
          location: 'br'
          style:    'notice'

        $.growl opts

    #
    # Display a flash message.
    #
    # @see {Flash.FlashController#initialize} options
    App.commands.setHandler "flash:display", (opts = {}) ->
      new Flash.FlashController opts
