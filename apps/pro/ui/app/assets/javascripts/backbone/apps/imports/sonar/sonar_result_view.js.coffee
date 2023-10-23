define [
  'base_itemview'
  'apps/imports/sonar/templates/result_view'
  'apps/imports/sonar/templates/empty_result_view'
], () ->
  @Pro.module 'ImportsApp.Sonar', (Sonar, App, Backbone, Marionette, $, _) ->

    #
    # View for Sonar Results Table
    #
    class Sonar.ResultView extends App.Views.ItemView
      template: @::templatePath 'imports/sonar/result_view'

      ui:
        resultsTable: '#sonar-results-table'

      onShow: (opts={})->
        columns = [
          {
            label: 'Address'
            attribute: 'address'
          }
          {
            label: 'Host Name'
            attribute: 'name'
          }
          {
            label: 'Service'
            attribute: 'host.service'
          }
          {
            label: 'Last Updated'
            attribute: 'updated_at'
          }
        ]

        # Sample Data for Now
        collection = new Backbone.Collection [
          {
            'address':      '10.0.0.1'
            'name':         'hostname-01'
            'host.service': 'smb'
            'updated_at':   '2015-10-21 09:38:26AM -06:00'
          }
          {
            'address':      '10.0.0.2'
            'name':         'hostname-02'
            'host.service': 'smb'
            'updated_at':   '2015-10-21 09:38:26AM -06:00'
          }
          {
            'address':      '10.0.0.3'
            'name':         'hostname-03'
            'host.service': 'smb'
            'updated_at':   '2015-10-21 09:38:26AM -06:00'
          }
          {
            'address':      '10.0.0.4'
            'name':         'hostname-04'
            'host.service': 'smb'
            'updated_at':   '2015-10-21 09:38:26AM -06:00'
          }
          {
            'address':      '10.0.0.5'
            'name':         'hostname-05'
            'host.service': 'smb'
            'updated_at':   '2015-10-21 09:38:26AM -06:00'
          }
        ]

        tableOpts =
          region:      new Backbone.Marionette.Region(el: @ui.resultsTable)
          columns:     columns
          selectable:  true
          collection:  collection
        #          static:      true
        #          taggable:           true
        #          static:             false
        #          htmlID:             opts.htmlID
        #          perPage:            20
        #          defaultSort:        'public.username'
        tableController = App.request "table:component", tableOpts

    #
    # View for Sonar Results Table
    #
    class Sonar.EmptyResultView extends App.Views.ItemView
      template: @::templatePath 'imports/sonar/empty_result_view'
      className: 'shared nexpose-sites'