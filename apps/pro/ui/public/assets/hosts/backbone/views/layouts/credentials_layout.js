(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js', '/assets/templates/hosts/layouts/credentials-99065b3f903ea4bf58a186938baba6e6eb04f356f670dc2094d6b53ef1acf608.js', '/assets/shared/lib/jquery.dataTables.editable-b41b4d502a481c1e3c3df0aebfa23862293b0b801f5b2bc68d0f37551a28ad70.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', '/assets/hosts/backbone/views/item_views/cred_form-8ea689d5e9e13e9ea69609ce084c45fc20fe42c562c24d9166007dddc3e96e34.js', '/assets/hosts/show-a4f434615b218a1c25cf8bd6faa4c93b147e04672a036779d8c5e0be31f6e7f9.js', 'lib/components/table/table_controller', 'apps/creds/show/show_view', 'base_layout', 'apps/creds/new/new_controller', 'lib/concerns/controllers/render_cores_table'], function($, EventAggregator) {
    var CredentialsLayout, DeleteView;
    DeleteView = (function(_super) {

      __extends(DeleteView, _super);

      function DeleteView() {
        return DeleteView.__super__.constructor.apply(this, arguments);
      }

      DeleteView.prototype.events = {
        click: 'suicide'
      };

      DeleteView.prototype.attributes = {
        style: 'text-align: center'
      };

      DeleteView.prototype.template = function() {
        return '<a href="javascript:void(0)" class="garbage"></a>';
      };

      DeleteView.prototype.suicide = function() {
        var _ref;
        if (!confirm('Are you sure you want to delete this Credential?')) {
          return;
        }
        this.model.destroy();
        return (_ref = this.collection) != null ? _ref.trigger('removedByUser') : void 0;
      };

      return DeleteView;

    })(Marionette.ItemView);
    return CredentialsLayout = (function(_super) {

      __extends(CredentialsLayout, _super);

      function CredentialsLayout() {
        this.renderTables = __bind(this.renderTables, this);

        this.renderLoginsTable = __bind(this.renderLoginsTable, this);

        this.onRender = __bind(this.onRender, this);

        this._rowRemoved = __bind(this._rowRemoved, this);

        this._countChanged = __bind(this._countChanged, this);
        return CredentialsLayout.__super__.constructor.apply(this, arguments);
      }

      CredentialsLayout.include('RenderCoresTable');

      CredentialsLayout.prototype.template = HandlebarsTemplates['hosts/layouts/credentials'];

      CredentialsLayout.prototype.regions = {
        accessingLoginsRegion: '.accessing-logins',
        originatingCredsRegion: '.originating-creds'
      };

      CredentialsLayout.prototype.onShow = function() {
        EventAggregator.on("redrawTable", this._countChanged);
        return EventAggregator.on("tabs_layout:change:count", this._countChanged);
      };

      CredentialsLayout.prototype.onDestroy = function() {
        EventAggregator.off("tabs_layout:change:count");
        return EventAggregator.off("redrawTable");
      };

      CredentialsLayout.prototype._countChanged = function(e, count) {
        var _ref, _ref1;
        this.$el.trigger('tabcountUpdated', {
          count: count,
          name: 'Credentials'
        });
        if ((_ref = this.accessingTable) != null) {
          _ref.refresh();
        }
        return (_ref1 = this.originatingTable) != null ? _ref1.refresh() : void 0;
      };

      CredentialsLayout.prototype._rowRemoved = function() {
        var count;
        count = this.accessingTable.collection.totalRecords + this.originatingTable.collection.totalRecords - 1;
        return this.$el.trigger('tabcountUpdated', {
          count: count,
          name: 'Credentials'
        });
      };

      CredentialsLayout.prototype.onRender = function() {
        var _this = this;
        this.renderTables();
        return _.defer(function() {
          return _this.$el.trigger('tabload');
        });
      };

      CredentialsLayout.prototype.renderLoginsTable = function(collection, region, opts) {
        var tableController;
        if (opts == null) {
          opts = {};
        }
        return tableController = Pro.request("table:component", {
          title: 'Related Logins',
          region: region,
          selectable: true,
          taggable: true,
          "static": false,
          checkboxes: true,
          perPage: 20,
          defaultSort: 'created_at',
          actionButtons: [
            {
              label: '+ Add',
              "class": 'add',
              click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                var controller;
                controller = Pro.request('creds:new', {
                  tableCollection: tableCollection,
                  login: true
                });
                return Pro.execute("showModal", controller, {
                  modal: {
                    title: 'Add Login(s)',
                    description: '',
                    height: 480,
                    width: 520
                  },
                  buttons: [
                    {
                      name: 'Cancel',
                      "class": 'close'
                    }, {
                      name: 'OK',
                      "class": 'btn primary'
                    }
                  ]
                });
              }
            }
          ],
          columns: [
            {
              attribute: 'core.public.username',
              label: 'Public',
              view: Backbone.Marionette.ItemView.extend({
                template: function(model) {
                  return "<a href='/workspaces/" + WORKSPACE_ID + "/credentials#creds/" + (_.escape(model['core_id'])) + "'>" + (_.escape(model['core.public.username'])) + "</a>";
                }
              })
            }, {
              attribute: 'core.private.data',
              "class": 'truncate',
              view: Pro.request('creds:shared:coresTablePrivateCell'),
              label: 'Private'
            }, {
              attribute: 'core.pretty_realm',
              label: 'Realm',
              sortAttribute: 'core.realm.value'
            }, {
              attribute: 'service.name',
              label: 'Service'
            }, {
              attribute: 'service.port',
              label: 'Port'
            }, {
              attribute: 'access_level',
              label: 'Access Level'
            }, {
              label: 'Tag',
              sortable: false,
              view: Pro.request('tags:index:component')
            }, {
              attribute: 'last_attempted_at',
              label: 'Last Attempted',
              view: Backbone.Marionette.ItemView.extend({
                modelEvents: {
                  'change:last_attempted_at': 'render'
                },
                template: function(m) {
                  return _.escape(m.last_attempted_at);
                }
              })
            }, {
              attribute: 'status',
              label: 'Validation',
              view: Pro.CredsApp.Show.Validation,
              hoverView: Pro.CredsApp.Show.ValidationHover,
              hoverOn: function() {
                return this.model.get('status') !== Pro.Entities.Login.Status.SUCCESSFUL;
              }
            }, {
              label: 'Validate',
              sortable: false,
              "class": 'get_session',
              view: Pro.CredsApp.Show.ValidateAuthentication
            }
          ],
          collection: collection
        });
      };

      CredentialsLayout.prototype.renderTables = function() {
        var accessingLogins, extraOpts, originatingCreds;
        extraOpts = {
          selectable: false,
          showClone: false,
          actionButtons: [],
          extraColumns: [
            {
              label: 'Validate',
              sortable: false,
              "class": 'get_session',
              attribute: 'get_session',
              view: Pro.CredsApp.Show.ValidateAuthentication
            }, {
              label: 'Delete',
              sortable: false,
              "class": 'delete',
              view: DeleteView
            }
          ]
        };
        accessingLogins = Pro.request('logins:entities', {
          provide_access_to_host: HOST_ID
        });
        this.accessingTable = this.renderLoginsTable(accessingLogins, this.accessingLoginsRegion, extraOpts);
        this.listenTo(this.accessingTable.collection, 'remove', this.accessingTable.refresh);
        this.listenTo(this.accessingTable.collection, 'removedByUser', this._rowRemoved);
        originatingCreds = Pro.request('creds:entities', {
          originating_from_host: HOST_ID
        });
        this.originatingTable = this.renderCoresTable(originatingCreds, this.originatingCredsRegion, _.extend({}, extraOpts, {
          withoutColumns: ['get_session']
        }));
        this.listenTo(this.originatingTable.collection, 'remove', this.originatingTable.refresh);
        this.listenTo(this.originatingTable.collection, 'removedByUser', this._rowRemoved);
        Pro.vent.off("cred:added");
        return Pro.vent.on("cred:added", function(credsCollection) {
          Pro.execute('flash:display', {
            title: 'Credential created',
            message: 'The credential was successfully saved.'
          });
          return credsCollection.fetch({
            reset: true
          });
        });
      };

      return CredentialsLayout;

    })(Marionette.LayoutView);
  });

}).call(this);
