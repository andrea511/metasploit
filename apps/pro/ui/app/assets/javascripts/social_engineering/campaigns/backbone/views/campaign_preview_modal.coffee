jQueryInWindow ($) ->
  class @CampaignPreviewModal extends PaginatedFormView
    initialize: (opts) ->
      @campaignSummary = opts['campaignSummary']
      @loaded = {}
      $(@el).addClass('preview')
      super

    pagesTemplate: _.template($('#campaign-preview-modal').html())

    render: ->
      # dont show portable files
      components = _.filter(@campaignSummary.get('campaign_components'), (cp) -> 
        cp.type != 'portable_file'
      )
      name = @campaignSummary.get('name')
      title = "#{name}: Preview"
      el = super
      $('.content', el).html(@pagesTemplate(components: components, title: title))
      @onLoad()

    findComponentById: (id, type) ->
      _.find(@campaignSummary.get('campaign_components'), ((cp) -> 
        return parseInt(cp.id) == parseInt(id) && cp.type == type
      ))

    setLoaded: (idx) -> @loaded[idx+''] = true
    isLoaded: (idx) -> !!@loaded[idx+'']

    page: (idx) ->
      super
      # inject iframe into page
      _.delay((=>
        $cell = $('.page.row>.cell', @el).eq(idx)
        unless @isLoaded(idx)
          @setLoaded(idx)
          type = $cell.attr('component-type')
          id = $cell.attr('component-id')
          url = "/workspaces/#{WORKSPACE_ID}/social_engineering/campaigns/#{@campaignSummary.id}/#{type}s/#{id}/preview_pane"
          $('.component-content', $cell).load(url, =>
            h = $('.content', @el).height()
            iframe = $('iframe', $cell)[0]
            $('.preview-pane', $cell).css('visibility': 'hidden')
            $(iframe).bind 'load', =>
              $cell.removeClass('loading')
              iframeWin = iframe.contentWindow || iframe.contentWindow.parentWindow
              if iframeWin.document.body then iframe.height = iframeWin.document.documentElement.scrollHeight || iframeWin.document.body.scrollHeight
              iframe.height = parseInt(iframe.height) + 20
              $(iframe).css('margin-bottom': '20px')
              $('.preview-pane', $cell).css('visibility': 'visible')

            $('.actions', @el).html('')
            $('.row.action-row', $cell).hide().clone().appendTo($('.actions', @el)).show()
          )
        else
          $('.actions', @el).html('')
          $('.row.action-row', $cell).clone().appendTo($('.actions', @el)).show()
      ), 300)

    renderHeader: ->
      super
      compTypes = _.map($('div.page.row>div.cell', @el), (item) -> $(item).attr('component-type'))
      $circles = $('.header .page-circle', @el)
      $('.header', @el).addClass('small-shadow')
      for i in [0...compTypes.length]
        $circles.eq(i).html('').removeClass('page-circle')
          .parent('.cell').addClass('tab').addClass(compTypes[i]) #reenable custom images

    actionButtons: -> nil