(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview', 'lib/components/analysis_tab/templates/layout', 'lib/components/analysis_tab/templates/empty', 'lib/components/table/table_view'], function() {
    return this.Pro.module('Components.AnalysisTab', function(AnalysisTab, App, Backbone, Marionette, $, _) {
      AnalysisTab.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('analysis_tab/layout');

        Layout.prototype.regions = {
          buttonsRegion: '#action-buttons-region',
          analysisTabsRegion: '#analysis-tabs-region',
          pushButtonRegion: 'a.nexpose-push'
        };

        Layout.prototype.onRender = function() {
          var has_workspace_web_vulns, path;
          path = window.location.pathname;
          if (path.indexOf('hosts') > 0) {
            this.$el.find('li.tab a.hosts').addClass('active');
          } else if (path.indexOf('notes') > 0) {
            this.$el.find('li.tab a.notes').addClass('active');
          } else if (path.indexOf('services') > 0) {
            this.$el.find('li.tab a.services').addClass('active');
          } else if (path.indexOf('vulns') > 0) {
            if (path.indexOf('web_vulns') > 0) {
              this.$el.find('li.tab a.web-vulnerabilities').addClass('active');
            } else {
              this.$el.find('li.tab a.vulnerabilities').addClass('active');
            }
          } else if (path.indexOf('loots') > 0) {
            this.$el.find('li.tab a.loots').addClass('active');
          } else if (path.indexOf('modules') > 0) {
            this.$el.find('li.tab a.modules').addClass('active');
          }
          has_workspace_web_vulns = $(document.body).find('ul.nav_tabs ul.sub-menu li a.web-vulnerabilities').length > 0;
          if (!has_workspace_web_vulns) {
            return this.$el.find('li.tab a.web-vulnerabilities').parent().remove();
          }
        };

        return Layout;

      })(App.Views.Layout);
      AnalysisTab.TableEmptyView = (function(_super) {

        __extends(TableEmptyView, _super);

        function TableEmptyView() {
          return TableEmptyView.__super__.constructor.apply(this, arguments);
        }

        TableEmptyView.prototype.tagName = 'tr';

        TableEmptyView.prototype.className = 'empty';

        TableEmptyView.prototype.template = TableEmptyView.prototype.templatePath('analysis_tab/empty');

        TableEmptyView.prototype.emptyText = 'No items were found.';

        TableEmptyView.prototype.serializeData = function() {
          return {
            emptyText: this.emptyText
          };
        };

        return TableEmptyView;

      })(App.Views.ItemView);
      return App.reqres.setHandler('analysis_tab:empty_view', function(opts) {
        if (opts == null) {
          opts = {};
        }
        if (opts.emptyText) {
          return (function(_super) {

            __extends(_Class, _super);

            function _Class() {
              return _Class.__super__.constructor.apply(this, arguments);
            }

            _Class.prototype.emptyText = opts.emptyText;

            return _Class;

          })(AnalysisTab.TableEmptyView);
        } else {
          return AnalysisTab.TableEmptyView;
        }
      });
    });
  });

}).call(this);
