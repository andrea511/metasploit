#
# globally available helpers (window.helpers.*)
#
$ = jQuery

window.helpers ||= {
  # returns a clonedNode with value properties cloned for text area, select
  # @return [Object] the cloned node
  cloneNodeAndForm: (oldNode)->
    clonedNode = $(oldNode).clone(true,true)[0]
    oldNodes = $('textarea, select',oldNode)
    clonedNodes = $('textarea, select',clonedNode)
    _.each(clonedNodes, (elem,index)->
      oldNode = oldNodes[index]
      newNode = clonedNodes[index]
      $(newNode).val($(oldNode).val())
    )
    clonedNode

  # returns the value of url param
  # @return [String] value in param
  urlParam : (name)->
    results = new RegExp('[\\?&amp;]' + name + '=([^&amp;#]*)').exec(window.location.href);
    results?[1] or 0

  # returns a humanized byte size
  # @param fs [Integer] the number of bytes to convert
  # @return [String] humanized byte count
  formatBytes: (fs) ->
    return '' if !fs || fs == ''
    size = parseInt(fs)
    units = ['B', 'KB', 'MB', 'GB', 'TB']
    i = 0
    while (size >= 1024)
      size /= 1024
      i++
    fmtSize = size.toFixed(1) + units[i].toLowerCase()
    fmtSize

  # @param fs a formatted string of some *byte unit: "11mb" or "12.5 kb"
  # @return [Integer] the number of bytes
  parseBytes: (fs) ->
    matches = fs.match(/[^0-9.]+/g)
    parsed =  parseFloat(fs.replace(/[^0-9.]+/g,''))
    if matches? and matches.size() > 0
      units = ['B','KB', 'MB', 'GB', 'TB']
      i = 0
      i++ while matches[0] != units[i]
      return parseInt(parsed*Math.pow(1024,i))
    else
      #If no units provided assume megabytes
      return parseInt(parseFloat(fs*1024*1024))


  #####
  # no more hardcoding table headers for dataTables!
  # Works around the annoying dataTables requirement:
  # 1. Requests page size of 0, inspects the table headers of the resposne
  # 2. Builds table with corresponding headers
  # 3. Requests first page over ajax and fills in table (calls .dataTable())
  #####
  # @param [Hash] opts a hash of options with the following keys:
  #  - el: jQuery collection containing the HTML element(s) to load the table into
  #  - success: a function called after the page is requested, passes a reference to the
  #                 dataTable object
  #  - renderValFn: A function that accepts a (columnName, value) pair and returns
  #                 a formatted HTML value for displaying
  #  - dataTable: A hash of options to pass to the dataTable constructor
  #  - additionCols: An array of extra column names
  #####
  loadRemoteTable: (opts={}) ->
    $area = opts.el
    cb = opts.cb
    dtOpts = opts.dataTable || {}
    dtOpts.sPaginationType = "r7Style"
    dtOpts.sDom = 'ft<"list-table-footer clearfix"ip <"sel" l>>r'
    $.ajax
      url: opts?.dataTable?.sAjaxSource
      dataType: 'json'
      success: (data) =>
        $area.removeClass('tab-loading').html('')
        colNames = data['sColumns'].split(',')
        $area.append('<table><thead><tr /></thead><tbody /></table>')
        $table = $('table', $area).addClass('list')
        $tr = $('thead tr', $area)
        colOverrides = opts.columns || {}
        additionalCols = opts.additionalCols || []
        colNames = _.union(additionalCols, colNames)
        colArr = _.map colNames, (name) ->
          $tr.append($('<th />', html: colOverrides[name]?.name ? _.str.humanize(name)))
          col = { mDataProp: _.str.underscored(name) }
          if colOverrides[name]?
            $.extend(col, colOverrides[name])
          col

        initCompleteCallback = dtOpts.fnInitComplete
        delete dtOpts['fnInitComplete']
        defaultOpts = {
          aoColumns: colArr
          bProcessing: true
          bServerSide: true
          sPaginationType: "full_numbers"
          bFilter: false
          bStateSave: true
          fnDrawCallback: -> $table.css('width', '100%')
          fnInitComplete: ->
            initCompleteCallback.apply(@, arguments) if initCompleteCallback?
            $table.trigger('tableload')
        }

        $dataTable = $table.dataTable($.extend({}, defaultOpts, dtOpts))
        $area.append($('<div />', style: 'clear:both'))

        if opts.editableOpts?
          $table.fnSettings().sAjaxDelete = opts.sAjaxDelete
          $table.fnSettings().sAjaxDestination = opts.sAjaxDestination
          $table.fnSettings().editableOpts = opts.editableOpts
          $table.fnInitEditRow()

        opts.success($dataTable) if opts.success?

  # show/hide Loading Dialog methods
  showLoadingDialog: (loadingMsg='Loading...') ->
    @_loaderDialog = $('<div class="loading tab-loading" />').dialog(
      modal: true
      closeOnEscape: false
      title: loadingMsg
      resizable: false
    )
    @_loaderDialog.parents('.ui-dialog').addClass('white')
    @_loaderDialog.append($('<p class="dialog-msg center">').text(''))

  hideLoadingDialog: ->
    @_loaderDialog?.dialog()
    @_loaderDialog?.dialog('close')?.remove() if @_loaderDialog?.dialog('isOpen')

  setDialogTitle: (title) =>
    $('.dialog-msg', @_loaderDialog).text title

}
