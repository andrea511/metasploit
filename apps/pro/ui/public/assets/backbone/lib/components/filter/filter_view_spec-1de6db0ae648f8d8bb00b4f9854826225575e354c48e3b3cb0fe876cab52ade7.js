(function() {

  define(['jquery', 'lib/components/filter/filter_view', 'lib/components/filter/filter_controller', 'css!css/visualsearch-datauri'], function($) {
    return describe('Components.Filter.FilterView', function() {
      set('keys', function() {
        return ['foo', 'bar'];
      });
      set('staticFacets', function() {
        return {
          foo: [
            {
              value: 'fooValue',
              label: 'fooLabel'
            }
          ],
          bar: [
            {
              value: 'barValue',
              label: 'barLabel'
            }
          ]
        };
      });
      set('options', function() {
        return {
          keys: keys,
          staticFacets: staticFacets
        };
      });
      set('filterView', function() {
        return new Pro.Components.Filter.FilterView(options);
      });
      beforeEach(function() {
        this.$body = $('body');
        this.$el = $("<div />", {
          id: 'filter-region'
        }).appendTo(this.$body)[0];
        return this.region = new Backbone.Marionette.Region({
          el: this.$el
        });
      });
      afterEach(function() {
        var _ref;
        this.region.reset();
        if ((_ref = this.$el) != null) {
          _ref.remove();
        }
        return $('.ui-autocomplete').remove();
      });
      describe('with a keys property in the options object', function() {
        return it('correctly passes the options to VisualSearch', function() {
          var callback;
          callback = jasmine.createSpy('callback');
          filterView.render();
          filterView.visualSearch.options.callbacks.facetMatches(callback);
          return expect(callback.mostRecentCall.args[0]).toEqual(keys);
        });
      });
      describe('with a staticFacets property in the options object', function() {
        return it('correctly passes the options to VisualSearch', function() {
          var callback, facet, searchTerm;
          callback = jasmine.createSpy('callback');
          filterView.render();
          facet = 'foo';
          searchTerm = '';
          filterView.visualSearch.options.callbacks.valueMatches(facet, searchTerm, callback);
          return expect(callback.mostRecentCall.args[0]).toEqual(staticFacets.foo);
        });
      });
      describe('when a query is made in search box', function() {
        return it('triggers filter:query:new', function() {
          filterView.render();
          spyOn(filterView, 'trigger');
          filterView.options.callbacks.search('foo:bar');
          return expect(filterView.trigger).toHaveBeenCalledWith('filter:query:new', 'foo:bar');
        });
      });
      describe('ui events', function() {
        describe('help link', function() {
          beforeEach(function() {
            this.$dialogRegion = $('<div id="dialog-region"></div>');
            return this.$dialogRegion.appendTo(this.$el);
          });
          afterEach(function() {
            return Pro.execute('closeModal');
          });
          describe('when only helpEndpoint provided in options', function() {
            return it('clicking help link displays the modal', function() {
              options.helpEndpoint = '/search_operators.json';
              filterView.render();
              filterView.ui.helpLink.click();
              return expect(this.$dialogRegion.find('.modal').length).toEqual(1);
            });
          });
          describe('when ony collection provided', function() {
            return it('clicking help link displays the modal', function() {
              var collection;
              collection = new (Backbone.Collection.extend({
                url: '/cores'
              }));
              options.collection = collection;
              filterView.render();
              filterView.ui.helpLink.click();
              return expect(this.$dialogRegion.find('.modal').length).toEqual(1);
            });
          });
          return describe('when neither helpEndpoint nor collection provided', function() {
            return it('it should throw an error', function() {
              filterView.render();
              return expect(function() {
                return filterView.ui.helpLink.click();
              }).toThrow("helpEndpoint or collection must be provided in options");
            });
          });
        });
        return describe('searchbox field', function() {
          it('expands when focusing on searchbox', function() {
            var $innerSearchBox;
            filterView.render();
            $innerSearchBox = filterView.$el.find('.VS-search-inner');
            $innerSearchBox.focusin();
            return expect(filterView.$VSsearch.hasClass('expanded')).toEqual(true);
          });
          return it('contracts when focusing out of searchbox', function() {
            var $innerSearchBox;
            filterView.render();
            $innerSearchBox = filterView.$el.find('.VS-search-inner');
            $innerSearchBox.focusin();
            $innerSearchBox.focusout();
            return expect(filterView.$VSsearch.hasClass('expanded')).toEqual(false);
          });
        });
      });
      return describe('_fetchValues', function() {
        set('searchTerm', function() {
          return 'bar';
        });
        set('key', function() {
          return "public.username";
        });
        set('currentQuery', function() {
          return 'public.username:foo';
        });
        beforeEach(function() {
          var callback;
          spyOn($, 'getJSON');
          options.filterValuesEndpoint = '/cores.json';
          callback = jasmine.createSpy('callback');
          filterView.render();
          filterView.searchBox.currentQuery = currentQuery;
          filterView._fetchValues(key, searchTerm, callback);
          this.requestUrl = $.getJSON.mostRecentCall.args[0];
          return this.sentData = $.getJSON.mostRecentCall.args[1];
        });
        describe('with non-blank search term', function() {
          set('searchTerm', function() {
            return 'bar';
          });
          it('makes a json request', function() {
            return expect(this.requestUrl).toEqual('/cores.json');
          });
          it('sent data search.custom_query is correct', function() {
            return expect(this.sentData.search.custom_query).toEqual('public.username:foo public.username:bar');
          });
          it('sent data ignore_pagination is correct', function() {
            return expect(this.sentData.ignore_pagination).toEqual(true);
          });
          it('sent data prefix is correct', function() {
            return expect(this.sentData.prefix).toEqual('public');
          });
          it('sent data column is correct', function() {
            return expect(this.sentData.column).toEqual('username');
          });
          return it('sent data sort_by is correct', function() {
            return expect(this.sentData.sort_by).toEqual('public.username asc');
          });
        });
        return describe('with blank search term', function() {
          set('searchTerm', function() {
            return '';
          });
          it('makes a json request', function() {
            return expect(this.requestUrl).toEqual('/cores.json');
          });
          return it('sent data search.custom_query is correct', function() {
            return expect(this.sentData.search.custom_query).toEqual('public.username:foo');
          });
        });
      });
    });
  });

}).call(this);
