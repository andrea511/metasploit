define [
  'base_layout'
  'base_view'
  'base_itemview'
  'base_compositeview'
  'apps/brute_force_reuse/header/templates/layout'
], ->
  @Pro.module 'BruteForceReuseApp.Header', (Header, App) ->

    class Header.Layout extends App.Views.Layout
      template: @::templatePath('brute_force_reuse/header/layout')

      className: 'brute-force-header'

      regions:
        crumbs : '.crumbs-region'
