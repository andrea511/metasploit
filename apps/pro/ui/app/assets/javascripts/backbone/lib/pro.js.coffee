###
 This script defines the Pro global, which contains a top-level Marionette
 Application, on top of which we define different namespaced modules for
 controllers and views. The Pro App can be further "refined" by calling
 instance methods on it (e.g. in your page-specific app source).

 This script is included in application.js (and therefore is on every page).
 This ensures that Pro.module method (used to namespace all of our stuff)
 is always defined and accessible, regardless of load order (important for
 parallel require.js loads).
###

@Pro = do ->

  App = new Backbone.Marionette.Application

  App.reqres.setHandler "default:region", ->
    App.mainRegion

  App.reqres.setHandler "default:region", -> App.mainRegion
  App.reqres.setHandler "concern", (concern) -> App.Concerns[concern]

  App.on "start", (options) ->
    if @startHistory?
      @startHistory()
      @navigate('',trigger: true) unless @getCurrentRoute()

  App.commands.setHandler "loadingOverlay:show", (opts={}) ->
    if App.mainRegion?
      App.mainRegion.$el?.addClass('blocking-loading')
      App.mainRegion.$el?.prepend("<div class='tab-loading-text'>#{opts.loadMsg}</div>") if opts.loadMsg
    else
      jQuery('.mainContent').addClass('blocking-loading')
      jQuery('mainContent').prepend("<div class='tab-loading-text'>#{opts.loadMsg}</div>") if opts.loadMsg

  App.commands.setHandler "loadingOverlay:hide", (opts={}) ->
    if App.mainRegion?
      if App.mainRegion?.$el?
        App.mainRegion?.$el.removeClass('blocking-loading')
        jQuery('.tab-loading-text',App.mainRegion?.$el).remove()

    else
      $mainContent = jQuery('.mainContent')
      $mainContent.removeClass('blocking-loading')
      jQuery('.tab-loading-text',$mainContent).remove()
  App
