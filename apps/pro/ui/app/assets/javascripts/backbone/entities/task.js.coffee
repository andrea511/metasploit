define [
  'jquery'
  'base_model'
  'base_collection'
  'entities/run_stat'
], ($) ->

  @Pro.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

    class Entities.Task extends App.Entities.Model

      defaults: ->
        workspace_id: null
        # schema used to define the arrangement of stats display
        schema: []
        # the actual real-time stat data
        run_stats: new Entities.RunStatsCollection([], task: @)
        # models used to render and update statistics from schema
        statDisplays: null

      initialize: (@opts={}) =>
        _.defaults(@opts, statDisplays: true)

        if @opts.statDisplays
          @set 'statDisplays', new Entities.StatDisplaysCollection [],
            schema: @get('schema'),
            run_stats: @get('run_stats')

          @on 'change:schema', =>
            @get('statDisplays').updateSchema(@get('schema'))

      url: (ext='.json') => "/workspaces/#{@get('workspace_id')}/tasks/#{@id}#{ext}"

      # @return [Boolean] has the task finished running?
      isCompleted: =>
        @get('state') == 'completed'

      # @return [Boolean] is the task failed?
      isFailed: =>
        @get('state') == 'failed'

      # @return [Boolean] is the task interrupted?
      isInterrupted: =>
        @get('state') == 'interrupted'

      # @return [Boolean] is the task stopped?
      isStopped: =>
        @get('state') == 'stopped'

      # @return [Boolean] is the task paused?
      isPaused: =>
        @get('state') == 'paused'

      #
      # Pause this task.
      pause: =>
        $.post Routes.pause_task_path(@get('id'))

      #
      # Resume this task.
      resume: =>
        $.post Routes.resume_task_path(@get('id'))

      #
      # Stop this task.
      stop: =>
        if @isPaused()
          $.post Routes.stop_paused_task_path(@get('id'))
        else
          $.post Routes.stop_task_path id: @get('id')

      # Override fetch so that if the Task knows about a `now` field in its
      # response, it passes it back to the server as the `since` key.
      fetch: (opts={}) =>
        if @get('now')?
          opts.data ||= $.param(since: @get('now'))
        super(opts)

      # Override fetch so that if the Task knows about a `now` field in its
      # response, it passes it back to the server as the `since` key.
      fetch: (opts={}) =>
        if @get('now')?
          opts.data ||= $.param(since: @get('now'))
        super(opts)

      #
      # Ensures that the #run_stats attribute is always an instance of Entities.RunStatsCollection,
      #   and that set()'s caused by normal syncing end up mutating the existing collection
      #   instead of simply replacing it with a new colleciton.
      #
      set: (key, val, options) ->
        # Handle the hash set({key:val}) syntax by extracting the key we care about
        if key instanceof Object and key.run_stats?
          @set('run_stats', key.run_stats, options)
          delete key.run_stats # prevent a double-set

        # Handle the set(key,val) syntax when key is run_stats
        else if key is 'run_stats' and not (val instanceof Entities.RunStatsCollection)
          # The collection is already wrapped, just set the models on the existing one
          stats = @get('run_stats') or new Entities.RunStatsCollection()
          _.each val, (stat) =>
            existingStat = stats.findByName(stat.name)
            if existingStat?
              existingStat.set('data', stat.data)
            else
              stat.task = @
              stats.add new Entities.RunStat(stat)
          val = stats

        # Let Backbone.Model::set do its thing on (key, val, options)
        super
