(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/layouts/task_chain_nav-dc77fd72fea5296eaf63a5bc22e355bbc32a0483787dfeba2abfd60be7e02ea3.js', '/assets/shared/lib/pie_chart-1f6948c3f005ea1112050389be09f7c3d8a5dfb36e582cd1151673a5694fc2bd.js', '/assets/task_chains/backbone/models/task_chain_item-f0c93bfd1962fca0c4b7eaa7fc7b017fc8b5a4de6027a4e9eed092851cc96b18.js', '/assets/task_chains/backbone/views/collection_views/task_chain_items-a73f503e0e2c5ff99b412f313c56d688f0a900defbf5d80c1411a79fc2386504.js'], function($, Template, PieChart, TaskChainItem, TaskChainItems) {
    var TaskChainNav;
    return TaskChainNav = (function(_super) {

      __extends(TaskChainNav, _super);

      function TaskChainNav() {
        this.addExistingTask = __bind(this.addExistingTask, this);

        this._closeDropdownHandler = __bind(this._closeDropdownHandler, this);

        this.onClose = __bind(this.onClose, this);

        this.onShow = __bind(this.onShow, this);
        return TaskChainNav.__super__.constructor.apply(this, arguments);
      }

      TaskChainNav.prototype.template = HandlebarsTemplates['task_chains/layouts/task_chain_nav'];

      TaskChainNav.prototype._taskViewPaths = {
        bruteforce: '/assets/task_chains/backbone/views/item_views/bruteforce_task-274b8cb0b87022ba82b2555e60beff3caf11397153de07737a86c988a5d59158.js',
        cleanup: '/assets/task_chains/backbone/views/item_views/cleanup_task-4876593b7104779874a1c01b3cb17e42d57ab3ee2219e9afd35cc916bc461911.js',
        collect: '/assets/task_chains/backbone/views/item_views/collect_task-139a10e72680a06cddc27473bc1a3350380be4876ebb328f630204db41a73e32.js',
        exploit: '/assets/task_chains/backbone/views/item_views/exploit_task-a49e6a00d7f7538146084cc3c84f6eb65ce6ddb380ec92af9cae95a5f051f7ee.js',
        'import': '/assets/task_chains/backbone/views/item_views/import_task-cafe5092674527359881555ce853f1b8ded1810118a5b6e3a021d33af0315d16.js',
        module_run: '/assets/task_chains/backbone/views/item_views/module_run_task-058a6325122a31b12e4d7aa3849448af6d2740d200d45fd2c11d958bc3bb5b7c.js',
        nexpose: '/assets/task_chains/backbone/views/item_views/nexpose_task-13c2ce60c7961e48348b40dd32acfe887b8116ed532ff14658ebc2fb62527636.js',
        report: '/assets/task_chains/backbone/views/item_views/report-5ab6cc81c8a23b2aed39af492b29497bf906a8afa36e0463fffc55b8d5e72c54.js',
        webscan: '/assets/task_chains/backbone/views/item_views/webscan_task-e2f3ffb74d8c7f8656e72498e48a5f3d4c809c8e254ba8e83acd84f99d659c75.js',
        scan: '/assets/task_chains/backbone/views/item_views/scan_task-0f26edb9faa8300accfe70ac833599141631c4615213b9dcdfac0ad253f9ea06.js',
        metamodule: '/assets/task_chains/backbone/views/item_views/metamodule_task-bf776d4dee4c37170de176bb27b34bbf2d090c9f9d52402efd1df81117e50c02.js',
        rc_script: '/assets/task_chains/backbone/views/item_views/rc_script_task-4545db2c188fdd471f2ffd813d0b9e7f47bd60f8d5a58c92f8768dd17070892f.js',
        nexpose_push: '/assets/task_chains/backbone/views/item_views/export_task-f083022ee2c0b380d951d3a024db0d16ee05a9ca6a6fced4e77b74ffb0616f2b.js'
      };

      TaskChainNav.prototype.events = {
        'click .add-task': '_toggleAddTask',
        'click .add-task-options': '_addTask',
        'click .action.delete': '_deleteTask',
        'click .action.reset': '_resetTask',
        'click .action.clone': '_cloneTask',
        'pieChanged .container': '_pieChanged'
      };

      TaskChainNav.prototype.ui = {
        addTaskOptions: '.add-task-options'
      };

      TaskChainNav.prototype.regions = {
        pies: '.pie-charts'
      };

      TaskChainNav.prototype.onShow = function() {
        $('.delete').tooltip();
        $('.clone').tooltip();
        $('.reset').tooltip();
        this._initPies();
        return this._bindTriggers();
      };

      TaskChainNav.prototype.onClose = function() {
        return this._unbindTriggers();
      };

      TaskChainNav.prototype._bindTriggers = function() {
        return $(document).on('click', this._closeDropdownHandler);
      };

      TaskChainNav.prototype._unbindTriggers = function() {
        return $(document).unbind('click', this._closeDropdownHandler);
      };

      TaskChainNav.prototype._closeDropdownHandler = function(e) {
        if (e.target !== $('.add-task', this.el)[0]) {
          return this._closeDropdown();
        }
      };

      TaskChainNav.prototype._closeDropdown = function() {
        return this.ui.addTaskOptions.hide();
      };

      TaskChainNav.prototype._toggleAddTask = function() {
        return this.ui.addTaskOptions.toggle();
      };

      TaskChainNav.prototype._resetTask = function(e) {
        var collection, status;
        status = confirm("Are you sure you want to reset the current task chain?");
        if (status) {
          collection = this.pies.currentView.collection;
          return collection.reset();
        }
      };

      TaskChainNav.prototype._deleteTask = function(e) {
        var collection, current_task, status;
        status = confirm("Are you sure you want to delete the current task?");
        if (status) {
          collection = this.pies.currentView.collection;
          current_task = collection.findWhere({
            selected: true
          });
          return collection.remove(current_task);
        }
      };

      TaskChainNav.prototype.addExistingTask = function(task) {
        var opts;
        if (task.kind === "collect_evidence") {
          task.kind = "collect";
        }
        if (task.kind === "scan_and_import") {
          task.kind = 'nexpose';
        }
        opts = {
          task_type: task.kind,
          task: task
        };
        return this._requireTaskConfig(this._addTaskUpdateView, opts);
      };

      TaskChainNav.prototype._addTask = function(e) {
        var opts;
        e.stopPropagation();
        opts = {
          task_type: $(e.target).data('task-type')
        };
        return this._requireTaskConfig(this._addTaskUpdateView, opts);
      };

      TaskChainNav.prototype._cloneTask = function(e) {
        var collection, current_task;
        collection = this.pies.currentView.collection;
        $(this.el).trigger('cloneTaskConfig');
        current_task = collection.findWhere({
          selected: true
        });
        return collection.add(new TaskChainItem({
          type: current_task.get('type'),
          cloned: true
        }));
      };

      TaskChainNav.prototype._pieChanged = function(e, view) {
        var opts;
        opts = {
          task_chain_item: view.model,
          task_type: view.model.get('type'),
          task: view.model.get('task')
        };
        return this._requireTaskConfig(this._updateView, opts);
      };

      TaskChainNav.prototype._addTaskUpdateView = function(opts, TaskView) {
        var show_opts, task_chain_item;
        if (opts.task_type === "collect_evidence") {
          opts.task_type = "collect";
        }
        task_chain_item = this._addPieChart({
          type: opts.task_type,
          task: opts.task
        });
        show_opts = {
          task_view: TaskView,
          form_id: task_chain_item.cid,
          task: opts.task
        };
        if (TaskView != null) {
          $(this.el).trigger('showTaskConfig', show_opts);
        }
        return this._closeDropdown();
      };

      TaskChainNav.prototype._updateView = function(opts, TaskView) {
        var show_opts;
        show_opts = {
          cloned: opts.task_chain_item.get('cloned'),
          task_view: TaskView,
          form_id: opts.task_chain_item.cid,
          task: opts.task
        };
        return $(this.el).trigger('showTaskConfig', show_opts);
      };

      TaskChainNav.prototype._requireTaskConfig = function(func, opts) {
        var rjs,
          _this = this;
        rjs = requirejs.config({
          context: "reports"
        });
        return rjs([this._taskViewPaths[opts.task_type]], function(TaskView) {
          return func.call(_this, opts, TaskView);
        });
      };

      TaskChainNav.prototype._addPieChart = function(options) {
        if (options == null) {
          options = {};
        }
        return this.tasks.add(options);
      };

      TaskChainNav.prototype._initPies = function() {
        this.tasks = new Backbone.Collection([], {
          model: TaskChainItem
        });
        return this.pies.show(new TaskChainItems({
          collection: this.tasks,
          sort: false
        }));
      };

      return TaskChainNav;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
