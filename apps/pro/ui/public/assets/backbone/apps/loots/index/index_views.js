(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_itemview'], function() {
    return this.Pro.module('LootsApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      return Index.DataCellView = (function(_super) {

        __extends(DataCellView, _super);

        function DataCellView() {
          return DataCellView.__super__.constructor.apply(this, arguments);
        }

        DataCellView.prototype.ui = {
          noteDataDisclosureLink: 'a.loot-data-view'
        };

        DataCellView.prototype.events = {
          'click @ui.noteDataDisclosureLink': 'displayModal'
        };

        DataCellView.prototype.template = function(data) {
          return data['data'];
        };

        DataCellView.prototype.displayModal = function(e) {
          var $dialog;
          $dialog = $("<div style='display:hidden'>" + (this.$el.find('.loot-data').html()) + "</div>").appendTo('body');
          $dialog.dialog({
            title: "Loot data",
            maxheight: 530,
            width: 670,
            buttons: {
              "Close": function() {
                return $(this).dialog('close');
              }
            }
          });
          return e.preventDefault();
        };

        return DataCellView;

      })(Pro.Views.ItemView);
    });
  });

}).call(this);
