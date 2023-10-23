define [
  'jquery'
  'base_itemview'
  'lib/shared/cve_cell/templates/view'
  'lib/shared/cve_cell/templates/single_cve_cell_view'
  'lib/shared/cve_cell/templates/empty_cve_cell_view'
  'lib/shared/cve_cell/templates/modal_view'
], ($) ->
  @Pro.module "Shared.CveCell", (CveCell, App, Backbone, Marionette, $, _) ->

    #
    # CveCell View
    #
    class CveCell.View
      constructor: (opts) ->
        refCount = parseInt(opts.model.get('ref_count'))
        ViewClass = switch refCount
          when 0 then CveCell.EmptyView
          when 1 then CveCell.SingleView
          else        CveCell.MultiView
        return new ViewClass(opts)

    #
    # CveCell Base View
    #
    class CveCell.BaseView extends App.Views.Layout
      className: 'shared cve-cell'

      templateHelpers:
        parsedRefs: -> @ref_names
        refCount: -> @ref_count

    #
    # CveCell View for mulptiple references
    #
    class CveCell.MultiView extends CveCell.BaseView
      template: @::templatePath "cve_cell/view"

      triggers:
        'click a' : 'refs:clicked'

    #
    # CveCell View for a single reference
    #
    class CveCell.SingleView extends CveCell.BaseView
      template: @::templatePath "cve_cell/single_cve_cell_view"

    #
    # CveCell View for no references
    #
    class CveCell.EmptyView extends CveCell.BaseView
      template: @::templatePath "cve_cell/empty_cve_cell_view"

    #
    # CveModal View
    #
    class CveCell.ModalView extends App.Views.ItemView
      template: @::templatePath "cve_cell/modal_view"

      className: 'shared cve-cell modal-content'

