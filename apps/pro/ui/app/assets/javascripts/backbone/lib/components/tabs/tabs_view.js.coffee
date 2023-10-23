define [
  'base_view'
  'base_itemview'
  'base_collectionview'
  'base_layout'
  'base_collectionview'
  'base_compositeview'
  'lib/components/tabs/templates/tabs_layout'
  'lib/components/tabs/templates/tab'
  'lib/concerns/views/chooseable'
], ->
  @Pro.module 'Components.Tabs', (Tabs, App, Backbone, Marionette, $, _) =>
    #
    # Contains the layout for the tab component
    #
    class Tabs.Layout extends App.Views.Layout
      template: @::templatePath 'tabs/tabs_layout'

      className: "tab-component"

      regions:
        tabs: '.tabs'
        tabContent: '.tab-content'

      ui:
        tabContent: '.tab-content'

    #
    # Individual Tab
    #
    class Tabs.Tab extends App.Views.ItemView
      template: @::templatePath 'tabs/tab'

      className: 'tab'
      tagName: 'li'

      ui:
        invalid: '.invalid'

      events:
        'click' : 'choose'

      modelEvents:
        'change:valid' : "validChanged"


      @include "Chooseable"

      validChanged: (model,valid) ->
        if valid
          @setValid()
        else
          @setInvalid()

      setValid: ->
        @ui.invalid.addClass('invisible')

      setInvalid: ->
        @ui.invalid.removeClass('invisible')

    #
    # Collection of Tab Views
    #
    class Tabs.TabCollection extends App.Views.CollectionView

      childView: Tabs.Tab

      tagName: 'ul'
