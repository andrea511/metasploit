define [
  'jquery'
  'pie_chart'
  'base_view'
  'base_itemview'
  'base_layout'
  'base_compositeview'
  'apps/task_chains/index/templates/index_layout'
  'apps/task_chains/index/templates/index_list'
  'apps/task_chains/index/templates/_task_chain'
  'apps/task_chains/index/templates/legacy_warning'
], ($,PieChart) ->

  @Pro.module 'TaskChainsApp.Index', (Index, App) ->

    class Index.Layout extends App.Views.Layout
      # TODO: We could use the custom renderer with our own global template lookup.
      template: @::templatePath 'task_chains/index/index_layout'

      regions:
        headerRegion:  '#task-chain-header-region'
        listRegion:    '#task-chain-list-region'

    class Index.LegacyWarningView extends App.Views.ItemView
      template: @::templatePath 'task_chains/index/legacy_warning'

      onFormSubmit: ->
        # jQuery Deffered Object that closes modal when resolved.
        defer = $.Deferred()
        formSubmit = () ->
        defer.promise(formSubmit)
        defer.resolve()

        formSubmit

    class Index.TaskChain extends App.Views.ItemView
      template: @::templatePath 'task_chains/index/_task_chain'
      tagName: 'tr'
      className: 'task-chain'

      ui:
        statusCanvas: 'td.status canvas'
        checkbox: 'td.checkbox input'

      events:
        'click @ui.checkbox': 'setSelected'

      addPieChart: ->
        @chart = new PieChart
          canvas: @ui.statusCanvas[0]
          percentage: @model.get('percent_tasks_started')
          text: @model.get('started_tasks')
          percentFill: '#006699'
          textFill: '#006699'
          stroke: 6
          fontSize: '20px'
        @chart.update()

      # On checkbox click, set whether or not the task chain is selected.
      setSelected: ->
        @model.set selected: @ui.checkbox.prop('checked')

      onRender: ->
        if @model.get('state') == 'running'
          @addPieChart()

    class Index.List extends App.Views.CompositeView
      template: @::templatePath 'task_chains/index/index_list'
      childView: Index.TaskChain
      childViewContainer: 'tbody'

      pollingInterval: 12000

      ui:
        newTaskChainLink:     '#new'
        numTotalIndicator:    '#num-total'
        numSelectedIndicator: '#num-selected'
        selectAllToggle:      'th#select-all input'
        sortingArrows:        'th .arrow'
        buttons:              '.toolbar a'
        deleteButton:         'a#delete'
        cloneButton:          'a#clone'
        stopButton:           'a#stop'
        suspendButton:        'a#suspend'
        resumeButton:         'a#unsuspend'
        runButton:            'a#run'
        newButton:            'a#new'

      events:
        'click @ui.deleteButton':            'deleteTaskChains'
        'click @ui.cloneButton':             'cloneTaskChain'
        'click @ui.stopButton':              'stopTaskChains'
        'click @ui.suspendButton':           'suspendTaskChains'
        'click @ui.resumeButton':            'resumeTaskChains'
        'click @ui.runButton':               'runTaskChains'
        'click @ui.selectAllToggle':         'toggleSelectAll'
        'click th.sortable':                 'handleHeaderClick'

      collectionEvents:
        'change:selected': 'setNumSelected enableButtons'
        'sort':            'renderRows'

      # Render the the table rows only.
      renderRows: ->
        # TODO: Ack! I'm using an undocumented "private" method. If anybody knows
        # another way to only render the ItemViews in a CompositeView (other than
        # triggering a 'reset' event on the collection), please let me know.
        @_renderChildren()
        @onRender()

      # Sort the list by the clicked column.
      handleHeaderClick: (e) ->
        $el = $(e.currentTarget)
        $arrow = $el.find 'div.arrow'
        sortColumn = $el.data 'sort-column'
        sortAttribute = @collection.sortAttribute

        # Toggle sort if the current column is sorted
        if (sortColumn == sortAttribute)
          this.collection.sortDirection *= -1
        else
          this.collection.sortDirection = 1

        # Adjust the indicators. Reset everything to hide the indicator.
        @ui.sortingArrows.removeClass('up').removeClass('down')

        # Now show the correct icon on the correct column.
        if (@collection.sortDirection == 1)
          $arrow.addClass 'up'
        else
          $arrow.addClass 'down'

        # Now sort the collection
        @collection.sortRows sortColumn

      # Disable all buttons, except those which are always enabled.
      disableAllButtons: ->
        @ui.buttons.addClass 'disabled'
        @ui.newButton.removeClass 'disabled'

      enableButtons: ->
        # TODO: There should be collection methods for grabbing these,
        # rather than relying on these magic strings.
        @disableAllButtons()

        selectedChains = @collection.where selected: true

        return false if selectedChains.size() == 0

        runningChains = _.filter(selectedChains, ((tc) => tc.get('state') == 'running'))

        if runningChains.size() > 0
          @ui.stopButton.removeClass 'disabled'
        else
          @ui.deleteButton.removeClass 'disabled'

        unless runningChains.size() == selectedChains.size()
          @ui.runButton.removeClass 'disabled'

        scheduledChains = _.filter selectedChains, (tc) =>
          tc.get('schedule_state') == 'scheduled' || tc.get('scheduled_state') == 'once'

        if scheduledChains.size() > 0 || runningChains.size() > 0
          @ui.suspendButton.removeClass 'disabled'

        suspendedChains = _.filter selectedChains, (tc) =>
          tc.get('schedule_state') == 'suspended'

        if suspendedChains.size() > 0
          @ui.resumeButton.removeClass 'disabled'

        if selectedChains.size() == 1
          @ui.cloneButton.removeClass 'disabled'

      cloneTaskChain: ->
        return false if @ui.cloneButton.hasClass 'disabled'

        if @collection.selected().size() != 1
          alert "Please select one task chain to clone."
          return false

        window.location = @collection.selected()[0].get('clone_workspace_task_chain_path')

      deleteTaskChains: ->
        return false if @ui.deleteButton.hasClass 'disabled'
        taskChainsToDelete = @collection.selected()

        if taskChainsToDelete.size() == 1
          selectedTaskChainsIndicator = 'task chain'
        else if taskChainsToDelete.size() > 1
          selectedTaskChainsIndicator = 'task chains'

        if confirm("Are you sure you want to delete the selected #{selectedTaskChainsIndicator}?")
          @collection.destroySelected()

      stopTaskChains: ->
        return false if @ui.stopButton.hasClass 'disabled'
        taskChainsToStop = @collection.selected()

        if taskChainsToStop.size() == 1
          selectedTaskChainsIndicator = 'task chain'
        else if taskChainsToStop.size() > 1
          selectedTaskChainsIndicator = 'task chains'

        if confirm("Are you sure you want to stop the selected #{selectedTaskChainsIndicator}?")
          @collection.stopSelected()

      suspendTaskChains: ->
        return false if @ui.suspendButton.hasClass 'disabled'

        @collection.suspendSelected()

      resumeTaskChains: ->
        return false if @ui.resumeButton.hasClass 'disabled'

        @collection.resumeSelected()

      runTaskChains: ->
        return false if @ui.runButton.hasClass 'disabled'

        selectedSize = @collection.where(selected: true).size()

        unless selectedSize > 1 && !confirm("Are you sure you want to run #{selectedSize} task chains at once?")
          @disableAllButtons()
          @collection.runSelected()

      # Toggle selection of all task chains.
      toggleSelectAll: ->
        selectAllToggleState = @ui.selectAllToggle.prop('checked')
        @collection.invoke 'set', { selected: selectAllToggleState }

        # Rather than triggering a re-render, let's just do this with some jQuery.
        @$el.find('input[type="checkbox"]').prop 'checked', selectAllToggleState

      # Display the number of task chains selected.
      setNumSelected: ->
        @ui.numSelectedIndicator.html @collection.selected().size()

      # Set the total number of task chains in the selection indicator.
      setNumTotal: ->
        @ui.numTotalIndicator.html @collection.size()

      # Correctly set the href for the "New Task Chain" link.
      setNewLinkPath: ->
        @ui.newTaskChainLink.attr('href', gon.new_workspace_task_chains_path)

      # Periodically update the task chain list.
      queueNextPoll: ->
        # Calling sort here triggers a re-render (see collectionEvents hash).
        @_timeout = setTimeout((=> @refreshList() ), @pollingInterval)

      # Fetch and resort the contents of the list.
      refreshList: ->
        clearTimeout(@_timeout)
        @collection.fetch(success: (=> @collection.sort()))

      onRender: ->
        @setNewLinkPath()
        @setNumTotal()
        @queueNextPoll()

      onCompositeCollectionRendered: ->
        @enableButtons()

