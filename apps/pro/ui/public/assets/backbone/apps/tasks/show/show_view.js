(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'pie_chart', 'base_view', 'base_itemview', 'base_layout', 'base_collectionview', 'apps/tasks/show/templates/layout', 'apps/tasks/show/templates/header', 'apps/tasks/show/templates/stat', 'apps/tasks/show/templates/drilldown', 'lib/concerns/views/spinner'], function($, PieChart) {
    return this.Pro.module('TasksApp.Show', function(Show, App) {
      Show.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          this.setTabIndex = __bind(this.setTabIndex, this);

          this.tabClicked = __bind(this.tabClicked, this);
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('tasks/show/layout');

        Layout.prototype.attributes = {
          "class": 'stats'
        };

        Layout.prototype.regions = {
          headerRegion: '.rollup-header',
          consoleRegion: '.console-area',
          statsRegion: '.stats-region',
          drilldownRegion: '.drilldown-area'
        };

        Layout.prototype.ui = {
          tabContainer: 'ul.rollup-tabs',
          pageContainer: 'div.rollup-page'
        };

        Layout.prototype.events = {
          'click ul.rollup-tabs li': 'tabClicked'
        };

        Layout.prototype.tabClicked = function(e) {
          return this.trigger('tasksApp:show:tabClicked', $(e.currentTarget).index());
        };

        Layout.prototype.setTabIndex = function(idx) {
          this.ui.tabContainer.find('li').removeClass('selected').eq(idx).addClass('selected');
          return this.ui.pageContainer.find('div.rollup-tab').hide().eq(idx).show();
        };

        return Layout;

      })(App.Views.Layout);
      Show.Drilldown = (function(_super) {

        __extends(Drilldown, _super);

        function Drilldown() {
          return Drilldown.__super__.constructor.apply(this, arguments);
        }

        Drilldown.prototype.template = Drilldown.prototype.templatePath('tasks/show/drilldown');

        Drilldown.prototype.regions = {
          tableRegion: '.table-region'
        };

        return Drilldown;

      })(App.Views.Layout);
      Show.Header = (function(_super) {

        __extends(Header, _super);

        function Header() {
          this.disableControlButtons = __bind(this.disableControlButtons, this);

          this.stopTask = __bind(this.stopTask, this);

          this.resumeTask = __bind(this.resumeTask, this);

          this.pauseTask = __bind(this.pauseTask, this);
          return Header.__super__.constructor.apply(this, arguments);
        }

        Header.include("Spinner");

        Header.prototype.template = Header.prototype.templatePath('tasks/show/header');

        Header.prototype.ui = {
          pauseButton: '#pause',
          resumeButton: '#resume',
          stopButton: '#stop',
          controlButtons: '.control-button'
        };

        Header.prototype.events = {
          'click @ui.pauseButton': 'pauseTask',
          'click @ui.resumeButton': 'resumeTask',
          'click @ui.stopButton': 'stopTask'
        };

        Header.prototype.modelEvents = {
          'change:completed_at': 'render',
          'change:state': 'render'
        };

        Header.prototype.pauseTask = function() {
          if (this.ui.pauseButton.hasClass('disabled')) {
            return;
          }
          this.disableControlButtons();
          return this.model.pause();
        };

        Header.prototype.resumeTask = function() {
          if (this.ui.resumeButton.hasClass('disabled')) {
            return;
          }
          this.trigger('tasksApp:resume');
          this.disableControlButtons();
          return this.model.resume();
        };

        Header.prototype.stopTask = function() {
          if (this.ui.stopButton.hasClass('disabled')) {
            return;
          }
          this.disableControlButtons();
          return this.model.stop();
        };

        Header.prototype.disableControlButtons = function() {
          this.showSpinner();
          return this.ui.controlButtons.addClass('disabled');
        };

        return Header;

      })(App.Views.ItemView);
      Show.StatView = (function(_super) {

        __extends(StatView, _super);

        function StatView() {
          this._buildPie = __bind(this._buildPie, this);

          this._updateSelected = __bind(this._updateSelected, this);

          this._updateClickable = __bind(this._updateClickable, this);

          this._updatePie = __bind(this._updatePie, this);

          this._updateBadge = __bind(this._updateBadge, this);

          this.update = __bind(this.update, this);

          this.onShow = __bind(this.onShow, this);

          this.initialize = __bind(this.initialize, this);
          return StatView.__super__.constructor.apply(this, arguments);
        }

        StatView.prototype.template = StatView.prototype.templatePath('tasks/show/stat');

        StatView.prototype.attributes = {
          "class": 'generic-stat-wrapper'
        };

        StatView.prototype.ui = {
          canvas: 'canvas',
          numStat: 'span.numStat',
          totalStat: 'span.totalStat',
          badge: '.stat-badge span',
          label: 'label.desc'
        };

        StatView.prototype.triggers = {
          'click div': 'stat:clicked'
        };

        StatView.prototype.pie = null;

        StatView.prototype.initialize = function() {
          var numStat, totalStat;
          numStat = this.model.get('numStat');
          totalStat = this.model.get('totalStat');
          this.listenTo(this.model, "change:selected", this._updateSelected);
          this.listenTo(this.model.get('run_stats').task, "change", this._updateBadge);
          if (numStat != null) {
            this.listenTo(numStat, 'change', this.update);
          }
          if (totalStat != null) {
            return this.listenTo(totalStat, 'change', this.update);
          }
        };

        StatView.prototype.onShow = function() {
          this.update();
          return this._updateClickable();
        };

        StatView.prototype.update = function() {
          var _ref, _ref1;
          this._updatePie();
          this._updateBadge();
          this.ui.numStat.text((_ref = this.model.get('numStat')) != null ? _ref.get('data') : void 0);
          this.ui.totalStat.text((_ref1 = this.model.get('totalStat')) != null ? _ref1.get('data') : void 0);
          return this.trigger('stat:updated');
        };

        StatView.prototype._updateBadge = function() {
          var val, _ref;
          val = (_ref = this.model.get('schema')) != null ? typeof _ref.badge === "function" ? _ref.badge(this.model.get('run_stats').task) : void 0 : void 0;
          this.ui.badge.parent().toggle(!!val);
          if (val) {
            return this.ui.badge.html(val);
          }
        };

        StatView.prototype._updatePie = function() {
          var num, total, _ref, _ref1;
          if (this.model.isPercentage() && this.model.shouldShowPieChart()) {
            if (this.pie == null) {
              this._buildPie();
            }
            num = ((_ref = this.model.get('numStat')) != null ? _ref.get('data') : void 0) || 0;
            total = ((_ref1 = this.model.get('totalStat')) != null ? _ref1.get('data') : void 0) || num;
            this.ui.label.attr('data-count', num);
            this.pie.setText(num + '', {
              shouldUpdate: false
            });
            this.pie.setPercentage(num / total * 100.0, {
              shouldUpdate: false
            });
            return this.pie.update();
          }
        };

        StatView.prototype._updateClickable = function() {
          return this.$el.attr('clickable', this.model.get('clickable'));
        };

        StatView.prototype._updateSelected = function() {
          return this.$el.toggleClass('selected', this.model.get('selected'));
        };

        StatView.prototype._buildPie = function() {
          return this.pie || (this.pie = new PieChart({
            canvas: this.ui.canvas[0],
            innerFill: this.model.bgColor(),
            innerFillHover: this.model.bgColor(),
            textFill: this.model.color(),
            textFillHover: this.model.color(),
            fontSize: '20px',
            outerFill: this.model.stroke(),
            percentFill: this.model.percentageStroke(),
            outerFillHover: this.model.stroke(),
            percentFillHover: this.model.percentageStroke()
          }));
        };

        return StatView;

      })(App.Views.ItemView);
      return Show.Stats = (function(_super) {

        __extends(Stats, _super);

        function Stats() {
          this._fixWidths = __bind(this._fixWidths, this);

          this._deferFixWidths = __bind(this._deferFixWidths, this);

          this.onRender = __bind(this.onRender, this);
          return Stats.__super__.constructor.apply(this, arguments);
        }

        Stats.prototype.childView = Show.StatView;

        Stats.prototype.attributes = {
          "class": 'center'
        };

        Stats.prototype.collectionEvents = {
          'add': '_deferFixWidths'
        };

        Stats.prototype.onRender = function() {
          return this._fixWidths();
        };

        Stats.prototype._deferFixWidths = function() {
          return _.defer(this._fixWidths);
        };

        Stats.prototype._fixWidths = function() {
          return this.$el.find('>*').css({
            width: "" + (100 / this.collection.models.length) + "%"
          });
        };

        return Stats;

      })(App.Views.CollectionView);
    });
  });

}).call(this);
