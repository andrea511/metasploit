(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(['jquery', 'base_itemview', 'visualsearch', 'css!visualsearch-datauri', 'lib/components/filter/templates/filter', 'lib/components/filter/help_view', 'lib/components/modal/modal_controller'], function($) {
    return this.Pro.module("Components.Filter", function(Filter, App) {
      return Filter.FilterView = (function(_super) {

        __extends(FilterView, _super);

        function FilterView() {
          return FilterView.__super__.constructor.apply(this, arguments);
        }

        FilterView.prototype.template = FilterView.prototype.templatePath("filter/filter");

        FilterView.prototype.ui = {
          container: '.filter-component',
          helpLink: '.help-icon'
        };

        FilterView.prototype.events = {
          'click @ui.helpLink': 'displayHelpModal',
          'focusin .VS-search-inner': 'expandField',
          'focusout .VS-search-inner': 'contractField'
        };

        FilterView.prototype.SORT_BY = {
          asc: 'asc',
          desc: 'desc'
        };

        FilterView.prototype.defaults = function() {
          var _this = this;
          return {
            container: this.ui.container,
            query: '',
            sortBy: this.SORT_BY.asc,
            autoFocusFacet: true,
            autoFocusValue: false,
            matchStartOfFacet: false,
            matchStartOfValue: false,
            enableFreeText: false,
            supportDotInFacet: true,
            filterValuesEndpoint: '',
            callbacks: {
              search: function(query, searchCollection) {
                _this.triggerQuery(_this._rewriteQuery(query));
                return _this.$VSsearch.removeClass('animating');
              },
              facetMatches: function(callback) {
                if (_this.$VSsearch.hasClass('animating')) {
                  return _this.$VSsearch.one("webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend", function() {
                    _this.$VSsearch.removeClass('animating');
                    return callback(_this.options.keys);
                  });
                } else {
                  return callback(_this.options.keys);
                }
              },
              valueMatches: function(facet, searchTerm, callback) {
                var statics;
                if (facet === 'address') {
                  searchTerm = _this.parseAddress(searchTerm);
                }
                statics = _this.staticFacets ? Object.keys(_this.staticFacets) : [];
                if (__indexOf.call(statics, facet) >= 0) {
                  return callback(_this.staticFacets[facet]);
                } else {
                  return _this._fetchValues(facet, searchTerm, callback);
                }
              }
            }
          };
        };

        FilterView.prototype.initialize = function(options) {
          this.staticFacets = this.options.staticFacets;
          return this.collection = this.options.collection;
        };

        FilterView.prototype.parseAddress = function(searchTerm) {
          var addrFragments;
          addrFragments = _.without(searchTerm.split('.'), "");
          switch (addrFragments.length) {
            case 1:
              searchTerm = "" + addrFragments[0] + ".0.0.0/8";
              break;
            case 2:
              searchTerm = "" + addrFragments[0] + "." + addrFragments[1] + ".0.0/16";
              break;
            case 3:
              searchTerm = "" + addrFragments[0] + "." + addrFragments[1] + "." + addrFragments[2] + ".0/24";
          }
          return searchTerm;
        };

        FilterView.prototype.expandField = function() {
          if (!this.$VSsearch.hasClass('expanded')) {
            return this.$VSsearch.addClass('expanded animating');
          }
        };

        FilterView.prototype.contractField = function() {
          if (this.currentQuery() === "") {
            return this.ui.container.find('.VS-search').removeClass('expanded');
          }
        };

        FilterView.prototype.setOptions = function(options) {
          var opts;
          opts = this.options.filterOpts || this.options;
          _.defaults(opts, this.defaults());
          this.options = opts;
          this.filterValuesEndpoint = this.options.filterValuesEndpoint;
          return this.helpEndpoint = this.options.helpEndpoint;
        };

        FilterView.prototype.helpUrl = function() {
          if (!(this.helpEndpoint || this.collection)) {
            throw "helpEndpoint or collection must be provided in options";
          }
          return this.helpEndpoint || this.collection.url.replace(/(\.json)|(\/)$/, '') + '/search_operators.json';
        };

        FilterView.prototype.displayHelpModal = function() {
          var HelpModel, help, keys,
            _this = this;
          HelpModel = Backbone.Model.extend({
            url: function() {
              return _this.helpUrl();
            }
          });
          help = new HelpModel();
          keys = this._keysToString(this.options.keys);
          return App.execute('showModal', new App.Filters.HelpView({
            model: help,
            whitelist: keys
          }), {
            modal: {
              title: 'Search Filters',
              description: '',
              width: 600,
              height: 600
            },
            buttons: [
              {
                name: 'Close',
                "class": 'close primary btn'
              }
            ]
          });
        };

        FilterView.prototype._keysToString = function(keys) {
          return _.map(keys, function(key) {
            return key.value || key;
          });
        };

        FilterView.prototype.currentQuery = function(lastKey) {
          var query;
          query = lastKey ? this._clearLastQuery(lastKey) : this.searchBox.currentQuery;
          return this._rewriteQuery(query);
        };

        FilterView.prototype._clearLastQuery = function(lastKey) {
          var matcher, re;
          re = "\\s" + lastKey + ".*$";
          matcher = new RegExp(re, 'i');
          return this.searchBox.currentQuery.replace(matcher, '');
        };

        FilterView.prototype._fetchValues = function(key, searchTerm, callback) {
          var data, enteredQuery, nextQuery, parts;
          if (_.isBlank(searchTerm)) {
            return;
          }
          searchTerm = '\"' + searchTerm + '\"';
          nextQuery = searchTerm === "" ? "" : " " + key + ":" + searchTerm;
          enteredQuery = this.currentQuery(key) + nextQuery;
          data = {
            search: {
              custom_query: enteredQuery
            }
          };
          parts = key.split('.');
          data.ignore_pagination = true;
          data.column = parts.pop();
          data.prefix = parts.pop();
          data.sort_by = "" + key + " " + this.options.sortBy;
          return $.getJSON(this.filterValuesEndpoint, data, function(data, status) {
            return callback(data);
          });
        };

        FilterView.prototype._rewriteQuery = function(query) {
          var parsedQuery;
          parsedQuery = this._rewriteAddrQuery(query);
          return parsedQuery.replace(/\:\s/g, ':');
        };

        FilterView.prototype._rewriteAddrQuery = function(query) {
          var _this = this;
          this.visualSearch.searchQuery.each(function(model) {
            if (model.get('category') === 'address') {
              return model.set('value', _this.parseAddress(model.get('value')));
            }
          });
          return this.visualSearch.searchBox.serialize();
        };

        FilterView.prototype.onRender = function() {
          this.setOptions();
          this.resetVisualSearchTemplates();
          this.visualSearch = VS.init(this.options);
          this.searchBox = this.visualSearch.searchBox;
          return this.$VSsearch = this.searchBox.$el.find('.VS-search');
        };

        FilterView.prototype.triggerQuery = function(query) {
          return this.trigger('filter:query:new', query);
        };

        FilterView.prototype.resetVisualSearchTemplates = function() {
          var originalTemplateSettings;
          originalTemplateSettings = _.templateSettings;
          _.templateSettings = {
            evaluate: /<%([\s\S]+?)%>/g,
            interpolate: /<%=([\s\S]+?)%>/g,
            escape: /<%-([\s\S]+?)%>/g
          };
          window.JST['search_box'] = this.searchBoxTemplate();
          window.JST['search_facet'] = this.searchFacetTemplate();
          window.JST['search_input'] = this.searchInputTemplate();
          return _.templateSettings = originalTemplateSettings;
        };

        FilterView.prototype.searchBoxTemplate = function() {
          return _.template("<div class=\"VS-search <% if (readOnly) { %>VS-readonly<% } %>\">\n  <div class=\"VS-search-box-wrapper VS-search-box\">\n    <div class=\"VS-icon VS-icon-search\"></div>\n    <div class=\"VS-placeholder\"></div>\n    <div class=\"VS-search-inner\"></div>\n    <div class=\"VS-icon VS-icon-cancel VS-cancel-search-box\" title=\"clear search\"></div>\n  </div>\n</div>");
        };

        FilterView.prototype.searchFacetTemplate = function() {
          return _.template("<% if (model.has(\'category\')) { %>\n  <div class=\"category\"><%= model.get(\'category\') %>:</div>\n<% } %>\n\n<div class=\"search_facet_input_container\">\n  <input type=\"text\" class=\"search_facet_input ui-menu VS-interface\" value=\"\" <% if (readOnly) { %>disabled=\"disabled\"<% } %> />\n</div>\n\n<div class=\"search_facet_remove VS-icon VS-icon-cancel\"></div>");
        };

        FilterView.prototype.searchInputTemplate = function() {
          return _.template("<input type=\"text\" class=\"ui-menu\" <% if (readOnly) { %>disabled=\"disabled\"<% } %> />");
        };

        return FilterView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
