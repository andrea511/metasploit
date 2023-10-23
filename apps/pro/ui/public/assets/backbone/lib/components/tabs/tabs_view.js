(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_itemview', 'base_collectionview', 'base_layout', 'base_collectionview', 'base_compositeview', 'lib/components/tabs/templates/tabs_layout', 'lib/components/tabs/templates/tab', 'lib/concerns/views/chooseable'], function() {
    var _this = this;
    return this.Pro.module('Components.Tabs', function(Tabs, App, Backbone, Marionette, $, _) {
      Tabs.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('tabs/tabs_layout');

        Layout.prototype.className = "tab-component";

        Layout.prototype.regions = {
          tabs: '.tabs',
          tabContent: '.tab-content'
        };

        Layout.prototype.ui = {
          tabContent: '.tab-content'
        };

        return Layout;

      })(App.Views.Layout);
      Tabs.Tab = (function(_super) {

        __extends(Tab, _super);

        function Tab() {
          return Tab.__super__.constructor.apply(this, arguments);
        }

        Tab.prototype.template = Tab.prototype.templatePath('tabs/tab');

        Tab.prototype.className = 'tab';

        Tab.prototype.tagName = 'li';

        Tab.prototype.ui = {
          invalid: '.invalid'
        };

        Tab.prototype.events = {
          'click': 'choose'
        };

        Tab.prototype.modelEvents = {
          'change:valid': "validChanged"
        };

        Tab.include("Chooseable");

        Tab.prototype.validChanged = function(model, valid) {
          if (valid) {
            return this.setValid();
          } else {
            return this.setInvalid();
          }
        };

        Tab.prototype.setValid = function() {
          return this.ui.invalid.addClass('invisible');
        };

        Tab.prototype.setInvalid = function() {
          return this.ui.invalid.removeClass('invisible');
        };

        return Tab;

      })(App.Views.ItemView);
      return Tabs.TabCollection = (function(_super) {

        __extends(TabCollection, _super);

        function TabCollection() {
          return TabCollection.__super__.constructor.apply(this, arguments);
        }

        TabCollection.prototype.childView = Tabs.Tab;

        TabCollection.prototype.tagName = 'ul';

        return TabCollection;

      })(App.Views.CollectionView);
    });
  });

}).call(this);
