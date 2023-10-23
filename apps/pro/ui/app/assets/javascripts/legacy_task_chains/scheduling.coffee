jQuery ($) ->
  $(document).ready ->
    window.CredManager = class CredManager
      @upload: ($dialog) =>
        $form = $dialog.find('form')
        $form.iframePostForm
          post: ->
            $form.siblings('.cred-uploader-status').css('visibility', 'visible')
          complete: (response) ->
            $form.siblings('.cred-uploader-status').css('visibility', 'hidden')

            # If upload fails, display flash message.
            if response.indexOf('class="errors"') > 0
              $form.before response
            # Otherwise, update cred file inputs across entire view.
            else
              $('.creds-table').remove()
              $('.creds-table-target').append(response)
              $dialog.dialog('close')

        $form.submit()

      @buttons:
        manage:
          bind: ->
            $('.control-bar').find('span.button a.new').live 'click', (e) ->
              $('#cred-uploader-form').clone().dialog
                title: "Upload Credential File"
                width: 500
                buttons:
                  "Upload": ->
                    CredManager.upload $(this)
              e.preventDefault()

      @bind: =>
        binding.bind() for button, binding of @buttons

    window.Scheduler = class Scheduler
      # Initially sets the display of the scheduler.
      @setup: =>
        $scheduler = $("div.task-chain-schedule")
        @displaySelected()

        defaultOptions = ampm: true
        $scheduler.find('#task-once-datetime').datetimepicker defaultOptions
        $scheduler.find('#task-daily-time').timepicker defaultOptions
        $scheduler.find('#task-weekly-time').timepicker defaultOptions
        $scheduler.find('#task-monthly-time').timepicker defaultOptions

        date = oneMinuteBeforeMidnight()
        $scheduler.find('#task-once-datetime').datetimepicker("setDate", date)
        $scheduler.find('#task-daily-time').timepicker("setDate", date)
        $scheduler.find('#task-weekly-time').timepicker("setDate", date)
        $scheduler.find('#task-monthly-time').timepicker("setDate", date) 

      # Hides the scheduler stuff until you ask for it
      $('div#scheduler-options').hide()

      # Shows/hides options based on the selected schedule type.
      @displaySelected: ->
        $scheduler = $("div.task-chain-schedule")
        $scheduler.find('.task-options').hide()
        $scheduler.find(".task-options.#{$('#task-frequency').val()}").show()

      @behaviors:
        now_or_later:
          bind: ->
            $('input.type-picker').click (e) ->
              val = $(this).val()
              if val is "manual"
                $('div#scheduler-options').hide()
              if val is "now"
                $('div#scheduler-options').hide()
              if val is "future"
                $('div#scheduler-options').show()

        frequency:
          bind: ->
            $('#task-frequency').change (e) ->
              Scheduler.displaySelected()

        # Displays appropriate selection menus based on the selected
        # monthly interval type.
        monthlyInterval:
          bind: ->
            $('#task-monthly-interval').change (e) ->
              if $(this).val() == "day"
                $('#task-monthly-day').show()
                $('#task-monthly-day-of-week').hide()
              else
                $('#task-monthly-day').hide()
                $('#task-monthly-day-of-week').show()

      @isMissingDate: ->
        if isFutureSchedule()
          frequency =  $("#task-frequency").val()
          if frequency is "once"
            return $('#task-once-datetime').val() is "" 
          if frequency is "daily"
            return $("input[name='schedule_recurrence[daily][time]']").val() is ""
          if frequency is "weekly"
            not_checked = !$("input[name='schedule_recurrence[weekly][days][]']").is(":checked")
            blank_date = $("input[name='schedule_recurrence[weekly][time]']").val() is "" 
            return not_checked or blank_date
        false

      isFutureSchedule = ->
        schedule_type = $("input[name = 'schedule_type']:checked").val()
        schedule_type is "future"

      oneMinuteBeforeMidnight = ->
        date = new Date()
        date.setHours(23)
        date.setMinutes(59)
        date

      @bind: =>
        binding.bind() for behavior, binding of @behaviors
        @setup()

    CredManager.bind()
    Scheduler.bind()
