define [
  'jquery'
  'base_layout'
  'base_view'
  'base_itemview'
  'apps/brute_force_reuse/review/templates/layout'
], ($) ->

  @Pro.module 'BruteForceReuseApp.Review', (Review, App) ->

    class Review.Layout extends App.Views.Layout

      className: 'review-view'

      ui:
        form: 'form'
        launchBtn:'.launch-container a'

      triggers:
        'change @ui.form' : 'form:changed'
        'input form' : 'form:changed'
        'click a.back-creds': 'credentials:back'
        'click a.back-targets': 'targets:back'

      regions:
        targetRegion: '.target-region'
        credRegion: '.creds-region'

      template: @::templatePath('brute_force_reuse/review/layout')

      disableLaunch:()->
        @ui.launchBtn.addClass('disabled')