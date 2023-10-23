(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'apps/brute_force_guess/quick/quick_views', 'entities/brute_force_guess/target', 'entities/brute_force_guess/mutation_options', 'lib/components/modal/modal_controller', 'lib/shared/payload_settings/payload_settings_controller', 'lib/components/breadcrumbs/breadcrumbs_controller', 'lib/components/file_input/file_input_controller', 'lib/components/tooltip/tooltip_controller'], function() {
    return this.Pro.module("BruteForceGuessApp.Quick", function(Quick, App) {
      return Quick.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this._updateTargetCount = __bind(this._updateTargetCount, this);

          this._configModel = __bind(this._configModel, this);

          this._listenToMainView = __bind(this._listenToMainView, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var taskChain;
          _.defaults(options, {
            taskChain: false
          });
          taskChain = options.taskChain, this.payloadModel = options.payloadModel, this.mutationModel = options.mutationModel;
          this.layout = new Quick.Layout({
            model: new Backbone.Model({
              taskChain: taskChain
            })
          });
          this.setMainView(this.layout);
          return this._listenToMainView();
        };

        Controller.prototype.restoreUIState = function(opts) {
          if (opts == null) {
            opts = {};
          }
          this.targetsView.restoreUIState();
          return this.credsView.restoreUIState(opts);
        };

        Controller.prototype.useLastUploaded = function(filePath) {
          var fileName;
          fileName = filePath.split('/').pop();
          return this.credsView.useLastUploaded(fileName);
        };

        Controller.prototype._listenToMainView = function() {
          this.listenTo(this._mainView, 'show', function() {
            this._initViews();
            this._listenToTargetsView();
            this._listenToCredsView();
            this._listenToPayloadSettings();
            this._listenToMutationOptions();
            this._listenToTooltips();
            this._initCrumbComponent();
            return this._showViews();
          });
          return this.listenTo(this._mainView, 'launch:clicked', function() {
            var view,
              _this = this;
            if (localStorage.getItem("Launch Bruteforce") !== "false") {
              view = new Quick.ConfirmationView({
                model: new Backbone.Model({
                  combo_count: this._getComboCount(),
                  fuzz: this.credsView.isFuzzed()
                })
              });
              App.execute('showModal', view, {
                modal: {
                  title: 'Launch Bruteforce',
                  description: '',
                  width: 400,
                  height: 220,
                  showAgainOption: true
                },
                buttons: [
                  {
                    name: 'No',
                    "class": 'close'
                  }, {
                    name: 'Yes',
                    "class": 'btn primary'
                  }
                ]
              });
              return this.listenTo(view, 'launch', function() {
                return _this._launchBruteForce();
              });
            } else {
              return this._launchBruteForce();
            }
          });
        };

        Controller.prototype._launchBruteForce = function() {
          var config, csrf_param, csrf_token, values_with_csrf,
            _this = this;
          Pro.execute('loadingOverlay:show');
          config = this._configModel();
          csrf_param = $('meta[name=csrf-param]').attr('content');
          csrf_token = $('meta[name=csrf-token]').attr('content');
          values_with_csrf;

          values_with_csrf = _.extend({}, config.toJSON());
          values_with_csrf[csrf_param] = csrf_token;
          if (this._mainView.credsRegion.currentView.ui.fileInput.val() !== '') {
            return config.save({}, {
              iframe: true,
              files: this._mainView.credsRegion.currentView.ui.fileInput,
              data: values_with_csrf,
              complete: function(data) {
                data = $.parseJSON(data.responseText);
                if (data.success === true) {
                  return window.location = data.redirect_to;
                } else {
                  Pro.execute('loadingOverlay:hide');
                  return _this._mainView.showErrors(data.errors);
                }
              }
            });
          } else {
            return config.save({}, {
              success: function(model, response, options) {
                return window.location = response.redirect_to;
              },
              error: function(model, response, options) {
                Pro.execute('loadingOverlay:hide');
                return _this._mainView.showErrors(response.responseJSON.errors);
              }
            });
          }
        };

        Controller.prototype.validateBruteForce = function(callback) {
          var config,
            _this = this;
          config = this._configModel();
          return config.save({
            validate_only: true
          }, {
            success: function(model, response, options) {
              return typeof callback === "function" ? callback(model, response, options) : void 0;
            },
            error: function(model, response, options) {
              return typeof callback === "function" ? callback(model, response, options) : void 0;
            }
          });
        };

        Controller.prototype._configModel = function() {
          var mergedHash, _ref, _ref1;
          mergedHash = _.extend(Backbone.Syphon.serialize(this._mainView, {
            exclude: ["quick_bruteforce[file]"]
          }), (_ref = this.payloadModel) != null ? _ref.toJSON() : void 0);
          _.extend(mergedHash, (_ref1 = this.mutationModel) != null ? _ref1.toJSON() : void 0);
          return Pro.request("new:brute_force_guess_form:entity", mergedHash);
        };

        Controller.prototype._initViews = function() {
          var target;
          target = App.request('bruteForceGuess:target:entities', {});
          this.targetsView = new Quick.TargetsView({
            model: target
          });
          this.credsView = new Quick.CredsView({
            model: new Backbone.Model({
              workspace_cred_count: gon.workspace_cred_count,
              is_task_chain: this._mainView.model.attributes.taskChain
            })
          });
          return this.optionsView = new Quick.OptionsView();
        };

        Controller.prototype._initCrumbComponent = function() {
          this.crumbsController = App.request('crumbs:component', {
            crumbs: [
              {
                title: 'TARGETS',
                selectable: false
              }, {
                title: 'CREDENTIALS',
                selectable: false
              }, {
                title: 'OPTIONS',
                selectable: false
              }
            ]
          });
          return this.crumbsCollection = this.crumbsController.crumbsCollection;
        };

        Controller.prototype._listenToTooltips = function() {
          return this.listenTo(this.optionsView, 'show', function() {
            var blacklist_addresses_tip, mutation_tip, overall_tip, service_tip, session_tip, target_addresses_tip, time_tip;
            target_addresses_tip = App.request('tooltip:component', {
              title: "Target Addresses",
              content: "To specify the target hosts, you can enter a single IP address, an address range, or a\nCIDR notation.You must use a newline to separate each entry.\n\nFor example:\n\n192.168.1.0/24\n192.169.1.1\n192.169.2.1-255\n\nIf you do not enter any hosts in the Target addresses field, all hosts in the project will\nbe selected except for the ones listed in the Excluded addresses field."
            });
            blacklist_addresses_tip = App.request('tooltip:component', {
              title: "Excluded Addresses",
              content: "Enter a single IP address, an address range, or a CIDR notation. Use a new line to\nseparate each entry.\n\nExample:\n10.20.37.60\n10.20.37.0/24"
            });
            time_tip = App.request('tooltip:component', {
              title: 'Interval',
              content: 'Sets the amount of time that Bruteforce should wait between login attempts.'
            });
            service_tip = App.request('tooltip:component', {
              title: 'Service Timeout',
              content: 'Sets the timeout, in seconds, for each target.'
            });
            overall_tip = App.request('tooltip:component', {
              title: 'Overall Timeout',
              content: "Sets the timeout limit for how long the Bruteforce task can run in its entirety.\nYou can specify the timeout in the following format: HH:MM:SS. To set no timeout\nlimit, leave the fields blank."
            });
            mutation_tip = App.request('tooltip:component', {
              title: 'Mutation',
              content: "Mutations can be used to create permutations of a password, which enables you to\nbuild a larger wordlist based on a small set of passwords. Mutations can be used to\nadd numbers and special characters to a password, toggle the casing of letters, and\ncontrol the length of a password."
            });
            session_tip = App.request('tooltip:component', {
              title: 'Session',
              content: "If enabled, Bruteforce will attempt to obtain a session when there is a successful\nlogin attempt to MSSQL, MySQL, PostgreSQL, SMB, SSH, telnet, WinRM, and HTTP."
            });
            this.show(target_addresses_tip, {
              region: this.targetsView.targetAddressesTooltipRegion
            });
            this.show(blacklist_addresses_tip, {
              region: this.targetsView.blacklistAddressesTooltipRegion
            });
            this.show(time_tip, {
              region: this.optionsView.timeTooltipRegion
            });
            this.show(service_tip, {
              region: this.optionsView.serviceTimeoutTooltipRegion
            });
            this.show(overall_tip, {
              region: this.optionsView.overallTimeoutTooltipRegion
            });
            this.show(mutation_tip, {
              region: this.optionsView.mutationTooltipRegion
            });
            return this.show(session_tip, {
              region: this.optionsView.sessionTooltipRegion
            });
          });
        };

        Controller.prototype._listenToTargetsView = function() {
          var _this = this;
          this.listenTo(this.targetsView, 'show', function() {
            if (gon.host_ips != null) {
              return this.targetsView.populateAddresses(_.map(gon.host_ips, function(host_ip) {
                return host_ip.address;
              }));
            }
          });
          this.listenTo(this.targetsView, 'countTargets', function() {
            var Model, data, model;
            data = Backbone.Syphon.serialize(this._mainView);
            Model = Backbone.Model.extend({
              url: function() {
                return Routes.target_count_workspace_brute_force_guess_runs_path(WORKSPACE_ID);
              }
            });
            model = new Model(data);
            return model.save().done(this._updateTargetCount);
          });
          return this.listenTo(this.targetsView, 'targetCount:update', function() {
            return _this._toggleLaunch();
          });
        };

        Controller.prototype._listenToPayloadSettings = function() {
          return this.listenTo(this.optionsView, 'payloadSettings:show', function(event) {
            var _ref,
              _this = this;
            if ((_ref = this.payloadModel) == null) {
              this.payloadModel = App.request('shared:payloadSettings:entities', {});
            }
            if (event.view.isPayloadSettingsSelected()) {
              return App.execute('showModal', new Pro.Shared.PayloadSettings.Controller({
                model: this.payloadModel
              }), {
                modal: {
                  title: 'Payload Settings',
                  description: '',
                  width: 400,
                  height: 330
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
                closeCallback: function() {
                  if (!_this.payloadModel.get('validated')) {
                    return _this.optionsView.deselectPayload();
                  }
                },
                loading: true
              });
            }
          });
        };

        Controller.prototype._listenToMutationOptions = function() {
          return this.listenTo(this.optionsView, 'mutationOptions:show', function(event) {
            var _ref;
            if ((_ref = this.mutationModel) == null) {
              this.mutationModel = App.request('mutationOptions:entities', {});
            }
            if (event.view.isMutationCheckboxSelected()) {
              this.credsView.showMutationLabel();
              return App.execute('showModal', new Quick.MutationView({
                model: this.mutationModel
              }), {
                modal: {
                  title: 'Add Mutation Rules',
                  description: '',
                  width: 400,
                  height: 330
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
                loading: false
              });
            } else {
              return this.credsView.hideMutationLabel();
            }
          });
        };

        Controller.prototype._listenToCredsView = function() {
          var _this = this;
          this.listenTo(this.credsView, 'show', function() {
            this.file_input = App.request('file_input:component', {
              name: 'quick_bruteforce[file]'
            });
            this.listenTo(this.file_input._mainView, "file:changed", function(obj) {
              this.credsView.fileChanged();
              return this.credsView.showFileCancel(true);
            });
            this.listenTo(this.file_input._mainView, "show", function() {
              return this.credsView.bindUIElements();
            });
            return this.show(this.file_input, {
              region: this.credsView.fileUploadRegion
            });
          });
          this.listenTo(this.credsView, 'fileInput:clear', function() {
            this.file_input.clear();
            this.credsView.resetFileCount();
            return this.credsView.showFileCancel(false);
          });
          return this.listenTo(this.credsView, 'credCount:update', function() {
            return _this._toggleLaunch();
          });
        };

        Controller.prototype._updateTargetCount = function(response) {
          return this.targetsView.setTargetCount(response.count);
        };

        Controller.prototype._getComboCount = function() {
          return this.targetsView.targetCount * this.credsView.getComboCount();
        };

        Controller.prototype._getFactoryDefaults = function() {
          return this.targetsView.targetCount > 0 && this.credsView.factoryDefaultChecked();
        };

        Controller.prototype._showViews = function() {
          this.show(this.crumbsController, {
            region: this._mainView.breadcrumbRegion
          });
          this.show(this.targetsView, {
            region: this._mainView.targetsRegion
          });
          this.show(this.credsView, {
            region: this._mainView.credsRegion
          });
          return this.show(this.optionsView, {
            region: this._mainView.optionsRegion
          });
        };

        Controller.prototype._toggleLaunch = function() {
          if (this._getComboCount() > 0 || this._getFactoryDefaults()) {
            return this._mainView.enableLaunch();
          } else {
            return this._mainView.disableLaunch();
          }
        };

        return Controller;

      })(App.Controllers.Application);
    });
  });

}).call(this);
