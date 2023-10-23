(function() {

  define(['jquery', 'base_view'], function($) {
    return this.Pro.module("Components.Table.CellViews", function(CellViews, App) {
      var _this = this;
      return CellViews.TruncateView = function(_arg) {
        var attribute, max;
        max = _arg.max, attribute = _arg.attribute;
        return Backbone.Marionette.ItemView.extend({
          template: function(model) {
            var text;
            max || (max = 16);
            text = model[attribute] || '';
            if (text.length > max) {
              text = text.substring(0, max) + '…';
              return "<span title='" + model[attribute] + "'>" + (_.escape(text)) + "</span>";
            } else {
              return _.escape(text);
            }
          },
          onRender: function() {
            return this.$el.tooltip();
          }
        });
      };
    });
  });

}).call(this);
