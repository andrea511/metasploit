(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/apps/app_stat_modal_header-cc639f0eb63defd381c4e5788940c1ed01f3f1d20667db8980c8c3f70510b9bd.js'], function($, Template) {
    var AppStatModalHeader, PUSH_VALIDATION_URL, VALIDATION_POLL_INTERVAL;
    PUSH_VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/nexpose/result/push_validations.json";
    VALIDATION_POLL_INTERVAL = 500;
    return AppStatModalHeader = (function(_super) {

      __extends(AppStatModalHeader, _super);

      function AppStatModalHeader() {
        this.startPollingValidationRun = __bind(this.startPollingValidationRun, this);

        this.pushValidationsClicked = __bind(this.pushValidationsClicked, this);

        this.serializeData = __bind(this.serializeData, this);

        this.initialize = __bind(this.initialize, this);
        return AppStatModalHeader.__super__.constructor.apply(this, arguments);
      }

      AppStatModalHeader.prototype.initialize = function(_arg) {
        this.appRun = _arg.appRun;
        return this.appRun.bind('change', this.render);
      };

      AppStatModalHeader.prototype.events = {
        'click @ui.pushButton': 'pushValidationsClicked'
      };

      AppStatModalHeader.prototype.ui = {
        pushButton: 'span.push_exceptions'
      };

      AppStatModalHeader.prototype.template = HandlebarsTemplates['apps/app_stat_modal_header'];

      AppStatModalHeader.prototype.stopSubmitting = function() {
        return this.ui.pushButton.removeClass('submitting disabled');
      };

      AppStatModalHeader.prototype.serializeData = function() {
        var stats,
          _this = this;
        stats = this.appRun.runStatHash();
        initProRequire(['entities/vuln'], function() {
          var all_vulns;
          all_vulns = Pro.request('vulns:entities');
          return all_vulns.on("sync", function(x, y) {
            var showButton, showItem;
            stats = _this.appRun.runStatHash();
            showItem = stats.vuln_exceptions + stats.vuln_validations > 0;
            showButton = y.length === _this.appRun.runStatHash()['vulns_found'];
            if (showItem && showButton) {
              _this.ui.pushButton.addClass('btn');
              return _this.ui.pushButton.append('<a class="nexpose" href="javascript:void(0)">Push To Nexpose</a>');
            } else if (showItem && !showButton) {
              return _this.ui.pushButton.append("<a href='../vulns/'>Go to Vulnerabilites Index</a>");
            } else {
              return _this.ui.pushButton.empty();
            }
          });
        });
        return _.extend({
          showPushLink: true
        }, this, {
          stats: stats
        });
      };

      AppStatModalHeader.prototype.pushValidationsClicked = function(e) {
        var $link,
          _this = this;
        e.preventDefault();
        $link = $(e.currentTarget);
        if ($link.is('.disabled')) {
          return;
        }
        $link.addClass('disabled submitting');
        return initProRequire(['lib/shared/nexpose_push/nexpose_push_controllers'], function() {
          var deselectedIDs, request_message, selectAllState, selectedIDs, selectedVisibleCollection, tableCollection;
          selectAllState = selectedIDs = deselectedIDs = selectedVisibleCollection = tableCollection = null;
          request_message = jQuery.ajax({
            url: Routes.push_to_nexpose_message_workspace_vulns_path({
              workspace_id: WORKSPACE_ID
            }),
            type: 'GET',
            data: {
              vv_run: true,
              selections: {
                select_all_state: selectAllState || null,
                selected_ids: selectedIDs || [],
                deselected_ids: deselectedIDs || [],
                ignore_pagination: true
              }
            }
          });
          return request_message.then(function(data) {
            var controller, opts;
            opts = {
              message: data.message,
              has_console: data.has_console,
              has_console_enabled: data.has_console_enabled,
              has_validations: data.has_validations,
              has_exceptions: data.has_exceptions,
              selectAllState: true,
              selectedIDs: data.selected_ids || [],
              deselectedIDs: data.deselected_ids || [],
              redirectToTaskLog: false
            };
            controller = new Pro.Shared.NexposePush.ModalController(opts);
            _this.listenTo(controller, "modal:close", _this.stopSubmitting);
            return controller.showModal();
          });
        });
      };

      AppStatModalHeader.prototype.startPollingValidationRun = function(taskId) {
        var done, poll, url,
          _this = this;
        done = false;
        url = "/workspaces/" + WORKSPACE_ID + "/tasks/" + taskId + ".json";
        poll = function() {
          return $.ajax({
            url: url,
            success: function(taskJson) {
              var $failed, $succeeded, img;
              if (taskJson.completed_at != null) {
                done = true;
                if ((taskJson.error != null) && taskJson.error.length > 0) {
                  img = '<img style="vertical-align: top;" src="/assets/icons/incomplete-50b39f1adc54caacb0b9a192d8035972748adeaaac4d109b588eceadf5252345.png" />';
                  $failed = $('<span />');
                  $failed.css({
                    paddingRight: '10px',
                    verticalAlign: 'top'
                  });
                  $failed.html(img + (" Push failed. [<a style='vertical-align:top;' href='/workspaces/" + WORKSPACE_ID + "/tasks/" + taskId + "'>more...</a>]"));
                  return $('span.push_validations', _this.el).replaceWith($failed);
                } else {
                  '<img style="vertical-align: top;" src="/assets/icons/complete-3fe782422074a41c8756a60093ef7ae245e1050729528498081bd09d9699fe9c.png" />';

                  $succeeded = $('<span />');
                  $succeeded.css({
                    paddingRight: '10px',
                    verticalAlign: 'top'
                  });
                  $succeeded.html("" + img + " Push succeeded.");
                  return $('span.push_validations', _this.el).replaceWith($succeeded);
                }
              } else {
                if (!done) {
                  return setTimeout(poll, VALIDATION_POLL_INTERVAL);
                }
              }
            },
            error: function() {
              done = true;
              return $('span.push_validations a', _this.el).removeClass('disabled submitting');
            }
          });
        };
        return setTimeout(poll, VALIDATION_POLL_INTERVAL);
      };

      return AppStatModalHeader;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
