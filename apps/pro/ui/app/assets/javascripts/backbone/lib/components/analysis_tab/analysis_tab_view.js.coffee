define [
  'base_layout'
  'base_view'
  'base_itemview'
  'lib/components/analysis_tab/templates/layout'
  'lib/components/analysis_tab/templates/empty'
  'lib/components/table/table_view'
], () ->
  @Pro.module 'Components.AnalysisTab', (AnalysisTab, App, Backbone, Marionette, $, _) ->

    class AnalysisTab.Layout extends App.Views.Layout
      template: @::templatePath 'analysis_tab/layout'

      regions:
        buttonsRegion:      '#action-buttons-region'
        analysisTabsRegion: '#analysis-tabs-region'
        pushButtonRegion:   'a.nexpose-push'

      #
      # Determine the active tab and set it
      onRender: ->
        path = window.location.pathname

        if path.indexOf('hosts') > 0
          @$el.find('li.tab a.hosts').addClass 'active'
        else if path.indexOf('notes') > 0
          @$el.find('li.tab a.notes').addClass 'active'
        else if path.indexOf('services') > 0
          @$el.find('li.tab a.services').addClass 'active'
        else if path.indexOf('vulns') > 0
          if path.indexOf('web_vulns') > 0
            @$el.find('li.tab a.web-vulnerabilities').addClass 'active'
          else
            @$el.find('li.tab a.vulnerabilities').addClass 'active'
        else if path.indexOf('loots') > 0
          @$el.find('li.tab a.loots').addClass 'active'
        else if path.indexOf('modules') > 0
          @$el.find('li.tab a.modules').addClass 'active'

        # adding a suppression for this tab based on analysis nav menu
        has_workspace_web_vulns = $(document.body).find('ul.nav_tabs ul.sub-menu li a.web-vulnerabilities').length > 0
        if !has_workspace_web_vulns
          @$el.find('li.tab a.web-vulnerabilities').parent().remove()


    #
    # Custom Empty View for Analysis Tables
    #
    class AnalysisTab.TableEmptyView extends App.Views.ItemView
      tagName:   'tr'
      className: 'empty'
      template:  @::templatePath 'analysis_tab/empty'
      emptyText: 'No items were found.'

      serializeData: ->
        emptyText: @emptyText

    #
    # Returns a View class (not instantiated) to be shown in Analysis Table when
    # no records exist
    #
    # @param opts [Hash] the options hash
    # @option opts :emptyText [String] the text to display in the empty view
    #
    App.reqres.setHandler 'analysis_tab:empty_view', (opts={}) ->
      if opts.emptyText
        class extends AnalysisTab.TableEmptyView
          emptyText: opts.emptyText
      else
        AnalysisTab.TableEmptyView
