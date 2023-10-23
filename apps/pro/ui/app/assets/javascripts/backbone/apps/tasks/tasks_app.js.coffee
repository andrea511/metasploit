define [
  'apps/tasks/show/show_controller'
  'entities/task'
], ->
  @Pro.module 'TasksApp', (TasksApp, App) ->
    class TasksApp.Router extends Marionette.AppRouter
      appRoutes:
        "": "index"

    API =
      index: (opts={}) ->
        task = new App.Entities.Task
          id: opts.task_id || window.TASK_ID
          workspace_id: opts.workspace_id || window.WORKSPACE_ID
        new TasksApp.Show.Controller(task: task)

    App.addRegions
      mainRegion: "#tasks-app"

    App.addInitializer ->
      new TasksApp.Router
        controller: API
      API.index()
