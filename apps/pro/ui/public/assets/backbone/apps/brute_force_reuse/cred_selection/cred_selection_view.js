(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_view', 'base_itemview', 'base_compositeview', 'entities/cred', 'entities/cred_group', 'select2', 'apps/brute_force_reuse/cred_selection/templates/cred_selection_layout', 'apps/brute_force_reuse/cred_selection/templates/group', 'apps/brute_force_reuse/cred_selection/templates/cred_row', 'apps/brute_force_reuse/cred_selection/templates/group_container', 'lib/components/lazy_list/lazy_list_controller', 'lib/concerns/views/right_side_scroll'], function($) {
    return this.Pro.module('BruteForceReuseApp.CredSelection', function(CredSelection, App) {
      CredSelection.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          this.toggleNext = __bind(this.toggleNext, this);
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.id = 'credSelection';

        Layout.prototype.template = Layout.prototype.templatePath('brute_force_reuse/cred_selection/cred_selection_layout');

        Layout.prototype.regions = {
          credsRegion: '.creds-table',
          groupsRegion: '.creds-groups'
        };

        Layout.prototype.ui = {
          rightSide: '.right-side',
          leftSide: '.left-side',
          next: 'a.btn.primary'
        };

        Layout.prototype.attributes = {
          "class": 'cred-selection-view'
        };

        Layout.prototype.triggers = {
          'click .add-selection': 'creds:addToCart'
        };

        Layout.include("RightSideScroll");

        Layout.prototype.toggleNext = function(enabled) {
          return this.ui.next.toggleClass('disabled', !enabled);
        };

        return Layout;

      })(App.Views.Layout);
      CredSelection.CredRow = (function(_super) {

        __extends(CredRow, _super);

        function CredRow() {
          this.removeCred = __bind(this.removeCred, this);

          this.initialize = __bind(this.initialize, this);
          return CredRow.__super__.constructor.apply(this, arguments);
        }

        CredRow.prototype.tagName = 'li';

        CredRow.prototype.attributes = {
          "class": 'cred-row'
        };

        CredRow.prototype.template = CredRow.prototype.templatePath('brute_force_reuse/cred_selection/cred_row');

        CredRow.prototype.events = {
          'click a.delete': 'removeCred'
        };

        CredRow.prototype.initialize = function(_arg) {
          this.collection = _arg.collection, this.model = _arg.model;
        };

        CredRow.prototype.removeCred = function() {
          return this.collection.remove(this.model);
        };

        return CredRow;

      })(App.Views.ItemView);
      CredSelection.Group = (function(_super) {

        __extends(Group, _super);

        function Group() {
          this.removeGroup = __bind(this.removeGroup, this);

          this.onShow = __bind(this.onShow, this);

          this.renderLazyList = __bind(this.renderLazyList, this);

          this.credsLoaded = __bind(this.credsLoaded, this);

          this.toggleExpansion = __bind(this.toggleExpansion, this);

          this.initialize = __bind(this.initialize, this);
          return Group.__super__.constructor.apply(this, arguments);
        }

        Group.prototype.tagName = 'li';

        Group.prototype.template = Group.prototype.templatePath('brute_force_reuse/cred_selection/group');

        Group.prototype.attributes = {
          "class": 'group'
        };

        Group.prototype.events = {
          'click': 'toggleExpansion',
          'click a.delete': 'removeGroup'
        };

        Group.prototype.regions = {
          list: '.cred-rows'
        };

        Group.prototype.childView = CredSelection.CredRow;

        Group.prototype.parentCollection = null;

        Group.prototype.collection = null;

        Group.prototype.lazyList = null;

        Group.prototype.initialize = function(_arg) {
          var collection;
          collection = _arg.collection, this.model = _arg.model;
          this.parentCollection = collection;
          this.collection = this.model.get('creds');
          return this.listenTo(this.model, 'creds:loaded', this.credsLoaded);
        };

        Group.prototype.toggleExpansion = function() {
          if (this.model.get('working')) {
            return;
          }
          this.model.set({
            expanded: !this.model.get('expanded')
          });
          this.render();
          if (this.model.get('expanded')) {
            if (this.model.get('state') === 'new') {
              return this.model.loadCredIDs();
            } else if (this.model.get('state') === 'loaded') {
              return this.renderLazyList({
                ids: this.model.get('cred_ids')
              });
            }
          } else {
            return this.list.destroy();
          }
        };

        Group.prototype.credsLoaded = function(opts) {
          return this.renderLazyList(opts);
        };

        Group.prototype.renderLazyList = function(opts) {
          var ids;
          if (opts == null) {
            opts = {};
          }
          ids = opts.ids;
          return this.lazyList = new App.Components.LazyList.Controller({
            collection: this.model.get('creds'),
            region: this.list,
            ids: ids,
            childView: CredSelection.CredRow
          });
        };

        Group.prototype.onShow = function() {
          if (this.model.get('working')) {
            return this.renderLazyList();
          }
        };

        Group.prototype.removeGroup = function(e) {
          this.parentCollection.remove(this.model);
          e.preventDefault();
          return e.stopImmediatePropagation();
        };

        return Group;

      })(App.Views.Layout);
      return CredSelection.GroupsContainer = (function(_super) {

        __extends(GroupsContainer, _super);

        function GroupsContainer() {
          this._loadGroups = __bind(this._loadGroups, this);

          this._destroySelect2 = __bind(this._destroySelect2, this);

          this._renderSelect2 = __bind(this._renderSelect2, this);

          this._numSelectedCreds = __bind(this._numSelectedCreds, this);

          this._updateSelectionCount = __bind(this._updateSelectionCount, this);

          this._updateClearState = __bind(this._updateClearState, this);

          this.clearClicked = __bind(this.clearClicked, this);

          this.selectionUpdated = __bind(this.selectionUpdated, this);

          this.onShow = __bind(this.onShow, this);

          this.dropdownChanged = __bind(this.dropdownChanged, this);

          this.buildChildView = __bind(this.buildChildView, this);

          this.onDestroy = __bind(this.onDestroy, this);

          this.onRender = __bind(this.onRender, this);

          this.onShow = __bind(this.onShow, this);
          return GroupsContainer.__super__.constructor.apply(this, arguments);
        }

        GroupsContainer.prototype.template = GroupsContainer.prototype.templatePath('brute_force_reuse/cred_selection/group_container');

        GroupsContainer.prototype.attributes = {
          "class": 'credential-groups'
        };

        GroupsContainer.prototype.childView = CredSelection.Group;

        GroupsContainer.prototype.childViewContainer = 'ul.groups';

        GroupsContainer.prototype.ui = {
          dropdown: 'div.dropdown',
          clear: 'a.clear',
          badge: 'span.badge'
        };

        GroupsContainer.prototype.events = {
          'change @ui.dropdown': 'dropdownChanged',
          'click @ui.dropdown': 'dropdownClicked',
          'click @ui.clear': 'clearClicked'
        };

        GroupsContainer.prototype.collection = null;

        GroupsContainer.prototype.groups = null;

        GroupsContainer.prototype.groupsFetched = false;

        GroupsContainer.prototype.workspace_id = null;

        GroupsContainer.prototype.workingGroup = null;

        GroupsContainer.prototype.workingGroupView = null;

        GroupsContainer.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          this.workspace_id = opts.workspace_id || WORKSPACE_ID;
          this.workingGroup = opts.workingGroup || new App.Entities.CredGroup({
            workspace_id: this.workspace_id,
            working: true
          });
          this.collection = new App.Entities.CredGroupsCollection([this.workingGroup], {
            workspace_id: this.workspace_id
          });
          this.groups = new App.Entities.CredGroupsCollection([], {
            workspace_id: this.workspace_id
          });
          this.listenTo(this.workingGroup.get('creds'), 'add', this.selectionUpdated);
          this.listenTo(this.workingGroup.get('creds'), 'remove', this.selectionUpdated);
          return this.listenTo(this.workingGroup.get('creds'), 'reset', this.selectionUpdated);
        };

        GroupsContainer.prototype.onShow = function() {
          var _this = this;
          this._loadGroups();
          return _.defer(function() {
            return _this.selectionUpdated();
          });
        };

        GroupsContainer.prototype.onRender = function() {
          if (this.groupsFetched) {
            return this._renderSelect2();
          }
        };

        GroupsContainer.prototype.onDestroy = function() {
          if (this.groupsFetched) {
            return this._destroySelect2();
          }
        };

        GroupsContainer.prototype.serializeData = function() {
          return this;
        };

        GroupsContainer.prototype.appendHtml = function(collectionView, itemView) {
          return this.$el.find(collectionView.childViewContainer).prepend(itemView.el);
        };

        GroupsContainer.prototype.buildChildView = function(item, ItemView) {
          var view;
          view = new ItemView({
            model: item,
            collection: this.collection
          });
          if (item === this.workingGroup) {
            this.workingGroupView = view;
          }
          return view;
        };

        GroupsContainer.prototype.dropdownChanged = function(e) {
          var newGroup;
          this.ui.dropdown.select2('val', '');
          newGroup = this.groups.get(e.val);
          if (newGroup != null) {
            newGroup.set({
              expanded: false
            });
          }
          if (newGroup != null) {
            return this.collection.add(newGroup);
          }
        };

        GroupsContainer.prototype.onShow = function() {
          return this.ui.clear.tooltip();
        };

        GroupsContainer.prototype.selectionUpdated = function() {
          this._updateClearState();
          return this._updateSelectionCount();
        };

        GroupsContainer.prototype.clearClicked = function() {
          var result;
          result = confirm("Are you sure you want to remove all selected credentials?");
          if (result) {
            return this.workingGroup.get('creds').reset([]);
          }
        };

        GroupsContainer.prototype._updateClearState = function() {
          var _this = this;
          return _.defer(function() {
            var _ref, _ref1;
            return (_ref = _this.ui) != null ? (_ref1 = _ref.clear) != null ? typeof _ref1.toggle === "function" ? _ref1.toggle(_this._numSelectedCreds() > 0) : void 0 : void 0 : void 0;
          });
        };

        GroupsContainer.prototype._updateSelectionCount = function() {
          var _this = this;
          return _.defer(function() {
            var _ref, _ref1;
            return (_ref = _this.ui) != null ? (_ref1 = _ref.badge) != null ? typeof _ref1.toggle === "function" ? _ref1.toggle(_this._numSelectedCreds() > 0).text(_this._numSelectedCreds()) : void 0 : void 0 : void 0;
          });
        };

        GroupsContainer.prototype._numSelectedCreds = function() {
          var _ref;
          return ((_ref = this.workingGroup.get('creds').ids) != null ? _ref.length : void 0) || 0;
        };

        GroupsContainer.prototype._renderSelect2 = function() {
          var models;
          models = _.map(this.groups.models, function(m) {
            return {
              name: m.get('name'),
              id: m.id.toString()
            };
          });
          this.ui.dropdown.select2({
            placeholder: 'Import Existing Group',
            data: {
              results: models,
              text: 'name'
            },
            initSelection: null,
            minimumResultsForSearch: 5,
            escapeMarkup: _.identity,
            formatResult: function(m) {
              return "<span>" + (_.escape(m.name)) + "</span><a class='right' href='javascript:void(0)'>×</a>";
            }
          });
          return this.ui.dropdown.change(this.dropdownChanged);
        };

        GroupsContainer.prototype._destroySelect2 = function() {
          return this.ui.dropdown.select2('destroy');
        };

        GroupsContainer.prototype._loadGroups = function() {
          var _this = this;
          if (this.isClosed) {
            return;
          }
          return this.groups.fetch().done(function() {
            _this.groupsFetched = true;
            return _this.render();
          }).error(function() {
            return _.delay(_this._loadGroups, 5000);
          });
        };

        return GroupsContainer;

      })(App.Views.CompositeView);
    });
  });

}).call(this);
