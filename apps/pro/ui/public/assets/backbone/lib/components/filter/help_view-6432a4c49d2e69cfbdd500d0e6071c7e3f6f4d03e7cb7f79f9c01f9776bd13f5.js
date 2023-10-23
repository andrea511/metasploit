(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lib/components/filter/templates/help', 'base_itemview'], function() {
    return this.Pro.module("Filters", function(Filters, App) {
      return Filters.HelpView = (function(_super) {

        __extends(HelpView, _super);

        function HelpView() {
          return HelpView.__super__.constructor.apply(this, arguments);
        }

        HelpView.prototype.template = HelpView.prototype.templatePath('filter/help');

        HelpView.prototype.className = 'tab-loading filter-help';

        HelpView.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          this.whitelist = opts.whitelist || [];
          return this.model.fetch().done(this.render);
        };

        HelpView.prototype.onRender = function() {
          if (_.isEmpty(_.keys(this.model.attributes))) {
            return;
          }
          return this.$el.removeClass('tab-loading');
        };

        HelpView.prototype.serializeData = function() {
          return this;
        };

        return HelpView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
