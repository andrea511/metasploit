(function() {

  define(['jquery', 'lib/components/lazy_list/lazy_list_controller', '/assets/support/matchers/to_contain_node_with_text.js'], function($) {
    return describe('Components.LazyList.Controller', function() {
      var checkLoadMoreVisible, getIdsFromUrl, numItemsVisible;
      set('textMatcher', function() {
        return 'Beware the Lambda.';
      });
      set('Model', function() {
        return Backbone.Model.extend();
      });
      set('Collection', function() {
        return Backbone.Collection.extend({
          model: Model,
          url: '/models'
        });
      });
      set('collection', function() {
        return new Collection([]);
      });
      set('ids', function() {
        return [];
      });
      set('perPage', function() {
        return 20;
      });
      set('itemView', function() {
        return Backbone.Marionette.ItemView.extend({
          template: function() {
            return textMatcher;
          }
        });
      });
      set('loadMoreLabel', function() {
        return 'Load Some More On It';
      });
      set('$el', function() {
        return $("<div />", {
          id: 'table-region'
        }).appendTo($('body'));
      });
      set('region', function() {
        var region;
        return region = new Backbone.Marionette.Region({
          el: $el
        });
      });
      set('controllerOpts', function() {
        return {
          collection: collection,
          ids: ids,
          loadMoreLabel: loadMoreLabel,
          childView: itemView,
          perPage: perPage,
          region: region
        };
      });
      set('controller', function() {
        return Pro.request("lazy_list:component", controllerOpts);
      });
      set('server', function() {
        var server;
        server = sinon.fakeServer.create();
        server.respondWith(function(req) {
          var ids, jsonBlob;
          ids = getIdsFromUrl(arguments[0].url);
          jsonBlob = JSON.stringify(_.map(ids, function(id) {
            return {
              id: id,
              a1: 'j',
              a2: 'k'
            };
          }));
          return req.respond(200, {
            'Content-type': 'application/json'
          }, jsonBlob);
        });
        return server;
      });
      getIdsFromUrl = function(url, url_prefix_matcher) {
        var matches, url_regex;
        if (url_prefix_matcher == null) {
          url_prefix_matcher = "with_ids";
        }
        url_regex = new RegExp("\\?" + url_prefix_matcher + "=(.*)$");
        matches = url.match(url_regex);
        if (!matches) {
          throw "No match for '" + url_prefix_matcher + "' in URL";
        }
        return decodeURIComponent(matches[1]).split(',');
      };
      numItemsVisible = function() {
        return controller.region.$el.html().match(new RegExp(textMatcher, 'g')).length;
      };
      checkLoadMoreVisible = function(shouldBeVisible) {
        waits(10);
        return runs(function() {
          if (shouldBeVisible) {
            return expect(controller.region.$el).toContainNodeWithText(loadMoreLabel);
          } else {
            return expect(controller.region.$el).not.toContainNodeWithText(loadMoreLabel);
          }
        });
      };
      beforeEach(function() {
        return server;
      });
      afterEach(function() {
        var emptyView;
        emptyView = Backbone.Marionette.ItemView.extend({
          template: function() {
            return "";
          }
        });
        region.show(new emptyView(), {
          preventDestroy: true
        });
        region.reset();
        $el.remove();
        return server.restore();
      });
      return describe('when calling App.request "lazy_list:component", view', function() {
        it('renders something', function() {
          return expect(controller.region.$el.children.length).toBeGreaterThan(0);
        });
        it('mixes the #loadMore method into the passed :collection', function() {
          return expect(controller.collection.loadMore).toBeDefined();
        });
        describe('when given an "ids" option of [1,2,3]', function() {
          set('ids', function() {
            return [1, 2, 3];
          });
          it('adds the .collection-loading class', function() {
            return expect(controller.region.$el.find('.collection-loading').length).toBeGreaterThan(0);
          });
          it('sets the listView.collection-loading property to true', function() {
            return expect(controller.listView.loading).toEqual(true);
          });
          return describe('after receiving a response from the server', function() {
            beforeEach(function() {
              controller;
              return server.respond();
            });
            it('removes the .collection-loading class', function() {
              return expect(controller.region.$el.find('.collection-loading').length).toEqual(0);
            });
            it('sets the listView.collection-loading property to false', function() {
              return expect(controller.listView.loading).toEqual(false);
            });
            it('renders three rows, one for each model', function() {
              return expect(numItemsVisible()).toEqual(ids.length);
            });
            return it('does not display a "Load More" row', function() {
              return checkLoadMoreVisible(false);
            });
          });
        });
        return describe('when given an "ids" property of [1..100]', function() {
          set('ids', function() {
            var _i, _results;
            return (function() {
              _results = [];
              for (_i = 1; _i <= 100; _i++){ _results.push(_i); }
              return _results;
            }).apply(this);
          });
          it('adds the .collection-loading class', function() {
            return expect(controller.region.$el.find('.collection-loading').length).toBeGreaterThan(0);
          });
          it('sets the listView.collection-loading property to true', function() {
            return expect(controller.listView.loading).toEqual(true);
          });
          return describe('after receiving a response from the server', function() {
            beforeEach(function() {
              controller;
              return server.respond();
            });
            it('removes the .collection-loading class', function() {
              return expect(controller.region.$el.find('.collection-loading').length).toEqual(0);
            });
            it('sets the listView.collection-loading property to false', function() {
              return expect(controller.listView.loading).toEqual(false);
            });
            describe('when perPage is twenty', function() {
              set('perPage', function() {
                return 20;
              });
              it('renders twenty items', function() {
                return expect(numItemsVisible()).toEqual(perPage);
              });
              it('displays a "Load More" row', function() {
                return checkLoadMoreVisible(true);
              });
              return describe('after clicking "Load More"', function() {
                beforeEach(function() {
                  var _ref;
                  return (_ref = controller.loadMoreView.$el) != null ? _ref.click() : void 0;
                });
                it('adds the .collection-loading class', function() {
                  return expect(controller.region.$el.find('.collection-loading').length).toBeGreaterThan(0);
                });
                it('sets the listView.collection-loading property to true', function() {
                  return expect(controller.listView.loading).toEqual(true);
                });
                return describe('and the server responds', function() {
                  beforeEach(function() {
                    return server.respond();
                  });
                  it('removes the .collection-loading class', function() {
                    return expect(controller.region.$el.find('.collection-loading').length).toEqual(0);
                  });
                  it('sets the listView.collection-loading property to false', function() {
                    return expect(controller.listView.loading).toEqual(false);
                  });
                  return it('displays forty items', function() {
                    return expect(numItemsVisible()).toEqual(40);
                  });
                });
              });
            });
            describe('when perPage is five', function() {
              set('perPage', function() {
                return 5;
              });
              it('renders five items', function() {
                return expect(numItemsVisible()).toEqual(perPage);
              });
              it('displays a "Load More" row', function() {
                return checkLoadMoreVisible(true);
              });
              return describe('after clicking "Load More"', function() {
                beforeEach(function() {
                  var _ref;
                  return (_ref = controller.loadMoreView.$el) != null ? _ref.click() : void 0;
                });
                it('adds the .collection-loading class', function() {
                  return expect(controller.region.$el.find('.collection-loading').length).toBeGreaterThan(0);
                });
                it('sets the listView.collection-loading property to true', function() {
                  return expect(controller.listView.loading).toEqual(true);
                });
                return describe('and the server responds', function() {
                  beforeEach(function() {
                    return server.respond();
                  });
                  it('removes the .collection-loading class', function() {
                    return expect(controller.region.$el.find('.collection-loading').length).toEqual(0);
                  });
                  it('sets the listView.collection-loading property to false', function() {
                    return expect(controller.listView.loading).toEqual(false);
                  });
                  it('displays ten items', function() {
                    return expect(numItemsVisible()).toEqual(10);
                  });
                  return it('displays a "Load More" row', function() {
                    return checkLoadMoreVisible(true);
                  });
                });
              });
            });
            return describe('when perPage is 100', function() {
              set('perPage', function() {
                return 100;
              });
              it('renders 100 items', function() {
                return expect(numItemsVisible()).toEqual(perPage);
              });
              return it('does not display a "Load More" row', function() {
                return checkLoadMoreVisible(false);
              });
            });
          });
        });
      });
    });
  });

}).call(this);
