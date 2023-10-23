jQueryInWindow ($) ->

  class @CampaignComponentsView extends Backbone.View
    initialize: (opts) ->
      @editing = false
      @campaignSummary = opts['campaignSummary']
      @currComponentType = 'email'
      _.bindAll(this, 'render', 'implicitlyCreateCampaign', 'toggleTray', 'renderComponentInModal')
      @campaignSummary.bind 'change:campaign_components change:config_type', @render
    template: _.template($('#campaign-components').html())

    baseURL: ->
      "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns/#{@campaignSummary.id}"

    implicitlyCreateCampaign: (e) ->
      # create campaign 
      if @campaignSummary.id == null
        e.stopImmediatePropagation()
        e.stopPropagation()
        e.preventDefault()
        data = $('form.social_engineering_campaign', @el).serialize()
        $(document).trigger('createCampaign', { data: data, callback: ->
          $(e.target).click()
        })

    openModalWindow: (url, cb=->) ->
      formViewClass = if @currComponentType == 'portable_file' then FormView else PaginatedFormView
      opts = {
        campaignSummary: @campaignSummary
        formQuery: @editFormQuery
        confirm: 'Are you sure you want to close? Your unsaved changes will be lost.'
        save: =>
          # send form request over ajax, termine results
          $form = $('form', @modal.el)
          Placeholders.submitHandler($form[0]) # resolve any placeholder polyfills from being submitted
          $('textarea.to-code-mirror', $form).trigger 'loadFromEditor'
          $form.trigger('syncWysiwyg')
        
          $.ajax(
            url: $form.attr('action'),
            type: $form.attr('method'),
            data: $form.serialize(),
            success: (data) => # data is the new CampaignSummary object
              @campaignSummary.set(data)
              @render()
              @modal.close(confirm: false)
            error: (response) =>
              $('.content-frame>.content', @modal.el).html(response.responseText)
              # determine what page the error occurred on
              $errs = $('p.inline-errors', @modal.el)
              $page = $errs.first().parents('.page>div.cell').first()
              pageIdx = $page.index()
             # @modal.initPage = pageIdx
              @renderComponentInModal()
              @modal.onLoad()
          )
      }
      if @currComponentType == 'portable_file'
        @modal = new FormView(opts)
      else if @currComponentType == 'email'
        @modal = new EmailFormView(opts)
      else if @currComponentType == 'web_page'
        @modal = new WebPageFormView(opts)
      @modal.load(url, cb)

    renderComponentInModal: ->
      if @currComponentType == 'web_page'
        window.renderCodeMirror()
        window.renderWebPageEdit()
        window.renderAttributeDropdown()
      else if @currComponentType == 'portable_file'
        window.renderPortableFileEdit()

    setCurrComponentType: (@currComponentType) ->
    setEditFormQuery: (@editFormQuery) ->

    calculateEditFormQuery: (name) ->
      return '' unless @campaignSummary.usesWizard()
      # campaign is using wizard, always hide component's name
      query = '?hide_name=true'
      query += "&init_name=#{name}" if name
      if @currComponentType == 'web_page' && name == encodeURIComponent('Landing Page')
        query += '&attack_type=phishing&disable_attack_type=true'
        query += '&show_only_custom_redirect_page=true'
      query

    getComponentPath: (target) ->
      $li = $(target).parents('ul.add-nav li')
      $li = $(target) unless $li.size()
      $a = $('a', $li)
      id = $a.attr('component-id')
      name = encodeURIComponent $('p', $li).text()
      query = @calculateEditFormQuery(name)
      @setEditFormQuery(query)
      if id && id.length > 0
        return "#{id}/edit#{query}"
      else
        return "new#{query}"

    addEmailButtonClicked: (e) ->
      e.preventDefault()
      return if @editing
      @setCurrComponentType('email')
      path = @getComponentPath(e.target)
      @openModalWindow "#{@baseURL()}/emails/#{path}", @renderComponentInModal

    addWebPageButtonClicked: (e) ->
      e.preventDefault()
      return if @editing
      @setCurrComponentType('web_page')
      path = @getComponentPath(e.target)
      @openModalWindow "#{@baseURL()}/web_pages/#{path}", @renderComponentInModal

    addPortableKeyButtonClicked: (e) ->
      e.preventDefault()
      return if @editing
      @setCurrComponentType('portable_file')
      path = @getComponentPath(e.target)
      @openModalWindow "#{@baseURL()}/portable_files/#{path}", @renderComponentInModal

    resetShadowArrowPosition: ->
      pos = $('.inline-add', @el).position()
      $('.shadow-arrow', @el).css(left: "#{pos.left+53}px")

    toggleTray: (e) ->
      e.preventDefault()
      $('.shadow-arrow', @el).toggle()
      @resetShadowArrowPosition()
      $('.component-buttons', @el).animate({height: 'toggle'}, 200)

    events:
      'click .component-buttons ul.add-nav li.component a': 'implicitlyCreateCampaign',
      'click .campaign-components ul.add-nav li a': 'implicitlyCreateCampaign',
      'click li .add-portable_file': 'addPortableKeyButtonClicked',
      'click li .add-email': 'addEmailButtonClicked',
      'click li .add-web_page': 'addWebPageButtonClicked',
      'click .toggle-component-edit-mode': 'toggleComponentEditMode',
      'click a.add-component': 'toggleTray',
      'click div.delete': 'deleteComponent'
      
    findOrCreateComponentByName: (name, type='') ->
      _.find(@campaignComponents, (comp) -> 
        comp.name == name
      ) || {
        name: name
        id: null
        type: type
        classText: 'unconfigured'
      }

    deleteComponent: (e) ->
      # grab id of component clicked from dom
      id = $(e.target).parents('li.component').find('a').attr('component-id')
      return unless id && id.length > 0
      id = parseInt(id)
      # find component in array based on id
      component = _.find(@campaignSummary.get('campaign_components'), ((comp) -> comp.id == id))
      return unless component
      # make sure we want to confirm the action
      return unless confirm("Are you sure you want to delete this #{_.str.humanize(component.type)}?")
      # fire off ajax request to kill component
      type = component.type
      type = if type is 'portable_file' then 'portable_file' else type # REMOVE ME
      url = "#{@baseURL()}/#{type}s/#{id}"
      $.ajax(
        url: url
        type: 'POST'
        data: { '_method': 'DELETE' }
        success: =>
          originalComponents = @campaignSummary.get('campaign_components')
          newComponents = _.without(originalComponents, component)
          @editing = false if newComponents.length == 0
          @campaignSummary.set('campaign_components': newComponents)

        error: =>
          # ??? deleting a component shouldn't fail
          originalComponents = @campaignSummary.get('campaign_components')
          newComponents = _.without(originalComponents, component)
          @editing = false if newComponents.length == 0
          @campaignSummary.set('campaign_components': newComponents) # SHOULD trigger a render
          
          
      )

    setEditing: (@editing) ->
      $('.campaign-components a.toggle-component-edit-mode', @el).toggleClass('active', @editing)
      $('.campaign-components .add-nav', @el).toggleClass('editing', @editing)
      $('.campaign-components .inline-add', @el).toggleClass('editing', @editing)
      $('.campaign-components .component-buttons, .shadow-arrow', @el).hide() if @editing

    toggleComponentEditMode: ->
      @setEditing(!@editing)
      false

    pollForPortableFilesIfNecessary: -> # an array of {id: 5}
      components = @campaignSummary.get('campaign_components')
      @portableFilePoller.stop() if @portableFilePoller
      @portableFilePoller = null
      pFiles = _.filter(components, (c) -> 
        c.type == 'portable_file' && !c.download
      )
      url = "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns/#{@campaignSummary.id}.json"
      return unless pFiles.length > 0

      @portableFilePoller = new SingleModelPoller(@campaignSummary, url, 2000, =>
        if @portableFilePoller && CampaignTabView.activeView.index != 0
          @portableFilePoller.stop()
          @portableFilePoller = null
      )
      @portableFilePoller.start()

    render: ->
      # render is called 3x when switching to this tab. wtf. wtf. wtf m8
      @campaignComponents = @campaignSummary.get('campaign_components')
      @wrapperClass = ''

      if @campaignSummary.get('config_type') == 'wizard'
        component1 = @findOrCreateComponentByName('Landing Page', 'web_page')
        # only show redirect page if the user has specified
        pdo = component1['phishing_redirect_origin']
        if pdo && pdo == 'phishing_wizard_redirect_page'
          component2 = @findOrCreateComponentByName('Redirect Page', 'web_page')
        component3 = @findOrCreateComponentByName('E-mail', 'email')
        @wizardComponents = [component3]
        @wizardComponents.push(component1)
        @wizardComponents.push(component2) if component2
        @wrapperClass = 'wizard'

      $next = @dom.next().first() if @dom
      @dom.remove() if @dom
      if $next && $next.size()
        @dom = $($.parseHTML(@template(this))[1])
        @dom.insertBefore $next
      else
        @dom = $($.parseHTML(@template(this))[1])
        @dom.appendTo $(@el)

      @setEditing(@editing)
      @pollForPortableFilesIfNecessary()

