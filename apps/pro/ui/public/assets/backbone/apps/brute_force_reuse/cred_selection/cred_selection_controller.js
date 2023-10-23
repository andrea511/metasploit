(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'entities/cred', 'entities/cred_group', 'apps/brute_force_reuse/cred_selection/cred_selection_view', 'lib/concerns/controllers/render_cores_table', 'lib/components/filter/filter_controller'], function() {
    return this.Pro.module('BruteForceReuseApp.CredSelection', function(CredSelection, App) {
      return CredSelection.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.addCred = __bind(this.addCred, this);

          this.refreshNextButton = __bind(this.refreshNextButton, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.include('RenderCoresTable');

        Controller.prototype.workspace_id = null;

        Controller.prototype.table = null;

        Controller.prototype.group = null;

        Controller.prototype.layout = null;

        Controller.prototype.initialize = function(opts) {
          var creds,
            _this = this;
          if (opts == null) {
            opts = {};
          }
          this.workspace_id = opts.workspace_id || WORKSPACE_ID;
          _.defaults(opts, {
            show: true
          });
          creds = App.request('creds:entities', {
            workspace_id: this.workspace_id
          });
          this.layout = new CredSelection.Layout;
          this.setMainView(this.layout);
          this.groups = new CredSelection.GroupsContainer(_.pick(opts, 'workingGroup'));
          this.listenTo(this.layout, 'show', function() {
            _this.show(_this.groups, {
              region: _this.getMainView().groupsRegion
            });
            _this.table = _this.renderCoresTable(creds, _this.layout.credsRegion, {
              htmlID: 'reuse-creds',
              withoutColumns: ['clone', 'type', 'logins_count', 'validation', 'origin_type', 'pretty_realm'],
              actionButtons: [],
              disableCredLinks: true,
              filterOpts: {
                filterValuesEndpoint: window.gon.filter_values_workspace_metasploit_credential_cores_path,
                keys: ['logins.status', 'private.data', 'private.type', 'public.username', 'realm.key', 'realm.value', 'tags.name'],
                staticFacets: {
                  'private.type': [
                    {
                      value: 'SSH key',
                      label: 'SSH Key'
                    }, {
                      value: 'NTLM hash',
                      label: 'NTLM Hash'
                    }, {
                      value: 'Nonreplayable hash',
                      label: 'Hash'
                    }, {
                      value: 'Password',
                      label: 'Plain-text Password'
                    }
                  ],
                  'realm.key': Pro.Entities.Cred.Realms.ALL.map(function(name) {
                    return {
                      value: name,
                      label: name
                    };
                  }),
                  'logins.status': Pro.Entities.Login.Status.ALL.map(function(name) {
                    return {
                      value: name,
                      label: name
                    };
                  })
                }
              }
            });
            _this.listenTo(_this.table.collection, 'all', _.debounce((function() {
              _this.getMainView().adjustSize();
              return _this.groups.workingGroupView.lazyList.resize();
            }), 50));
            return _this.listenTo(_this.groups.workingGroupView.lazyList.collection, 'all', _.debounce(_this.refreshNextButton, 50));
          });
          this.listenTo(this.layout, 'creds:addToCart', function() {
            if (_this.table.tableSelections.selectAllState) {
              return _this.table.collection.fetchIDs(_this.table.tableSelections).done(function(ids) {
                ids = _.difference(ids, _.keys(_this.table.tableSelections.deselectedIDs));
                _this.groups.workingGroupView.lazyList.addIDs(ids);
                return _this.refreshNextButton();
              });
            } else {
              _this.groups.workingGroupView.lazyList.addIDs(_.keys(_this.table.tableSelections.selectedIDs));
              return _this.refreshNextButton();
            }
          });
          _.defer(function() {
            _this.groups.selectionUpdated();
            return _this.refreshNextButton();
          });
          if (opts.show) {
            return this.show(this.layout, this.region);
          }
        };

        Controller.prototype.refreshNextButton = function() {
          return this.layout.toggleNext(!_.isEmpty(this.groups.workingGroupView.lazyList.collection.ids));
        };

        Controller.prototype.addCred = function(core_id) {
          return this.groups.workingGroupView.lazyList.addIDs([core_id]);
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
