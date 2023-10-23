(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_layout', 'base_view', 'base_itemview', 'apps/creds/findings/templates/private_cell', 'apps/creds/findings/templates/private_cell_disclosure_dialog', 'apps/creds/findings/templates/realm_cell', 'apps/creds/findings/templates/logins_hover', 'lib/concerns/views/hover_timeout', 'apps/creds/findings/templates/realm_hover', 'apps/creds/findings/templates/sessions_hover'], function() {
    return this.Pro.module('CredsApp.Findings', function(Findings, App, Backbone, Marionette, $, _) {
      Findings.PrivateCellDisclosureDialog = (function(_super) {

        __extends(PrivateCellDisclosureDialog, _super);

        function PrivateCellDisclosureDialog() {
          return PrivateCellDisclosureDialog.__super__.constructor.apply(this, arguments);
        }

        PrivateCellDisclosureDialog.prototype.template = PrivateCellDisclosureDialog.prototype.templatePath('creds/findings/private_cell_disclosure_dialog');

        return PrivateCellDisclosureDialog;

      })(App.Views.ItemView);
      Findings.Private = (function(_super) {

        __extends(Private, _super);

        function Private() {
          return Private.__super__.constructor.apply(this, arguments);
        }

        Private.prototype.template = Private.prototype.templatePath('creds/findings/private_cell');

        Private.prototype.events = {
          'click a': '_showPrivateModal'
        };

        Private.prototype._showPrivateModal = function() {
          var dialogView;
          dialogView = new Findings.PrivateCellDisclosureDialog({
            model: this.model
          });
          return App.execute('showModal', dialogView, {
            modal: {
              title: 'Private Data',
              description: '',
              width: 600,
              height: 400
            },
            buttons: [
              {
                name: 'Close',
                "class": 'close'
              }
            ]
          });
        };

        return Private;

      })(App.Views.ItemView);
      Findings.Realm = (function(_super) {

        __extends(Realm, _super);

        function Realm() {
          return Realm.__super__.constructor.apply(this, arguments);
        }

        Realm.prototype.template = Realm.prototype.templatePath('creds/findings/realm_cell');

        Realm.prototype.regions = {
          hoverRegion: '.hover-region'
        };

        Realm.include("HoverTimeout");

        return Realm;

      })(App.Views.Layout);
      Findings.RealmHover = (function(_super) {

        __extends(RealmHover, _super);

        function RealmHover() {
          return RealmHover.__super__.constructor.apply(this, arguments);
        }

        RealmHover.prototype.template = RealmHover.prototype.templatePath('creds/findings/realm_hover');

        RealmHover.prototype.className = 'realm-hover';

        return RealmHover;

      })(App.Views.ItemView);
      Findings.SuccessfulLogins = (function(_super) {

        __extends(SuccessfulLogins, _super);

        function SuccessfulLogins() {
          return SuccessfulLogins.__super__.constructor.apply(this, arguments);
        }

        SuccessfulLogins.prototype.template = function(m) {
          var numHosts, phrase, subject;
          subject = 'credential';
          numHosts = parseInt(m.successful_logins, 10);
          if (numHosts !== 1) {
            subject += 's';
          }
          phrase = _.escape("" + (_.escape(m.successful_logins)) + " " + subject);
          if (numHosts > 0) {
            return "<a href='javascript:void(0)'>" + phrase + "</a>";
          } else {
            return phrase;
          }
        };

        return SuccessfulLogins;

      })(App.Views.ItemView);
      Findings.Sessions = (function(_super) {

        __extends(Sessions, _super);

        function Sessions() {
          return Sessions.__super__.constructor.apply(this, arguments);
        }

        Sessions.prototype.template = function(m) {
          var numHosts, phrase, subject;
          subject = 'session';
          numHosts = parseInt(m.session_count, 10);
          if (numHosts !== 1) {
            subject += 's';
          }
          phrase = _.escape("" + (_.escape(m.session_count)) + " " + subject);
          if (numHosts > 0) {
            return "<a href='javascript:void(0)'>" + phrase + "</a>";
          } else {
            return phrase;
          }
        };

        return Sessions;

      })(App.Views.ItemView);
      Findings.LoginsHover = (function(_super) {

        __extends(LoginsHover, _super);

        function LoginsHover() {
          this.sync = __bind(this.sync, this);
          return LoginsHover.__super__.constructor.apply(this, arguments);
        }

        LoginsHover.prototype.className = 'hover-square';

        LoginsHover.prototype.template = LoginsHover.prototype.templatePath('creds/findings/logins_hover');

        LoginsHover.prototype.ui = {
          scrollie: '.scrollie'
        };

        LoginsHover.prototype.onShow = function() {
          return this.timeout = setTimeout(this.sync, 500);
        };

        LoginsHover.prototype.onDestroy = function() {
          return clearTimeout(this.timeout);
        };

        LoginsHover.prototype.sync = function() {
          var url,
            _this = this;
          url = Routes.task_detail_path(WORKSPACE_ID, TASK_ID) + ("/stats/successful_logins_hover.json?service_id=" + (this.model.get('id')));
          return $.getJSON(url).done(function(data) {
            var _ref;
            _this.model.set({
              rowData: data
            });
            if (((_ref = _this.el) != null ? _ref.parentNode : void 0) != null) {
              return _this.render();
            }
          });
        };

        return LoginsHover;

      })(Pro.Views.CompositeView);
      return Findings.SessionsHover = (function(_super) {

        __extends(SessionsHover, _super);

        function SessionsHover() {
          this.sync = __bind(this.sync, this);
          return SessionsHover.__super__.constructor.apply(this, arguments);
        }

        SessionsHover.prototype.className = 'hover-square session';

        SessionsHover.prototype.template = SessionsHover.prototype.templatePath('creds/findings/sessions_hover');

        SessionsHover.prototype.ui = {
          scrollie: '.scrollie'
        };

        SessionsHover.prototype.onShow = function() {
          return this.timeout = setTimeout(this.sync, 500);
        };

        SessionsHover.prototype.onDestroy = function() {
          return clearTimeout(this.timeout);
        };

        SessionsHover.prototype.sync = function() {
          var url,
            _this = this;
          url = Routes.task_detail_path(WORKSPACE_ID, TASK_ID) + ("/stats/sessions_hover.json?service_id=" + (this.model.get('attempt_ids')));
          return $.getJSON(url).done(function(data) {
            var _ref;
            _this.model.set({
              rowData: data
            });
            if (((_ref = _this.el) != null ? _ref.parentNode : void 0) != null) {
              return _this.render();
            }
          });
        };

        return SessionsHover;

      })(Pro.Views.CompositeView);
    });
  });

}).call(this);
