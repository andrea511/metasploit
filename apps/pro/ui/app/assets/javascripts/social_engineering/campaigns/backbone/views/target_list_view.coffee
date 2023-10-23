jQueryInWindow ($) ->
  class @TargetListView extends FormView
    initialize: (opts) ->
      @options = opts
      @loadingModal = $('<div class="loading">').dialog(
        modal: true, 
        title: 'Submitting...',
        autoOpen: false,
        closeOnEscape: false
      )
      _.bindAll(this, 'deleteClicked')
      super

    onLoad: ->
      super
      window.renderTargets()
      $table = $('table.list.sortable', @el)
      $table.dataTable {
        sDom: 't<"list-table-footer clearfix"ip <"sel" l>>r',
        sPaginationType: 'r7Style',
        oLanguage: {
          sEmptyTable: "No data has been recorded."
        },
        aoColumns: [
          {bSortable: false},
          {},
          {},
          {}
        ],
        fnDrawCallback: =>
          resetDeleteBtn = =>
            $boxes = $(".table input[type=checkbox]", @el).not('[name^=all_]') 
            anyChecked = _.find $boxes, (box) -> $(box).is(':checked')
            $('.target-list-show .delete-span', @el).show().toggleClass('ui-disabled', !!!anyChecked)

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
      $('a.save-targets', @el).click (e) =>
        $form = $(e.target).parents('form').first()
        @submitForm($form)
      $('.target-list-show .delete-span', @el).click(@deleteClicked)

    submitForm: ($form, url=null) ->
      @loadingModal.dialog('open')
      render = (data) =>
        @loadingModal.dialog('close')
        $('.content-frame>.content', @el).html('')
        $('.content-frame>.content', @el).html(data)
        @onLoad()
      $.ajax(
        url: url || $form.attr('action')
        type: 'POST'
        data: $form.serialize()
        success: (data) -> render(data)
        error: (e) -> render(e.responseText)
      )

    deleteClicked: (e) ->
      return if $('.target-list-show  .delete-span').hasClass('ui-disabled')
      return unless confirm("Are you sure you want to delete the selected Human Targets?")
      $form = $('form', @el).first()
      url = $form.attr('action') + '/remove_targets'
      @submitForm($form, url)

    actionButtons: ->
      if @options['buttons'] == false
        [
          [['cancel primary', 'Done']]
        ]
      else
        [
          [['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]
        ]

    save: ->
      # send form request over ajax, termine results
      $form = $('.target-list-new form', @el)
      @loadingModal.dialog('open')
      $.ajax
        url: $form.attr('action')
        type: 'POST'
        files: $(':file', $form)
        data: $('input,select,textarea', $form).not(':file').serializeArray()
        iframe: true
        processData: false
        success: (data, status) =>
          $('.content', @el).html(data)
          @loadingModal.dialog('close')
          saveStatus = $('meta[name=save-status]', @el).attr('content')
          if saveStatus == 'false' || !saveStatus
            @onLoad()
          else # success!
            jsonData = $.parseJSON(saveStatus)
            @close()
        error: =>
          @loadingModal.dialog('close')

      super
