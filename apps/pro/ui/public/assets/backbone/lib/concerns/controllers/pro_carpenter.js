(function() {

  define(['lib/components/table/table_view'], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.ProCarpenter = {
        initialize: function() {
          var _this = this;
          if (this.filterOpts) {
            this.initializeFilter();
          }
          if (this["static"]) {
            this.collection.bootstrap();
          }
          this.collection.carpenterRadio = this.carpenterRadio;
          this.carpenterRadio.off('error:search');
          return this.carpenterRadio.on('error:search', function(message) {
            _this.collection.reset();
            return App.execute('flash:display', {
              title: 'Error in search',
              style: 'error',
              message: message || 'There is an error in your search terms.'
            });
          });
        },
        initializeFilter: function() {
          switch (this.filterOpts.searchType) {
            case 'pro':
              this.initializeProSearchFilter();
              break;
            default:
              this.initializeVisualSearchFilter();
          }
          return this.show(this.filter, {
            region: this.filterOpts.filterRegion != null ? this.filterOpts.filterRegion : this.getMainView().filterRegion
          });
        },
        initializeVisualSearchFilter: function() {
          var _this = this;
          if (this.search) {
            this.fetch = false;
            this.filterOpts.query = this.addWhiteSpaceToQuery(this.search);
          }
          this.staticFacets = this.filterOpts.staticFacets;
          this.filter = App.request('filter:component', this);
          if (this.search) {
            this.applyCustomFilter(this.search);
          }
          return this.listenTo(this.filter, 'filter:query:new', function(query) {
            _this.toggleInteraction(false);
            return _this.applyCustomFilter(query);
          });
        },
        initializeProSearchFilter: function() {
          var _this = this;
          this.filter = App.request('pro:search:filter:component', this);
          return this.listenTo(this.filter, 'pro:search:filter:query:new', function(query) {
            _this.toggleInteraction(false);
            return _this.applyProSearchFilter(query);
          });
        },
        applyCustomFilter: function(query) {
          return this.list.setSearch({
            attributes: {
              custom_query: query
            }
          });
        },
        applyProSearchFilter: function(query) {
          return this.list.setSearch({
            attributes: {
              pro_search_query: query
            }
          });
        },
        addWhiteSpaceToQuery: function(query) {
          return query.replace(/([^:]):([^:\s])/g, "$1: $2");
        },
        postTableState: function(opts) {
          var data, defaultOpts;
          data = {
            ui: true,
            selections: {
              select_all_state: this.tableSelections.selectAllState || null,
              selected_ids: Object.keys(this.tableSelections.selectedIDs),
              deselected_ids: Object.keys(this.tableSelections.deselectedIDs)
            },
            search: this.collection.server_api.search,
            ignore_pagination: true
          };
          opts.data || (opts.data = {});
          _.extend(opts.data, data);
          defaultOpts = {
            method: 'POST',
            url: _.result(this.collection, 'url'),
            dataType: 'json'
          };
          _.defaults(opts, defaultOpts);
          return $.ajax(opts);
        }
      };
    });
  });

}).call(this);
