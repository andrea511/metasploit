(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'lib/components/table/table_controller', 'apps/creds/show/show_view', 'entities/login', 'lib/components/tags/index/index_controller', 'apps/creds/shared/templates/origin_cell', 'apps/creds/shared/templates/origin_cell_disclosure_dialog'], function() {
    return this.Pro.module("CredsApp.Show", function(Show, App) {
      return Show.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var cred, relatedLogins, show,
            _this = this;
          _.defaults(options, {
            show: true
          });
          this.id = options.id, cred = options.cred, show = options.show, this.workspace_id = options.workspace_id;
          this.cred || (this.cred = App.request("cred:entity", this.id));
          this.workspace_id || (this.workspace_id = WORKSPACE_ID);
          this.layout = new Show.Layout({
            model: this.cred
          });
          this.setMainView(this.layout);
          relatedLogins = App.request('logins:entities', {
            core_id: this.id,
            workspace_id: this.workspace_id
          });
          this.listenTo(this.layout, 'show', function() {
            var originCellView, privateCredView, tagsView;
            privateCredView = App.request('creds:shared:coresTablePrivateCell', {
              model: _this.cred,
              displayFilterLink: true
            }, {
              instantiate: true
            });
            originCellView = App.request('creds:shared:coresTableOriginCell', {
              model: _this.cred
            }, {
              instantiate: true
            });
            _this.cred.set('tag_count', _this.cred.get('tags').length);
            tagsView = App.request('tags:index:component', {
              instantiate: true,
              model: _this.cred
            });
            _this.show(privateCredView, {
              region: _this._mainView.privateRegion
            });
            _this.show(originCellView, {
              region: _this._mainView.originRegion
            });
            _this.show(tagsView, {
              region: _this._mainView.tags
            });
            return _this.relatedLoginsRegion(relatedLogins, _this.id);
          });
          this.listenTo(this.layout, 'reuse:show', function() {
            return App.vent.trigger('quickReuse:show', _this.id);
          });
          if (show) {
            return this.show(this.layout, {
              region: this.region,
              loading: {
                loadingType: 'overlay'
              }
            });
          }
        };

        Controller.prototype.relatedLoginsRegion = function(relatedLogins, core_id) {
          var tableController;
          return tableController = App.request("table:component", {
            title: 'Related Logins',
            region: this.layout.relatedLoginsRegion,
            selectable: true,
            taggable: true,
            "static": false,
            perPage: 20,
            defaultSort: 'created_at',
            actionButtons: [
              {
                label: 'Delete',
                activateOn: 'any',
                click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                  var controller;
                  controller = App.request('logins:delete', {
                    selectAllState: selectAllState,
                    selectedIDs: selectedIDs,
                    deselectedIDs: deselectedIDs,
                    selectedVisibleCollection: selectedVisibleCollection,
                    tableCollection: tableCollection,
                    credID: core_id
                  });
                  return App.execute("showModal", controller, {
                    modal: {
                      title: 'Are you sure?',
                      description: '',
                      height: 150,
                      width: 550,
                      hideBorder: true
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
              }, {
                label: '+ Add',
                "class": 'add',
                click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection) {
                  var controller;
                  controller = App.request('logins:new', core_id);
                  return App.execute("showModal", controller, {
                    modal: {
                      title: 'Add Login',
                      hideBorder: true,
                      description: '',
                      height: 290,
                      width: 460
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
              }, {
                label: 'Tag',
                "class": 'tag',
                containerClass: 'right',
                activateOn: 'any',
                click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                  var collection, controller, ids, models, query, url;
                  ids = selectAllState ? deselectedIDs : selectedIDs;
                  models = _.map(ids, function(id) {
                    return new Backbone.Model({
                      id: id
                    });
                  });
                  collection = new Backbone.Collection(models);
                  query = "";
                  url = "/workspaces/" + WORKSPACE_ID + "/metasploit/credential/cores/" + (_.escape(core_id)) + "/logins/quick_multi_tag.json";
                  controller = App.request('tags:new:component', collection, {
                    selectAllState: selectAllState,
                    selectedIDs: selectedIDs,
                    deselectedIDs: deselectedIDs,
                    q: query,
                    url: url,
                    serverAPI: tableCollection.server_api,
                    ids_only: true,
                    content: App.request('new:login:entity').get('taggingModalHelpContent')
                  });
                  return App.execute("showModal", controller, {
                    modal: {
                      title: 'Tags',
                      description: '',
                      height: 170,
                      width: 400,
                      hideBorder: true
                    },
                    buttons: [
                      {
                        name: 'Cancel',
                        "class": 'close'
                      }, {
                        name: 'OK',
                        "class": 'btn primary'
                      }
                    ],
                    doneCallback: function() {
                      return App.vent.trigger('login:tag:added', tableCollection);
                    }
                  });
                }
              }
            ],
            columns: [
              {
                attribute: 'service.name',
                label: 'Service'
              }, {
                attribute: 'service.port',
                label: 'Port'
              }, {
                attribute: 'service.host.name',
                label: 'Host',
                view: Show.SingleHostFilterLink
              }, {
                attribute: 'access_level',
                label: 'Access Level',
                view: Show.AccessLevel
              }, {
                attribute: 'tags',
                sortable: false,
                view: App.request('tags:index:component')
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
                view: Show.Validation,
                hoverView: Show.ValidationHover,
                hoverOn: function() {
                  return this.model.get('status') !== Pro.Entities.Login.Status.SUCCESSFUL;
                }
              }, {
                label: 'Validate',
                sortable: false,
                "class": 'get_session',
                view: Show.ValidateAuthentication
              }
            ],
            collection: relatedLogins
          });
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
