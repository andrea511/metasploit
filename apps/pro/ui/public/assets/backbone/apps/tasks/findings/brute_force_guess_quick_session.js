(function() {

  define(['css!css/brute_force_guess_findings', 'lib/components/table/cell_views', 'lib/shared/attempt_session/attempt_session_controller', 'apps/creds/findings/findings_controller', 'lib/shared/creds/cell_views'], function() {
    return this.Pro.module('TasksApp.Findings', function(Findings, App) {
      var goToSession, hostView, privateView, publicView, realmView, sessions, sessionsHover;
      hostView = Backbone.Marionette.ItemView.extend({
        template: function(m) {
          return "<a href='/hosts/" + (_.escape(m.host_id)) + "' class='underline'>" + (_.escape(m.address)) + "</a>";
        }
      });
      publicView = Backbone.Marionette.ItemView.extend({
        template: function(m) {
          if (m.core_id) {
            return "<a href='/workspaces/" + WORKSPACE_ID + "/credentials#creds/" + (_.escape(m.core_id)) + "' class='underline'>" + (_.escape(m["public"])) + "</a>";
          } else {
            return "" + (_.escape(m["public"]));
          }
        }
      });
      goToSession = Backbone.Marionette.ItemView.extend({
        template: function(m) {
          if (m.session_id) {
            return "<a href='" + (Routes.session_path(WORKSPACE_ID, m.session_id)) + "' class='underline'>Session " + m.session_id + "</a>";
          } else {
            return '';
          }
        }
      });
      privateView = App.CredsApp.Findings.PrivateController;
      realmView = App.CredsApp.Findings.RealmController;
      sessionsHover = App.CredsApp.Findings.SessionsHover;
      sessions = App.CredsApp.Findings.Sessions;
      return Findings.BruteForceGuessQuickSession = {
        stats: [
          {
            title: 'Login Attempts',
            type: 'percentage',
            num: 'logins_attempted',
            total: 'maximum_login_attempts'
          }, {
            title: 'Targets Compromised',
            type: 'percentage',
            num: 'targets_compromised',
            total: 'maximum_targets_compromised'
          }, {
            title: 'Successful Logins',
            type: 'percentage',
            num: 'successful_login_attempts',
            total: 'logins_attempted'
          }
        ],
        tables: {
          login_attempts: {
            defaultSort: 'attempted_at',
            columns: [
              {
                label: 'Host IP',
                attribute: 'address',
                view: hostView
              }, {
                label: 'Host name',
                attribute: 'host_name',
                "class": 'truncate'
              }, {
                label: 'Service',
                attribute: 'service_name'
              }, {
                label: 'Port',
                attribute: 'service_port'
              }, {
                label: 'Public',
                attribute: 'public',
                view: publicView
              }, {
                label: 'Private',
                attribute: 'private',
                view: privateView
              }, {
                label: 'Realm',
                attribute: 'realm',
                view: realmView,
                sortAttribute: 'realm_key'
              }, {
                label: 'Result',
                attribute: 'status'
              }
            ]
          },
          targets_compromised: {
            columns: [
              {
                label: 'Host IP',
                attribute: 'address',
                view: hostView
              }, {
                label: 'Host name',
                attribute: 'host_name'
              }, {
                label: "OS",
                attribute: "host_os_name"
              }, {
                label: 'Service',
                attribute: 'name'
              }, {
                label: 'Port',
                attribute: 'port'
              }, {
                label: 'Successful Logins',
                attribute: 'successful_logins',
                view: Pro.Creds.CellViews.Count,
                viewOpts: {
                  attribute: 'successful_logins',
                  subject: 'credential'
                },
                hoverView: Pro.Creds.CellViews.CollectionHover.extend({
                  url: function() {
                    return Routes.task_detail_path(WORKSPACE_ID, TASK_ID) + ("/stats/successful_logins_hover.json?service_id=" + (this.model.get('attempt_ids')));
                  },
                  title: function() {
                    return "";
                  },
                  columns: [
                    {
                      label: 'Public',
                      size: 4,
                      attribute: 'public_username'
                    }, {
                      label: 'Private',
                      size: 5,
                      attribute: 'private_data'
                    }, {
                      label: 'Private Type',
                      size: 3,
                      attribute: 'private_type'
                    }
                  ]
                })
              }, {
                label: "Sessions",
                attribute: 'session_count',
                view: sessions,
                hoverView: sessionsHover
              }
            ]
          },
          successful_logins: {
            columns: [
              {
                label: 'Host IP',
                attribute: 'address',
                view: hostView
              }, {
                label: 'Host name',
                attribute: 'host_name'
              }, {
                label: "OS",
                attribute: "host_os_name"
              }, {
                label: 'Service',
                attribute: 'service_name'
              }, {
                label: 'Port',
                attribute: 'port'
              }, {
                label: 'Public',
                attribute: 'public',
                view: publicView
              }, {
                label: 'Private',
                attribute: 'private',
                view: privateView
              }, {
                label: 'Realm',
                attribute: 'realm',
                view: realmView,
                sortAttribute: 'realm_key'
              }, {
                label: 'Go to Session',
                attribute: 'sessions_id',
                view: goToSession
              }
            ]
          }
        }
      };
    });
  });

}).call(this);
