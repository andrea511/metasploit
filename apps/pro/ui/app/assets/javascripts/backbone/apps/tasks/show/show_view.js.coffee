define [
  'jquery'
  'pie_chart'
  'base_view'
  'base_itemview'
  'base_layout'
  'base_collectionview'
  'apps/tasks/show/templates/layout'
  'apps/tasks/show/templates/header'
  'apps/tasks/show/templates/stat'
  'apps/tasks/show/templates/drilldown'
  'lib/concerns/views/spinner'
], ($, PieChart) ->

  @Pro.module 'TasksApp.Show', (Show, App) ->

    class Show.Layout extends App.Views.Layout

      template: @::templatePath 'tasks/show/layout'

      attributes:
        class: 'stats'

      regions:
        headerRegion:    '.rollup-header'
        consoleRegion:   '.console-area'
        statsRegion:     '.stats-region'
        drilldownRegion: '.drilldown-area'

      ui:
        tabContainer: 'ul.rollup-tabs'
        pageContainer: 'div.rollup-page'

      events:
        'click ul.rollup-tabs li': 'tabClicked'

      # Called when the user clicks a tab
      tabClicked: (e) =>
        @trigger('tasksApp:show:tabClicked', $(e.currentTarget).index())

      # Sets the selected tab and page to the given index
      # @param idx [Number] the (zero-offset) index of the tab to select
      setTabIndex: (idx) =>
        @ui.tabContainer.find('li').removeClass('selected').eq(idx).addClass('selected')
        @ui.pageContainer.find('div.rollup-tab').hide().eq(idx).show()

    class Show.Drilldown extends App.Views.Layout

      template: @::templatePath 'tasks/show/drilldown'

      regions:
        tableRegion: '.table-region'

    class Show.Header extends App.Views.ItemView
      @include "Spinner"

      template: @::templatePath 'tasks/show/header'

      ui:
        pauseButton:    '#pause'
        resumeButton:   '#resume'
        stopButton:     '#stop'
        controlButtons: '.control-button'

      events:
        'click @ui.pauseButton':  'pauseTask'
        'click @ui.resumeButton': 'resumeTask'
        'click @ui.stopButton':   'stopTask'

      modelEvents:
        'change:completed_at': 'render'
        'change:state': 'render'

      pauseTask: =>
        return if @ui.pauseButton.hasClass 'disabled'

        @disableControlButtons()
        this.model.pause()

      resumeTask: =>
        return if @ui.resumeButton.hasClass 'disabled'

        @trigger 'tasksApp:resume'

        @disableControlButtons()
        this.model.resume()

      stopTask: =>
        return if @ui.stopButton.hasClass 'disabled'

        @disableControlButtons()
        this.model.stop()

      #
      # Disable the pause/resume/stop control buttons.
      disableControlButtons: =>
        @showSpinner()
        @ui.controlButtons.addClass 'disabled'

    class Show.StatView extends App.Views.ItemView

      template: @::templatePath 'tasks/show/stat'

      attributes:
        class: 'generic-stat-wrapper'

      ui:
        canvas: 'canvas'
        numStat: 'span.numStat'
        totalStat: 'span.totalStat'
        badge: '.stat-badge span'
        label: 'label.desc'

      triggers:
        'click div': 'stat:clicked'

      # @property [PieChart]
      pie: null

      initialize: =>
        numStat = @model.get('numStat')
        totalStat = @model.get('totalStat')
        @listenTo @model, "change:selected", @_updateSelected
        @listenTo(@model.get('run_stats').task, "change", @_updateBadge)
        @listenTo(numStat, 'change', @update) if numStat?
        @listenTo(totalStat, 'change', @update) if totalStat?

      onShow: =>
        @update()
        @_updateClickable()

      update: =>
        @_updatePie()
        @_updateBadge()
        @ui.numStat.text(@model.get('numStat')?.get('data'))
        @ui.totalStat.text(@model.get('totalStat')?.get('data'))
        @trigger('stat:updated')

      _updateBadge: =>
        val = @model.get('schema')?.badge?(@model.get('run_stats').task)
        @ui.badge.parent().toggle(!!val)
        @ui.badge.html(val) if val

      _updatePie: =>
        if @model.isPercentage() and @model.shouldShowPieChart()
          @_buildPie() unless @pie?
          num = @model.get('numStat')?.get('data') || 0
          total = @model.get('totalStat')?.get('data') || num
          @ui.label.attr('data-count',num)
          @pie.setText(num+'', shouldUpdate: false)
          @pie.setPercentage(num/total*100.0, shouldUpdate: false)
          @pie.update()

      _updateClickable: =>
        @$el.attr('clickable', @model.get('clickable'))

      _updateSelected: =>
        @$el.toggleClass('selected', @model.get('selected'))

      _buildPie: =>
        @pie ||= new PieChart
          canvas: @ui.canvas[0]
          innerFill: @model.bgColor()
          innerFillHover: @model.bgColor()
          textFill: @model.color()
          textFillHover: @model.color()
          fontSize: '20px'
          outerFill: @model.stroke()
          percentFill: @model.percentageStroke()
          outerFillHover: @model.stroke()
          percentFillHover: @model.percentageStroke()

    class Show.Stats extends App.Views.CollectionView

      childView: Show.StatView

      attributes:
        class: 'center'

      collectionEvents:
        'add': '_deferFixWidths'

      onRender: =>
        @_fixWidths()

      _deferFixWidths: =>
        _.defer @_fixWidths

      _fixWidths: =>
        @$el.find('>*').css(width: "#{100/@collection.models.length}%")
