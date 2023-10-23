(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'pie_chart', 'base_view', 'base_itemview', 'base_layout', 'base_compositeview', 'apps/task_chains/index/templates/index_layout', 'apps/task_chains/index/templates/index_list', 'apps/task_chains/index/templates/_task_chain', 'apps/task_chains/index/templates/legacy_warning'], function($, PieChart) {
    return this.Pro.module('TaskChainsApp.Index', function(Index, App) {
      Index.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('task_chains/index/index_layout');

        Layout.prototype.regions = {
          headerRegion: '#task-chain-header-region',
          listRegion: '#task-chain-list-region'
        };

        return Layout;

      })(App.Views.Layout);
      Index.LegacyWarningView = (function(_super) {

        __extends(LegacyWarningView, _super);

        function LegacyWarningView() {
          return LegacyWarningView.__super__.constructor.apply(this, arguments);
        }

        LegacyWarningView.prototype.template = LegacyWarningView.prototype.templatePath('task_chains/index/legacy_warning');

        LegacyWarningView.prototype.onFormSubmit = function() {
          var defer, formSubmit;
          defer = $.Deferred();
          formSubmit = function() {};
          defer.promise(formSubmit);
          defer.resolve();
          return formSubmit;
        };

        return LegacyWarningView;

      })(App.Views.ItemView);
      Index.TaskChain = (function(_super) {

        __extends(TaskChain, _super);

        function TaskChain() {
          return TaskChain.__super__.constructor.apply(this, arguments);
        }

        TaskChain.prototype.template = TaskChain.prototype.templatePath('task_chains/index/_task_chain');

        TaskChain.prototype.tagName = 'tr';

        TaskChain.prototype.className = 'task-chain';

        TaskChain.prototype.ui = {
          statusCanvas: 'td.status canvas',
          checkbox: 'td.checkbox input'
        };

        TaskChain.prototype.events = {
          'click @ui.checkbox': 'setSelected'
        };

        TaskChain.prototype.addPieChart = function() {
          this.chart = new PieChart({
            canvas: this.ui.statusCanvas[0],
            percentage: this.model.get('percent_tasks_started'),
            text: this.model.get('started_tasks'),
            percentFill: '#006699',
            textFill: '#006699',
            stroke: 6,
            fontSize: '20px'
          });
          return this.chart.update();
        };

        TaskChain.prototype.setSelected = function() {
          return this.model.set({
            selected: this.ui.checkbox.prop('checked')
          });
        };

        TaskChain.prototype.onRender = function() {
          if (this.model.get('state') === 'running') {
            return this.addPieChart();
          }
        };

        return TaskChain;

      })(App.Views.ItemView);
      return Index.List = (function(_super) {

        __extends(List, _super);

        function List() {
          return List.__super__.constructor.apply(this, arguments);
        }

        List.prototype.template = List.prototype.templatePath('task_chains/index/index_list');

        List.prototype.childView = Index.TaskChain;

        List.prototype.childViewContainer = 'tbody';

        List.prototype.pollingInterval = 12000;

        List.prototype.ui = {
          newTaskChainLink: '#new',
          numTotalIndicator: '#num-total',
          numSelectedIndicator: '#num-selected',
          selectAllToggle: 'th#select-all input',
          sortingArrows: 'th .arrow',
          buttons: '.toolbar a',
          deleteButton: 'a#delete',
          cloneButton: 'a#clone',
          stopButton: 'a#stop',
          suspendButton: 'a#suspend',
          resumeButton: 'a#unsuspend',
          runButton: 'a#run',
          newButton: 'a#new'
        };

        List.prototype.events = {
          'click @ui.deleteButton': 'deleteTaskChains',
          'click @ui.cloneButton': 'cloneTaskChain',
          'click @ui.stopButton': 'stopTaskChains',
          'click @ui.suspendButton': 'suspendTaskChains',
          'click @ui.resumeButton': 'resumeTaskChains',
          'click @ui.runButton': 'runTaskChains',
          'click @ui.selectAllToggle': 'toggleSelectAll',
          'click th.sortable': 'handleHeaderClick'
        };

        List.prototype.collectionEvents = {
          'change:selected': 'setNumSelected enableButtons',
          'sort': 'renderRows'
        };

        List.prototype.renderRows = function() {
          this._renderChildren();
          return this.onRender();
        };

        List.prototype.handleHeaderClick = function(e) {
          var $arrow, $el, sortAttribute, sortColumn;
          $el = $(e.currentTarget);
          $arrow = $el.find('div.arrow');
          sortColumn = $el.data('sort-column');
          sortAttribute = this.collection.sortAttribute;
          if (sortColumn === sortAttribute) {
            this.collection.sortDirection *= -1;
          } else {
            this.collection.sortDirection = 1;
          }
          this.ui.sortingArrows.removeClass('up').removeClass('down');
          if (this.collection.sortDirection === 1) {
            $arrow.addClass('up');
          } else {
            $arrow.addClass('down');
          }
          return this.collection.sortRows(sortColumn);
        };

        List.prototype.disableAllButtons = function() {
          this.ui.buttons.addClass('disabled');
          return this.ui.newButton.removeClass('disabled');
        };

        List.prototype.enableButtons = function() {
          var runningChains, scheduledChains, selectedChains, suspendedChains,
            _this = this;
          this.disableAllButtons();
          selectedChains = this.collection.where({
            selected: true
          });
          if (selectedChains.size() === 0) {
            return false;
          }
          runningChains = _.filter(selectedChains, (function(tc) {
            return tc.get('state') === 'running';
          }));
          if (runningChains.size() > 0) {
            this.ui.stopButton.removeClass('disabled');
          } else {
            this.ui.deleteButton.removeClass('disabled');
          }
          if (runningChains.size() !== selectedChains.size()) {
            this.ui.runButton.removeClass('disabled');
          }
          scheduledChains = _.filter(selectedChains, function(tc) {
            return tc.get('schedule_state') === 'scheduled' || tc.get('scheduled_state') === 'once';
          });
          if (scheduledChains.size() > 0 || runningChains.size() > 0) {
            this.ui.suspendButton.removeClass('disabled');
          }
          suspendedChains = _.filter(selectedChains, function(tc) {
            return tc.get('schedule_state') === 'suspended';
          });
          if (suspendedChains.size() > 0) {
            this.ui.resumeButton.removeClass('disabled');
          }
          if (selectedChains.size() === 1) {
            return this.ui.cloneButton.removeClass('disabled');
          }
        };

        List.prototype.cloneTaskChain = function() {
          if (this.ui.cloneButton.hasClass('disabled')) {
            return false;
          }
          if (this.collection.selected().size() !== 1) {
            alert("Please select one task chain to clone.");
            return false;
          }
          return window.location = this.collection.selected()[0].get('clone_workspace_task_chain_path');
        };

        List.prototype.deleteTaskChains = function() {
          var selectedTaskChainsIndicator, taskChainsToDelete;
          if (this.ui.deleteButton.hasClass('disabled')) {
            return false;
          }
          taskChainsToDelete = this.collection.selected();
          if (taskChainsToDelete.size() === 1) {
            selectedTaskChainsIndicator = 'task chain';
          } else if (taskChainsToDelete.size() > 1) {
            selectedTaskChainsIndicator = 'task chains';
          }
          if (confirm("Are you sure you want to delete the selected " + selectedTaskChainsIndicator + "?")) {
            return this.collection.destroySelected();
          }
        };

        List.prototype.stopTaskChains = function() {
          var selectedTaskChainsIndicator, taskChainsToStop;
          if (this.ui.stopButton.hasClass('disabled')) {
            return false;
          }
          taskChainsToStop = this.collection.selected();
          if (taskChainsToStop.size() === 1) {
            selectedTaskChainsIndicator = 'task chain';
          } else if (taskChainsToStop.size() > 1) {
            selectedTaskChainsIndicator = 'task chains';
          }
          if (confirm("Are you sure you want to stop the selected " + selectedTaskChainsIndicator + "?")) {
            return this.collection.stopSelected();
          }
        };

        List.prototype.suspendTaskChains = function() {
          if (this.ui.suspendButton.hasClass('disabled')) {
            return false;
          }
          return this.collection.suspendSelected();
        };

        List.prototype.resumeTaskChains = function() {
          if (this.ui.resumeButton.hasClass('disabled')) {
            return false;
          }
          return this.collection.resumeSelected();
        };

        List.prototype.runTaskChains = function() {
          var selectedSize;
          if (this.ui.runButton.hasClass('disabled')) {
            return false;
          }
          selectedSize = this.collection.where({
            selected: true
          }).size();
          if (!(selectedSize > 1 && !confirm("Are you sure you want to run " + selectedSize + " task chains at once?"))) {
            this.disableAllButtons();
            return this.collection.runSelected();
          }
        };

        List.prototype.toggleSelectAll = function() {
          var selectAllToggleState;
          selectAllToggleState = this.ui.selectAllToggle.prop('checked');
          this.collection.invoke('set', {
            selected: selectAllToggleState
          });
          return this.$el.find('input[type="checkbox"]').prop('checked', selectAllToggleState);
        };

        List.prototype.setNumSelected = function() {
          return this.ui.numSelectedIndicator.html(this.collection.selected().size());
        };

        List.prototype.setNumTotal = function() {
          return this.ui.numTotalIndicator.html(this.collection.size());
        };

        List.prototype.setNewLinkPath = function() {
          return this.ui.newTaskChainLink.attr('href', gon.new_workspace_task_chains_path);
        };

        List.prototype.queueNextPoll = function() {
          var _this = this;
          return this._timeout = setTimeout((function() {
            return _this.refreshList();
          }), this.pollingInterval);
        };

        List.prototype.refreshList = function() {
          var _this = this;
          clearTimeout(this._timeout);
          return this.collection.fetch({
            success: (function() {
              return _this.collection.sort();
            })
          });
        };

        List.prototype.onRender = function() {
          this.setNewLinkPath();
          this.setNumTotal();
          return this.queueNextPoll();
        };

        List.prototype.onCompositeCollectionRendered = function() {
          return this.enableButtons();
        };

        return List;

      })(App.Views.CompositeView);
    });
  });

}).call(this);
