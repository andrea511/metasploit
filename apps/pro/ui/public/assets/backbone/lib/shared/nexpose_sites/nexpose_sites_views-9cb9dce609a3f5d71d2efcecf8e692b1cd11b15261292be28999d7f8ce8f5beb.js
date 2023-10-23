(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'lib/shared/nexpose_sites/templates/view', 'lib/components/table/table_controller', 'lib/shared/nexpose_sites/templates/sites_filter', 'lib/components/filter/filter_controller'], function() {
    return this.Pro.module('Shared.NexposeSites', function(NexposeSites, App, Backbone, Marionette, $, _) {
      return NexposeSites.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('nexpose_sites/view');

        Layout.prototype.regions = {
          siteRegion: '.site-region',
          filterRegion: '.filter-region'
        };

        Layout.prototype.initialize = function(opts) {
          _.defaults(opts, {
            htmlID: 'nexpose-sites'
          });
          return this.collection = opts.collection, this.htmlID = opts.htmlID, opts;
        };

        Layout.prototype.onShow = function() {
          this._renderSitesTable(this.collection, this.siteRegion, {
            filterOpts: {
              filterValuesEndpoint: Routes.filter_values_workspace_nexpose_data_sites_path(WORKSPACE_ID),
              helpEndpoint: Routes.search_operators_workspace_nexpose_data_sites_path(WORKSPACE_ID),
              keys: ['name'],
              filterRegion: this.getRegion('filterRegion')
            },
            htmlID: this.htmlID
          });
          return this.listenTo(this, 'filter:query:new', function(query) {
            return this.table.applyCustomFilter(query);
          });
        };

        Layout.prototype._renderSitesTable = function(collection, region, opts) {
          var columns, extraColumns;
          if (opts == null) {
            opts = {};
          }
          extraColumns = opts.extraColumns || [];
          columns = _.union([
            {
              label: 'Name',
              attribute: 'name'
            }, {
              label: 'Assets',
              attribute: 'summary.assets_count',
              sortable: false
            }, {
              label: 'Vulns',
              attribute: 'summary.critical_vulnerabilities_count',
              sortable: false
            }, {
              label: 'Last Scan',
              attribute: 'last_scan_date'
            }
          ], extraColumns);
          this.table = App.request("table:component", _.extend({
            region: region,
            taggable: true,
            selectable: true,
            "static": false,
            collection: collection,
            htmlID: opts.htmlID,
            perPage: 100,
            defaultSort: 'public.username',
            columns: columns
          }, opts));
          this.trigger('table:initialized');
          return this.table;
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
