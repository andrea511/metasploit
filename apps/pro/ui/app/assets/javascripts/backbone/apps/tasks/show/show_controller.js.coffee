define [
  'jquery'
  'task_console'
  'base_controller'
  'lib/components/modal/modal_controller'
  'lib/components/table/table_controller'
  'apps/tasks/show/show_view'
  'entities/task'
  'lib/concerns/pollable'
  'jquery.ajax-retry'
], ($, TaskConsole) ->

  @Pro.module 'TasksApp.Show', (Show, App) ->

    class Show.Controller extends App.Controllers.Application

      @include "Pollable"

      # @property [Entities.Task] the Task we are showing
      task: null

      # @property [TasksApp.Show.Layout] the layout (container) view
      layout: null

      # @property [TasksApp.Show.Header] the header view
      headerView: null

      # @property [TaskConsole]
      consoleView: null

      # @property [TasksApp.Show.Stats]
      statsView: null

      # @property [Table.Controller] currently visible table component
      table: null

      # Sets the poll interval used by the Pollable concern
      pollInterval: 3000

      #
      # Creates a new TasksApp.Show.Controller that renders itself in the
      # mainRegion of the App
      # @param opts [Object] the options hash
      # @option opts task [Entities.Task] the task that we are rendering
      # @option opts fetch [Boolean] (true) fetch the task before showing the subviews
      #
      initialize: (opts={}) ->
        _.defaults(opts, fetch: true)

        @task = opts.task
        @layout = new Show.Layout()
        @headerView  = new Show.Header(model: @task)
        @consoleView = new TaskConsole(task: @task.id)
        @drilldownView = new Show.Drilldown(task: @task.id)

        # "Install" the subviews when we are ready to go
        @listenTo @layout, 'show', =>
          @statsView = new Show.Stats(collection: @task.get('statDisplays'))
          @region.$el.removeClass('tab-loading')
          @layout.headerRegion.show(@headerView)
          @layout.consoleRegion.show(@consoleView)
          @layout.statsRegion.show(@statsView)
          @layout.drilldownRegion.show(@drilldownView)

          grabFirst = =>
            firstStat = @task.get('statDisplays').findFirstClickable()
            if firstStat?
              @selectStat(firstStat)

          @task.get('statDisplays').on 'add', grabFirst

          grabFirst()

          if @task.isPaused()
            # Only load initially, don't poll.
            @consoleView.refreshLog()
          else
            @consoleView.startUpdating()

          @startPolling()

          # Select the stat when clicked and load the table
          @listenTo @statsView, 'childview:stat:clicked', (statView) =>
            if statView.model.get('clickable') and not statView.model.get('selected')
              @selectStat(statView.model)

          # Reload the table view if the selected stat is clicked
          @listenTo @statsView, 'childview:stat:updated', (statView) =>
            debouncedRefresh() if statView.model.get('selected')

        # debounce is used to ensure near-simultaneous updates dont
        # refresh the table multiple times.
        debouncedRefresh = _.debounce((=> @table?.refresh()), 200)

        # Set up some handlers on the nested views in the layout
        @listenTo @layout, 'tasksApp:show:tabClicked', (idx) =>
          @controller?.tabClicked?(idx)
          @setTabIndex(idx)

        # Start task log polling again when resuming tasks.
        @listenTo @headerView, 'tasksApp:resume', =>
          @consoleView.resumeUpdating()

        # Fetch the task if necessary
        if opts.fetch
          @task.fetch().retry(times: 9999, timeout: 4000).done(@_loadClientSideCode)
        else
          @_loadClientSideCode()

      # Loads a coffeescript file containing the specific Findings presenter for this Task
      _loadClientSideCode: =>
        if @task.get('run_stats').length == 0
          @region.show(new Backbone.Marionette.ItemView(template: -> ''))
          @region.$el.addClass('tab-loading')
          return _.delay((=>@task.fetch().done(@_loadClientSideCode)), 1000)

        presenterCamel = _.chain(@task.get('presenter')).camelize().capitalize().value()
        presenterClass = -> App.TasksApp?.Findings?[presenterCamel]
        classLoaded = =>
          @task.set('schema', presenterClass())
          @show(@layout, preventDestroy:true)

        # autoload the presenter class if not in scope
        unless presenterClass()?
          initProRequire ["apps/tasks/findings/#{@task.get('presenter')}"], classLoaded
        else
          classLoaded()

      selectStat: (stat) =>
        # deselect all the other stats
        _.each @statsView.collection.models, (m) =>
          m.set('selected', false) unless m is stat
        # select the desired stats
        stat.set('selected', true)
        # hide the loader, if present
        _.defer => @layout?.drilldownRegion?.$el?.removeClass?('tab-loading')

        @controller = @table = null
        if stat.get('controller')?
          @controller = new (stat.get('controller'))(task: @task, region: @drilldownView.tableRegion)
        else if stat.get('view')?
          view = new stat.get('view')(task: @task)
          @drilldownView.tableRegion.show(view)
        else if stat.get('table')?
          # set up the table
          collectionURL = stat.collectionURL(@task)
          collection =
            new Backbone.Collection.extend({},
              url: collectionURL,
              model: Backbone.Model
            )
          # render the table
          @table = App.request "table:component", _.extend {
            actionButtons: [
              {
                label: 'Export'
                click: (selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) =>
                  url = @table.collection.url + '.csv'
                  getParams = _.map(@table.collection.server_api, (v, k) =>
                    v = if _.isFunction(v) then v.call(@table.collection) else v
                    v = if _.isObject(v) then JSON.stringify(v) else v
                    v = 'csv' if k is 'json'
                    "#{encodeURIComponent(k)}=#{encodeURIComponent(v)}"
                  ).join('&')
                  _.each @table.columns, (column) ->
                    getParams += "&columns[]=#{encodeURIComponent(column.attribute)}"
                  url = "#{url}?#{getParams}"
                  $iframe = $('<iframe />', src: url, style: 'display:none').appendTo($('body'))
                  _.delay((=> $iframe.remove()), 30000)
                  $btn = @layout.$el.find('.action-button')
                  $btn.addClass('disabled')
                  _.delay((=> $btn.removeClass('disabled')), 3000)
              }
            ]
            htmlID:     "findings_table_#{_.str.underscored(stat.get('title'))}"
            title:      stat.get('title')
            region:     @drilldownView.tableRegion
            taggable:   false
            selectable: false
            static:     false
            collection: collection
            perPage:    10
          }, stat.get('table')

      # Toggles the tab at the given +idx+
      # @param idx [Number] the zero-based offset of the tab to toggle
      setTabIndex: (idx) =>
        @layout.setTabIndex(idx)

      # Implementation is required by the Pollable concern
      poll: =>
        if @task.isCompleted()
          # stop in 5 seconds, to ensure any last-minute updates are synced.
          _.defer(@stopPolling, @pollInterval)
        @task.fetch()
