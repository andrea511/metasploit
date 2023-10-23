(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/apps/backbone/views/app_tabbed_modal-47bc923af640493921da87e077e6e91f982f1e34a731bbf5c8ee2b73d047af83.js'], function($, AppTabbedModalView) {
    var DominoModalView;
    return DominoModalView = (function(_super) {
      var DOMINO_APP_URL, EMPTY_MESSAGE, HOSTS_URL, LOGINS_SUBURL, LOGINS_URL, SERVICES_SUBURL, SESSIONS_URL, TAGS_SUBURL;

      __extends(DominoModalView, _super);

      function DominoModalView() {
        this.close = __bind(this.close, this);

        this.submitUrl = __bind(this.submitUrl, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

        this.formOverrides = __bind(this.formOverrides, this);

        this.handleErrors = __bind(this.handleErrors, this);
        return DominoModalView.__super__.constructor.apply(this, arguments);
      }

      DominoModalView.WIDTH = 900;

      DOMINO_APP_URL = "/workspaces/" + WORKSPACE_ID + "/apps/domino/task_config/";

      HOSTS_URL = "" + DOMINO_APP_URL + "hosts_table.json";

      LOGINS_URL = "" + DOMINO_APP_URL + "logins_table.json";

      SESSIONS_URL = "" + DOMINO_APP_URL + "sessions_table.json";

      SERVICES_SUBURL = "" + DOMINO_APP_URL + "services_subtable.json";

      LOGINS_SUBURL = "" + DOMINO_APP_URL + "logins_subtable.json";

      TAGS_SUBURL = "" + DOMINO_APP_URL + "tags_subtable.json";

      EMPTY_MESSAGE = "No hosts were found with at least 1 session or login.";

      DominoModalView.prototype.events = _.extend({
        'change .termination-conditions input': 'terminationInputChanged',
        'keyup .termination-conditions input': 'terminationInputChanged',
        'change input#task_config_dynamic_stagers': 'changeDynamicStagers'
      }, AppTabbedModalView.prototype.events);

      DominoModalView.prototype.initialize = function() {
        DominoModalView.__super__.initialize.apply(this, arguments);
        this.setTitle('Credentials Domino');
        this.setDescription('Performs an iterative credentials-based attack against a set of targets ' + 'using a valid login or open session.');
        return this.setTabs([
          {
            name: 'Select Initial Host'
          }, {
            name: 'Scope'
          }, {
            name: 'Settings'
          }, {
            name: 'Generate Report',
            checkbox: true
          }
        ]);
      };

      DominoModalView.prototype.handleErrors = function(errorsHash) {
        var $page, $tab, modelErrors, _ref, _ref1;
        if ((errorsHash != null ? (_ref = errorsHash.errors) != null ? (_ref1 = _ref.task_config) != null ? _ref1.initial_attack : void 0 : void 0 : void 0) != null) {
          $tab = this.tabAt(0);
          $tab.find('.hasErrors').show();
          $page = this.pageAt(0);
          modelErrors = errorsHash.errors.task_config.initial_attack.join(", ");
          $page.find('p.inline-error').remove();
          $page.find('p.error-desc').remove();
          $page.prepend($('<p>').addClass('error-desc').text(modelErrors));
          delete errorsHash.errors.task_config.initial_attack;
        }
        return DominoModalView.__super__.handleErrors.apply(this, arguments);
      };

      DominoModalView.prototype.changeDynamicStagers = function(e) {
        if ($(e.target).prop('checked')) {
          return $('.dynamic_stagers_warning', this.el).removeClass('display-none');
        } else {
          return $('.dynamic_stagers_warning', this.el).addClass('display-none');
        }
      };

      DominoModalView.prototype.terminationInputChanged = function(_arg) {
        var target;
        target = _arg.target;
        return $(target).val($(target).val().replace(/[^\d]+/g, ''));
      };

      DominoModalView.prototype.formOverrides = function() {
        var _ref;
        return {
          'task_config[high_value_tags_string]': ((_ref = this.tagForm) != null ? _ref.tokenInput.val() : void 0) || ''
        };
      };

      DominoModalView.prototype.formLoadedSuccessfully = function(html) {
        var tabbedModal,
          _this = this;
        tabbedModal = this;
        return initProRequire(['base_layout', 'base_itemview', 'lib/components/table/table_controller', 'lib/components/table/cell_views', 'lib/components/tags/new/new_controller', 'lib/shared/creds/cell_views', 'lib/components/filter/filter_controller'], function() {
          var TableLayout, initHost, initLogin, initSession;
          DominoModalView.__super__.formLoadedSuccessfully.call(_this, html);
          initHost = null;
          initLogin = null;
          initSession = null;
          _this.$el.find('label[for=task_config_high_value_hosts_string]').after($('<p />', {
            text: 'Enter IP range or address(es) of high value hosts.'
          }));
          _this.$el.find('label[for=task_config_high_value_tags_string]').after($('<p />', {
            text: 'Enter the tags you applied to high value hosts.'
          }));
          _this.$el.find('a.back').click(function() {
            tabbedModal.$el.find('#domino-hosts-table').show();
            tabbedModal.$el.find('.drill-in').hide();
            tabbedModal.$el.find('.page.select_initial_host input:checked').prop('checked', false);
            initHost = null;
            initLogin = null;
            initSession = null;
            tabbedModal.$el.find('[name=saved_login_id]').val('');
            tabbedModal.$el.find('[name=saved_session_id]').val('');
            return tabbedModal.$el.find('[name=saved_host_id]').val('');
          });
          _this.$el.find('.select_initial_host .region').hide();
          _this.$el.find('.select_initial_host .tab-loading').show();
          _this.tagRegion = new Backbone.Marionette.Region({
            el: '#high_value_tags_region'
          });
          _this.tagForm = new Pro.Components.Tags.New.TagForm({
            model: new Backbone.Model,
            tokenValue: 'name'
          });
          _this.tagRegion.show(_this.tagForm);
          _this.$el.find('#add_tags').css({
            padding: 0
          });
          TableLayout = (function(_super1) {

            __extends(TableLayout, _super1);

            function TableLayout() {
              _this.onShow = __bind(_this.onShow, this);

              _this.val = __bind(_this.val, this);
              return TableLayout.__super__.constructor.apply(this, arguments);
            }

            TableLayout.prototype.regions = {
              tableRegion: '.table-region'
            };

            TableLayout.prototype.template = function() {
              return "<div class='table-region'></div>";
            };

            TableLayout.prototype.val = function(name, val) {
              if (val == null) {
                val = null;
              }
              if (val != null) {
                return tabbedModal.$el.find("[name='" + name + "']").first().val(val);
              } else {
                return tabbedModal.$el.find("[name='" + name + "']").first().val();
              }
            };

            TableLayout.prototype.onShow = function() {
              var Collection, View,
                _this = this;
              Collection = Backbone.Collection.extend({
                url: HOSTS_URL
              });
              this.table = Pro.request("table:component", {
                perPage: 10,
                region: this.tableRegion,
                selectable: false,
                title: 'Choose a host from the list below',
                collection: new Collection,
                tableEmptyView: View = (function(_super2) {

                  __extends(View, _super2);

                  function View() {
                    return View.__super__.constructor.apply(this, arguments);
                  }

                  View.prototype.template = function() {
                    return "<td colspan='100%'>" + EMPTY_MESSAGE + "</td>";
                  };

                  return View;

                })(Pro.Components.Table.Empty),
                columns: [
                  {
                    label: 'Host IP',
                    attribute: 'address',
                    "class": 'truncate',
                    view: View = (function(_super2) {

                      __extends(View, _super2);

                      function View() {
                        this.inputChanged = __bind(this.inputChanged, this);
                        return View.__super__.constructor.apply(this, arguments);
                      }

                      View.prototype.ui = {
                        input: 'input'
                      };

                      View.prototype.events = {
                        'change @ui.input': 'inputChanged'
                      };

                      View.prototype.inputChanged = function() {
                        var _ref;
                        this.model.selected = this.ui.input.is(':checked');
                        return (_ref = this.model.collection) != null ? _ref.trigger('inputChanged', this.model) : void 0;
                      };

                      View.prototype.template = function(m) {
                        return "<label><input type='radio' name='task_config[initial_host_id]' value='" + (_.escape(m.id)) + "' />" + (_.escape(m.address)) + "</label>";
                      };

                      return View;

                    })(Pro.Views.ItemView)
                  }, {
                    label: 'Host Name',
                    attribute: 'name',
                    view: Pro.Components.Table.CellViews.TruncateView({
                      max: 14,
                      attribute: 'name'
                    })
                  }, {
                    label: 'OS',
                    attribute: 'os_name',
                    "class": 'truncate'
                  }, {
                    label: 'Services',
                    attribute: 'services_count',
                    view: Pro.Creds.CellViews.Count,
                    viewOpts: {
                      attribute: 'services_count',
                      subject: 'service'
                    },
                    hoverView: Pro.Creds.CellViews.CollectionHover.extend({
                      attributes: {
                        style: 'width: 260px; margin-left:-50%;'
                      },
                      url: function() {
                        return SERVICES_SUBURL + '?host_id=' + this.model.get('id');
                      },
                      columns: [
                        {
                          label: 'Service',
                          size: 8,
                          attribute: 'name'
                        }, {
                          label: 'Port',
                          size: 4,
                          attribute: 'port'
                        }
                      ]
                    }),
                    hoverOn: function() {
                      return parseInt(this.model.get('services_count'), 10) > 0;
                    }
                  }, {
                    label: 'Logins',
                    attribute: 'logins_count',
                    view: Pro.Creds.CellViews.Count,
                    viewOpts: {
                      attribute: 'logins_count',
                      subject: 'login'
                    },
                    hoverView: Pro.Creds.CellViews.CollectionHover.extend({
                      attributes: {
                        style: 'width: 260px; margin-left:-60%;'
                      },
                      url: function() {
                        return LOGINS_SUBURL + '?host_id=' + this.model.get('id');
                      },
                      columns: [
                        {
                          label: 'Public',
                          size: 6,
                          attribute: 'public'
                        }, {
                          label: 'Private',
                          size: 6,
                          attribute: 'private'
                        }
                      ]
                    }),
                    hoverOn: function() {
                      return parseInt(this.model.get('logins_count'), 10) > 0;
                    }
                  }, {
                    label: 'Sessions',
                    attribute: 'sessions_count',
                    view: Pro.Creds.CellViews.Count,
                    viewOpts: {
                      attribute: 'sessions_count',
                      subject: 'session',
                      link: false
                    }
                  }, {
                    label: 'Tags',
                    attribute: 'tags_count',
                    view: Pro.Creds.CellViews.Count,
                    viewOpts: {
                      attribute: 'tags_count',
                      subject: 'tag'
                    },
                    hoverView: Pro.Creds.CellViews.CollectionHover.extend({
                      attributes: {
                        style: 'width: 100px; margin-left:-70%;'
                      },
                      url: function() {
                        return TAGS_SUBURL + '?host_id=' + this.model.get('id');
                      },
                      columns: [
                        {
                          label: 'Name',
                          size: 12,
                          attribute: 'name'
                        }
                      ]
                    }),
                    hoverOn: function() {
                      return parseInt(this.model.get('tags_count'), 10) > 0;
                    }
                  }
                ],
                filterOpts: {
                  filterValuesEndpoint: window.gon.filter_values_apps_domino_task_config_index_path,
                  helpEndpoint: window.gon.search_operators_apps_domino_task_config_index_path,
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
              initHost = this.val('saved_host_id');
              initLogin = this.val('saved_login_id');
              initSession = this.val('saved_session_id');
              this.tabbedModalLoaded = false;
              if (!_.isBlank(initHost)) {
                _.defer(function() {
                  return _this.table.collection.trigger('inputChanged', {
                    id: initHost
                  });
                });
              } else {
                $(this.el).trigger('tabbed-modal-loaded');
                this.tabbedModalLoaded = true;
              }
              return this.listenTo(this.table.collection, 'inputChanged', function(m) {
                var checked, done, loginURL, sessionChecked, sessionURL, toggleOr, val, _ref, _ref1, _ref2;
                Collection = Backbone.Collection.extend({
                  url: HOSTS_URL + '?id=' + m.id
                });
                tabbedModal.$el.find('#domino-hosts-table').hide();
                tabbedModal.$el.find('.drill-in').show();
                _this.val('saved_host_id', m.id);
                if ((_ref = _this.drillRegion) == null) {
                  _this.drillRegion = new Backbone.Marionette.Region({
                    el: '#domino-metamodule-modal .selected-host-table'
                  });
                }
                _this.drillTable = Pro.request("table:component", {
                  perPage: 10,
                  region: _this.drillRegion,
                  selectable: false,
                  collection: new Collection,
                  columns: [
                    {
                      label: 'Host IP',
                      attribute: 'address',
                      "class": 'truncate',
                      view: View = (function(_super2) {

                        __extends(View, _super2);

                        function View() {
                          _this.inputChanged = __bind(_this.inputChanged, this);
                          return View.__super__.constructor.apply(this, arguments);
                        }

                        View.prototype.ui = {
                          input: 'input'
                        };

                        View.prototype.events = {
                          'change @ui.input': 'inputChanged'
                        };

                        View.prototype.inputChanged = function() {
                          var _ref1;
                          this.model.selected = this.ui.input.is(':checked');
                          return (_ref1 = this.model.collection) != null ? _ref1.trigger('inputChanged', this.model) : void 0;
                        };

                        View.prototype.template = function(m) {
                          return "<label><input type='radio' name='task_config[initial_host_id]' value='" + m.id + "' checked />" + (_.escape(m.address)) + "</label>";
                        };

                        return View;

                      })(Pro.Views.ItemView)
                    }, {
                      label: 'Host Name',
                      attribute: 'name',
                      "class": 'truncate'
                    }, {
                      label: 'OS',
                      attribute: 'os_name',
                      "class": 'truncate'
                    }, {
                      label: 'Services',
                      attribute: 'services_count'
                    }, {
                      label: 'Logins',
                      attribute: 'logins_count'
                    }, {
                      label: 'Sessions',
                      attribute: 'sessions_count'
                    }, {
                      label: 'Tags',
                      attribute: 'tags_count'
                    }
                  ]
                });
                _this.listenTo(_this.drillTable.collection, 'inputChanged', function(m) {
                  tabbedModal.$el.find('task_config[initial_login_id]:checked').prop('checked', false);
                  return tabbedModal.$el.find('task_config[initial_session_id]:checked').prop('checked', false);
                });
                if ((_ref1 = _this.loginsRegion) == null) {
                  _this.loginsRegion = new Backbone.Marionette.Region({
                    el: '#domino-metamodule-modal .logins-table'
                  });
                }
                if ((_ref2 = _this.sessionsRegion) == null) {
                  _this.sessionsRegion = new Backbone.Marionette.Region({
                    el: '#domino-metamodule-modal .sessions-table'
                  });
                }
                _this.loginsRegion.$el.toggle(!_.isBlank(initLogin) && _.isBlank(initSession));
                _this.sessionsRegion.$el.toggle(_.isBlank(initLogin) && !_.isBlank(initSession));
                loginURL = LOGINS_URL + '?host_id=' + m.id;
                if (!_.isBlank(initLogin)) {
                  loginURL = LOGINS_URL + '?id=' + initLogin;
                }
                checked = _.isBlank(initLogin) ? '' : 'checked';
                val = _this.val;
                _this.loginsTable = Pro.request("table:component", {
                  perPage: 10,
                  region: _this.loginsRegion,
                  selectable: false,
                  collection: new (Backbone.Collection.extend({
                    url: loginURL
                  })),
                  columns: [
                    {
                      label: 'Public',
                      attribute: 'public',
                      "class": 'truncate',
                      view: View = (function(_super2) {

                        __extends(View, _super2);

                        function View() {
                          _this.inputChanged = __bind(_this.inputChanged, this);
                          return View.__super__.constructor.apply(this, arguments);
                        }

                        View.prototype.ui = {
                          input: 'input'
                        };

                        View.prototype.events = {
                          'change @ui.input': 'inputChanged'
                        };

                        View.prototype.inputChanged = function(e) {
                          tabbedModal.$el.find('[name="task_config[initial_session_id]"]:checked').prop('checked', false);
                          val('saved_login_id', $(e.target).val());
                          return val('saved_session_id', '');
                        };

                        View.prototype.template = function(m) {
                          return "<label><input name='task_config[initial_login_id]' type='radio' " + checked + " value='" + (_.escape(m.login_id)) + "' />" + (_.escape(m["public"])) + "</label>";
                        };

                        return View;

                      })(Pro.Views.ItemView)
                    }, {
                      label: 'Private',
                      attribute: 'private',
                      "class": 'truncate'
                    }, {
                      label: 'Realm',
                      attribute: 'realm_key',
                      view: Pro.Creds.CellViews.Realm,
                      hoverView: Pro.Creds.CellViews.RealmHover,
                      hoverOn: function() {
                        return !_.isEmpty(this.model.get('realm'));
                      }
                    }, {
                      label: 'Service',
                      attribute: 'service_name'
                    }, {
                      label: 'Port',
                      attribute: 'service_port'
                    }
                  ]
                });
                done = 0;
                toggleOr = function() {
                  done++;
                  if (_this.loginsTable.collection.models.length > 0 && _this.sessionsTable.collection.models.length > 0) {
                    tabbedModal.$el.find('.or').show();
                  }
                  if (done >= 2) {
                    if (!_this.tabbedModalLoaded) {
                      $(_this.el).trigger('tabbed-modal-loaded');
                    }
                    _this.tabbedModalLoaded = true;
                    if (_this.loginsTable.collection.models.length === 0 && !_.isBlank(initLogin)) {
                      tabbedModal.$el.find('a.back').click();
                    }
                    if (_this.sessionsTable.collection.models.length === 0 && !_.isBlank(initSession)) {
                      return tabbedModal.$el.find('a.back').click();
                    }
                  }
                };
                _this.listenTo(_this.loginsTable.collection, 'sync', function() {
                  tabbedModal.$el.find('.select_initial_host .tab-loading').hide();
                  if (_this.loginsTable.collection.models.length > 0) {
                    _this.loginsRegion.$el.show();
                  }
                  return toggleOr();
                });
                _this.listenTo(_this.drillTable.collection, 'sync', function() {
                  if (_this.drillTable.collection.models.length === 0 && !_.isBlank(initHost)) {
                    return tabbedModal.$el.find('a.back').click();
                  }
                });
                sessionURL = SESSIONS_URL + '?host_id=' + m.id;
                sessionChecked = '';
                if (!_.isBlank(initSession)) {
                  sessionURL = SESSIONS_URL + '?id=' + initSession;
                  sessionChecked = 'checked';
                }
                _this.sessionsTable = Pro.request("table:component", {
                  perPage: 10,
                  region: _this.sessionsRegion,
                  selectable: false,
                  collection: new (Backbone.Collection.extend({
                    url: sessionURL
                  })),
                  columns: [
                    {
                      label: 'Sessions',
                      attribute: 'id',
                      view: View = (function(_super2) {

                        __extends(View, _super2);

                        function View() {
                          _this.inputChanged = __bind(_this.inputChanged, this);
                          return View.__super__.constructor.apply(this, arguments);
                        }

                        View.prototype.ui = {
                          input: 'input'
                        };

                        View.prototype.events = {
                          'change @ui.input': 'inputChanged'
                        };

                        View.prototype.inputChanged = function(e) {
                          tabbedModal.$el.find('[name="task_config[initial_login_id]"]:checked').prop('checked', false);
                          val('saved_session_id', $(e.target).val());
                          return val('saved_login_id', '');
                        };

                        View.prototype.template = function(m) {
                          return "<label><input name='task_config[initial_session_id]' type='radio' " + sessionChecked + " value='" + (_.escape(m.id)) + "'/>Session " + (_.escape(m.id)) + "</label>";
                        };

                        return View;

                      })(Pro.Views.ItemView)
                    }
                  ]
                });
                return _this.listenTo(_this.sessionsTable.collection, 'sync', function() {
                  tabbedModal.$el.find('.select_initial_host .tab-loading').hide();
                  if (_this.sessionsTable.collection.models.length > 0) {
                    _this.sessionsRegion.$el.show();
                  }
                  return toggleOr();
                });
              });
            };

            return TableLayout;

          })(Pro.Views.Layout);
          _this.region = new Backbone.Marionette.Region({
            el: '#domino-hosts-table'
          });
          _this.region.show(new TableLayout());
          return _.delay(function() {
            return tabbedModal.$el.click();
          });
        });
      };

      DominoModalView.prototype.submitUrl = function() {
        return DOMINO_APP_URL;
      };

      DominoModalView.prototype.close = function() {
        var _ref, _ref1, _ref2, _ref3, _ref4;
        DominoModalView.__super__.close.apply(this, arguments);
        if ((_ref = this.tagRegion) != null) {
          if (typeof _ref.empty === "function") {
            _ref.empty();
          }
        }
        if ((_ref1 = this.region) != null) {
          if (typeof _ref1.empty === "function") {
            _ref1.empty();
          }
        }
        if ((_ref2 = this.drillRegion) != null) {
          if (typeof _ref2.empty === "function") {
            _ref2.empty();
          }
        }
        if ((_ref3 = this.loginsRegion) != null) {
          if (typeof _ref3.empty === "function") {
            _ref3.empty();
          }
        }
        return (_ref4 = this.sessionsRegion) != null ? typeof _ref4.empty === "function" ? _ref4.empty() : void 0 : void 0;
      };

      return DominoModalView;

    })(AppTabbedModalView);
  });

}).call(this);
