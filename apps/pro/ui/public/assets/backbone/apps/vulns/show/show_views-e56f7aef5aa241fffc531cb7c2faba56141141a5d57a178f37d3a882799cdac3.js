(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['lib/utilities/dom/has_overflowed_height', 'base_layout', 'base_view', 'base_itemview', 'apps/vulns/show/templates/show_layout', 'apps/vulns/show/templates/header', 'apps/vulns/show/templates/exploit_button', 'apps/vulns/show/templates/overview_tab', 'apps/vulns/show/templates/description', 'apps/vulns/show/templates/related_modules_tab', 'apps/vulns/show/templates/related_hosts_tab', 'lib/components/filter/filter_controller', 'apps/vulns/show/templates/host', 'apps/vulns/show/templates/platform', 'apps/vulns/show/templates/push_validation_confirmation_view', 'apps/vulns/show/templates/push_exception_confirmation_view', 'apps/vulns/show/templates/push_buttons', 'apps/vulns/show/templates/comment_view', 'apps/vulns/show/components/vuln_attempt_status_pill/vuln_attempt_status_pill_controller', 'entities/vuln_history', 'entities/related_modules', 'entities/related_hosts', 'entities/vuln_history', 'entities/related_modules', 'entities/nexpose/validation', 'entities/nexpose/exception', 'entities/note', 'lib/components/table/table_controller', 'lib/components/pill/pill_controller', 'lib/components/stars/stars_controller', 'lib/components/os/os_controller', 'lib/components/tabs/tabs_controller', 'lib/shared/cve_cell/cve_cell_controller', 'lib/components/tags/index/index_controller', 'lib/concerns/pollable', 'entities/task'], function() {
    return this.Pro.module("VulnsApp.Show", function(Show, App) {
      Show.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('vulns/show/show_layout');

        Layout.prototype.className = 'vuln-show-container';

        Layout.prototype.regions = {
          headerRegion: '.header-region',
          contentRegion: '.tab-content-region',
          pushButtonsRegion: '.push-buttons-region'
        };

        return Layout;

      })(App.Views.Layout);
      Show.Header = (function(_super) {

        __extends(Header, _super);

        function Header() {
          this.onRender = __bind(this.onRender, this);
          return Header.__super__.constructor.apply(this, arguments);
        }

        Header.prototype.template = Header.prototype.templatePath('vulns/show/header');

        Header.prototype.ui = {
          refs: '.refs',
          more: 'a.more',
          vulnEdit: '.vuln-name a.pencil',
          refEdit: '.vuln-refs a.pencil'
        };

        Header.prototype.triggers = {
          'click @ui.vulnEdit': 'vuln:edit',
          'click @ui.refEdit': 'ref:edit',
          'click @ui.more': 'ref:more'
        };

        Header.prototype.modelEvents = {
          'change': 'render'
        };

        Header.prototype.onRender = function() {
          var _this = this;
          return _.defer(function() {
            if (_this.ui.refs.hasOverflowedHeight()) {
              return _this.ui.more.show();
            }
          });
        };

        return Header;

      })(App.Views.ItemView);
      Show.PushButtons = (function(_super) {

        __extends(PushButtons, _super);

        function PushButtons() {
          return PushButtons.__super__.constructor.apply(this, arguments);
        }

        PushButtons.prototype.template = PushButtons.prototype.templatePath('vulns/show/push_buttons');

        PushButtons.prototype.ui = {
          nexposeBtn: 'a.nexpose',
          notExploitable: '.not-exploitable',
          notExploitableCheckBox: '[name="not_exploitable"]'
        };

        PushButtons.prototype.triggers = {
          'click @ui.nexposeBtn': 'nexpose:push'
        };

        PushButtons.prototype.events = {
          'change @ui.notExploitable': '_toggleExploitable'
        };

        PushButtons.prototype.modelEvents = {
          'change:markable': 'render',
          'change:not_exploitable': 'render',
          'change:not_pushable_reason': 'render'
        };

        PushButtons.prototype._toggleExploitable = function() {
          return this.trigger('vuln:not:exploitable', this.ui.notExploitableCheckBox.prop('checked'));
        };

        return PushButtons;

      })(App.Views.ItemView);
      Show.Description = (function(_super) {

        __extends(Description, _super);

        function Description() {
          return Description.__super__.constructor.apply(this, arguments);
        }

        Description.prototype.template = Description.prototype.templatePath('vulns/show/description');

        Description.prototype.defaults = function() {
          return {
            runModuleText: false
          };
        };

        Description.prototype.initialize = function(opts) {
          var config, runModuleText, vuln;
          config = _.defaults(opts, this._getDefaults());
          runModuleText = config.runModuleText, vuln = config.vuln;
          this.model.set('runModuleText', runModuleText);
          return this.model.set('vuln', vuln);
        };

        return Description;

      })(App.Views.ItemView);
      Show.RelatedModulesTab = (function(_super) {

        __extends(RelatedModulesTab, _super);

        function RelatedModulesTab() {
          return RelatedModulesTab.__super__.constructor.apply(this, arguments);
        }

        RelatedModulesTab.prototype.template = RelatedModulesTab.prototype.templatePath('vulns/show/related_modules_tab');

        RelatedModulesTab.prototype.initialize = function(opts) {
          return this.model = opts.model, opts;
        };

        RelatedModulesTab.prototype.regions = {
          relatedModulesRegion: '.related-modules-region'
        };

        RelatedModulesTab.prototype.onShow = function() {
          return this.renderRelatedModulesTable();
        };

        RelatedModulesTab.prototype.renderRelatedModulesTable = function() {
          var collection, columns;
          collection = App.request('relatedModules:entities', {
            workspace_id: WORKSPACE_ID,
            vuln_id: VULN_ID
          });
          columns = [
            {
              label: 'Module Type',
              attribute: 'mtype',
              render: function() {
                return _.escape(_.str.capitalize(this.model.get('mtype')));
              }
            }, {
              label: 'Platform',
              attribute: 'module_icons',
              view: Pro.Components.Os.Controller,
              sortable: false
            }, {
              label: 'Module',
              attribute: 'description',
              view: Show.Description,
              viewOpts: {
                vuln: this.model
              }
            }, {
              label: 'Ranking',
              attribute: 'rating',
              sortAttribute: 'rank',
              view: Pro.Components.Stars.Controller
            }, {
              label: 'References',
              attribute: 'references',
              view: Pro.Shared.CveCell.Controller,
              sortAttribute: 'ref_count'
            }, {
              label: 'Action',
              sortable: false,
              attribute: 'action',
              view: Show.ExploitButton,
              viewOpts: {
                vuln: this.model
              }
            }
          ];
          return App.request("table:component", {
            region: this.relatedModulesRegion,
            "static": false,
            collection: collection,
            perPage: 20,
            columns: columns
          });
        };

        return RelatedModulesTab;

      })(App.Views.Layout);
      Show.ExploitButton = (function(_super) {

        __extends(ExploitButton, _super);

        function ExploitButton() {
          return ExploitButton.__super__.constructor.apply(this, arguments);
        }

        ExploitButton.prototype.template = ExploitButton.prototype.templatePath('vulns/show/exploit_button');

        ExploitButton.prototype.initialize = function(opts) {
          return this.vuln = opts.vuln, opts;
        };

        ExploitButton.prototype.events = {
          'click input': 'redirectToModule'
        };

        ExploitButton.prototype.redirectToModule = function() {
          var target_host, url;
          target_host = this.vuln.get('host').address;
          url = "" + (Routes.new_module_run_path(WORKSPACE_ID)) + "/" + (this.model.get('module')) + "?target_host=" + target_host;
          return window.location.href = url;
        };

        return ExploitButton;

      })(App.Views.ItemView);
      Show.CommentView = (function(_super) {

        __extends(CommentView, _super);

        function CommentView() {
          return CommentView.__super__.constructor.apply(this, arguments);
        }

        CommentView.prototype.template = CommentView.prototype.templatePath('vulns/show/comment_view');

        CommentView.prototype.className = 'comment-view';

        CommentView.prototype.ui = {
          comment: 'textarea',
          error: '.error'
        };

        CommentView.prototype.triggers = {
          'mouseout @ui.comment': 'center'
        };

        CommentView.prototype.getComment = function() {
          return this.ui.comment.val();
        };

        CommentView.prototype.onFormSubmit = function() {
          var commentModel, defer,
            _this = this;
          defer = $.Deferred();
          defer.promise();
          commentModel = App.request('new:note:entity', {
            data: {
              comment: this.ui.comment.val()
            },
            workspace_id: WORKSPACE_ID,
            type: 'Mdm::Vuln',
            type_id: VULN_ID
          });
          commentModel.save({}, {
            success: function(model) {
              return defer.resolve();
            },
            error: function(model, response) {
              _this.ui.error.html(response.responseJSON.error.data[0]);
              return _this.ui.error.show();
            }
          });
          return defer;
        };

        return CommentView;

      })(App.Views.Layout);
      Show.OverviewTab = (function(_super) {

        __extends(OverviewTab, _super);

        function OverviewTab() {
          return OverviewTab.__super__.constructor.apply(this, arguments);
        }

        OverviewTab.prototype.template = OverviewTab.prototype.templatePath('vulns/show/overview_tab');

        OverviewTab.prototype.className = 'foundation overview-tab';

        OverviewTab.prototype.regions = {
          overviewRegion: '.overview-region'
        };

        OverviewTab.prototype.modelEvents = {
          'change:new_vuln_attempt_status': 'refreshTable',
          'change:restore_vuln_attempt_status': 'refreshTable'
        };

        OverviewTab.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          return this.model.set('buttomMoreAssetTag', '<img class="btn more-text" src="/assets/icons/buttom_more-7136ef601f6f896bafce9a49dd2841ecc0be81984871cf677951f03acebb21c9.svg" />');
        };

        OverviewTab.prototype.refreshTable = function(model, value, options) {
          if (value == null) {
            return this.table.refresh();
          }
        };

        OverviewTab.prototype.ui = {
          commentBtn: 'img.btn.more-text',
          commentInput: 'textarea#comments',
          error: '.error'
        };

        OverviewTab.prototype.events = {
          'click @ui.commentBtn': '_commentModal',
          'focusout @ui.commentInput': '_saveComment'
        };

        OverviewTab.prototype._commentModal = function() {
          var commentView, data, model,
            _this = this;
          data = Backbone.Syphon.serialize(this);
          _.extend(data, {
            workspace_id: WORKSPACE_ID,
            type: 'Mdm::Vuln',
            type_id: VULN_ID
          });
          model = App.request('new:note:entity', data);
          commentView = new Show.CommentView({
            model: model
          });
          return App.execute('showModal', commentView, {
            modal: {
              title: 'Comment',
              description: '',
              width: 300
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
              _this.model.set('notes', [
                {
                  comment: commentView.getComment()
                }
              ]);
              return _this._setComment(commentView.getComment());
            }
          });
        };

        OverviewTab.prototype._setComment = function(comment) {
          return this.ui.commentInput.val(comment);
        };

        OverviewTab.prototype._saveComment = function() {
          var commentModel,
            _this = this;
          commentModel = App.request('new:note:entity', {
            data: {
              comment: this.ui.commentInput.val()
            },
            workspace_id: WORKSPACE_ID,
            type: 'Mdm::Vuln',
            type_id: VULN_ID
          });
          return commentModel.save({}, {
            success: function(model) {
              _this.model.set('notes', [
                {
                  comment: model.get('data').comment
                }
              ]);
              _this.ui.error.html();
              return _this.ui.error.hide();
            },
            error: function(model, response) {
              _this.ui.error.html(response.responseJSON.error.data[0]);
              return _this.ui.error.show();
            }
          });
        };

        OverviewTab.prototype.onShow = function() {
          return this.renderOverviewTable();
        };

        OverviewTab.prototype.renderOverviewTable = function() {
          var collection, columns;
          collection = App.request('vulnHistory:entities', {
            workspace_id: WORKSPACE_ID,
            vuln_id: VULN_ID
          });
          columns = [
            {
              label: 'Action',
              attribute: 'action',
              sortable: false
            }, {
              label: 'Description',
              attribute: 'description',
              view: Show.Description,
              viewOpts: {
                runModuleText: true,
                vuln: this.model
              }
            }, {
              label: 'Status',
              attribute: 'status',
              sortable: false,
              view: Pro.Components.VulnAttemptStatusPill.Controller
            }, {
              label: 'User',
              attribute: 'username'
            }, {
              label: 'Time',
              attribute: 'attempted_at',
              sortAttribute: 'vuln_attempts.attempted_at'
            }
          ];
          return this.table = App.request("table:component", {
            region: this.overviewRegion,
            "static": false,
            collection: collection,
            perPage: 20,
            columns: columns,
            filterable: false
          });
        };

        return OverviewTab;

      })(App.Views.Layout);
      Show.Platform = (function(_super) {

        __extends(Platform, _super);

        function Platform() {
          return Platform.__super__.constructor.apply(this, arguments);
        }

        Platform.prototype.template = Platform.prototype.templatePath('vulns/show/platform');

        Platform.prototype.className = 'icon-logo';

        return Platform;

      })(App.Views.ItemView);
      Show.Host = (function(_super) {

        __extends(Host, _super);

        function Host() {
          return Host.__super__.constructor.apply(this, arguments);
        }

        Host.prototype.template = Host.prototype.templatePath('vulns/show/host');

        return Host;

      })(App.Views.ItemView);
      Show.RelatedHostsTab = (function(_super) {

        __extends(RelatedHostsTab, _super);

        function RelatedHostsTab() {
          return RelatedHostsTab.__super__.constructor.apply(this, arguments);
        }

        RelatedHostsTab.prototype.template = RelatedHostsTab.prototype.templatePath('vulns/show/related_hosts_tab');

        RelatedHostsTab.prototype.className = 'foundation related-hosts-tab';

        RelatedHostsTab.prototype.regions = {
          relatedHostsRegion: '.related-hosts-region'
        };

        RelatedHostsTab.prototype.onShow = function() {
          return this.renderRelatedHostsTable();
        };

        RelatedHostsTab.prototype.renderRelatedHostsTable = function() {
          var collection, columns;
          collection = App.request('relatedHosts:entities', {
            workspace_id: WORKSPACE_ID,
            vuln_id: VULN_ID
          });
          columns = [
            {
              label: 'Host IP',
              attribute: 'address',
              view: Show.Host
            }, {
              label: 'Host Name',
              attribute: 'name'
            }, {
              label: 'Platform',
              attribute: 'os_name',
              view: Show.Platform
            }, {
              label: 'Tags',
              attribute: 'tags',
              view: App.request('tags:index:component')
            }, {
              label: 'Vuln Status',
              attribute: 'vuln_attempt_status',
              sortable: false,
              view: Pro.Components.VulnAttemptStatusPill.Controller
            }, {
              label: "Host Status",
              attribute: 'status',
              view: Pro.Components.Pill.Controller
            }
          ];
          return this.table = App.request('table:component', {
            region: this.relatedHostsRegion,
            "static": false,
            collection: collection,
            columns: columns,
            filterOpts: {
              filterValuesEndpoint: Routes.related_hosts_filter_values_workspace_vuln_path(WORKSPACE_ID, VULN_ID),
              helpEndpoint: Routes.search_operators_workspace_vuln_path(WORKSPACE_ID, VULN_ID),
              keys: [
                {
                  label: 'host.address',
                  value: 'address'
                }, {
                  label: 'host.name',
                  value: 'name'
                }, {
                  label: 'host.os_name',
                  value: 'os_name'
                }
              ]
            }
          });
        };

        return RelatedHostsTab;

      })(App.Views.Layout);
      Show.PushExceptionConfirmationView = (function(_super) {

        __extends(PushExceptionConfirmationView, _super);

        function PushExceptionConfirmationView() {
          this.poll = __bind(this.poll, this);
          return PushExceptionConfirmationView.__super__.constructor.apply(this, arguments);
        }

        PushExceptionConfirmationView.include("Pollable");

        PushExceptionConfirmationView.prototype.template = PushExceptionConfirmationView.prototype.templatePath('vulns/show/push_exception_confirmation_view');

        PushExceptionConfirmationView.prototype.className = 'push-exception-confirmation-view';

        PushExceptionConfirmationView.prototype.ui = {
          processing: '.processing',
          errorState: '.error-state',
          message: '.msg',
          datetime: '.datetime',
          form: 'form'
        };

        PushExceptionConfirmationView.prototype.pollInterval = 3000;

        PushExceptionConfirmationView.prototype.initialize = function() {
          var comment, _ref, _ref1;
          comment = (_ref = this.model.get('notes')) != null ? (_ref1 = _ref[0]) != null ? _ref1.comment : void 0 : void 0;
          return this.model = App.request('new:nexpose:exception:entity', {
            vuln_id: VULN_ID,
            workspace_id: WORKSPACE_ID,
            comments: comment
          });
        };

        PushExceptionConfirmationView.prototype.poll = function() {
          var _this = this;
          if (this.task.isCompleted()) {
            this.model.fetch({
              success: function(model, response) {
                if (response[0].sent_to_nexpose) {
                  return _this.formDefer.resolve();
                } else {
                  return _this._setErrorState(response[0].nexpose_response);
                }
              }
            });
            _.defer(this.stopPolling, this.pollInterval);
          }
          return this.task.fetch();
        };

        PushExceptionConfirmationView.prototype._setErrorState = function(msg) {
          this.ui.form.removeClass('disabled');
          this.ui.processing.hide();
          this.ui.errorState.html(msg);
          this.ui.errorState.show();
          return this.trigger("btn:enable:modal", "Yes");
        };

        PushExceptionConfirmationView.prototype._hideErrorState = function() {
          this.ui.errorState.html();
          return this.ui.errorState.hide();
        };

        PushExceptionConfirmationView.prototype.onShow = function() {
          return this.ui.datetime.datepicker({
            minDate: 1
          });
        };

        PushExceptionConfirmationView.prototype.onBeforeDestroy = function() {
          return this.ui.datetime.datepicker('destroy');
        };

        PushExceptionConfirmationView.prototype.onFormSubmit = function() {
          var formData,
            _this = this;
          this.formDefer = $.Deferred();
          this.formDefer.promise();
          this._hideErrorState();
          this.trigger("btn:disable:modal", "Yes");
          this.ui.form.addClass('disabled');
          formData = Backbone.Syphon.serialize(this);
          this.model.save(formData, {
            success: function(model, response) {
              _this.ui.processing.show();
              _this.task = new App.Entities.Task({
                id: response.task_id,
                workspace_id: WORKSPACE_ID
              });
              return _this.startPolling();
            },
            error: function(model, response) {
              return _this._setErrorState();
            }
          });
          return this.formDefer;
        };

        return PushExceptionConfirmationView;

      })(App.Views.ItemView);
      return Show.PushValidationConfirmationView = (function(_super) {

        __extends(PushValidationConfirmationView, _super);

        function PushValidationConfirmationView() {
          this.poll = __bind(this.poll, this);
          return PushValidationConfirmationView.__super__.constructor.apply(this, arguments);
        }

        PushValidationConfirmationView.include("Pollable");

        PushValidationConfirmationView.prototype.template = PushValidationConfirmationView.prototype.templatePath('vulns/show/push_validation_confirmation_view');

        PushValidationConfirmationView.prototype.className = 'push-validation-confirmation-view';

        PushValidationConfirmationView.prototype.ui = {
          processing: '.processing',
          errorState: '.error-state',
          message: '.msg'
        };

        PushValidationConfirmationView.prototype.pollInterval = 3000;

        PushValidationConfirmationView.prototype.initialize = function() {
          return this.model = App.request('new:nexpose:validation:entity', {
            vuln_id: VULN_ID,
            workspace_id: WORKSPACE_ID
          });
        };

        PushValidationConfirmationView.prototype.poll = function() {
          var _this = this;
          if (this.task.isCompleted()) {
            this.model.fetch({
              success: function(model, response) {
                if (response[0].sent_to_nexpose) {
                  return _this.formDefer.resolve();
                } else {
                  return _this._setErrorState(response[0].nexpose_response);
                }
              }
            });
            _.defer(this.stopPolling, this.pollInterval);
          }
          return this.task.fetch();
        };

        PushValidationConfirmationView.prototype.onFormSubmit = function() {
          var _this = this;
          this.formDefer = $.Deferred();
          this.formDefer.promise();
          this.trigger("btn:disable:modal", "Yes");
          this.model.save({}, {
            success: function(model, response) {
              _this.ui.processing.show();
              _this._hideErrorState();
              _this.task = new App.Entities.Task({
                id: response.task_id,
                workspace_id: WORKSPACE_ID
              });
              return _this.startPolling();
            },
            error: function(model, response) {
              return _this._setErrorState();
            }
          });
          return this.formDefer;
        };

        PushValidationConfirmationView.prototype._setErrorState = function(msg) {
          this.ui.processing.hide();
          this.ui.errorState.html(msg);
          this.ui.errorState.show();
          return this.trigger("btn:enable:modal", "Yes");
        };

        PushValidationConfirmationView.prototype._hideErrorState = function() {
          this.ui.errorState.html();
          return this.ui.errorState.hide();
        };

        return PushValidationConfirmationView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
