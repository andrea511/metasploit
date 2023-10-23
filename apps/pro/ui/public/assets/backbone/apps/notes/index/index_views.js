(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_itemview'], function() {
    return this.Pro.module('NotesApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      Index.DataCellView = (function(_super) {

        __extends(DataCellView, _super);

        function DataCellView() {
          return DataCellView.__super__.constructor.apply(this, arguments);
        }

        DataCellView.prototype.ui = {
          noteDataDisclosureLink: 'a.note-data-view'
        };

        DataCellView.prototype.events = {
          'click @ui.noteDataDisclosureLink': 'displayModal'
        };

        DataCellView.prototype.template = function(data) {
          return data['data'];
        };

        DataCellView.prototype.displayModal = function(e) {
          var $dialog;
          $dialog = $("<div style='display:hidden'>" + (this.$el.find('.note-data').html()) + "</div>").appendTo('body');
          $dialog.dialog({
            title: "Note data",
            buttons: {
              "Close": function() {
                return $(this).dialog('close');
              }
            },
            open: function(event, ui) {
              $(this).css({
                'max-height': 400,
                'overflow-y': 'auto'
              });
              if ($(this).parent().position().top === 0) {
                return $('.ui-resizable').css({
                  'top': '100px'
                });
              }
            }
          });
          return e.preventDefault();
        };

        return DataCellView;

      })(Pro.Views.ItemView);
      return Index.StatusCellView = (function(_super) {

        __extends(StatusCellView, _super);

        function StatusCellView() {
          return StatusCellView.__super__.constructor.apply(this, arguments);
        }

        StatusCellView.prototype.template = function(data) {
          if (data.critical === "true" && (data.seen === "false" || data.seen === null)) {
            return "<img title=\"flagged\" src=\"/assets/icons/flag_red-5804818c614ec1e9cdf256e6aab3602b63b57d7a03609f71c56f709b48003014.png\" />";
          } else {
            return "&nbsp;";
          }
        };

        return StatusCellView;

      })(Pro.Views.ItemView);
    });
  });

}).call(this);
