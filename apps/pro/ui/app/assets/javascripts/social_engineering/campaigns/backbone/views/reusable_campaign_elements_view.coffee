jQueryInWindow ($) ->
  class @ReusableCampaignElementsView extends SingleTabPageView

    @EMAIL_TEMPLATES: 1
    @MALICIOUS_FILES: 3
    @TARGET_LISTS: 0
    @WEB_TEMPLATES: 2

    initialize: ->
      _.bindAll(this, 'render', 'updateTable', 'willDisplay', 'editClicked', 'deleteClicked')

    tblTemplate: _.template($('#reusable-elements').html())

    events:
      'change select[name=element_type]': 'updateTable',
      'click a.new': 'newClicked',
      'click .delete-span': 'deleteClicked'

    willDisplay: ->
      @render()

    @generateTableHeaders: ->
      renderName = (row,link=true) ->
        url = $('select[name=element_type]', @el).val()
        selIdx = $('select[name=element_type]', @el).attr('selectedIndex')
        name = row.aData.name || row.aData.attachable_type
        id = row.aData.id
        return name if selIdx == ReusableCampaignElementsView.MALICIOUS_FILES || !link
        "<a class='name' href='#{_.escape(url)}/#{_.escape(id)}/edit' target='_blank' data-id='#{_.escape(id)}'>#{_.escape(name)}</a>"

      renderNameWithoutLink = (row) ->
        renderName(row, false)

      renderNameShow = (row) ->
        url = $('select[name=element_type]', @el).val()
        name = row.aData.name || row.aData.attachable_type
        id = row.aData.id
        "<a class='name' href='#{_.escape(url)}/#{_.escape(id)}' target='_blank' data-id='#{_.escape(id)}'>#{_.escape(name)}</a>"
      renderCheckbox = (model_name) ->
        return (row) ->
          id = row.aData.id
          "<input type='checkbox' name='#{model_name}_ids[]' value='#{_.escape(id)}' />"
      checkboxDisplay = (model_name) ->
        "<input type='checkbox' name='all_#{_.escape(model_name)}s' value='false' />"

      headers = []
      cboxWidth = '20px'
      headers[@EMAIL_TEMPLATES] = [
        { bSortable: false, display: checkboxDisplay('email_template'), sWidth: cboxWidth, fnRender: renderCheckbox('email_template') },
        { mDataProp: 'name', display: 'Name', fnRender: renderName},
        { mDataProp: 'created_at', display: 'Created', fnRender: dataTableDateFormat }
      ]
      headers[@MALICIOUS_FILES] = [
        { bSortable: false, display: checkboxDisplay('user_submitted_file'), sWidth: cboxWidth, fnRender: renderCheckbox('user_submitted_file') },
        { mDataProp: 'name', display: 'Name', fnRender: renderNameWithoutLink},
        { mDataProp: 'user_name', display: 'User'},
        { mDataProp: 'file_size', display: 'File Size', fnRender: (row) =>
          fs = row.aData['file_size']
          helpers.formatBytes(fs)
        },
        { mDataProp: 'created_at', display: 'Created', fnRender: dataTableDateFormat}
      ]
      headers[@TARGET_LISTS] = [
        { bSortable: false, display: checkboxDisplay('target_list'), sWidth: cboxWidth, fnRender: renderCheckbox('target_list') },
        { mDataProp: 'name', display: 'Name', fnRender: renderNameShow},
        { mDataProp: 'targets_count', display: '# Targets' },
        { mDataProp: 'created_at', display: 'Created', fnRender: dataTableDateFormat }
      ]
      headers[@WEB_TEMPLATES] = [
        { bSortable: false, display: checkboxDisplay('email_template'), sWidth: cboxWidth, fnRender: renderCheckbox('web_template') },
        { mDataProp: 'name', display: 'Name', fnRender: renderName},
        { mDataProp: 'created_at', display: 'Created', fnRender: dataTableDateFormat }
      ]
      headers

    tableHeaders: @generateTableHeaders()

    headerForRow: (row) -> 
      headers = @tableHeaders[row]
      "<tr><th>#{_.pluck(headers, 'display').join('</th><th>')}</th></tr>"

    updateTable: (e) ->
      $select = $('select[name=element_type]', @el)
      url =  $select.val()
      name = $('option:selected', $select).text() # holds "Web Templates"
      #return if url == @_url # don't update if they didnt change
      @_url = url
      # blank the current table and load via ajax
      tblMarkup = '<table class="list sortable"><thead></thead><tbody></tbody></table>'
      $table = $(tblMarkup)
      $('.table', @el).html('').append($table)
      row = $select.get(0).selectedIndex
      $('thead', $table).html(@headerForRow(row))
      sort_col = [[@tableHeaders[row].length-1, 'desc']]
      
      @tableHeaders[row][0].sClass = 'checkbox'
      @dataTable = $table.dataTable {
        oLanguage: {
          sEmptyTable: "No data has been recorded."
        },
        aoColumns: @tableHeaders[row],
        bServerSide: true,
        sAjaxSource: "#{url}.json",
        bFilter: false,
        bProcessing: true,
        aaSorting: sort_col,
        sDom: 't<"list-table-footer clearfix"ip <"sel" l>>r'
        sPaginationType: 'r7Style',
        fnDrawCallback: =>
          $('.table a.name', @el).click(@editClicked)
          resetDeleteBtn = =>
            $boxes = $(".table input[type=checkbox]", @el).not('[name^=all_]') 
            anyChecked = _.find $boxes, (box) -> $(box).is(':checked')
            $('.delete-span', @el).show().toggleClass('ui-disabled', !!!anyChecked)

          $(".table input[name^=all_][type=checkbox]", @el).change (e) =>
            checked = $(e.target).is(':checked')
            if checked
              $('.table input[type=checkbox]', @el).attr('checked', 'checked')
            else
              $('.table input[type=checkbox]', @el).removeAttr('checked')
            resetDeleteBtn()

          $(".table input[type=checkbox]", @el).not('[name^=all_]').change (e) =>
            checked = $(e.target).is(':checked')
            unless checked
              $(".table input[name^=all_][type=checkbox]", @el).removeAttr('checked')
            resetDeleteBtn()

      }
      singleName = name.replace(/s$/, '')
      $('.table', @el).removeClass('loading')
      newURL = "#{url}/new"
      $('a.new', @el).attr('href', newURL).text("New #{singleName}")
      $('.reusable-elements form', @el).attr('action', url)
      
    classForSelectedOption: ->
      selIdx = $('select[name=element_type] option:selected', @el).index()
      [TargetListView, EmailTemplateView, WebTemplateView, MaliciousFileView][selIdx]

    newClicked: (e) ->
      e.preventDefault()
      url = $(e.target).attr('href')
      klass = @classForSelectedOption()
      fv = new klass(onClose: => @updateTable())
      fv.load(url)

    editClicked: (e) ->
      e.preventDefault()
      url = $(e.target).attr('href')
      klass = @classForSelectedOption()
      fv = new klass(onClose: (=> @updateTable()), buttons: false)
      fv.load(url)

    deleteClicked: (e) ->
      e.preventDefault()
      return if $(e.target).hasClass('ui-disabled')
      $form = $('.reusable-elements form', @el)
      $sels = $('td input[type=checkbox]:checked', $form)
      name = $('select[name=element_type] option:selected', @el).text()
      singleName = name.replace(/s$/, '')
      pluralizedName = if $sels.size() == 1 then singleName else name
      return unless confirm("Are you sure you want to delete #{$sels.size()} #{pluralizedName}?")
      $(e.currentTarget).addClass('ui-disabled')
      
      url = $form.attr('action')
      $.ajax(
        url: url,
        type: 'POST',
        data: $form.serialize(),
        success: (data) =>
          $('.reusable-elements .status', @el).show().removeClass('errors').addClass('success')
            .text("Successfully deleted #{name}.").delay(5000).fadeOut()
          $(e.currentTarget).removeClass('ui-disabled')
          @updateTable()
        error: (e) =>
          data = $.parseJSON(e.responseText)
          $('.reusable-elements .status', @el).show().addClass('errors').removeClass('success')
            .text(data['error']).delay(5000).fadeOut()
          $(e.currentTarget).removeClass('ui-disabled')
          $('.reusable-elements .delete-span', @el).removeClass('ui-disabled')
      )

    render: ->
      @dom ||= super
      @tblDom.remove() if @tblDom
      @tblDom = $($.parseHTML(@tblTemplate(this))).appendTo(@dom)
      @_url = null
      $('select', @el).select2(DEFAULT_SELECT2_OPTS)
      @updateTable()
