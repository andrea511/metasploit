
jQuery ($) ->
  window.TaskChain = class TaskChain
    @container           = "ul#task-chain"
    @taskSelector        = "select#task-selector"
    @configViewport      = "div#config-viewport"
    @configWrapperClass  = "task-config-wrapper"
    @deleteButtonClass   = "task-delete"
    @mainFormSelector    = "form#new_task_chain"
    @uberSubmitButton    = "#snowball-submitter"
    @moduleSelectorLinks = "a.module-name"

    # Options for module config popups 
    # Callbacks that control their behavior
    @moduleConfigPopupOptions: 
      width: 980
      height: 600 
      autoOpen:false
      modal:true
      title: "Configure Module"
      buttons:
        [
          {
            text: "OK"
            click: ->
                dialogBox  = $(this)
                infoClass  = 'task-chain-item-extra-info' #p tag where we put the module name

                taskNumber = TaskChain.numberFromId(dialogBox.attr('id'))
                taskId     = TaskChain.taskId(taskNumber)
                taskItem   = $("##{taskId}")
                moduleName = taskItem.find(".#{infoClass}")   

                # If there's no module name, this is the first time the dialog has been open
                if moduleName.length is 0
                  pathInputName   = "inputs_for_task[#{taskNumber}][path]"
                  modulePath = dialogBox.find("input[name='#{pathInputName}']").val()
    
                  $("##{taskId}").append("<p class='#{infoClass}'>#{modulePath}</p>")

                  TaskChain.rebindMainForm()

                  # Make the click event for the module task item open this dialog instead
                  $("##{TaskChain.configId(taskNumber)}").remove()
                  taskItem.unbind('selectableselected')
                  taskItem.bind 'click', (e)->
                    TaskChain.singleSelectTask(taskId)
                    dialogBox.dialog('open')

                # Close at the end whether we're altering inputs or not
                dialogBox.dialog('close')

          },
          {
            text: "Cancel"
            click: ->
              dialogBox  = $(this)
              taskNumber = TaskChain.numberFromId(dialogBox.attr('id'))
              $("##{TaskChain.configId(taskNumber)}").hide()
              dialogBox.dialog('close')
          }
        ]

    
    # class of hidden input correlating chain order w/ task type
    @scheduledTaskInputClass = "scheduled_task"


    # Inputs we leave alone when concatenating 
    # config formsfor submit
    @inputSkipNames = ["utf8", "authenticity_token", "_method"]

    # Number of task elements currently in taskchain container
    @currentSize: () ->
      $(TaskChain.container).children().size()

    # Form element for TaskChain creation
    @topForm:
      $(TaskChain.taskSelector).parents('form')

    # Id for a task item's corresponding hidden input
    @scheduleInputId: (taskNumber) ->
      "task-input-#{taskNumber}"

    # Name of a task's hidden input
    @taskInputNameString: (taskNumber) ->
      "scheduled_task_types[#{taskNumber}]"

    # Unselect any selected tasks in task chain
    @unselectAllTasks: ->
      $("#{TaskChain.container} li.ui-selected").removeClass('ui-selected')

    # Programatically select specific task
    @singleSelectTask: (taskId) ->
      TaskChain.unselectAllTasks()
      $("##{taskId}").addClass('ui-selected')

    # Id of a task's config div
    @configId: (taskNumber) ->
      "config-#{taskNumber}"

    # Id of a task in the chain
    @taskId: (taskNumber) ->
      "task-#{taskNumber}"

    # Id of a module's config popup div
    @moduleConfigPopupId: (taskNumber) ->
      "module-config-#{taskNumber}"

    # Class for a module's config popup div
    @moduleConfigClass = "module-config"

    # Assume number is last part of split of '-'
    @numberFromId: (someId) ->
      parseInt(someId.split('-').pop())

    # Some config forms create submit bindings that we don't want
    @rebindMainForm: ->
      $("#{TaskChain.mainFormSelector}").unbind('submit')
      TaskChain.elementBehaviors.formSubmission.bind()

    # returns true if the task chain has specified type
    @hasTaskType: (type)->
      $("input.#{TaskChain.scheduledTaskInputClass}[value='#{type}']").length > 0

    # AJAX load module search form results
    @loadModuleSearch: (query, loadTargetId) ->
      path = "/workspaces/#{window.currentWorkspaceId}/modules"
      args = 
        _nl: "1"
        q: query

      $.ajax path,
        type: "POST"
        data: args
        success: (data, textStatus, jqXHR) ->
          $("##{loadTargetId}").html(data)
          TaskChain.elementBehaviors.moduleSelection.bind()
          TaskChain.elementBehaviors.moduleSearch.bind()


    # AJAX load content for single-module config
    # or load existing form if already in DOM for this module
    @loadModule: (moduleFullName, configWrapperId) ->
      taskNumber = TaskChain.numberFromId(configWrapperId)
      dialogId = TaskChain.moduleConfigPopupId(taskNumber)
      dialogBox = $("<div id='#{dialogId}' class='#{TaskChain.moduleConfigClass}'></div>")
      path = "/workspaces/#{window.currentWorkspaceId}/tasks/new_module_run/#{moduleFullName}"
      args = _nl:"1"
      $.get path, args, (data) ->
        $data = $(data)
        pathInputName   = "inputs_for_task[#{taskNumber}][path]"
        formPath        = $data.find('form').attr('action')
        subString       = "/workspaces/#{window.currentWorkspaceId}/tasks/start_module_run/"
        modulePath      = formPath.replace(subString, "")
        alteredData     = $data.attr('id','')

        alteredData.find('form').append("<input type='hidden' name='#{pathInputName}' value='#{modulePath}' />")
        dialogBox.html(TaskChain.resetInputsForForm(alteredData, taskNumber, 'module_run'))
        dialogBox.dialog(TaskChain.moduleConfigPopupOptions)
        dialogBox.dialog('open')
      


    # Returns input element for the order of the tasks, by ID number
    # Chop the serialized string to get the sweet, sweet values within
    @taskOrderInput: () ->
      orderString = $(TaskChain.container).sortable('serialize', {key:'o'})
      orderString = orderString.replace(/&o=/g,',').replace(/o=/, '')
      "<input type='hidden' name='scheduled_task_order' value='#{orderString}'>"

    @selectTaskAndShowConfig: (taskId, performSelect=true) ->
      if performSelect
        TaskChain.singleSelectTask(taskId)
      taskNumber = TaskChain.numberFromId(taskId)
      $(TaskChain.configViewport).find(".#{TaskChain.configWrapperClass}").hide()
      $(TaskChain.configViewport).find("##{TaskChain.configId(taskNumber)}").show()

    # Rename the inputs so that you can have multiple
    @resetInputsForForm: (form_html, taskNumber, taskType) ->
      configForm     = $(form_html)
      taskNamePrefix = ""
      
      if taskType == "collect"
        taskNamePrefix = "#{taskType}_evidence_task"
      else if taskType == "report"
        taskNamePrefix = "#{taskType}"
      else
        taskNamePrefix = "#{taskType}_task"

      multipleParamNamePrefix = "inputs_for_task[#{taskNumber}]"

      configForm.find('input, textarea, select').each (index, element) ->
        if element in TaskChain.inputSkipNames
          return null # the way you continue to next inside a jQuery each
        currentName = $(element).attr('name')
        if currentName
          newName = currentName.replace(taskNamePrefix, multipleParamNamePrefix)
          $(element).attr('name', newName)
      configForm


    # AJAX load config options from the TasksController
    @loadTaskConfigForm: (taskType, taskNumber) ->
      configWrapper = "<div id='#{TaskChain.configId(taskNumber)}' class='#{TaskChain.configWrapperClass}' tasktype='#{taskType}'></div>"
      wId = window.currentWorkspaceId

      # Module_run needs to load a list of modules, not single module
      # config
      filePath = switch taskType
        when "module_run" then "/workspaces/#{wId}/modules"
        when "report"     then "/workspaces/#{wId}/reports/new"
        else                   "/workspaces/#{wId}/tasks/new_#{taskType}"
      args = _nl:"1"
      $.get filePath, args, (data)->
        formHtml = TaskChain.resetInputsForForm(data, taskNumber, taskType)
        $(TaskChain.configViewport).append($(configWrapper).html(formHtml).hide())
        theId = TaskChain.taskId(taskNumber)
        TaskChain.selectTaskAndShowConfig(theId)

        # Disable any onclick actions for control bar buttons.
        $('.control-bar span.button a').removeAttr 'onclick'

        # Trigger a custom event to inform the page that a new task has been loaded.
        if taskType == 'report'
          $('body').trigger('reportLoaded')
        else
          $('body').trigger('taskLoaded')
  
        # Bind the module link's behavior on module list
        TaskChain.elementBehaviors.moduleSelection.bind()
        # Bind the module search bar's behavior to work w/ AJAX
        TaskChain.elementBehaviors.moduleSearch.bind()

        # Bind bruteforce list checkboxes for select all
        if taskType == "bruteforce"
          TaskChain.elementBehaviors.bruteForceList.bind()

        # Bind collect list checkboxes for select all
        if taskType == "collect"
          TaskChain.elementBehaviors.collectEvidenceList.bind()

        # Bind cleanup list checkboxes for select all
        if taskType == "cleanup"
          TaskChain.elementBehaviors.cleanupList.bind()

        # Reset any submit bindings that could've gotten applied to our main form
        # by a loaded task config form (happens w/ Bruteforce and w/ any module run
        # that involves a search)
        TaskChain.rebindMainForm()
      

    # Place a new task in the taskchain container
    @addTask: (taskType) ->
      # Task metadata
      taskNumber =  (TaskChain.currentSize() + 1)
      taskId = TaskChain.taskId(taskNumber)
      taskName = TaskChain.nameFromType(taskType)

      # What goes in the TaskChain.container element
      taskElem = "<li class='scheduled-task' id='#{taskId}'><span class='task-name'>#{taskName}</span><a class='#{TaskChain.deleteButtonClass}'>Delete</a></li>"
      handleElem = "<div class='handle'><span class='ui-icon ui-icon-carat-2-n-s'></span></div>"
      $(TaskChain.container).append($(taskElem).prepend(handleElem))

      # Input tells controller what kind of task it is
      taskInput = "<input type='hidden' class='#{TaskChain.scheduledTaskInputClass}' name='#{TaskChain.taskInputNameString(taskNumber)}' value='#{taskType}' id='#{TaskChain.scheduleInputId(taskNumber)}'>"
      $(TaskChain.topForm).append(taskInput)

      # Grab the appropriate form
      $(TaskChain.loadTaskConfigForm(taskType, taskNumber))

      # TODO: refactor event bindings w/ .live() or .on() so this is unnecessary
      # Bind the new item's delete button
      TaskChain.elementBehaviors.taskDeletion.bind()

    
    # Remove a task (and all associated DOM objects) from the taskchain container
    @removeTask: (taskElementId) ->
      taskNumber = TaskChain.numberFromId(taskElementId)
      
      # remove config, hidden input, and selectable/sortable ui item
      configSel = "##{TaskChain.configId(taskNumber)}"
      inputSel  = "##{TaskChain.scheduleInputId(taskNumber)}"
      itemSel   = "##{TaskChain.taskId(taskNumber)}"

      # delete module config if it's been added
      moduleSel = "##{TaskChain.moduleConfigPopupId(taskNumber)}"

      $(configSel).remove()
      $(inputSel).remove()
      $(moduleSel).remove()
      $(itemSel).hide().remove()



    # Reset the task selector - for use on change
    @resetSelector: ->
      sel = TaskChain.taskSelector
      $(sel).val($('options:first', sel).val())

    # Convert "foo_bar" into "Foo bar"
    @nameFromType: (taskType) ->
      capitalized = taskType.charAt(0).toUpperCase() + taskType.slice(1)
      capitalized.replace("_"," ")

    # Updates name of element to format needed for TaskChain context
    @reportNameForChain: (element, taskNum) ->
      element.name = element.name.replace(/report\[/, "inputs_for_task[#{taskNum}][")

    # Any alterations needed to the view for report creation for the
    # task chain context
    @transformReportViewForChain: () ->
      container = $('div#report_container')
      # Hide the normal generate report submit button:
      reportSubmitButton = container.find('div.one_col_no_sidebar fieldset.buttons')
      reportSubmitButton.remove()

      # Update the name attrs on inputs so the snowball
      # collection stores config in the right structure
      taskNum = container.parent().attr("id").split('-').last()
      inputs = $.grep(container.find("input"), (element, index) ->
        # -1 not in array; >=0 is position in array
        $.inArray(element.name, TaskChain.inputSkipNames) < 0
      )
      TaskChain.reportNameForChain(input, taskNum) for input in inputs
      # Same thing, but for dropdowns
      selects = $.grep(container.find("select"), (element, index) ->
        $.inArray(element.name, TaskChain.selectSkipNames) < 0
      )
      TaskChain.reportNameForChain(select, taskNum) for select in selects


# ------------------------ ELEMENT BEHAVIOR -----------------------------------
    # Various bindings and behaviors attached to page elements
    @elementBehaviors:

      # Use select element to add task to chain; then reset select
      taskSelector:
        bind: ->
          $(TaskChain.taskSelector).change ()->
            taskType = $(this).val()
            TaskChain.addTask(taskType)
            TaskChain.resetSelector()

      reportSubmitHider:
        bind: ->
          $('body').bind 'reportLoaded', -> TaskChain.transformReportViewForChain()

      # Add sortability and selectability to the items in the task chain
      taskSortingAndSelecting:
        bind: ->
          $(TaskChain.container).sortable({handle:'.handle'}).selectable(
            selected: ->
              theId = $(this).find('li.ui-selected').attr('id')
              TaskChain.selectTaskAndShowConfig(theId, false)
          )

      # Configure module selector link event handlers and do other
      # things that need to happen after loading a module list.
      moduleSelection:
        bind: ->
          # Turn off search instructions stuff, since it doesn't display
          # correctly w/out JS wrangling anyway.
          wrapperDiv = $('div.center')
          searchForm = wrapperDiv.find('form.searchform')
          wrapperDiv.html(searchForm)
          $(TaskChain.moduleSelectorLinks).click (event) ->
            taskLink = $(this)
            taskConfigId = taskLink.parents(".#{TaskChain.configWrapperClass}").attr('id')
            TaskChain.loadModule(taskLink.attr('module_fullname'), taskConfigId)
            return false


      # Hijack the search form for modules and route it through AJAX
      # instead so that it can be seen in this screen.
      moduleSearch:
        bind: ->
          inputSel = "input[name='q']"
          $("div.task-config-wrapper #{inputSel}").parents('form').submit ->
            query = $(this).find(inputSel).val()
            wrapperId = $(this).parents("div.#{TaskChain.configWrapperClass}").attr('id')
            TaskChain.loadModuleSearch(query, wrapperId)
            return false


      # Ensure that bruteforce select all, etc works right
      bruteForceList:
        bind: ->
          $("#all_services").checkAll $("#service_list")
          $("#all_cred_files").checkAll $("#cred_file_list")

      # Ensure select all works right
      collectEvidenceList:
        bind: ->
          $("#collect_all_sessions").checkAll $("#collect_sessions")


      # Ensure select all works right
      cleanupList:
        bind: ->
          $("#cleanup_all_sessions").checkAll $("#cleanup_sessions")


      # Handles all pre-processing to send one giant params hash to
      # controller.
      formSubmission:
        bind: ->
          $(TaskChain.mainFormSelector).submit ->

            if $("#task_chain_clear_workspace_before_run").is(":checked")
              unless confirm("This will DELETE all project data before running!")
                enableSubmitButtons()
                return false

            if Scheduler.isMissingDate()
              alert("Please provide a schedule date.")
              enableSubmitButtons()
              return false

            if $("#task_chain_name").val() is ''
              alert("Please provide a name for the chain!")
              enableSubmitButtons()
              return false

            if $(TaskChain.container).find('li').length is 0
              alert("You can't save a chain with no tasks!")
              enableSubmitButtons()
              return false
            else

              # Prevent it from asking you about nav'ing away
              $(window).unbind('beforeunload') 
              # Get the order of tasks into an input on the form
              form = $(this)
              form.append($(TaskChain.taskOrderInput()))

              # The kinds of elements that hold data
              dataElementSelector = "input, textarea, select"
              
              # remove triply-nested form! it makes IE9 choke
              $('form#cred-delete-form').remove()

              # The giant array of all data elements that will be appended to main form
              dataSnowball = []

              # Get all task configs
              $(".task-config-wrapper").each (index, configDiv) ->
                $configDiv = $(configDiv)
                dataSnowball = dataSnowball.concat $configDiv.find(dataElementSelector)

              # Get the module_run stuff which lives in pop-ups
              if TaskChain.hasTaskType('module_run')
                $(".module-config").each (index, configDiv) ->
                  $configDiv = $(configDiv)
                  dataSnowball = dataSnowball.concat $configDiv.find(dataElementSelector)

              # Append the things in the data snowball to the main task chain creation form
              dataSnowball.each (elementArray, index) ->
                elementArray.each (index, element) ->
                  $element = $(element)
                  unless $element.attr('name') in TaskChain.inputSkipNames
                    $element.hide()
                    form.append($element)


      # Confirm navigation away from page if user has added tasks to chain
      navigatingAway:
        bind: ->
          $(window).bind 'beforeunload', ->
            if $(TaskChain.container).find('li').length > 0
              return "You have tasks in your schedule..."

      # What happens when you click the delete button
      taskDeletion:
        bind: ->
          buttonOptions =
            text: false
            icons:
              primary:'ui-icon-trash'

          delSel = ".#{TaskChain.deleteButtonClass}"
          $(delSel).button(buttonOptions).removeClass('ui-selectee')
          $(delSel).click (event) ->
            taskId = $(this).parents('li').attr('id')
            TaskChain.removeTask(taskId)
            event.stopImmediatePropagation()


    # Call the bind function for each item in @element_behaviors, 
    # setting the jQuery event bindings each in turn
    @bind: ->
      binding.bind() for element, binding of @elementBehaviors

  $(document).ready ->
    TaskChain.bind()
