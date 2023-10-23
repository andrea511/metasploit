(function() {

  define(['entities/task', '/assets/support/matchers/to_be_an_instance_of.js'], function($) {
    return describe('Entities.Task', function() {
      set('taskOptions', function() {
        return {};
      });
      set('task', function() {
        return new Pro.Entities.Task(taskOptions);
      });
      return describe('the #run_stats attribute', function() {
        describe('when a Task initialized with no options', function() {
          set('taskOptions', function() {
            return {
              schema: []
            };
          });
          it('is a Pro.Entities.RunStatsCollection', function() {
            return expect(task.get('run_stats')).toBeAnInstanceOf(Pro.Entities.RunStatsCollection);
          });
          it('is an empty collection', function() {
            return expect(task.get('run_stats').models.length).toEqual(0);
          });
          describe('and #run_stats is set to an array containing 2 hashes', function() {
            var add_stats;
            add_stats = function() {
              return task.set('run_stats', [
                {
                  name: 'a'
                }, {
                  name: 'b'
                }
              ]);
            };
            it('is a Pro.Entities.RunStatsCollection', function() {
              add_stats();
              return expect(task.get('run_stats')).toBeAnInstanceOf(Pro.Entities.RunStatsCollection);
            });
            it('is an collection with 2 models', function() {
              add_stats();
              return expect(task.get('run_stats').models.length).toEqual(2);
            });
            it('fires 2 add events', function() {
              var add_events;
              add_events = 0;
              task.get('run_stats').on('add', function() {
                return add_events++;
              });
              add_stats();
              return expect(add_events).toEqual(2);
            });
            return describe('and #run_stats is reset to an empty array', function() {
              var remove_stats;
              remove_stats = function() {
                return task.set('run_stats', []);
              };
              return xit('fires 2 remove events', function() {});
            });
          });
          return describe('and using the hash-style set(), #run_stats is set to an array containing 2 hashes', function() {
            var add_stats;
            add_stats = function() {
              return task.set({
                run_stats: [
                  {
                    name: 'a'
                  }, {
                    name: 'b'
                  }
                ]
              });
            };
            it('is a Pro.Entities.RunStatsCollection', function() {
              add_stats();
              return expect(task.get('run_stats')).toBeAnInstanceOf(Pro.Entities.RunStatsCollection);
            });
            it('is an collection with 2 models', function() {
              add_stats();
              return expect(task.get('run_stats').models.length).toEqual(2);
            });
            return it('fires 2 add events', function() {
              var add_events;
              add_events = 0;
              task.get('run_stats').on('add', function() {
                return add_events++;
              });
              add_stats();
              return expect(add_events).toEqual(2);
            });
          });
        });
        describe('when a Task initialized with a #run_stats attribute containing 2 hashes', function() {
          set('taskOptions', function() {
            return {
              run_stats: [
                {
                  name: 'a'
                }, {
                  name: 'b'
                }
              ]
            };
          });
          it('is a Pro.Entities.RunStatsCollection', function() {
            return expect(task.get('run_stats')).toBeAnInstanceOf(Pro.Entities.RunStatsCollection);
          });
          return it('is is a collection with 2 models', function() {
            return expect(task.get('run_stats').models.length).toEqual(2);
          });
        });
        return describe('when a Task is fetched via AJAX', function() {
          set('taskData', function() {
            return {
              id: 1,
              workspace_id: 5
            };
          });
          set('time', function() {
            return (new Date).getTime();
          });
          beforeEach(function() {
            this.server = sinon.fakeServer.create();
            this.server.respondWith(/.*/, [
              200, {
                "Content-Type": "application/json"
              }, JSON.stringify(taskData)
            ]);
            return task.fetch();
          });
          afterEach(function() {
            return this.server.restore();
          });
          describe('when the ajax response contains a :run_stats key', function() {
            set('taskData', function() {
              return {
                run_stats: [
                  {
                    id: 1,
                    name: 'a',
                    data: 1,
                    workspace_id: 5
                  }
                ]
              };
            });
            it('is a Pro.Entities.RunStatsCollection', function() {
              this.server.respond();
              return expect(task.get('run_stats')).toBeAnInstanceOf(Pro.Entities.RunStatsCollection);
            });
            return it('is a collection containing one model', function() {
              this.server.respond();
              return expect(task.get('run_stats').models.length).toEqual(1);
            });
          });
          return describe('when the ajax response contains a :now key', function() {
            set('taskData', function() {
              return {
                id: 2,
                name: 'b',
                now: time,
                workspace_id: 5
              };
            });
            it('saves the :now key in the Model', function() {
              this.server.respond();
              return expect(task.get('now')).toBeDefined();
            });
            return describe('then fetch() is called again', function() {
              beforeEach(function() {
                return this.server.respond();
              });
              return it('sends back the time in the :since key', function() {
                task.fetch();
                expect(this.server.queue[0].url).toMatch(/\?since=\d+/);
                return this.server.respond();
              });
            });
          });
        });
      });
    });
  });

}).call(this);
