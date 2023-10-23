jQueryInWindow ($) ->
  class Template
    constructor: (tplSel) -> @tpl = $(tplSel).html()
    render: (opts) ->
      @tpl = @tpl.replace("{#{key}}", val) for own key, val of opts
      @tpl = @tpl.replace(/\{.*?\}/g, "")
      @tpl

  updateNames = ->
    $('.multi-add-human-target li').each (idx) ->
      $('input:eq(0)', this).attr 'name', "social_engineering_target_list[quick_add_targets][#{idx}][email_address]"
      $('input:eq(1)', this).attr 'name', "social_engineering_target_list[quick_add_targets][#{idx}][first_name]"
      $('input:eq(2)', this).attr 'name', "social_engineering_target_list[quick_add_targets][#{idx}][last_name]"

  removeLine = (btn) ->
    $(btn).parents('li').remove()
    updateNames()
    $('.multi-add-human-target li:last-child div:last-child').show()

  addLine = (opts) ->
    $('.multi-add-human-target li div:last-child').hide()
    tpl = new Template '#multi-add-human-target-template'
    $('.multi-add-human-target').append tpl.render(opts)
    updateNames()
    $li = $('.multi-add-human-target li:last-child')
    $('input', $li).inputHint()
    $('a.plus', $li).click ->
      addLine()
      return false
    $('a.minus', $li).click ->
      removeLine(this)
      return false

  isBlank = (obj) ->
    for own key, val of obj
      return false if val && val.length > 0
    true

  window.renderTargets = ->
    window.prevTargets = jQuery.parseJSON(jQuery('#prevTargets').attr('content')) || null
    jQuery('#prevTargets').remove()

    count = 0
    if prevTargets
      for own idx, val of prevTargets
        unless isBlank(val)
          addLine(val)
          count++

    addLine() unless count
