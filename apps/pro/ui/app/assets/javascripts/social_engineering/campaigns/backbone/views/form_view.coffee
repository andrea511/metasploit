jQueryInWindow ($) ->
  class @FormView extends @PaginatedRollupModalView
    initialize: (opts) ->
      @options = opts
      @saveCallback = @options['save'] || @saveCallback
      @length = 1
      _.bindAll(this, 'save', 'onLoad')
      super

    events: _.extend({
        'click .actions a.cancel': 'close'
        'click .actions a.save': 'save'
      }, PaginatedRollupModalView.prototype.events)

    save: ->
      @saveCallback.call(this) if @saveCallback

    onLoad: ->
      @inputChanged = false
      setInputChangedFn = (e) =>
        str = String.fromCharCode(e.keyCode)
        @inputChanged = true if str.match(/\w/) || str == ' '

      $('input,select,textarea', @el).keydown(setInputChangedFn)
      $('select,input,textarea', @el).change(=> @inputChanged = true)
      if @options['formQuery'] # rewrite action URL, appending query params
        $form = $('form', @el).first()
        currAction = $form.attr('action')
        $form.attr('action', "#{currAction}#{@options['formQuery']}")
      _.each($('select>option', @el), (item) -> 
        $(item).removeAttr('value') if $(item).val() == ''
      )
      $('select', @el).select2(DEFAULT_SELECT2_OPTS) unless @dontRenderSelect2
      super

    close: (opts={}) ->
      # if no changes to form, just go ahead and close
      if @inputChanged
        super(opts)
      else
        # save and restore confirms
        optionsConfirm = @options.confirm
        @options.confirm = null
        optsConfirm = opts.confirm
        opts.confirm = null
        super(opts)
        @options.confirm = optionsConfirm
        opts.confirm = optsConfirm


    actionButtons: ->  [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]]
