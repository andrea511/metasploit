# ModuleSearch: provides a nice state manager for inserting
# the module search into your form. 
# 
#  ===== Constructor =====
#  new ModuleSearch $('div\#my_module_container',
#                      workspace: 1     all hash values optional
#                     modulePath: '/auxiliary/blah/module'
#                    moduleTitle: 'Newest module exploit'
#                     extraQuery: 'app:client'
#                     fileFormat: false
#           hiddenInputContainer: $('div#my_hidden_module_container')
#                  paramWrapName: 'social_engineering_web_page'
#                   moduleConfig: JS object containing previous inputs
#                    configSaved: function(success) { 'config saved!' }
#                     hideSearch: false
#
#  hiddenInputContainer: optional div inside formto contain hidden inputs.
#                        If missing, a new div will be appended to @ele
#                          Useful if you want to have multiple ModuleSearch
#                        objects, but only the most recently saved set of 
#                        config inputs gets submitted.
#  moduleConfig: to pass a config input from a Rails controller, spit out the 
#    *_config blob as JSON into a metadata tag in the HTML. Grab this element,
#    parse it, and then pass it into ModuleSearch constructor
#
#
#  ===== Methods =====
#    m = new ModuleSearch $('.eleblah'), opts
#    m.loadModuleModalConfig()  # loads the modal config for the current @modulePath/@moduleTitle
#    m.loadmoduleSearch('joe')  # AJAXily load the module search div (happens automatically unless @hideSearch)
#    m.activate()   # if multiple ModuleSearch instances share one hiddenInputContainer,
#                   # then bring the current ModuleSearch to the front
#    m.currentlyLoaded()        # returns true or false, depending on contents of hiddenInputContainer

INPUTS_TO_HIDE = [ 
                   'module_run_task[options][SRVHOST]', 
                   'module_run_task[options][URIPATH]', 
                   'module_run_task[options][SRVPORT]', 
                   'module_run_task[options][FILENAME]' 
                 ]

FF_ELEMENTS_TO_REMOVE = [ # list of selectors to remove on fileformat modal
                          'h3:contains(Target Systems)+table'
                          'h3:contains(Target Systems)'
                        ]

jQuery ($) ->
  $ ->
    # required by /workspaces/#id/module
    window.moduleLinksInit = (moduleRunPathFragment) ->
      onclick = (event) -> return true if $(this).attr('href') isnt "#"
      $('a.module-name').unbind 'click.moduleLinksInit'
      $('a.module-name').bind 'click.moduleLinksInit', onclick

    # add sorting function for star columns
    $.fn.dataTableExt.oSort['star-asc']  = (a,b) ->
      (a.match(/img/g)||[]).length - (b.match(/img/g)||[]).length
    $.fn.dataTableExt.oSort['star-desc']  = (a,b) ->
      $.fn.dataTableExt.oSort['star-asc'](b,a)

    window.ModuleSearch = class ModuleSearch
      constructor: (ele, opts) ->
        @ele = $(ele)
        @workspace = opts['workspace'] || 1
        @modulePath =  opts['modulePath'] || ''
        @moduleTitle = opts['moduleTitle'] || ''
        @extraQuery = opts['extraQuery']
        @extraQuery = 'app:client' if @extraQuery == undefined
        @fileFormat = opts['fileFormat'] || false
        @hiddenInputContainer = opts['hiddenInputContainer']
        @paramWrapName = opts['paramWrapName'] || 'social_engineering_web_page'
        @hideSearch = opts['hideSearch'] || false
        if !@hiddenInputContainer
          @hiddenInputContainer = @ele.parent().append('<div class="hiddenInputContainer"></div>')
            .children().last().hide()
        @moduleConfig = opts['moduleConfig'] || false
        @modal = null
        @configSavedCallback = opts['configSavedCallback'] || (->)
        # add some inner structure to the class
        @ele.html('<div class="selected"></div><div class="load">'+
          '<div style="position:relative;top: 5px;text-align:center;">Initializing module cache</div>'+
          '<div class="tab-loading"></div></div>')
        # add initial @moduleConfig to @hiddenInputContainer as inputs
        if @moduleConfig
          for own k, v of @convertToQueryFormat(@moduleConfig)
            newName = "#{@paramWrapName}[exploit_module_config#{k}]"
            @hiddenInputContainer.append $('<input type="hidden">').attr(name: newName, value: v)
          @hiddenInputContainer.append $('<input type="hidden">').attr(name: "#{@paramWrapName}[exploit_module_path]", value: @modulePath)
          @hiddenInputContainer.append $('<input type="hidden">').attr(name: 'modulePath', value: @modulePath)
          @oldHTML = @hiddenInputContainer.html()
        if @hideSearch then $(">.load", @ele).hide() else @loadModuleSearch('')
        @refreshTitleBar()

      # format input field names from modal form to campaign form
      formatName: (name) ->
        name = name.replace 'module_run_task', 'exploit_module_config'
        switch name
          when "modulePath" then name = 'exploit_module_path'
        "#{@paramWrapName}[#{name}]"

      # load module partial via ajax and dump into @ele
      loadModuleSearch: (query, cb) ->
        path = "/workspaces/#{@workspace}/modules"
        args = _nl: "1", q: query, extra_query: @extraQuery, file_format: (@fileFormat || ''), straight: 'true'
        $.ajax path, type: "POST", data: args, success: (data, status) =>
          $(">.load", @ele).html(data) # stuff data into the div
          # remove some random stuff in the module search
          $(".searchform~*", @ele).remove()
          $(".searchform", @ele).parent().contents().last().remove()
          # ajaxify search field
          $(".searchform", @ele).submit =>
            $box = $(".searchform input[type=text]#q", @ele)
            $box.blur().attr('disabled', 'disabled').addClass('loading')
            @loadModuleSearch $('input[name=q]', @ele).val(), ->
              $box.removeAttr('disabled').removeClass('loading')
            false
          # add click handler to links in module search results
          that = this
          $('input#q').change (e) ->
            that.loadModuleSearch($(this).val())
          $('a.module-name', @ele).click (e) ->
            mp = $(this).attr('module_fullname')
            mt = $(this).text()
            that.loadModuleModalConfig(mp, mt)
            false
          # convert header links to plaintext
          $("table.module_list th a", @ele).each ->
            $(this).before($(this).html())
            $(this).remove()
          # add some data tables magick
          $("table.module_list", @ele).addClass('sortable').dataTable
            oLanguage:
              sEmptyTable:    "No matching Modules found."
            sDom: 'ft<"list-table-footer clearfix"ip <"sel" l>>r'
            sPaginationType: 'r7Style'
            bFilter: false
            aaSorting: [ [4, 'desc'] ]
            aoColumns: [ {}, {}, {}, {}, { sType: 'star' }, {}, {}, {}, {} ]
          cb() if cb

      # grab form data from modal config and save it into hiddenInputContainer
      saveFromModal: ->
        SKIP_NAMES = ["utf8", "authenticity_token", "_method", "moduleName", "selected_action"]
        @hiddenInputContainer.html('')
        @modulePath = @modulePath_ || @modulePath
        @moduleTitle = @moduleTitle_ || @moduleTitle
        @modulePath_ = @moduleTitle_ = null
        @modal.find('input, textarea, select').each (index, element) =>
          for skip in SKIP_NAMES
            return if skip == $(element).attr('name')
          currentName = @formatName $(element).attr('name')
          val = $(element).val()
          if $(element).attr('type') == 'checkbox'
            val = 'checked'
            return unless $(element).attr('checked')

          #Skip radio buttons that are not selected
          if $(element).attr('type') == 'radio' & !$(element).prop('checked')
            return

          $input = $('<input type="hidden">').attr
            name:  currentName
            value: $(element).val()
          @hiddenInputContainer.append $input
        $input = $('<input type="hidden">').attr
          name:  'modulePath'
          value: @modulePath
        @hiddenInputContainer.append $input
        @oldHTML = @hiddenInputContainer.html()

      # options to pass into jQuery UI modal
      moduleModalOptions: ->
        return {
          width: 980
          height: 600 
          autoOpen: false
          modal: true
          draggable: false
          resizable: false
          title: "Configure Module"
          buttons:
            [
              {
                text: "Cancel"
                click: => 
                  @modal.data('save', 'false')
                  @modal.dialog('close')
                  @configSavedCallback.call(@, false)
              },
              {
                text: "OK"
                click: => # called when OK is clicked on modal
                    # append all contents of the form to the current web page
                  @saveFromModal()
                  @refreshTitleBar()
                  @modal.data('save', 'true')
                  @modal.dialog('close')
              }
            ]
          close: =>
            # unless @modal.data('save') # user exited with ESC, cancel, or close btn
            #if type == 'bap' || type == 'java_signed_applet'
            #  $('option', $inputs).removeAttr('selected')
            #  $('option', $inputs).first().attr('selected', 'true')
            #  $inputs.first().change()
            @modal.remove()
            @configSavedCallback(@modal.data('save') == 'true')
        }

      # converts e.g. params[blah][blah] to "blah[blah]" for input names
      # TODO: regex loop is shitty. refactor this.
      convertToQueryFormat: (hash) ->
        out = {}
        p = $.param(hash)
        pl     = /\+/g
        search = /([^&=]+)=?([^&]*)/g
        decode = (s) -> decodeURIComponent(s.replace(pl, ' '))
        while match = search.exec(p)
          left = decode(match[1])
          if match2 = left.match /(.*)?\[.*\]/
            left = left.replace /^[^\[]*/, "[#{match2[1]}]"
          else
            left = "[#{left}]"
          out[left] = decode(match[2]) 
        out

      refreshTitleBar: ->
        if @moduleTitle && @moduleTitle.length > 0
          html = "<div class='module-path'><span class='gt'>&gt;</span><span class='rest'>#{@moduleTitle}</div> <a href='#'>Edit Config</a></span>"
        else 
          html = "<div class='module-path'><div>No exploit module chosen. Choose a module from the form below.</div></div>"
        $(".selected", @ele).filter(':visible').html(html)
        $a = $(".selected>a", @ele).filter(':visible')
        $a.click (e) => @loadModuleModalConfig()

      # show modal of module config
      loadModuleModalConfig: (mp, mt) ->
        mp ||= @modulePath
        mt ||= @moduleTitle
        @modal = $("<div class='module-config'></div>")
        path = "/workspaces/#{@workspace}/tasks/new_module_run/#{mp}"
        args = _nl: "1", allow_ff: (if @fileFormat then "true" else "false")
        $.get path, args, (data) =>
          $data = $(data)
          formPath        = $data.find('form').attr('action')
          subString       = "/workspaces/#{@workspace}/tasks/start_module_run/"
          mp              = formPath.replace(subString, "")
          alteredData     = $data.attr('id', '')
          alteredData.find('form').append("<input type='hidden' name='modulePath' value=\"#{mp}\" />")
          alteredData.find('form').append("<input type='hidden' name='moduleName' value=\"#{mt}\" />")
          alteredData.find("input[name='#{n}']").parents('tr').remove() for n in INPUTS_TO_HIDE
          alteredData.find(sel).remove() for sel in FF_ELEMENTS_TO_REMOVE
          # replace values of input, textarea, and select if necessar
          alteredData.find('input[type=checkbox]').removeAttr('checked')
          # prefill form
          that = this
          if @hiddenInputContainer.find('[name=modulePath]').val() == mp
            alteredData.find('input, textarea').each ->
              name = that.formatName $(this).attr('name')
              $node =  $("input[name='#{name}']", @hiddenInputContainer)
              v = $node.val()

              #If restoring radio button, else skip
              if $(this).attr("type") == "radio"
                if $(this).val() == $node.val()
                  $(this).prop("checked",true)
                else
                  return

              $(this).val(v) if v

              if $(this).attr('type') == 'checkbox'
                if v then $(this).attr('checked', 'true') else $(this).removeAttr('checked')
            alteredData.find('select').each ->
              name = that.formatName $(this).attr('name')
              v = $("input[name='#{name}']", @hiddenInputContainer).val()
              $('option', $(this)).removeAttr('selected')
              $('option', $(this)).each ->
                $(this).attr('selected', true) if $(this).val() == v
          @modal.html $(alteredData)
          @modulePath_ = mp
          @moduleTitle_ = mt   # save the selected module, assign after user clicks 'Save'
          @modal.dialog @moduleModalOptions()
          @modal.dialog('open')

      # activate() loads the ModuleSearch's config options into @hiddenInputContainer
      # good if you have multiple interdependent ModuleSearches
      activate: -> @hiddenInputContainer.html(@oldHTML) if @oldHTML

      # check if this ModuleSearch instance is currently saved in @hiddenInputContainer
      currentlyLoaded: -> $("[name=\'#{@paramWrapName}[exploit_module_path]\']", @hiddenInputContainer).val() == @modulePath
