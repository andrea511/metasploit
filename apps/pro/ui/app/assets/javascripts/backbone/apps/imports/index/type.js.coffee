define [
  'base_model'
], ->
  @Pro.module "ImportsApp.Index", (Index, App,Backbone, Marionette, $, _) ->
    Index.Type =
      File: 'file'
      Nexpose: 'nexpose'
      Sonar: 'sonar'

    #
    # A view model to represent UI state for {Index.TypeSelectionView} and
    #
    # @param [String]  type               The type of import view to show in {Index.Layout}
    # @param [Boolean] showTypeSelection  Whether to display the Radio button selections
    #                                     for import type i.e {Index.TypeSelectionView}
    #
    class Index.ImportTypeSelection extends App.Entities.Model
      defaults:
        type: Index.Type.Nexpose
        showTypeSelection: true
