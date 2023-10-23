(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/apps/backbone/views/app_tabbed_modal-47bc923af640493921da87e077e6e91f982f1e34a731bbf5c8ee2b73d047af83.js', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js'], function($, AppTabbedModalView, m) {
    var PASS_THE_HASH_APP_TABLE_URL, PASS_THE_HASH_APP_URL, PassTheHashModalView, TRUNCATE_KEY_LEN;
    PASS_THE_HASH_APP_URL = "/workspaces/" + WORKSPACE_ID + "/apps/pass_the_hash/task_config/";
    PASS_THE_HASH_APP_TABLE_URL = "" + PASS_THE_HASH_APP_URL + "show_smb_hashes.json";
    TRUNCATE_KEY_LEN = 60;
    return PassTheHashModalView = (function(_super) {

      __extends(PassTheHashModalView, _super);

      function PassTheHashModalView() {
        this.manualMode = __bind(this.manualMode, this);

        this.chosenRow = __bind(this.chosenRow, this);

        this.rowClicked = __bind(this.rowClicked, this);

        this.credTypeChanged = __bind(this.credTypeChanged, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

        this.transformErrorData = __bind(this.transformErrorData, this);

        this.formOverrides = __bind(this.formOverrides, this);

        this.submitUrl = __bind(this.submitUrl, this);
        return PassTheHashModalView.__super__.constructor.apply(this, arguments);
      }

      PassTheHashModalView.prototype.events = _.extend({
        'change #task_config_cred_type_input input': 'credTypeChanged',
        'click .stored.advanced tr': 'rowClicked'
      }, AppTabbedModalView.prototype.events);

      PassTheHashModalView.prototype.initialize = function() {
        PassTheHashModalView.__super__.initialize.apply(this, arguments);
        this.setTitle('Pass The Hash');
        this.setDescription('Attempts to log in to systems with a recovered password hash ' + 'and user name and reports the hosts it was able to authenticate.');
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

      PassTheHashModalView.prototype.submitUrl = function() {
        return PASS_THE_HASH_APP_URL;
      };

      PassTheHashModalView.prototype.formOverrides = function($node) {
        var $row, overrides;
        if ($node == null) {
          $node = null;
        }
        overrides = {};
        if (!this.manualMode($node) && this.chosenRow($node).size()) {
          $row = this.chosenRow($node);
          $.extend(overrides, {
            '[realm]': $($row.find('td')[1]).text(),
            '[smb_username]': $($row.find('td')[2]).text(),
            '[hash]': $($row.find('td')[3]).text(),
            '[core_id]': $row.find("td.id input").val()
          });
        }
        return overrides;
      };

      PassTheHashModalView.prototype.transformErrorData = function(data) {
        var _ref, _ref1;
        if (((_ref = data.errors) != null ? (_ref1 = _ref.task_config) != null ? _ref1.core : void 0 : void 0) != null) {
          data.errors.task_config.cred_type = data.errors.task_config.core;
          delete data.errors.task_config.core;
        }
        return data;
      };

      PassTheHashModalView.prototype.formLoadedSuccessfully = function(html) {
        var _this = this;
        PassTheHashModalView.__super__.formLoadedSuccessfully.apply(this, arguments);
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
                sClass: 'hash',
                name: 'Hash',
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
                sType: 'title-string',
                name: 'Created',
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
              sAjaxSource: PASS_THE_HASH_APP_TABLE_URL,
              oLanguage: {
                sEmptyTable: "No replayable hashes were found in this workspace."
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

      PassTheHashModalView.prototype.credTypeChanged = function(e) {
        $('.advanced.user_supplied', this.$modal).toggle(this.manualMode());
        return $('.advanced.stored', this.$modal).toggle(!this.manualMode());
      };

      PassTheHashModalView.prototype.rowClicked = function(e) {
        return $(e.currentTarget).find('input[type=radio]').prop('checked', true);
      };

      PassTheHashModalView.prototype.chosenRow = function($node) {
        if ($node == null) {
          $node = null;
        }
        $node = $node != null ? $node : this.$modal;
        return $('.advanced.stored table input[type=radio]:checked', $node).parents('tr').first();
      };

      PassTheHashModalView.prototype.manualMode = function($node) {
        if ($node == null) {
          $node = null;
        }
        $node = $node != null ? $node : this.$modal;
        return !$('#task_config_cred_type_stored', $node).is(':checked');
      };

      PassTheHashModalView.prototype.setHiddenCred = function(form) {
        var radio_input;
        radio_input = "<div class=\"hidden_cred\">\n  <div>Last Selected Cred</div>\n  <table class=\"list\">\n    <tr>\n      <th>Realm</th>\n      <th>User</th>\n      <th>Hash</th>\n    </tr>\n    <tr class=\"odd\">\n      <td class=\"id\" style=\"display:none;\"><input type=\"radio\" name=\"cred-datatable\" checked=\"checked\" value=\"" + (_.escape(form['core_id'])) + "\"></td>\n      <td class=\"realm\">" + (_.escape(form['realm'])) + "</td>\n      <td class=\"username sorting_1\">" + (_.escape(form['smb_username'])) + "</td>\n      <td class=\"hash\">\n        <span title=\"" + (_.escape(form['hash'])) + "\">\n          " + (_.escape(form['hash'])) + "\n        </span>\n      </td>\n    </tr>\n  </table>\n</div>";
        return $('.stored.advanced', this.el).prepend(radio_input);
      };

      PassTheHashModalView.prototype.removeHiddenCred = function() {
        return $('.hidden_cred', this.el).remove();
      };

      return PassTheHashModalView;

    })(AppTabbedModalView);
  });

}).call(this);
