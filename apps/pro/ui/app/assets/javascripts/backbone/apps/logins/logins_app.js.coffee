define [
  'lib/utilities/navigation'
  'apps/logins/new/new_controller'
  'apps/logins/delete/delete_controller'
  'lib/components/modal/modal_controller'
], () ->
  @Pro.module 'LoginsApp', (LoginsApp, App, Backbone, Marionette, $, _, HostViewController) ->
    class LoginsApp.Router extends Marionette.AppRouter
      appRoutes:
        ":id/logins/new": "_new"

    API =
      _new: () ->
        App.execute "showModal", new LoginsApp.New.Controller

    # @see {Delete.Controller#initialize} options
      delete: (options) ->
        new LoginsApp.Delete.Controller options

    App.addInitializer ->
      new LoginsApp.Router
        controller: API

    # @see {Delete.Controller#initialize} options
    App.reqres.setHandler 'logins:delete', (options = {}) ->
      API.delete options