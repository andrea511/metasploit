(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['/assets/templates/apps/layouts/app_stat_modal_layout-898fb49e80c8faa87afcd4e9e1a422b9affb40af251bc2fec81337af31bf3bf0.js', '/assets/apps/backbone/views/generic_stats_view-2f48b530a3c8ef4e2a013c321ce9ec891ca098d16ce732da94c990b157c8cd7f.js', '/assets/shared/backbone/views/task_console-2b33ca95cff5e52d76224f72a04e65c43567724dde282154d9eec61ad3e31df3.js', 'jquery', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js', '/assets/apps/backbone/views/app_stat_modal_header-6dd3d5a7f0dc9327e8d9f773f02758aff6b4c5f2ced1b5c47e31d6247fc689fa.js'], function(Template, GenericStatsView, TaskConsole, $, m, AppStatModalHeader) {
    var AppStatModalLayout, VULN_VALIDATION_WIZARD_URL;
    VULN_VALIDATION_WIZARD_URL = '/wizards/vuln_validation/form/';
    return AppStatModalLayout = (function(_super) {

      __extends(AppStatModalLayout, _super);

      function AppStatModalLayout() {
        this.serializeData = __bind(this.serializeData, this);

        this.tabClicked = __bind(this.tabClicked, this);

        this.statClicked = __bind(this.statClicked, this);

        this.loadTableClicked = __bind(this.loadTableClicked, this);

        this.onClose = __bind(this.onClose, this);

        this.onRender = __bind(this.onRender, this);

        this.onModelChange = __bind(this.onModelChange, this);

        this.initialize = __bind(this.initialize, this);
        return AppStatModalLayout.__super__.constructor.apply(this, arguments);
      }

      AppStatModalLayout.BASE_URL = "/workspaces/" + window.WORKSPACE_ID + "/apps/app_runs";

      AppStatModalLayout.prototype._selectedStat = null;

      AppStatModalLayout.prototype._dataTable = null;

      AppStatModalLayout.prototype._header = null;

      AppStatModalLayout.prototype.template = HandlebarsTemplates['apps/layouts/app_stat_modal_layout'];

      AppStatModalLayout.prototype.regions = {
        statsArea: '.stats',
        consoleArea: '.console-area',
        drilldownArea: '.drilldown-area'
      };

      AppStatModalLayout.prototype.initialize = function(_arg) {
        this.appRun = _arg.appRun;
        return this.appRun.bind('change', this.onModelChange);
      };

      AppStatModalLayout.prototype.events = {
        'click ul.rollup-tabs li a': 'tabClicked',
        'click .load-table': 'loadTableClicked',
        'click .exploit-continue-btn': 'exploitContinueClicked'
      };

      AppStatModalLayout.prototype.onModelChange = function() {
        if (this._dataTable != null) {
          return this._dataTable.fnDraw();
        }
      };

      AppStatModalLayout.prototype.onRender = function() {
        var _this = this;
        this.showStatsForApp(this.appRun.get('app'), {
          complete: function() {
            return $('.load-table', _this.el).not('[clickable=false]').first().click();
          }
        });
        this.showConsoleForTask(this.appRun.get('tasks')[0]);
        if (this._header == null) {
          this._header = new AppStatModalHeader({
            appRun: this.appRun,
            el: this.$el.find('.rollup-header .max-width')[0]
          });
          return this._header.render();
        }
      };

      AppStatModalLayout.prototype.onClose = function() {
        this.console.stopUpdating();
        return this.statsView.stopPoll();
      };

      AppStatModalLayout.prototype.loadTableClicked = function(e) {
        var _ref;
        if ((this._selectedStat != null) && ((_ref = this._selectedStat) != null ? _ref[0] : void 0) === e.currentTarget) {
          return;
        }
        this.statClicked(e.currentTarget);
        $('canvas,.big-stat', this.el).removeClass('selected');
        $('canvas,.big-stat', e.currentTarget).addClass('selected');
        return this.statsView.update();
      };

      AppStatModalLayout.prototype.statClicked = function(statEl) {
        var $area, datatable_columns, label, merged_column_opts, name, opts, statName, toggle, url,
          _this = this;
        if ($(statEl).attr('clickable') === 'false') {
          return;
        }
        this._selectedStat = $(statEl);
        this.statsView.setSelected(true);
        this.statsView.update();
        label = $(statEl).attr('label');
        statName = $(statEl).attr('name');
        if (!((label != null ? label.length : void 0) > 0)) {
          label = statName;
        }
        url = AppStatModalLayout.BASE_URL + ("/" + this.appRun.id + ".json?collection=") + statName;
        $area = $('.drilldown-area', this.el);
        $area.addClass('tab-loading').html('');
        datatable_columns = this.appRun.get('datatable_columns');
        opts = {
          el: $area,
          dataTable: {
            aaSorting: [[3, "desc"]],
            sAjaxSource: url,
            oLanguage: {
              sEmptyTable: "No data has been recorded."
            },
            fnInitComplete: function(oSettings, json) {
              return $('table', $area).attr({
                id: label
              });
            }
          },
          columns: {
            created_at: {
              name: 'Created',
              sType: 'title-string',
              fnRender: function(o) {
                var time, _ref;
                time = (_ref = o.aData) != null ? _ref.created_at : void 0;
                return "<span title='" + (_.escape(time)) + "'>" + (_.escape(moment(time).fromNow())) + "</span>";
              }
            }
          },
          success: function(dt) {
            _this._dataTable = dt;
            return $area.prepend($('<h4 />', {
              html: _.str.humanize(label),
              'data-table-id': label
            }));
          }
        };
        if (datatable_columns != null) {
          merged_column_opts = $.extend(opts.columns, datatable_columns[statName]);
          opts.columns = merged_column_opts;
        }
        helpers.loadRemoteTable(opts);
        name = _.str.humanize(statName);
        toggle = name.toLowerCase() === 'exploit matches' && this.appRun.get('dry_run') && this.appRun.get('procedure_state') === 'paused';
        return $area.parent().find('.right.exploit-continue-btn').toggle(toggle);
      };

      AppStatModalLayout.prototype.exploitContinueClicked = function(e) {
        var _this = this;
        if ($(e.currentTarget).hasClass('disabled')) {
          return;
        }
        $(e.currentTarget).addClass('disabled submitting');
        return $.ajax({
          url: VULN_VALIDATION_WIZARD_URL + 'continue_exploitation',
          data: {
            procedure_id: this.appRun.get('procedure_id')
          },
          type: 'POST',
          success: function() {
            return window.location.reload(true);
          },
          error: function() {
            return $(e.currentTarget).removeClass('disabled submitting');
          }
        });
      };

      AppStatModalLayout.prototype.showStatsForApp = function(app, _arg) {
        var $stats, complete, done;
        complete = _arg.complete;
        $stats = $('.stats', this.el);
        $stats.addClass('tab-loading');
        done = function() {
          $stats.removeClass('tab-loading');
          if (complete != null) {
            return complete();
          }
        };
        this.statsView = new GenericStatsView({
          model: this.appRun
        });
        this.statsArea.show(this.statsView);
        return done();
      };

      AppStatModalLayout.prototype.showConsoleForTask = function(task) {
        this.console = new TaskConsole({
          task: task.id
        });
        this.consoleArea.show(this.console);
        return this.console.startUpdating();
      };

      AppStatModalLayout.prototype.tabClicked = function(e) {
        var $selLi;
        e.preventDefault();
        $('ul.rollup-tabs li', this.el).removeClass('selected');
        $selLi = $(e.currentTarget).parents('ul.rollup-tabs li').first();
        $selLi.addClass('selected');
        $('.rollup-tab', this.el).hide();
        return $('.rollup-tab', this.el).eq($selLi.index()).show();
      };

      AppStatModalLayout.prototype.serializeData = function() {
        return this;
      };

      return AppStatModalLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
