(function() {

  define(['jquery', 'lib/shared/creds/cell_views', 'apps/meta_modules/domino/visualization_controller', 'lib/components/table/table_controller'], function($) {
    return Pro.module('TasksApp.Findings').Domino = {
      stats: [
        {
          title: 'Iterations',
          type: 'stat',
          num: 'iterations'
        }, {
          title: 'Unique Credentials Captured',
          type: 'stat',
          num: 'creds_captured'
        }, {
          title: 'Hosts Compromised',
          type: 'stat',
          num: 'hosts_compromised',
          badge: function(task) {
            var count, plural;
            count = task.get('high_values');
            plural = count === 1 ? '' : 's';
            if (count > 0) {
              return "" + count + " Designated High Value Host" + plural;
            } else {
              return null;
            }
          }
        }
      ],
      controllers: {
        iterations: Pro.MetaModulesApp.Domino.Controller
      },
      tables: {
        unique_credentials_captured: {
          columns: [
            {
              label: 'Public',
              attribute: 'public',
              view: Pro.Creds.CellViews.Public
            }, {
              label: 'Private',
              attribute: 'private',
              "class": 'truncate',
              view: Pro.Creds.CellViews.Private
            }, {
              label: 'Realm',
              attribute: 'realm_key',
              view: Pro.Creds.CellViews.Realm,
              hoverView: Pro.Creds.CellViews.RealmHover,
              hoverOn: function() {
                return !_.isEmpty(this.model.get('realm'));
              }
            }, {
              label: 'Captured from',
              attribute: 'captured_from_address',
              view: Pro.Creds.CellViews.HostAddress,
              viewOpts: {
                attribute: 'captured_from_address'
              }
            }, {
              label: 'Host name',
              attribute: 'captured_from_name'
            }, {
              label: 'Compromised Hosts',
              attribute: 'compromised_hosts',
              view: Pro.Creds.CellViews.Count,
              viewOpts: {
                attribute: 'compromised_hosts',
                subject: 'host'
              },
              hoverView: Pro.Creds.CellViews.CollectionHover.extend({
                attributes: {
                  width: '300px'
                },
                url: function() {
                  return Routes.task_detail_path(this.model.get('workspace_id'), this.model.get('task_id')) + ("/stats/hosts_compromised_from.json?core_id=" + (this.model.get('core_id')));
                },
                title: function() {
                  return "Compromised Hosts (" + (this.model.get('compromised_hosts')) + "):";
                },
                columns: [
                  {
                    label: 'Host IP',
                    size: 6,
                    attribute: 'host_address'
                  }, {
                    label: 'Host Name',
                    size: 6,
                    attribute: 'host_name'
                  }
                ]
              }),
              hoverOn: function() {
                return parseInt(this.model.get('compromised_hosts'), 10) > 0;
              }
            }
          ]
        },
        hosts_compromised: {
          onShow: function(controller) {
            var $checkbox, collection, onlyHighValueTargets, updateRowHighlights;
            $checkbox = $("<label class='high-value-only'>\n  <input type='checkbox' /> Show High Value Hosts only\n</label>");
            controller.list.$el.parent().append($checkbox);
            $checkbox.on('change', function() {
              return onlyHighValueTargets($checkbox.find('input').is(':checked'));
            });
            collection = controller.collection;
            collection.on('reset sync', updateRowHighlights);
            updateRowHighlights = function() {
              var _this = this;
              return _.each(controller.list.table.find('tbody tr'), function(tr, idx) {
                var _ref;
                return $(tr).toggleClass('high-value', ((_ref = collection.models[idx]) != null ? typeof _ref.get === "function" ? _ref.get('high_value') : void 0 : void 0) === 'true');
              });
            };
            return onlyHighValueTargets = function(only) {
              var baseURL;
              baseURL = collection.url.replace(/[^\/]+$/, '');
              collection.url = only ? baseURL + 'high_value_hosts_compromised' : baseURL + 'hosts_compromised';
              return collection.goTo(1);
            };
          },
          columns: [
            {
              label: 'Host IP',
              attribute: 'address',
              view: Pro.Creds.CellViews.HostAddress
            }, {
              label: 'Host name',
              attribute: 'name'
            }, {
              label: 'OS',
              attribute: 'os_name'
            }, {
              label: 'Service',
              attribute: 'service_name'
            }, {
              label: 'Port',
              attribute: 'service_port'
            }, {
              label: 'Public',
              attribute: 'public',
              view: Pro.Creds.CellViews.Public
            }, {
              label: 'Private',
              attribute: 'private',
              view: Pro.Creds.CellViews.Private
            }, {
              label: 'Realm',
              attribute: 'realm_key',
              view: Pro.Creds.CellViews.Realm,
              hoverView: Pro.Creds.CellViews.RealmHover,
              hoverOn: function() {
                return !_.isEmpty(this.model.get('realm'));
              }
            }, {
              label: 'Credentials Looted',
              attribute: 'captured_creds_count',
              view: Pro.Creds.CellViews.Count,
              viewOpts: {
                attribute: 'captured_creds_count',
                subject: 'credential'
              },
              hoverView: Pro.Creds.CellViews.CollectionHover.extend({
                url: function() {
                  return Routes.task_detail_path(this.model.get('workspace_id'), this.model.get('task_id')) + ("/stats/creds_captured_from.json?node_id=" + (this.model.get('node_id')));
                },
                title: function() {
                  return "Credentials Looted (" + (this.model.get('captured_creds_count')) + "):";
                },
                columns: [
                  {
                    label: 'Public',
                    size: 4,
                    attribute: 'public'
                  }, {
                    label: 'Private',
                    size: 5,
                    attribute: 'private'
                  }, {
                    label: 'Private Type',
                    size: 3,
                    attribute: 'private_type'
                  }
                ]
              }),
              hoverOn: function() {
                return parseInt(this.model.get('captured_creds_count'), 10) > 0;
              }
            }, {
              label: 'Sessions',
              attribute: 'sessions_count',
              view: Pro.Creds.CellViews.Count,
              viewOpts: {
                attribute: 'sessions_count',
                subject: 'session',
                link: function(m) {
                  return Routes.host_path(m.host_id) + '#sessions';
                }
              }
            }
          ]
        }
      }
    };
  });

}).call(this);
