define [
  'jquery'
  'base_layout'
  'base_compositeview'
  'base_itemview'
  'lib/shared/targets/templates/targets_layout'
  'lib/shared/targets/templates/target'
  'lib/concerns/views/right_side_scroll'
], ($) ->
  @Pro.module "Shared.Targets", (Targets, App) ->

    #
    # Targets Layout
    #
    class Targets.Layout extends App.Views.Layout

      template: @::templatePath "targets/targets_layout"

      regions:
        targetsRegion: '.targets-table'
        targetListRegion: '.target-list'

      ui:
        addSelectionButton: '.add-selection'
        rightSide: '.right-side'
        leftSide: '.left-side'
        next: 'a.btn.primary'

      attributes:
        class: 'target-selection-view'

      triggers:
        'click @ui.addSelectionButton': 'targets:addToCart'

      @include "RightSideScroll"

      toggleNext: (enabled) =>
        @ui.next.toggleClass('disabled', !enabled)

    class Targets.Target extends App.Views.ItemView
      template: @::templatePath('targets/target')

      attributes:
       class: 'target-row'

      events:
        'click div:not(span)': 'toggleInfo'
        'click a.delete': 'removeTarget'

      ui:
        toggleInfo: '.toggle-info'
        arrow: '.arrow-container a'

      initialize: ({@collection, @model}) =>

      removeTarget: =>
        @collection.remove(@model)

      toggleInfo: (e) ->
        @ui.arrow.toggleClass('expand')
        @ui.arrow.toggleClass('contract')
        @ui.toggleInfo.toggleClass('display-none')


    class Targets.HostnameCellModalView extends App.Views.ItemView
      ui:
        content: '.truncated-data'

      #
      # Select the truncated data when the dialog opens.
      #
      onShow: ->
        @selectText @ui.content[0]

      template: (model) =>
        "<div class='truncated-data'>#{_.escape(model['host.name'])}</div>"

    class Targets.HostnameCellView extends App.Views.ItemView
      ui:
        disclosureLink: 'a.more'

      events:
        'click @ui.disclosureLink': 'showDisclosureDialog'

      showDisclosureDialog: =>
        dialogView = new Targets.HostnameCellModalView model: @model
        App.execute 'showModal', dialogView,
          modal:
            title: 'Hostname'
            description: ''
            width: 600
            height: 400
          buttons: [
            { name: 'Close', class: 'close'}
          ]

      template: (model) =>
        max = 16
        text = model['host.name'] || ''
        if text.length > max
          @truncatedText = text.substring(0, max)+'…'
          "#{_.escape(@truncatedText)} <a class='more' href='javascript:void(0);'>more</a>"
        else
          _.escape text
