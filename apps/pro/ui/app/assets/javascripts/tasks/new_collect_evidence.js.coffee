jQuery ($) ->
  $(document).ready ->
    # On Collect Evidence page, disable subfields when "Collect other files" is unchecked
    setFileFieldState = ->
      if $('#collect_evidence_task_collect_files').prop 'checked'
        $('#collect_evidence_task_collect_files_pattern').removeAttr "disabled"
        $('#collect_evidence_task_collect_files_count').removeAttr "disabled"
        $('#collect_evidence_task_collect_files_size').removeAttr "disabled"
      else
        $('#collect_evidence_task_collect_files_pattern').attr "disabled", "disabled"
        $('#collect_evidence_task_collect_files_count').attr "disabled", "disabled"
        $('#collect_evidence_task_collect_files_size').attr "disabled", "disabled"

    setFileFieldState()

    $(document).on 'click', '#collect_evidence_task_collect_files', (e) ->
      setFileFieldState()

    $("#collect_all_sessions").checkAll $("#collect_sessions")
    $('#collect_all_sessions').trigger('click')