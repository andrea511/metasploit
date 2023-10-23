jQueryInWindow ($) ->
  # workaround to prevent click events from firing when the ui-disabled class is applied
  $(document).click (e) ->
    if $(e.target).hasClass('ui-disabled')
      e.preventDefault() && e.stopPropagation() && e.stopImmediatePropagation()

  # global date format function
  window.dateFormat = (dateStr) ->
    d = moment(new Date(dateStr))
    d.format('MMMM D, YYYY') + ' at ' + d.format('h:mm A')

  window.dataTableDateFormat = (row) ->
    d = row.aData['created_at']
    "<span title='#{d}'>#{dateFormat(d)}</span>"

  # on ajaxError, show a confirm
  LOGGED_OUT_TEXT = 'Your session has expired, please log in again.'
  loggedOut = false
  $(document).ajaxError (e, jqXHR) ->
    if jqXHR.status == 403 && !loggedOut
      loggedOut = true # prevent other handlers from running
      alert(LOGGED_OUT_TEXT)
      document.location.reload(true)

  # move the #modals div to the very bottom of <body>
  $('#modals').appendTo($('body'))

  # handle 403 forbidden responses by refreshing
  DELAY_LOGIN_CHECK = 10000
  checkIfLoggedIn = ->
    $.ajax(
      url: './campaigns/logged_in'
      success: ->
        _.delay(checkIfLoggedIn, DELAY_LOGIN_CHECK)
      error: (jqXHR) ->
        if jqXHR.status == 403 && !loggedOut
          loggedOut = true
          alert(LOGGED_OUT_TEXT)
          document.location.reload(true)
    )
  _.delay(checkIfLoggedIn, DELAY_LOGIN_CHECK)

  # set _.templates to use {{ handlebars-style }} template interpolation
  _.templateSettings = {
    evaluate: /\{%([\s\S]+?)%\}/g,
    escape: /\{\{([\s\S]+?)\}\}/g
  }

  # add ?show=1 to jump to the second tab, etc
  jumpToComponent = window.location.href.match(/show=(.*?)([#|&]|$)/i)
  jumpToComponent = [jumpToComponent[1]] if jumpToComponent && jumpToComponent.length > 1
  @JUMP_TO_COMPONENT = jumpToComponent || null

  _.deepClone = (obj) -> # underscore only has shallow _.clone(obj)
    $.extend(true, {}, obj)

   # load Campaign model from DOM=======
   # fix this later: our CampaignFactsView depends on this constant being set
  numCampaigns = $('meta[name=num-campaigns]').attr('content')
  @PASSWORD_UNCHANGED = $('meta[name=smtp-password-unchanged]').attr('content')
  # shared options for the select2 plugin
  @DEFAULT_SELECT2_OPTS = {
    minimumResultsForSearch: 12,
    formatResultCssClass: (result) -> # make gary's life a little easier
      "id-#{result.id}"
  }

  $(document).ready =>
    Placeholders.init(true)
    campaignSummary = new CampaignSummary()

    # jump to second tab if campaigns exist
    index = if numCampaigns > 0 then 1 else 0
    @tabView = new CampaignTabView({ 
      el: $('#tab-wrap'),
      campaignSummary: campaignSummary,
      index: index
    })
