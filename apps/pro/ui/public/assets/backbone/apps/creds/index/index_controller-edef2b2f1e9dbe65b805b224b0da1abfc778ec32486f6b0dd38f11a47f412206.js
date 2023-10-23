(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/creds/index/index_view', 'entities/cred', 'lib/concerns/controllers/render_cores_table', 'lib/components/filter/filter_controller'], function() {
    return this.Pro.module("CredsApp.Index", function(Index, App) {
      return Index.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.include('RenderCoresTable');

        Controller.prototype.initialize = function(options) {
          var creds, filterAttrs, search, show, _ref,
            _this = this;
          _.defaults(options, {
            show: true
          });
          show = options.show, filterAttrs = options.filterAttrs, search = options.search;
          this.layout = new Index.Layout;
          this.setMainView(this.layout);
          creds = App.request('creds:entities', typeof window !== "undefined" && window !== null ? (_ref = window.gon) != null ? _ref.related_logins : void 0 : void 0);
          this.listenTo(this._mainView, 'show', function() {
            _this.table = _this.renderCoresTable(creds, _this.layout.credsRegion, {
              search: search,
              htmlID: 'manage-creds',
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
                      label: 'Nonreplayable Hash'
                    }, {
                      value: 'Password',
                      label: 'Password'
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
                },
                filterRegion: _this.layout.filterRegion
              }
            });
            return _this._mainView.setCarpenterChannel(_this.table.channel());
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

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
