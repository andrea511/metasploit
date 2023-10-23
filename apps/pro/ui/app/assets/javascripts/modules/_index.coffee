jQuery ($) ->
  window.moduleLinksInit=(moduleRunPathFragment) ->
      formId = "#new_module_run"

      $('a.module-name').click (event) ->
        if $(this).attr('href') isnt "#"
          return true
        else
          pathPiece = $(this).attr('module_fullname')
          modAction = "#{moduleRunPathFragment}/#{pathPiece}"
          theForm = $(formId)
          theForm.attr('action', modAction)
          theForm.submit()
          return false

  $(document).ready ->
    window.moduleLinksInit($("meta[name='msp:module_run_path']").attr('content'))
