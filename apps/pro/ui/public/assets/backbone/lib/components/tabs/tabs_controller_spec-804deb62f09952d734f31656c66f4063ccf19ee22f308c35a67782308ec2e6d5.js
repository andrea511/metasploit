(function() {

  define(['jquery', 'lib/components/tabs/tabs_controller', '/assets/support/matchers/to_have_nodes.js'], function($) {
    return describe('Components.Tabs.Controller', function() {
      beforeEach(function() {
        this.$el = $("<div />", {
          id: 'tabs-region'
        }).appendTo($('body'))[0];
        return this.region = new Backbone.Marionette.Region({
          el: this.$el
        });
      });
      afterEach(function() {
        var _ref;
        this.region.reset();
        return (_ref = this.$el) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      set('tab1', function() {
        return Pro.Views.ItemView.extend({
          template: _.template('<div>Tab 1 Content</div>')
        });
      });
      set('tab2', function() {
        return Pro.Views.ItemView.extend({
          template: _.template('<div>Tab 2 Content</div>')
        });
      });
      set('tab3', function() {
        return Pro.Views.ItemView.extend({
          template: _.template('<div>Tab 3 Content</div>')
        });
      });
      describe('when making an App Request with destroy option true', function() {
        beforeEach(function() {
          var controller;
          controller = Pro.request('tabs:component', {
            tabs: [
              {
                name: "Tab 1 Header",
                view: tab1
              }, {
                name: "Tab 2 Header",
                view: tab2
              }, {
                name: "Tab 3 Header",
                view: tab3
              }
            ]
          });
          return controller.show(controller.getMainView(), {
            region: this.region
          });
        });
        it('renders with tabs', function() {
          return expect($('.tabs ul li', this.region.el).length).toEqual(3);
        });
        return describe('when switching tabs', function() {
          it('renders the initial tab', function() {
            return expect($('.tab-content div>div', this.region.el).html()).toEqual("Tab 1 Content");
          });
          it('renders the second tab', function() {
            $('.tabs ul li', this.region.el).eq(1).click();
            return expect($('.tab-content div>div', this.region.el).html()).toEqual("Tab 2 Content");
          });
          it('renders the third tab', function() {
            $('.tabs ul li', this.region.el).eq(1).click();
            $('.tabs ul li', this.region.el).eq(2).click();
            return expect($('.tab-content div>div', this.region.el).html()).toEqual("Tab 3 Content");
          });
          return it('restores the second tab', function() {
            $('.tabs ul li', this.region.el).eq(1).click();
            $('.tabs ul li', this.region.el).eq(2).click();
            $('.tabs ul li', this.region.el).eq(1).click();
            return expect($('.tab-content div>div', this.region.el).html()).toEqual("Tab 2 Content");
          });
        });
      });
      return describe('when making an App Request without destroy option false', function() {
        beforeEach(function() {
          var controller;
          controller = Pro.request('tabs:component', {
            tabs: [
              {
                name: "Tab 1 Header",
                view: tab1
              }, {
                name: "Tab 2 Header",
                view: tab2
              }, {
                name: "Tab 3 Header",
                view: tab3
              }
            ],
            destroy: false
          });
          return controller.show(controller.getMainView(), {
            region: this.region
          });
        });
        it('renders with tabs', function() {
          return expect($('.tabs ul li', this.region.el).length).toEqual(3);
        });
        return describe('when switching tabs', function() {
          it('renders the initial tab', function() {
            return expect($('.tab-content div:visible>div>div', this.region.el).html()).toEqual("Tab 1 Content");
          });
          describe('when rendering the second tab', function() {
            return it('renders the tab', function() {
              $('.tabs ul li', this.region.el).eq(1).click();
              return expect($('.tab-content div:visible>div>div', this.region.el).html()).toEqual("Tab 2 Content");
            });
          });
          describe('when rendering the third tab', function() {
            return it('renders the tab', function() {
              $('.tabs ul li', this.region.el).eq(1).click();
              $('.tabs ul li', this.region.el).eq(2).click();
              return expect($('.tab-content div:visible>div>div', this.region.el).html()).toEqual("Tab 3 Content");
            });
          });
          return describe('when restoring the second tab', function() {
            beforeEach(function() {
              $('.tabs ul li', this.region.el).eq(1).click();
              $('.tabs ul li', this.region.el).eq(2).click();
              return $('.tabs ul li', this.region.el).eq(1).click();
            });
            it('restores the tab', function() {
              return expect($('.tab-content div:visible>div>div', this.region.el).html()).toEqual("Tab 2 Content");
            });
            return it('hides all other tabs', function() {
              var nodes;
              nodes = $('.tab-content > div');
              return expect($('.tab-content > div:hidden')).toHaveNodes([nodes[0], nodes[2]]);
            });
          });
        });
      });
    });
  });

}).call(this);
