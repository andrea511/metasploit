(function() {

  define(['jquery', 'apps/tasks/show/show_controller', 'entities/task', '/assets/support/matchers/to_have_class.js', '/assets/support/matchers/to_contain_text.js'], function($) {
    return describe('TasksApp.Show.Controller', function() {
      Pro.module('TasksApp.Findings', function(Findings, App) {
        return Findings.BruteForceReuse = {
          stats: [
            {
              name: 'login_attempts',
              type: 'percentage',
              num: 'logins_tried',
              total: 'total_logins'
            }
          ]
        };
      });
      set('completed_at', function() {
        return null;
      });
      set('presenter', function() {
        return 'brute_force_reuse';
      });
      set('run_stats', function() {
        return [
          {
            name: 'logins_tried',
            data: 40
          }, {
            name: 'total_logins',
            data: 50
          }
        ];
      });
      set('state', function() {
        return 'Running';
      });
      set('task', function() {
        return {
          presenter: presenter,
          completed_at: completed_at,
          state: state,
          run_stats: run_stats
        };
      });
      beforeEach(function() {
        this.server = sinon.fakeServer.create();
        this.server.respondWith(/\/tasks\/\d+\.json/, [
          200, {
            "Content-Type": "application/json"
          }, JSON.stringify(task)
        ]);
        this.regionEl = $('<div />', {
          "class": 'tab-loading'
        }).appendTo($('body'))[0];
        this.region = new Backbone.Marionette.Region({
          el: this.regionEl
        });
        this.task = new Pro.Entities.Task({
          id: 1,
          workspace_id: 1
        });
        return this.controller = new Pro.TasksApp.Show.Controller({
          task: this.task,
          region: this.region
        });
      });
      afterEach(function() {
        var _ref;
        this.server.restore();
        this.region.reset();
        return (_ref = $(this.regionEl)) != null ? typeof _ref.remove === "function" ? _ref.remove() : void 0 : void 0;
      });
      it('should render', function() {
        this.server.respond();
        return expect($(this.regionEl).children().length).toBeGreaterThan(0);
      });
      describe('before the server responds', function() {
        return it('has the "tab-loading" class', function() {
          return expect(this.region.el).toHaveClass('tab-loading');
        });
      });
      return describe('after the server responds', function() {
        beforeEach(function() {
          return this.server.respond();
        });
        it('removes the "tab-loading" class', function() {
          return expect(this.region.el).not.toHaveClass('tab-loading');
        });
        it('selects the "Statistics" tab', function() {
          return expect(this.controller.layout.ui.tabContainer.find('li.selected')).toContainText('Statistics');
        });
        describe('when rendering a task that is running', function() {
          set('state', function() {
            return 'Running';
          });
          return it('displays the running status', function() {
            return expect(this.region.$el).toContainNodeWithText('Running');
          });
        });
        describe('when rendering a task that is completed', function() {
          set('state', function() {
            return 'Finished';
          });
          return it('displays the finished status', function() {
            return expect(this.region.el).toContainNodeWithText('Finished');
          });
        });
        describe('when the user clicks the "Task Log" tab', function() {
          beforeEach(function() {
            return this.region.$el.find(':contains(Task Log)').click();
          });
          return it('selects the "Task Log" tab', function() {
            return expect(this.controller.layout.ui.tabContainer.find('li.selected')).toContainText('Task Log');
          });
        });
        return describe('when the task has a :run_stats hash', function() {
          return describe('with a percentage stat', function() {
            it('creates a RunStatsCollection association on the Task model', function() {
              return expect(this.controller.task.get('run_stats')).toBeAnInstanceOf(Pro.Entities.RunStatsCollection);
            });
            return it('renders the text "40/50"', function() {
              return expect(this.region.el).toContainText('40/50');
            });
          });
        });
      });
    });
  });

}).call(this);
