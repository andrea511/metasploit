(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/hosts/backbone/views/item_views/vuln_form-1cc7b36421c773badb5827996b6c4a19d59df0e3943ca7e7df6ef280d88f7247.js', 'base_controller', 'apps/vulns/show/show_views', 'entities/vuln', 'lib/shared/cve_cell/cve_cell_controller'], function(VulnForm) {
    return this.Pro.module("VulnsApp.Show", function(Show, App) {
      return Show.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this._buildModel = __bind(this._buildModel, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(opts) {
          var _this = this;
          if (opts == null) {
            opts = {};
          }
          this.model = this._buildModel(opts);
          this.layout = new Show.Layout({
            model: this.model
          });
          this.setMainView(this.layout);
          this.headerView = new Show.Header({
            model: this.model
          });
          this.listenTo(this.headerView, 'vuln:edit', function() {
            return _this._show_vuln_edit_modal({
              hideRefs: true,
              height: 200
            });
          });
          this.listenTo(this.headerView, 'ref:edit', function() {
            return _this._show_vuln_edit_modal({
              hideVuln: true,
              height: 400
            });
          });
          this.listenTo(this.headerView, 'ref:more', function() {
            return _this._show_refs_modal();
          });
          this.listenTo(this.layout, 'show', function() {
            _this._show_tabs();
            return _this._bindPushButtonEvents();
          });
          if (opts.model != null) {
            return this.show(this.layout);
          } else {
            this.model.fetch();
            return this.show(this.layout, {
              loading: {
                loadingType: 'overlay'
              }
            });
          }
        };

        Controller.prototype._buildModel = function(opts) {
          return opts.model || new App.Entities.Vuln(opts);
        };

        Controller.prototype._show_tabs = function() {
          this.tabView = App.request("tabs:component", {
            tabs: [
              {
                name: 'Overview',
                view: Show.OverviewTab,
                model: this.model
              }, {
                name: 'Related Modules',
                view: Show.RelatedModulesTab,
                model: this.model
              }, {
                name: 'Related Hosts',
                view: Show.RelatedHostsTab,
                model: this.model
              }
            ],
            destroy: false
          });
          this.pushButtonsView = new Show.PushButtons({
            model: this.model
          });
          this.show(this.pushButtonsView, {
            region: this.layout.pushButtonsRegion
          });
          this.show(this.headerView, {
            region: this.layout.headerRegion
          });
          return this.show(this.tabView, {
            region: this.layout.contentRegion
          });
        };

        Controller.prototype._bindPushButtonEvents = function() {
          var _this = this;
          this.listenTo(this.pushButtonsView, 'nexpose:push', function() {
            var description, height, view, width;
            if (_this.model.get('markable')) {
              view = new Show.PushExceptionConfirmationView({
                model: _this.model
              });
              description = "You are about to push this vulnerability to Nexpose as an exception. Please select the following:";
              height = 170;
              width = 400;
            } else {
              view = new Show.PushValidationConfirmationView();
              height = 170;
              width = 400;
            }
            return App.execute('showModal', view, {
              modal: {
                title: 'Push To Nexpose',
                description: description,
                width: width
              },
              buttons: [
                {
                  name: 'No',
                  "class": 'close'
                }, {
                  name: 'Yes',
                  "class": 'btn primary'
                }
              ],
              doneCallback: function() {
                return _this.model.fetch();
              }
            });
          });
          return this.listenTo(this.pushButtonsView, 'vuln:not:exploitable', function(checked) {
            if (checked) {
              return _this.model.updateLastVulnStatus('Not Exploitable');
            } else {
              return _this.model.restoreLastVulnStatus();
            }
          });
        };

        Controller.prototype._show_refs_modal = function() {
          var dialogView, moduleDetail;
          moduleDetail = this.model;
          dialogView = new Pro.Shared.CveCell.ModalView({
            model: moduleDetail
          });
          moduleDetail.fetch();
          return App.execute('showModal', dialogView, {
            modal: {
              title: 'References',
              width: 260,
              height: 300
            },
            buttons: [
              {
                name: 'Close',
                "class": 'close'
              }
            ],
            loading: true
          });
        };

        Controller.prototype._show_vuln_edit_modal = function(opts) {
          var config, formView,
            _this = this;
          if (opts == null) {
            opts = {};
          }
          config = {
            action: 'edit',
            id: this.model.get('id'),
            host_id: this.model.get('host').id
          };
          _.extend(config, opts);
          formView = new VulnForm(config);
          return App.execute('showModal', formView, {
            modal: {
              title: 'Vulnerability',
              width: 600,
              height: config.height
            },
            buttons: [
              {
                name: 'Close',
                "class": 'close'
              }, {
                name: 'OK',
                "class": 'btn primary'
              }
            ],
            doneCallback: function() {
              return _this.model.fetch();
            }
          });
        };

        return Controller;

      })(App.Controllers.Application);
    }, VulnForm);
  });

}).call(this);
