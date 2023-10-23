(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/apps/backbone/views/app_tabbed_modal-47bc923af640493921da87e077e6e91f982f1e34a731bbf5c8ee2b73d047af83.js', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js'], function($, AppTabbedModalView, m) {
    var SINGLE_PASSWORD_APP_TABLE_URL, SINGLE_PASSWORD_APP_URL, SinglePasswordModalView, TRUNCATE_KEY_LEN;
    SINGLE_PASSWORD_APP_URL = "/workspaces/" + WORKSPACE_ID + "/apps/single_password/task_config/";
    SINGLE_PASSWORD_APP_TABLE_URL = "" + SINGLE_PASSWORD_APP_URL + "show_creds.json";
    TRUNCATE_KEY_LEN = 150;
    return SinglePasswordModalView = (function(_super) {

      __extends(SinglePasswordModalView, _super);

      function SinglePasswordModalView() {
        this.manualMode = __bind(this.manualMode, this);

        this.chosenRow = __bind(this.chosenRow, this);

        this.rowClicked = __bind(this.rowClicked, this);

        this.credTypeChanged = __bind(this.credTypeChanged, this);

        this.submitUrl = __bind(this.submitUrl, this);

        this.loadTable = __bind(this.loadTable, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

        this.transformErrorData = __bind(this.transformErrorData, this);

        this.formOverrides = __bind(this.formOverrides, this);
        return SinglePasswordModalView.__super__.constructor.apply(this, arguments);
      }

      SinglePasswordModalView.prototype.events = _.extend({
        'change #task_config_cred_type_input input': 'credTypeChanged',
        'click .advanced.stored tr': 'rowClicked'
      }, AppTabbedModalView.prototype.events);

      SinglePasswordModalView.prototype.initialize = function() {
        SinglePasswordModalView.__super__.initialize.apply(this, arguments);
        this.setTitle('Single Credentials Testing');
        this.setDescription('Attempts to use a known credential pair to authenticate services ' + 'on a range of target hosts and reports the ones it was able to ' + 'authenticate.');
        return this.setTabs([
          {
            name: 'Scope'
          }, {
            name: 'Service and Ports'
          }, {
            name: 'Credentials'
          }, {
            name: 'Generate Report',
            checkbox: true
          }
        ]);
      };

      SinglePasswordModalView.prototype.formOverrides = function($node) {
        var $row, overrides;
        if ($node == null) {
          $node = null;
        }
        overrides = {};
        if (!this.manualMode($node) && this.chosenRow($node).size()) {
          $row = this.chosenRow($node);
          $.extend(overrides, {
            '[realm]': $($row.find('td')[1]).text(),
            '[auth_username]': $($row.find('td')[2]).text(),
            '[password]': $($row.find('td')[3]).text(),
            '[core_id]': $row.find("td.id input").val()
          });
        }
        return overrides;
      };

      SinglePasswordModalView.prototype.transformErrorData = function(data) {
        var _ref, _ref1, _ref2, _ref3;
        if (((_ref = data.errors) != null ? (_ref1 = _ref.task_config) != null ? _ref1.core : void 0 : void 0) != null) {
          data.errors.task_config.cred_type = data.errors.task_config.core;
          delete data.errors.task_config.core;
        }
        if (((_ref2 = data.errors) != null ? (_ref3 = _ref2.task_config) != null ? _ref3.services : void 0 : void 0) != null) {
          data.errors.services = data.errors.task_config.services;
          delete data.errors.task_config.services;
        }
        return data;
      };

      SinglePasswordModalView.prototype.formLoadedSuccessfully = function(html) {
        SinglePasswordModalView.__super__.formLoadedSuccessfully.apply(this, arguments);
        this.credTypeChanged();
        return this.loadTable();
      };

      SinglePasswordModalView.prototype.loadTable = function() {
        var _this = this;
        if (!this.cachedNode) {
          return helpers.loadRemoteTable({
            el: $('.advanced.stored', this.$modal),
            additionalCols: ["id"],
            columns: {
              id: {
                sClass: 'id',
                name: '',
                bSortable: false,
                mData: null,
                mDataProp: null,
                sWidth: "20px",
                fnRender: function(o) {
                  return "<input type='radio' name='cred-datatable' value='" + (_.escape(o.aData.id)) + "'/>";
                }
              },
              password: {
                sClass: "password",
                name: "Private",
                fnRender: function(o) {
                  var short, title, _ref;
                  if (((_ref = o.aData.password) != null ? _ref.length : void 0) > TRUNCATE_KEY_LEN) {
                    short = _.escape(o.aData.password.slice(0, TRUNCATE_KEY_LEN)) + "&hellip;";
                    title = _.escape(o.aData.password);
                    return "<span title='" + title + "'>" + short + "</span>";
                  } else {
                    return o.aData.password;
                  }
                }
              },
              username: {
                sClass: "username",
                name: "Public"
              },
              domain: {
                name: 'Realm'
              },
              created_at: {
                name: 'Created',
                sType: 'title-string',
                fnRender: function(o) {
                  var time, _ref;
                  time = (_ref = o.aData) != null ? _ref.created_at : void 0;
                  return "<span title='" + (_.escape(time)) + "'>" + (_.escape(moment(time).fromNow())) + "</span>";
                }
              }
            },
            dataTable: {
              aaSorting: [[1, "desc"]],
              bAutoWidth: true,
              sAjaxSource: SINGLE_PASSWORD_APP_TABLE_URL,
              oLanguage: {
                sEmptyTable: "No private credentials were found in this workspace."
              },
              fnInitComplete: function() {
                return $(_this.el).trigger('tabbed-modal-loaded');
              }
            }
          });
        } else {
          return $(this.el).trigger('tabbed-modal-loaded');
        }
      };

      SinglePasswordModalView.prototype.submitUrl = function() {
        return SINGLE_PASSWORD_APP_URL;
      };

      SinglePasswordModalView.prototype.credTypeChanged = function(e) {
        $('.advanced.user_supplied', this.$modal).toggle(this.manualMode());
        return $('.advanced.stored', this.$modal).toggle(!this.manualMode());
      };

      SinglePasswordModalView.prototype.rowClicked = function(e) {
        return $(e.currentTarget).find('input[type=radio]').prop('checked', true);
      };

      SinglePasswordModalView.prototype.chosenRow = function($node) {
        if ($node == null) {
          $node = null;
        }
        $node = $node != null ? $node : this.$modal;
        return $('.advanced.stored input[type=radio]:checked', $node).parents('tr').first();
      };

      SinglePasswordModalView.prototype.manualMode = function($node) {
        if ($node == null) {
          $node = null;
        }
        $node = $node != null ? $node : this.$modal;
        return !$('#task_config_cred_type_stored', $node).is(':checked');
      };

      SinglePasswordModalView.prototype.setHiddenCred = function(form) {
        var radio_input;
        radio_input = "<div class=\"hidden_cred\">\n  <div>Last Selected Cred</div>\n  <table class=\"list\">\n    <tr>\n      <th>Realm</th>\n      <th>Public</th>\n      <th>Private</th>\n    </tr>\n    <tr class=\"odd\">\n      <td style=\"display:none;\"><input type=\"radio\" name=\"cred-datatable\" checked=\"checked\"  value=\"" + (_.escape(form['core_id'])) + "\"></td>\n      <td class=\"realm\">" + (_.escape(form['realm'])) + "</td>\n      <td class=\"username sorting_1\">" + (_.escape(form['auth_username'])) + "</td>\n      <td class=\"password\">" + (_.escape(form['password'])) + "</td>\n    </tr>\n  </table>\n</div>";
        return $('.stored.advanced', this.el).prepend(radio_input);
      };

      SinglePasswordModalView.prototype.removeHiddenCred = function() {
        return $('.hidden_cred', this.el).remove();
      };

      return SinglePasswordModalView;

    })(AppTabbedModalView);
  });

}).call(this);
