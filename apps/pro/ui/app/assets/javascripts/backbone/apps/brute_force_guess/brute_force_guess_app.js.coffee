define [
  'lib/utilities/navigation'
  'apps/brute_force_guess/index/index_controller'
  'entities/abstract/brute_force_guess'
  'css!css/brute_force'
], ->
  @Pro.module 'BruteForceGuessApp', (BruteForceGuessApp, App)->

    class BruteForceGuessApp.Router extends Marionette.AppRouter
      appRoutes:
        "quick": "quick"

    API =
      quick: () ->
        new BruteForceGuessApp.Index.Controller()

    App.addInitializer ->
      new BruteForceGuessApp.Router(controller: API)

    # Sets the mainRegion, which is used by default when #show if called
    # without explicitly setting a region.
    App.addRegions
      mainRegion: "#bruteforce-main-region"