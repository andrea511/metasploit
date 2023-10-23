(function() {

  define(['jquery', 'lib/components/table/table_controller', 'lib/components/filter/filter_controller'], function($) {
    return describe('Pro.Concerns.ProCarpenter', function() {
      set('Model', function() {
        return Backbone.Model.extend();
      });
      set('Collection', function() {
        return Backbone.Collection.extend({
          model: Model
        });
      });
      set('collection', function() {
        return new Collection([]);
      });
      beforeEach(function() {
        var _this = this;
        this.$el = $("<div />", {
          id: 'table-region'
        }).appendTo($('body'));
        this.region = new Backbone.Marionette.Region({
          el: this.$el
        });
        return this.renderTable = function(opts) {
          var controller, defaultOpts;
          defaultOpts = {
            collection: collection,
            region: _this.region,
            "static": true
          };
          _.defaults(opts, defaultOpts);
          controller = Pro.request("table:component", opts);
          return controller.show(controller.getMainView(), {
            region: _this.region
          });
        };
      });
      afterEach(function() {
        var _ref;
        this.region.reset();
        return (_ref = this.$el) != null ? _ref.remove() : void 0;
      });
      return describe('when making an App Request', function() {
        describe('when passing filterOpts', function() {
          return it('renders the Carpenter table with a search filter', function() {
            this.renderTable({
              filterOpts: {
                keys: ['foo', 'bar']
              }
            });
            return expect($('.filter-component', this.region.el).length).toEqual(1);
          });
        });
        return describe('when not passing any filterOpts', function() {
          return it('renders the Carpenter table with a search filter', function() {
            this.renderTable;
            return expect($('.filter-component', this.region.el).length).toEqual(0);
          });
        });
      });
    });
  });

}).call(this);
