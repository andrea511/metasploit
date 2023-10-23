jQuery ($) ->
  $ ->
    window.HTMLCloner = class HTMLCloner
      constructor: (args) ->
        @origin    = args['origin']
        @success   = args['success']
        @error     = args['error']
        @redirects = []

      fixURL: (url) -> 
        return url if url.match /https:\/\//
        return 'http://'+url unless url.match /\w+:\/\//
        url

      cloneURL: (args) ->
        # reset redirects only when not calling 
        args[0]['value'] = @fixURL args[0]['value']
        $.ajax
          type: 'POST'
          url: @origin
          data: $.param(args)
          dataType: 'json'
          success: @success
          error: @error
