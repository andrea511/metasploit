(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/apps/backbone/views/app_tabbed_modal-47bc923af640493921da87e077e6e91f982f1e34a731bbf5c8ee2b73d047af83.js', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js'], function($, AppTabbedModalView, m) {
    var SSH_KEY_APP_TABLE_URL, SSH_KEY_APP_URL, SshKeyModalView, TRUNCATE_KEY_LEN;
    SSH_KEY_APP_URL = "/workspaces/" + WORKSPACE_ID + "/apps/ssh_key/task_config/";
    SSH_KEY_APP_TABLE_URL = "" + SSH_KEY_APP_URL + "show_ssh_keys.json";
    TRUNCATE_KEY_LEN = 150;
    return SshKeyModalView = (function(_super) {

      __extends(SshKeyModalView, _super);

      function SshKeyModalView() {
        this.chosenRow = __bind(this.chosenRow, this);

        this.manualMode = __bind(this.manualMode, this);

        this.rowClicked = __bind(this.rowClicked, this);

        this.credTypeChanged = __bind(this.credTypeChanged, this);

        this.submitUrl = __bind(this.submitUrl, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

        this.transformErrorData = __bind(this.transformErrorData, this);

        this.formOverrides = __bind(this.formOverrides, this);
        return SshKeyModalView.__super__.constructor.apply(this, arguments);
      }

      SshKeyModalView.prototype.events = _.extend({
        'change #task_config_cred_type_input input': 'credTypeChanged',
        'click .stored tr': 'rowClicked'
      }, AppTabbedModalView.prototype.events);

      SshKeyModalView.prototype.initialize = function() {
        SshKeyModalView.__super__.initialize.apply(this, arguments);
        this.setTitle('SSH Key Testing');
        this.setDescription('Attempts to log in to systems on a target range with a recovered ' + 'private SSH key and reports the hosts that it was able to successfully ' + 'authenticate.');
        return this.setTabs([
          {
            name: 'Scope'
          }, {
            name: 'Credentials'
          }, {
            name: 'Generate Report',
            checkbox: true
          }
        ]);
      };

      SshKeyModalView.prototype.formOverrides = function($node) {
        var $row, overrides;
        if ($node == null) {
          $node = null;
        }
        overrides = {};
        if (!this.manualMode($node) && this.chosenRow($node).size()) {
          $row = this.chosenRow();
          $.extend(overrides, {
            '[ssh_username]': $($row.find('td')[1]).text(),
            '[password]': $($row.find('td')[2]).text(),
            '[key_file_content]': $($row.find('td')[3]).text(),
            '[core_id]': $row.find("td.id input").val()
          });
        }
        return overrides;
      };

      SshKeyModalView.prototype.transformErrorData = function(data) {
        var _ref, _ref1;
        if (((_ref = data.errors) != null ? (_ref1 = _ref.task_config) != null ? _ref1.core : void 0 : void 0) != null) {
          data.errors.task_config.cred_type = data.errors.task_config.core;
          delete data.errors.task_config.core;
        }
        return data;
      };

      SshKeyModalView.prototype.formLoadedSuccessfully = function(html) {
        var _this = this;
        SshKeyModalView.__super__.formLoadedSuccessfully.apply(this, arguments);
        this.credTypeChanged();
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
              user: {
                sClass: 'username'
              },
              pass: {
                name: 'SSH Key',
                sClass: 'key_file_stored',
                fnRender: function(o) {
                  var short, title, _ref;
                  if (((_ref = o.aData.pass) != null ? _ref.length : void 0) > TRUNCATE_KEY_LEN) {
                    short = _.escape(o.aData.pass.slice(0, TRUNCATE_KEY_LEN)) + "&hellip;";
                    title = _.escape(o.aData.pass);
                    return "<span title='" + title + "'>" + short + "</span>";
                  } else {
                    return o.aData.pass;
                  }
                }
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
              sAjaxSource: SSH_KEY_APP_TABLE_URL,
              oLanguage: {
                sEmptyTable: "No SSH keys were found in this workspace."
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

      SshKeyModalView.prototype.submitUrl = function() {
        return SSH_KEY_APP_URL;
      };

      SshKeyModalView.prototype.credTypeChanged = function(e) {
        $('.advanced.user_supplied', this.$modal).toggle(this.manualMode());
        return $('.advanced.stored', this.$modal).toggle(!this.manualMode());
      };

      SshKeyModalView.prototype.rowClicked = function(e) {
        return $(e.currentTarget).find('input[type=radio]').prop('checked', true);
      };

      SshKeyModalView.prototype.manualMode = function($node) {
        if ($node == null) {
          $node = null;
        }
        $node = $node != null ? $node : this.$modal;
        return !$('#task_config_cred_type_stored', $node).is(':checked');
      };

      SshKeyModalView.prototype.chosenRow = function($node) {
        if ($node == null) {
          $node = null;
        }
        $node = $node != null ? $node : this.$modal;
        return $('.stored.advanced input[type=radio]:checked', $node).parents('tr').first();
      };

      SshKeyModalView.prototype.setHiddenCred = function(form) {
        var radio_input, ssh_key;
        ssh_key = $('[name="password"]', this.el).val();
        radio_input = "<div class=\"hidden_cred\">\n  <div>Last Selected Cred</div>\n  <table class=\"list\">\n    <tr>\n      <th>Public</th>\n      <th>Private</th>\n    </tr>\n    <tr class=\"odd\">\n      <td class=\"id\" style=\"display:none;\"><input type=\"radio\" name=\"cred-datatable\" checked=\"checked\" value=\"" + (_.escape(form['core_id'])) + "\"></td>\n      <td class=\"username sorting_1\">" + (_.escape(form['ssh_username'])) + "</td>\n      <td class=\"key_file_content\">" + (_.escape(form['key_file_content']) || _.escape(ssh_key)) + "</td>\n    </tr>\n  </table>\n</div>";
        return $('.stored.advanced', this.el).prepend(radio_input);
      };

      SshKeyModalView.prototype.removeHiddenCred = function() {
        return $('.hidden_cred', this.el).remove();
      };

      return SshKeyModalView;

    })(AppTabbedModalView);
  });

}).call(this);
