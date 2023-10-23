(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  jQuery(function($) {
    var TaskChain;
    window.TaskChain = TaskChain = (function() {

      function TaskChain() {}

      TaskChain.container = "ul#task-chain";

      TaskChain.taskSelector = "select#task-selector";

      TaskChain.configViewport = "div#config-viewport";

      TaskChain.configWrapperClass = "task-config-wrapper";

      TaskChain.deleteButtonClass = "task-delete";

      TaskChain.mainFormSelector = "form#new_task_chain";

      TaskChain.uberSubmitButton = "#snowball-submitter";

      TaskChain.moduleSelectorLinks = "a.module-name";

      TaskChain.moduleConfigPopupOptions = {
        width: 980,
        height: 600,
        autoOpen: false,
        modal: true,
        title: "Configure Module",
        buttons: [
          {
            text: "OK",
            click: function() {
              var dialogBox, infoClass, moduleName, modulePath, pathInputName, taskId, taskItem, taskNumber;
              dialogBox = $(this);
              infoClass = 'task-chain-item-extra-info';
              taskNumber = TaskChain.numberFromId(dialogBox.attr('id'));
              taskId = TaskChain.taskId(taskNumber);
              taskItem = $("#" + taskId);
              moduleName = taskItem.find("." + infoClass);
              if (moduleName.length === 0) {
                pathInputName = "inputs_for_task[" + taskNumber + "][path]";
                modulePath = dialogBox.find("input[name='" + pathInputName + "']").val();
                $("#" + taskId).append("<p class='" + infoClass + "'>" + modulePath + "</p>");
                TaskChain.rebindMainForm();
                $("#" + (TaskChain.configId(taskNumber))).remove();
                taskItem.unbind('selectableselected');
                taskItem.bind('click', function(e) {
                  TaskChain.singleSelectTask(taskId);
                  return dialogBox.dialog('open');
                });
              }
              return dialogBox.dialog('close');
            }
          }, {
            text: "Cancel",
            click: function() {
              var dialogBox, taskNumber;
              dialogBox = $(this);
              taskNumber = TaskChain.numberFromId(dialogBox.attr('id'));
              $("#" + (TaskChain.configId(taskNumber))).hide();
              return dialogBox.dialog('close');
            }
          }
        ]
      };

      TaskChain.scheduledTaskInputClass = "scheduled_task";

      TaskChain.inputSkipNames = ["utf8", "authenticity_token", "_method"];

      TaskChain.currentSize = function() {
        return $(TaskChain.container).children().size();
      };

      TaskChain.topForm = $(TaskChain.taskSelector).parents('form');

      TaskChain.scheduleInputId = function(taskNumber) {
        return "task-input-" + taskNumber;
      };

      TaskChain.taskInputNameString = function(taskNumber) {
        return "scheduled_task_types[" + taskNumber + "]";
      };

      TaskChain.unselectAllTasks = function() {
        return $("" + TaskChain.container + " li.ui-selected").removeClass('ui-selected');
      };

      TaskChain.singleSelectTask = function(taskId) {
        TaskChain.unselectAllTasks();
        return $("#" + taskId).addClass('ui-selected');
      };

      TaskChain.configId = function(taskNumber) {
        return "config-" + taskNumber;
      };

      TaskChain.taskId = function(taskNumber) {
        return "task-" + taskNumber;
      };

      TaskChain.moduleConfigPopupId = function(taskNumber) {
        return "module-config-" + taskNumber;
      };

      TaskChain.moduleConfigClass = "module-config";

      TaskChain.numberFromId = function(someId) {
        return parseInt(someId.split('-').pop());
      };

      TaskChain.rebindMainForm = function() {
        $("" + TaskChain.mainFormSelector).unbind('submit');
        return TaskChain.elementBehaviors.formSubmission.bind();
      };

      TaskChain.hasTaskType = function(type) {
        return $("input." + TaskChain.scheduledTaskInputClass + "[value='" + type + "']").length > 0;
      };

      TaskChain.taskIsReport = function(taskNumber) {
        return $("#" + TaskChain.configId(taskNumber)).find('#report_option_forms').length > 0;
      };

      TaskChain.chosenReportConfigForTask = function(taskConfig) {
        var taskType;
        taskType = taskConfig.find('select#report_selector').val();
        taskType = taskType.toLowerCase();
        return taskConfig.find("#report_option_forms #report_form_" + taskType);
      };

      TaskChain.loadModuleSearch = function(query, loadTargetId) {
        var args, path;
        path = "/workspaces/" + window.currentWorkspaceId + "/modules";
        args = {
          _nl: "1",
          q: query
        };
        return $.ajax(path, {
          type: "POST",
          data: args,
          success: function(data, textStatus, jqXHR) {
            $("#" + loadTargetId).html(data);
            TaskChain.elementBehaviors.moduleSelection.bind();
            return TaskChain.elementBehaviors.moduleSearch.bind();
          }
        });
      };

      TaskChain.loadModule = function(moduleFullName, configWrapperId) {
        var args, dialogBox, dialogId, path, taskNumber;
        taskNumber = TaskChain.numberFromId(configWrapperId);
        dialogId = TaskChain.moduleConfigPopupId(taskNumber);
        dialogBox = $("<div id='" + dialogId + "' class='" + TaskChain.moduleConfigClass + "'></div>");
        path = "/workspaces/" + window.currentWorkspaceId + "/tasks/new_module_run/" + moduleFullName;
        args = {
          _nl: "1"
        };
        return $.get(path, args, function(data) {
          var $data, alteredData, formPath, modulePath, pathInputName, subString;
          $data = $(data);
          pathInputName = "inputs_for_task[" + taskNumber + "][path]";
          formPath = $data.find('form').attr('action');
          subString = "/workspaces/" + window.currentWorkspaceId + "/tasks/start_module_run/";
          modulePath = formPath.replace(subString, "");
          alteredData = $data.attr('id', '');
          alteredData.find('form').append("<input type='hidden' name='" + pathInputName + "' value='" + modulePath + "' />");
          dialogBox.html(TaskChain.resetInputsForForm(alteredData, taskNumber, 'module_run'));
          dialogBox.dialog(TaskChain.moduleConfigPopupOptions);
          return dialogBox.dialog('open');
        });
      };

      TaskChain.taskOrderInput = function() {
        var orderString;
        orderString = $(TaskChain.container).sortable('serialize', {
          key: 'o'
        });
        orderString = orderString.replace(/&o=/g, ',').replace(/o=/, '');
        return "<input type='hidden' name='scheduled_task_order' value='" + orderString + "'>";
      };

      TaskChain.selectTaskAndShowConfig = function(taskId, performSelect) {
        var taskNumber;
        if (performSelect == null) {
          performSelect = true;
        }
        if (performSelect) {
          TaskChain.singleSelectTask(taskId);
        }
        taskNumber = TaskChain.numberFromId(taskId);
        $(TaskChain.configViewport).find("." + TaskChain.configWrapperClass).hide();
        return $(TaskChain.configViewport).find("#" + (TaskChain.configId(taskNumber))).show();
      };

      TaskChain.resetInputsForForm = function(form_html, taskNumber, taskType) {
        var configForm, multipleParamNamePrefix, taskNamePrefix;
        configForm = $(form_html);
        taskNamePrefix = "";
        if (taskType === "collect") {
          taskNamePrefix = "" + taskType + "_evidence_task";
        } else {
          taskNamePrefix = "" + taskType + "_task";
        }
        multipleParamNamePrefix = "inputs_for_task[" + taskNumber + "]";
        configForm.find('input, textarea, select').each(function(index, element) {
          var currentName, newName;
          if (__indexOf.call(TaskChain.inputSkipNames, element) >= 0) {
            return null;
          }
          currentName = $(element).attr('name');
          if (currentName) {
            newName = currentName.replace(taskNamePrefix, multipleParamNamePrefix);
            return $(element).attr('name', newName);
          }
        });
        return configForm;
      };

      TaskChain.loadTaskConfigForm = function(taskType, taskNumber) {
        var args, configWrapper, filePath, wId;
        configWrapper = "<div id='" + (TaskChain.configId(taskNumber)) + "' class='" + TaskChain.configWrapperClass + "' tasktype='" + taskType + "'></div>";
        wId = window.currentWorkspaceId;
        filePath = "";
        if (taskType === "module_run") {
          filePath = "/workspaces/" + wId + "/modules";
        } else {
          filePath = "/workspaces/" + wId + "/tasks/new_" + taskType;
        }
        args = {
          _nl: "1"
        };
        return $.get(filePath, args, function(data) {
          var formHtml, theId;
          formHtml = TaskChain.resetInputsForForm(data, taskNumber, taskType);
          $(TaskChain.configViewport).append($(configWrapper).html(formHtml).hide());
          theId = TaskChain.taskId(taskNumber);
          TaskChain.selectTaskAndShowConfig(theId);
          $('.control-bar span.button a').removeAttr('onclick');
          $('body').trigger('taskLoaded');
          TaskChain.elementBehaviors.moduleSelection.bind();
          TaskChain.elementBehaviors.moduleSearch.bind();
          if (taskType === "bruteforce") {
            TaskChain.elementBehaviors.bruteForceList.bind();
          }
          if (taskType === "collect") {
            TaskChain.elementBehaviors.collectEvidenceList.bind();
          }
          if (taskType === "cleanup") {
            TaskChain.elementBehaviors.cleanupList.bind();
          }
          return TaskChain.rebindMainForm();
        });
      };

      TaskChain.addTask = function(taskType) {
        var handleElem, taskElem, taskId, taskInput, taskName, taskNumber;
        taskNumber = TaskChain.currentSize() + 1;
        taskId = TaskChain.taskId(taskNumber);
        taskName = TaskChain.nameFromType(taskType);
        taskElem = "<li class='scheduled-task' id='" + taskId + "'><span class='task-name'>" + taskName + "</span><a class='" + TaskChain.deleteButtonClass + "'>Delete</a></li>";
        handleElem = "<div class='handle'><span class='ui-icon ui-icon-carat-2-n-s'></span></div>";
        $(TaskChain.container).append($(taskElem).prepend(handleElem));
        taskInput = "<input type='hidden' class='" + TaskChain.scheduledTaskInputClass + "' name='" + (TaskChain.taskInputNameString(taskNumber)) + "' value='" + taskType + "' id='" + (TaskChain.scheduleInputId(taskNumber)) + "'>";
        $(TaskChain.topForm).append(taskInput);
        $(TaskChain.loadTaskConfigForm(taskType, taskNumber));
        return TaskChain.elementBehaviors.taskDeletion.bind();
      };

      TaskChain.removeTask = function(taskElementId) {
        var configSel, inputSel, itemSel, moduleSel, taskNumber;
        taskNumber = TaskChain.numberFromId(taskElementId);
        configSel = "#" + (TaskChain.configId(taskNumber));
        inputSel = "#" + (TaskChain.scheduleInputId(taskNumber));
        itemSel = "#" + (TaskChain.taskId(taskNumber));
        moduleSel = "#" + (TaskChain.moduleConfigPopupId(taskNumber));
        $(configSel).remove();
        $(inputSel).remove();
        $(moduleSel).remove();
        return $(itemSel).hide().remove();
      };

      TaskChain.resetSelector = function() {
        var sel;
        sel = TaskChain.taskSelector;
        return $(sel).val($('options:first', sel).val());
      };

      TaskChain.nameFromType = function(taskType) {
        var capitalized;
        capitalized = taskType.charAt(0).toUpperCase() + taskType.slice(1);
        return capitalized.replace("_", " ");
      };

      TaskChain.elementBehaviors = {
        taskSelector: {
          bind: function() {
            return $(TaskChain.taskSelector).change(function() {
              var taskType;
              taskType = $(this).val();
              TaskChain.addTask(taskType);
              return TaskChain.resetSelector();
            });
          }
        },
        reportTaskPreparer: {
          bind: function() {
            return $('body').bind('reportTaskLoaded', function() {
              return $('#report_option_forms').find('fieldset.buttons').remove();
            });
          }
        },
        taskSortingAndSelecting: {
          bind: function() {
            return $(TaskChain.container).sortable({
              handle: '.handle'
            }).selectable({
              selected: function() {
                var theId;
                theId = $(this).find('li.ui-selected').attr('id');
                return TaskChain.selectTaskAndShowConfig(theId, false);
              }
            });
          }
        },
        moduleSelection: {
          bind: function() {
            var searchForm, wrapperDiv;
            wrapperDiv = $('div.center');
            searchForm = wrapperDiv.find('form.searchform');
            wrapperDiv.html(searchForm);
            return $(TaskChain.moduleSelectorLinks).click(function(event) {
              var taskConfigId, taskLink;
              taskLink = $(this);
              taskConfigId = taskLink.parents("." + TaskChain.configWrapperClass).attr('id');
              TaskChain.loadModule(taskLink.attr('module_fullname'), taskConfigId);
              return false;
            });
          }
        },
        moduleSearch: {
          bind: function() {
            var inputSel;
            inputSel = "input[name='q']";
            return $("div.task-config-wrapper " + inputSel).parents('form').submit(function() {
              var query, wrapperId;
              query = $(this).find(inputSel).val();
              wrapperId = $(this).parents("div." + TaskChain.configWrapperClass).attr('id');
              TaskChain.loadModuleSearch(query, wrapperId);
              return false;
            });
          }
        },
        bruteForceList: {
          bind: function() {
            $("#all_services").checkAll($("#service_list"));
            return $("#all_cred_files").checkAll($("#cred_file_list"));
          }
        },
        collectEvidenceList: {
          bind: function() {
            return $("#collect_all_sessions").checkAll($("#collect_sessions"));
          }
        },
        cleanupList: {
          bind: function() {
            return $("#cleanup_all_sessions").checkAll($("#cleanup_sessions"));
          }
        },
        formSubmission: {
          bind: function() {
            return $(TaskChain.mainFormSelector).submit(function() {
              var dataElementSelector, dataSnowball, form;
              if ($("#task_chain_clear_workspace_before_run").is(":checked")) {
                if (!confirm("This will DELETE all project data before running!")) {
                  enableSubmitButtons();
                  return false;
                }
              }
              if (Scheduler.isMissingDate()) {
                alert("Please provide a schedule date.");
                enableSubmitButtons();
                return false;
              }
              if ($("#task_chain_name").val() === '') {
                alert("Please provide a name for the chain!");
                enableSubmitButtons();
                return false;
              }
              if ($(TaskChain.container).find('li').length === 0) {
                alert("You can't save a chain with no tasks!");
                enableSubmitButtons();
                return false;
              } else {
                $(window).unbind('beforeunload');
                form = $(this);
                form.append($(TaskChain.taskOrderInput()));
                dataElementSelector = "input, textarea, select";
                $('form#cred-delete-form').remove();
                dataSnowball = [];
                $(".task-config-wrapper").each(function(index, configDiv) {
                  var $configDiv;
                  $configDiv = $(configDiv);
                  if ($configDiv.attr('tasktype') === "report") {
                    return null;
                  }
                  return dataSnowball = dataSnowball.concat($configDiv.find(dataElementSelector));
                });
                if (TaskChain.hasTaskType('module_run')) {
                  $(".module-config").each(function(index, configDiv) {
                    var $configDiv;
                    $configDiv = $(configDiv);
                    return dataSnowball = dataSnowball.concat($configDiv.find(dataElementSelector));
                  });
                }
                if (TaskChain.hasTaskType('report')) {
                  $('.task-config-wrapper[tasktype="report"]').each(function(index, configDiv) {
                    var $configDiv;
                    $configDiv = $(configDiv);
                    return dataSnowball = dataSnowball.concat(TaskChain.chosenReportConfigForTask($configDiv).find(dataElementSelector));
                  });
                }
                return dataSnowball.each(function(elementArray, index) {
                  return elementArray.each(function(index, element) {
                    var $element, _ref;
                    $element = $(element);
                    if (_ref = $element.attr('name'), __indexOf.call(TaskChain.inputSkipNames, _ref) < 0) {
                      $element.hide();
                      return form.append($element);
                    }
                  });
                });
              }
            });
          }
        },
        navigatingAway: {
          bind: function() {
            return $(window).bind('beforeunload', function() {
              if ($(TaskChain.container).find('li').length > 0) {
                return "You have tasks in your schedule...";
              }
            });
          }
        },
        taskDeletion: {
          bind: function() {
            var buttonOptions, delSel;
            buttonOptions = {
              text: false,
              icons: {
                primary: 'ui-icon-trash'
              }
            };
            delSel = "." + TaskChain.deleteButtonClass;
            $(delSel).button(buttonOptions).removeClass('ui-selectee');
            return $(delSel).click(function(event) {
              var taskId;
              taskId = $(this).parents('li').attr('id');
              TaskChain.removeTask(taskId);
              return event.stopImmediatePropagation();
            });
          }
        }
      };

      TaskChain.bind = function() {
        var binding, element, _ref, _results;
        _ref = this.elementBehaviors;
        _results = [];
        for (element in _ref) {
          binding = _ref[element];
          _results.push(binding.bind());
        }
        return _results;
      };

      return TaskChain;

    })();
    return $(document).ready(function() {
      return TaskChain.bind();
    });
  });

}).call(this);
