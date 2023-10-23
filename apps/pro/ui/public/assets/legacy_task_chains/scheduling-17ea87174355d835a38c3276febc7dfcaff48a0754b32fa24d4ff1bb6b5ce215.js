(function() {

  jQuery(function($) {
    return $(document).ready(function() {
      var CredManager, Scheduler;
      window.CredManager = CredManager = (function() {

        function CredManager() {}

        CredManager.upload = function($dialog) {
          var $form;
          $form = $dialog.find('form');
          $form.iframePostForm({
            post: function() {
              return $form.siblings('.cred-uploader-status').css('visibility', 'visible');
            },
            complete: function(response) {
              $form.siblings('.cred-uploader-status').css('visibility', 'hidden');
              if (response.indexOf('class="errors"') > 0) {
                return $form.before(response);
              } else {
                $('.creds-table').remove();
                $('.creds-table-target').append(response);
                return $dialog.dialog('close');
              }
            }
          });
          return $form.submit();
        };

        CredManager.buttons = {
          manage: {
            bind: function() {
              return $('.control-bar').find('span.button a.new').live('click', function(e) {
                $('#cred-uploader-form').clone().dialog({
                  title: "Upload Credential File",
                  width: 500,
                  buttons: {
                    "Upload": function() {
                      return CredManager.upload($(this));
                    }
                  }
                });
                return e.preventDefault();
              });
            }
          }
        };

        CredManager.bind = function() {
          var binding, button, _ref, _results;
          _ref = CredManager.buttons;
          _results = [];
          for (button in _ref) {
            binding = _ref[button];
            _results.push(binding.bind());
          }
          return _results;
        };

        return CredManager;

      }).call(this);
      window.Scheduler = Scheduler = (function() {
        var isFutureSchedule, oneMinuteBeforeMidnight;

        function Scheduler() {}

        Scheduler.setup = function() {
          var $scheduler, date, defaultOptions;
          $scheduler = $("div.task-chain-schedule");
          Scheduler.displaySelected();
          defaultOptions = {
            ampm: true
          };
          $scheduler.find('#task-once-datetime').datetimepicker(defaultOptions);
          $scheduler.find('#task-daily-time').timepicker(defaultOptions);
          $scheduler.find('#task-weekly-time').timepicker(defaultOptions);
          $scheduler.find('#task-monthly-time').timepicker(defaultOptions);
          date = oneMinuteBeforeMidnight();
          $scheduler.find('#task-once-datetime').datetimepicker("setDate", date);
          $scheduler.find('#task-daily-time').timepicker("setDate", date);
          $scheduler.find('#task-weekly-time').timepicker("setDate", date);
          return $scheduler.find('#task-monthly-time').timepicker("setDate", date);
        };

        $('div#scheduler-options').hide();

        Scheduler.displaySelected = function() {
          var $scheduler;
          $scheduler = $("div.task-chain-schedule");
          $scheduler.find('.task-options').hide();
          return $scheduler.find(".task-options." + ($('#task-frequency').val())).show();
        };

        Scheduler.behaviors = {
          now_or_later: {
            bind: function() {
              return $('input.type-picker').click(function(e) {
                var val;
                val = $(this).val();
                if (val === "manual") {
                  $('div#scheduler-options').hide();
                }
                if (val === "now") {
                  $('div#scheduler-options').hide();
                }
                if (val === "future") {
                  return $('div#scheduler-options').show();
                }
              });
            }
          },
          frequency: {
            bind: function() {
              return $('#task-frequency').change(function(e) {
                return Scheduler.displaySelected();
              });
            }
          },
          monthlyInterval: {
            bind: function() {
              return $('#task-monthly-interval').change(function(e) {
                if ($(this).val() === "day") {
                  $('#task-monthly-day').show();
                  return $('#task-monthly-day-of-week').hide();
                } else {
                  $('#task-monthly-day').hide();
                  return $('#task-monthly-day-of-week').show();
                }
              });
            }
          }
        };

        Scheduler.isMissingDate = function() {
          var blank_date, frequency, not_checked;
          if (isFutureSchedule()) {
            frequency = $("#task-frequency").val();
            if (frequency === "once") {
              return $('#task-once-datetime').val() === "";
            }
            if (frequency === "daily") {
              return $("input[name='schedule_recurrence[daily][time]']").val() === "";
            }
            if (frequency === "weekly") {
              not_checked = !$("input[name='schedule_recurrence[weekly][days][]']").is(":checked");
              blank_date = $("input[name='schedule_recurrence[weekly][time]']").val() === "";
              return not_checked || blank_date;
            }
          }
          return false;
        };

        isFutureSchedule = function() {
          var schedule_type;
          schedule_type = $("input[name = 'schedule_type']:checked").val();
          return schedule_type === "future";
        };

        oneMinuteBeforeMidnight = function() {
          var date;
          date = new Date();
          date.setHours(23);
          date.setMinutes(59);
          return date;
        };

        Scheduler.bind = function() {
          var behavior, binding, _ref;
          _ref = Scheduler.behaviors;
          for (behavior in _ref) {
            binding = _ref[behavior];
            binding.bind();
          }
          return Scheduler.setup();
        };

        return Scheduler;

      }).call(this);
      CredManager.bind();
      return Scheduler.bind();
    });
  });

}).call(this);
