(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_collectionview', 'base_itemview', 'lib/components/breadcrumbs/templates/crumb', 'lib/concerns/views/chooseable'], function($) {
    return this.Pro.module("Components.Breadcrumbs", function(Breadcrumbs, App) {
      Breadcrumbs.Crumb = (function(_super) {

        __extends(Crumb, _super);

        function Crumb() {
          return Crumb.__super__.constructor.apply(this, arguments);
        }

        Crumb.prototype.template = Crumb.prototype.templatePath("breadcrumbs/crumb");

        Crumb.prototype.tagName = 'li';

        Crumb.prototype.ui = {
          crumb: 'a'
        };

        Crumb.prototype.events = {
          'click': 'choose'
        };

        Crumb.prototype.modelEvents = {
          'change:launchable': 'launchableChanged'
        };

        Crumb.prototype.launchableChanged = function(model, value) {
          if (value) {
            return this.ui.crumb.addClass('launchable');
          } else {
            return this.ui.crumb.removeClass('launchable');
          }
        };

        Crumb.include("Chooseable");

        return Crumb;

      })(App.Views.ItemView);
      return Breadcrumbs.CrumbCollection = (function(_super) {

        __extends(CrumbCollection, _super);

        function CrumbCollection() {
          return CrumbCollection.__super__.constructor.apply(this, arguments);
        }

        CrumbCollection.prototype.childView = Breadcrumbs.Crumb;

        CrumbCollection.prototype.tagName = 'ul';

        CrumbCollection.prototype.className = 'breadcrumbs';

        return CrumbCollection;

      })(App.Views.CollectionView);
    });
  });

}).call(this);
