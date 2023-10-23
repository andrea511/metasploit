define [
  'base_layout'
  'base_view'
  'base_itemview'
  'base_compositeview'
  'apps/brute_force_reuse/index/templates/layout'
], ->
  @Pro.module 'BruteForceReuseApp.Index', (Index, App) ->

    class Index.Layout extends App.Views.Layout
      template: @::templatePath('brute_force_reuse/index/layout')

      regions:
        content : '.content-region'

      triggers:
        'click .target-selection-view a.launch:not(.disabled)' : 'tab:credentials'
        'click .cred-selection-view a.launch:not(.disabled)' : 'tab:review'
        'click .review-view .launch-container a:not(.disabled)' : 'tab:launch'

      events:
        'click .review-view a.launch.disabled': 'reviewBadClick'
        'click .cred-selection-view a.launch.disabled': 'credBadClick'
        'click .target-selection-view a.launch.disabled': 'targetBadClick'

      credBadClick: ->
        App.execute 'flash:display',
          title: 'Error'
          style: 'error'
          message: "You must add at least 1 credential to the list."
          duration: 3000

      reviewBadClick: ->

      targetBadClick: ->
        App.execute 'flash:display',
          title: 'Error'
          style: 'error'
          message: "You must add at least 1 target to the list."
          duration: 3000
        

