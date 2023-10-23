(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/hosts/backbone/views/layouts/host_view_layout-a8c5bb3c7fa23021944fe10d7092d0df8ebff5d628af089bfa24aa93eeb9a26e.js', '/assets/hosts/backbone/views/item_views/host_stats_overview_item_view-9d23e02216fdfbc2bfcbc622f0a286b998a654e76c9c31d21b534b4cd1646f67.js', '/assets/hosts/backbone/views/layouts/tag_layout-966e4fb574af917a39055bb03b767b611a4c1b5142e4b26d4bc19f15f455a429.js', '/assets/shared/backbone/layouts/row_dropdown_layout-d7eb5e77dd727973872528cd743e94f2871afdbb96b04fd2118e1f14002a024d.js', '/assets/shared/backbone/layouts/tabs_layout-fb7b8503e9a0043ea7ec1c4160991a083b950fe41e26078183f66e3b886810ef.js', '/assets/hosts/backbone/views/layouts/services_layout-02dadc523d443dfd640cdbd96d74b9c4ce41f65d3e76544bd7a9ac7c1ce38ed9.js', '/assets/hosts/backbone/views/layouts/sessions_layout-e79680e538d1da981052eddf8d93c141e650a5163bf687035054d248266a6379.js', '/assets/hosts/backbone/views/layouts/vulnerabilities_layout-018b2b281698925c675962c3c4ea757b0aa9dd0679db31bdcf26b8d6524fab37.js', '/assets/hosts/backbone/views/layouts/web_vulnerabilities_layout-0fe4f91fc16b2abbf59e60219c75fa3e973c6727a76c3a188795774fd6daaf58.js', '/assets/hosts/backbone/views/layouts/credentials_layout-b7199ad885a6d83f197d27ba8aec0e96a89e021abdafe10f0b8d35074ef2b1d1.js', '/assets/hosts/backbone/views/layouts/captured_data_layout-9838b686d6561d5a054ba0a0d8371863adab1e80352e079c257dc4800300ec7e.js', '/assets/hosts/backbone/views/layouts/notes_layout-9f8bd2201ceca916cf0b00713102d09770f0bcf39635d3153db70abcd09fda57.js', '/assets/hosts/backbone/views/layouts/attempts_layout-8f3c874ce694ab01458af01399d6f5fbf0705aed907710eb62b9b70ec7a2470b.js', '/assets/hosts/backbone/views/layouts/modules_layout-33a87cac4e272cf6aba1d38181a74bfa2a0d093f4a00439edcade81596748c51.js', '/assets/hosts/backbone/views/layouts/history_layout-7082892deea7b5313b5989e8d3dd4ac4a1e16e6d3ce5a44e32bcb6e0e24512d0.js', '/assets/hosts/backbone/views/layouts/file_shares_layout-981ee549d7a24e26bd6e087bc0ca3655e80dc50831835b44d7a2d4ef313c74a3.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js', '/assets/hosts/backbone/models/single_host_presenter-55b1a02fc944d2272e2ac8bdd7e5fbd3c1fee448ecacc315e15eb8aad3870180.js', '/assets/hosts/backbone/models/host-75df51a08668a9a9cfe703a1f982afa60ba619dc2f4352fac14c9f9f4a4424dc.js'], function($, HostViewLayout, HostStatsOverviewItemView, TagLayout, RowDropdownLayout, TabsLayout, ServicesLayout, SessionsLayout, VulnerabilitiesLayout, WebVulnerabilitiesLayout, CredentialsLayout, CapturedDataLayout, NotesLayout, AttemptsLayout, ModulesLayout, HistoryLayout, FileSharesLayout, EventAggregator, SingleHostPresenter, Host) {
    var HostViewController;
    return HostViewController = (function(_super) {

      __extends(HostViewController, _super);

      function HostViewController() {
        this._fetchForever = __bind(this._fetchForever, this);

        this._update_url_by_tab = __bind(this._update_url_by_tab, this);

        this._display_tabs = __bind(this._display_tabs, this);

        this.Tab = __bind(this.Tab, this);
        return HostViewController.__super__.constructor.apply(this, arguments);
      }

      HostViewController.POLL_INTERVAL = 10000;

      HostViewController.prototype.initialize = function(_arg) {
        this.id = _arg.id;
        return window.HOST_ID = this.id;
      };

      HostViewController.prototype.Tab = function(tab, region) {
        this.region = region != null ? region : new Backbone.Marionette.Region({
          el: '#host-view'
        });
        this.tab = tab;
        this.show_region({
          region: this.region
        });
        this.show_host_view_layout(tab);
        return $(this.region.el).addClass('tab-loading');
      };

      HostViewController.prototype.show_region = function(_arg) {
        this.region = _arg.region;
        this.row_dropdown = new RowDropdownLayout({
          enabled: false
        });
        return this.region.show(this.row_dropdown);
      };

      HostViewController.prototype.show_host_view_layout = function(tab) {
        var presenter,
          _this = this;
        presenter = new SingleHostPresenter({
          id: this.id
        });
        return presenter.fetch({
          success: function(presenter) {
            $(_this.region.el).removeClass('tab-loading');
            _this._show_header(new Host(presenter.get('host')));
            _this._display_tabs(presenter);
            _this._bind_events();
            return _this._fetchForever(presenter);
          }
        });
      };

      HostViewController.prototype._show_header = function(host) {
        this.row_dropdown.header.show(new HostViewLayout({}));
        this.row_dropdown.header.currentView.host_stats_overview.show(new HostStatsOverviewItemView({
          model: host
        }));
        return this.row_dropdown.header.currentView.tags.show(new TagLayout({
          host: host
        }));
      };

      HostViewController.prototype._display_tabs = function(presenter) {
        var tab_layout, tab_model;
        tab_model = new Backbone.Model({
          tabs: [
            {
              name: 'Services',
              view: ServicesLayout,
              count: presenter.get('tab_counts').services
            }, {
              name: 'Sessions',
              view: SessionsLayout,
              count: presenter.get('tab_counts').sessions
            }, {
              name: 'Disclosed Vulnerabilities',
              view: VulnerabilitiesLayout,
              count: presenter.get('tab_counts').vulnerabilities
            }, {
              name: 'Web Vulnerabilities',
              view: WebVulnerabilitiesLayout,
              count: presenter.get('tab_counts').web_vulnerabilities,
              hideOnZero: true
            }, {
              name: 'Credentials',
              view: CredentialsLayout,
              count: presenter.get('tab_counts').credentials
            }, {
              name: 'Captured Data',
              view: CapturedDataLayout,
              count: presenter.get('tab_counts').captured_data
            }, {
              name: 'Notes',
              view: NotesLayout,
              count: presenter.get('tab_counts').notes
            }, {
              name: 'File Shares',
              view: FileSharesLayout,
              count: presenter.get('tab_counts').file_shares,
              hideOnZero: true
            }, {
              name: 'Attempts',
              view: AttemptsLayout,
              count: presenter.get('tab_counts').attempts
            }, {
              name: 'Modules',
              view: ModulesLayout,
              count: presenter.get('tab_counts').modules,
              hideOnZero: true
            }, {
              name: 'History',
              view: HistoryLayout,
              count: presenter.get('tab_counts').history,
              hideOnZero: true
            }
          ]
        });
        tab_layout = new TabsLayout({
          model: tab_model,
          host_id: this.id,
          host_address: presenter.get('host').address
        });
        this.row_dropdown.dropdown.show(tab_layout);
        return tab_layout.set_tab(this.tab || tab_model.get('tabs')[0].name);
      };

      HostViewController.prototype._bind_events = function() {
        return EventAggregator.on('tabs_layout:tab:changed', this._update_url_by_tab);
      };

      HostViewController.prototype._update_url_by_tab = function(last_tab) {
        last_tab = _.string.underscored(last_tab).toLowerCase();
        if (window.HostViewAppRouter != null) {
          return window.HostViewAppRouter.navigate(last_tab, {
            trigger: false
          });
        } else {
          return Pro.vent.trigger("host:tab:chose", last_tab);
        }
      };

      HostViewController.prototype._fetchForever = function(model) {
        var fetchAgain,
          _this = this;
        fetchAgain = function() {
          return window.setTimeout((function() {
            return _this._fetchForever(model);
          }), HostViewController.POLL_INTERVAL);
        };
        return model.fetch({
          success: fetchAgain,
          error: fetchAgain
        });
      };

      return HostViewController;

    })(Backbone.Marionette.Controller);
  });

}).call(this);
