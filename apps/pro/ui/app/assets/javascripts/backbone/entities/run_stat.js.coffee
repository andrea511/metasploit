define [
  'base_model'
  'base_collection'
], ->
  @Pro.module "Entities", (Entities, App) ->

    # RunStat is 1-to-1 with the Rails RunStat model, which contains a single
    #   key and value containing data collected from a Task.
    class Entities.RunStat extends App.Entities.Model
      defaults:
        task_id: null
        name: null
        data: null
        id: null

      # Ensure that the name of the stat is underscored correctly
      set: (key, val, opts) =>
        if key is 'name'
          val = _.str.underscored(val)
        else if key instanceof Object and key.name?
          @set('name', key.name, opts)
          delete key.name
        super

    # A collection for containing all the RunStats associated with a Task
    class Entities.RunStatsCollection extends App.Entities.Collection

      initialize: (models, opts={}) =>
        @task = opts.task

      findByName: (name) =>
        name = _.str.underscored(name.toString())
        _.find @models, (m) -> m.get('name') is name

    # A "display" for a given statistic, which may incorporate 1 or more
    #   RunStats (e.g. percentage is calculated from 2 RunStats). These models
    #   are 1-to-1 with the views rendered, and 1-to-many with actual RunStats.
    class Entities.StatDisplay extends App.Entities.Model

      defaults: ->
        # schema explains how the data is to be presented
        schema: {}
        # RunStatsCollection containing all relevant RunStats
        run_stats: null
        # the numerator stat
        numStat: null
        # the (optional) denominator stat
        totalStat: null
        # user can click the stat to reveal a table
        clickable: true
        # user has selected this stat
        selected: false
        # corresponding Table component schema for displaying stats
        table: null
        # title of the stat
        title: null
        # the task
        task: null

      initialize: =>
        @set 'numStat', @get('run_stats').findByName(@get('schema').num)
        if @isPercentage()
          @set 'totalStat', @get('run_stats').findByName(@get('schema').total)
        if @get('schema').clickable?
          @set('clickable', @get('schema').clickable)
        @set('title', @get('schema').title || _.str.humanize(@get('numStat').get('name')))

      # @return [Boolean] this statistic is displayed as a percentage
      isPercentage: =>
        @get('schema').type is 'percentage'

      # @return [Boolean] should render a pie chart display
      shouldShowPieChart: =>
        !(@get('schema').pie is false)

      # @return [String] the HTML color of the text in the Pie chart
      color: =>
        @get('schema').color || '#2b2b2b'

      # @return [String] the HTML color of the Pie chart background
      bgColor: =>
        @get('schema').bg_color || 'white'

      # @return [String] the HTML color of the Pie chart border
      stroke: =>
        @get('schema').stroke || '#c5c5c5'

      # @return [String] the HTML color of the Pie chart border that is filled
      percentageStroke: =>
        @get('schema').percentage_stroke || '#ea5709'

      # @param task [Entity.Task] the task that these stats belong to
      # @return [String] the URL to the data for this StatDisplay's associated table
      collectionURL: (task) =>
        "/workspaces/#{task.get('workspace_id')}/tasks/#{task.get('id')}/"+
        "stats/#{_.str.underscored(@get('title'))}"

    # A collection for containing all the StatDisplays, which are dependent on
    #   different RunStats and may need to be recalculated dynamically at Runtime.
    class Entities.StatDisplaysCollection extends App.Entities.Collection

      initialize: (models, opts={}) =>
        { @schema, @run_stats } = opts

        unless @schema?
          throw new Error('schema attribute must be present in the options for a StatDisplaysCollection')

        unless @run_stats? and @run_stats instanceof Entities.RunStatsCollection
          throw new Error('run_stats attribute must be present in the options for a StatDisplaysCollection')

        @updateSchema(@schema)

      findFirstClickable: =>
        _.find @models, (m) -> m.get('clickable')

      updateSchema: (@schema) =>
        _.each _.result(@schema, 'stats'), (statistic) =>
          @add new Entities.StatDisplay
            run_stats: @run_stats
            schema: statistic
            table: _.result(@schema, 'tables')?[_.str.underscored statistic.title]
            view: _.result(@schema, 'views')?[_.str.underscored statistic.title]
            controller: _.result(@schema, 'controllers')?[_.str.underscored statistic.title]
