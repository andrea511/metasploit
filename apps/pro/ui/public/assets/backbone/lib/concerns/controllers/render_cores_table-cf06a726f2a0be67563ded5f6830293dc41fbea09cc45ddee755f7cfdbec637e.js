(function() {

  define(['lib/components/table/table_controller', 'entities/cred', 'entities/origin', 'lib/components/modal/modal_controller', 'apps/creds/shared/cred_shared_views', 'lib/components/tags/index/index_controller', 'apps/creds/new/new_controller', 'lib/components/tags/new/new_controller'], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.RenderCoresTable = {
        renderCoresTable: function(collection, region, opts) {
          var columns, extraColumns, showClone, tableController;
          if (opts == null) {
            opts = {};
          }
          extraColumns = opts.extraColumns || [];
          showClone = opts.showClone != null ? opts.showClone : true;
          if (showClone) {
            extraColumns.unshift({
              "class": 'clone',
              sortable: false,
              attribute: 'clone',
              view: App.request('creds:shared:coresTableCloneCell')
            });
          }
          columns = _.union([
            {
              label: 'Logins',
              attribute: 'logins_count',
              sortable: false
            }, {
              attribute: 'public.username',
              label: 'Public',
              defaultDirection: 'asc',
              view: App.request('creds:shared:coresTablePublicCell'),
              viewOpts: {
                disableCredLinks: opts.disableCredLinks
              }
            }, {
              label: 'Private',
              "class": 'truncate',
              view: App.request('creds:shared:coresTablePrivateCell'),
              attribute: 'private.data'
            }, {
              label: 'Type',
              attribute: 'pretty_type',
              sortAttribute: 'private.type'
            }, {
              label: 'Realm',
              attribute: 'pretty_realm',
              "class": 'truncate',
              sortAttribute: 'realm.value'
            }, {
              label: "Origin",
              attribute: 'origin_type',
              view: App.request('creds:shared:coresTableOriginCell')
            }, {
              attribute: 'validation',
              sortable: false
            }, {
              attribute: 'tags',
              sortable: false,
              view: App.request('tags:index:component')
            }
          ], extraColumns);
          if (opts.withoutColumns != null) {
            columns = _.reject(columns, function(col) {
              return _.contains(opts.withoutColumns, col.attribute);
            });
          }
          return tableController = App.request("table:component", _.extend({
            region: region,
            taggable: true,
            selectable: true,
            "static": false,
            collection: collection,
            htmlID: opts.htmlID,
            perPage: 20,
            defaultSort: 'public.username',
            actionButtons: [
              {
                label: 'Export',
                click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                  var controller;
                  controller = App.request('creds:export', {
                    selectAllState: selectAllState,
                    selectedIDs: selectedIDs,
                    deselectedIDs: deselectedIDs,
                    selectedVisibleCollection: selectedVisibleCollection,
                    tableCollection: tableCollection
                  });
                  return App.execute("showModal", controller, {
                    modal: {
                      title: 'Export',
                      description: '',
                      height: 280,
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
              }, {
                label: 'Delete',
                activateOn: 'any',
                click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                  var controller;
                  controller = App.request('creds:delete', {
                    selectAllState: selectAllState,
                    selectedIDs: selectedIDs,
                    deselectedIDs: deselectedIDs,
                    selectedVisibleCollection: selectedVisibleCollection,
                    tableCollection: tableCollection
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
                click: function(selectAllState, selectedIDs, deselectedIDs, selectedVisibleCollection, tableCollection) {
                  var controller;
                  controller = App.request('creds:new', {
                    tableCollection: tableCollection
                  });
                  return App.execute("showModal", controller, {
                    modal: {
                      title: 'Add Credential(s)',
                      description: '',
                      height: 390,
                      width: 620
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
                  var controller, ids, models, query, url;
                  ids = selectAllState ? deselectedIDs : selectedIDs;
                  models = _.map(ids, function(id) {
                    return new Backbone.Model({
                      id: id
                    });
                  });
                  collection = new Backbone.Collection(models);
                  query = "";
                  url = "/workspaces/" + WORKSPACE_ID + "/metasploit/credential/cores/quick_multi_tag.json";
                  controller = App.request('tags:new:component', collection, {
                    selectAllState: selectAllState,
                    selectedIDs: selectedIDs,
                    deselectedIDs: deselectedIDs,
                    q: query,
                    url: url,
                    serverAPI: tableCollection.server_api,
                    ids_only: true,
                    content: App.request('new:cred:entity').get('taggingModalHelpContent')
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
                      return App.vent.trigger('core:tag:added', tableCollection);
                    }
                  });
                }
              }
            ],
            columns: columns
          }, opts));
        }
      };
    });
  });

}).call(this);
