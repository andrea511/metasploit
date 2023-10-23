(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview', 'lib/components/pro_search_filter/templates/filter', 'css!css/components/pro_search_filter'], function($) {
    return this.Pro.module("Components.ProSearchFilter", function(ProSearchFilter, App) {
      return ProSearchFilter.FilterView = (function(_super) {

        __extends(FilterView, _super);

        function FilterView() {
          return FilterView.__super__.constructor.apply(this, arguments);
        }

        FilterView.prototype.template = FilterView.prototype.templatePath("pro_search_filter/filter");

        FilterView.prototype.ui = {
          container: '.filter-component',
          input: 'input',
          cancelButton: '.cancel-search'
        };

        FilterView.prototype.events = {
          'keyup @ui.input': 'inputChanged',
          'click @ui.cancelButton': 'cancelClicked'
        };

        FilterView.prototype.SORT_BY = {
          asc: 'asc',
          desc: 'desc'
        };

        FilterView.prototype.defaults = function() {
          return {
            container: this.ui.container,
            query: '',
            sortBy: this.SORT_BY.asc
          };
        };

        FilterView.prototype.initialize = function(options) {
          this.debouncedTriggerQuery = _.debounce(this._triggerQuery, 300);
          this.model = new Backbone.Model({
            placeHolderText: this.options.filterOpts.placeHolderText
          });
          return this.collection = this.options.collection;
        };

        FilterView.prototype.setOptions = function(options) {
          var opts;
          opts = this.options.filterOpts || this.options;
          _.defaults(opts, this.defaults());
          return this.options = opts;
        };

        FilterView.prototype.onRender = function() {
          return this.setOptions();
        };

        FilterView.prototype.inputChanged = function() {
          this._toggleCancelButton();
          return this.triggerQuery(this._inputText());
        };

        FilterView.prototype._inputText = function() {
          return this.ui.input.val();
        };

        FilterView.prototype._toggleCancelButton = function() {
          if (this._inputText() === '') {
            return this._hideCancelButton();
          } else {
            return this._showCancelButton();
          }
        };

        FilterView.prototype._hideCancelButton = function() {
          return this.ui.cancelButton.hide(200);
        };

        FilterView.prototype._showCancelButton = function() {
          return this.ui.cancelButton.show(200);
        };

        FilterView.prototype.cancelClicked = function() {
          this._clearInputText();
          return this.inputChanged();
        };

        FilterView.prototype._clearInputText = function() {
          return this.ui.input.val('');
        };

        FilterView.prototype.triggerQuery = function(query) {
          return this.debouncedTriggerQuery(query);
        };

        FilterView.prototype._triggerQuery = function(query) {
          return this.trigger('pro:search:filter:query:new', query);
        };

        return FilterView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
