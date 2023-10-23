(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/apps/views/generic_stats_view-a8a7be0dda0665d5a2132afdf8725599cddbecf47756ff8ef6dbe99ec15d95b2.js', '/assets/templates/apps/views/stat_views/_stat-fb1da74325e738ccb2cde2c67d53caa00a726add0fa2bdc64f2e4ee9fb20defe.js', '/assets/shared/lib/pie_chart-1f6948c3f005ea1112050389be09f7c3d8a5dfb36e582cd1151673a5694fc2bd.js'], function($, Template, StatTemplate, PieChart) {
    var GenericStatsView;
    return GenericStatsView = (function(_super) {

      __extends(GenericStatsView, _super);

      function GenericStatsView() {
        this._buildPies = __bind(this._buildPies, this);

        this._updatePies = __bind(this._updatePies, this);

        this._updateStats = __bind(this._updateStats, this);

        this._updateWidths = __bind(this._updateWidths, this);

        this.update = __bind(this.update, this);

        this.serializeData = __bind(this.serializeData, this);

        this.setSelected = __bind(this.setSelected, this);

        this.onRender = __bind(this.onRender, this);

        this.onClose = __bind(this.onClose, this);

        this.stopPoll = __bind(this.stopPoll, this);

        this.poll = __bind(this.poll, this);

        this.setSelectedStat = __bind(this.setSelectedStat, this);

        this.initialize = __bind(this.initialize, this);
        return GenericStatsView.__super__.constructor.apply(this, arguments);
      }

      GenericStatsView.POLL_DELAY = 3000;

      GenericStatsView.prototype._polling = false;

      GenericStatsView.prototype._rendered = false;

      GenericStatsView.prototype._selected = false;

      GenericStatsView.prototype._showHeader = false;

      GenericStatsView.prototype.template = HandlebarsTemplates['apps/views/generic_stats_view'];

      GenericStatsView.prototype.initialize = function(args) {
        var presenter, _ref, _ref1,
          _this = this;
        presenter = (_ref = this.model.get('tasks')) != null ? (_ref1 = _ref[0]) != null ? _ref1.presenter : void 0 : void 0;
        if (presenter != null) {
          return initProRequire(["apps/tasks/findings/" + presenter], function(Findings) {
            var stats;
            stats = Findings.stats;
            _.each(stats, function(v, k) {
              var _ref2;
              return (_ref2 = v.name) != null ? _ref2 : v.name = v.title;
            });
            _this.model.get('app').stats = stats;
            _this.model.bind('change', _this.update);
            _this._showHeader = args.showHeader;
            _this.render();
            return _this.update();
          });
        } else {
          this.model.bind('change', this.update);
          return this._showHeader = args.showHeader;
        }
      };

      GenericStatsView.prototype.events = {
        'click .generic-stat-wrapper[clickable="true"]': 'setSelectedStat'
      };

      GenericStatsView.prototype.setSelectedStat = function(e) {
        $('.generic-stat-wrapper', this.el).removeClass('selected');
        return $(e.currentTarget).addClass('selected');
      };

      GenericStatsView.prototype.poll = function() {
        var fetchMe,
          _this = this;
        if (this._polling) {
          return;
        }
        this._polling = true;
        fetchMe = function() {
          if (!_this._polling) {
            return;
          }
          if ((_this.model.get('status') || '').toLowerCase() === 'finished') {
            return _this.stopPoll();
          } else {
            return _this.model.fetch({
              success: function() {
                return _this._pollTimeout = setTimeout((function() {
                  return fetchMe();
                }), GenericStatsView.POLL_DELAY);
              }
            });
          }
        };
        return fetchMe();
      };

      GenericStatsView.prototype.stopPoll = function() {
        this._polling = false;
        return clearTimeout(this._pollTimeout);
      };

      GenericStatsView.prototype.onClose = function() {
        return this.stopPoll();
      };

      GenericStatsView.prototype.onRender = function() {
        if (!this._rendered) {
          this.poll();
        }
        this._rendered = true;
        return this.update();
      };

      GenericStatsView.prototype.setSelected = function(_selected) {
        this._selected = _selected;
        return this.update();
      };

      GenericStatsView.prototype.serializeData = function() {
        return _.extend(GenericStatsView.__super__.serializeData.apply(this, arguments), {
          showHeader: this._showHeader
        });
      };

      GenericStatsView.prototype.update = function() {
        var statData;
        statData = this.model.runStatHash();
        this._selected = $(this._canvas).hasClass('selected');
        this._updateStats(statData);
        this._updatePies(statData);
        return this._updateWidths(statData);
      };

      GenericStatsView.prototype._updateWidths = function(statData) {
        var $genericStats, width;
        $genericStats = $('.generic-stat-wrapper', this.el);
        width = 100 / ($genericStats.length || 1);
        return $genericStats.css({
          width: "" + width + "%"
        });
      };

      GenericStatsView.prototype._updateStats = function(statData) {
        var _this = this;
        return _.each($('.run-stat', this.el), function(el) {
          var data, format, num, origData, total;
          data = statData[$(el).attr('name')] || '0';
          total = statData[$(el).attr('total')];
          format = $(el).attr('format');
          if ((data != null) && (total != null)) {
            return $(el).text("" + data + "/" + total);
          } else if (data != null) {
            if ((format != null) && format.length > 0) {
              if (format === 'bytes') {
                $(el).text(helpers.formatBytes(data).toUpperCase().replace(/\.0/, ''));
                return $(el).attr('title', "" + data + " bytes");
              }
            } else {
              origData = data;
              if (("" + data).match(/^\d+$/) && parseInt(data) > 1000) {
                num = (parseInt(data) / 1000).toFixed(1);
                data = ("" + num + "k").replace(/\.0/, '');
              }
              data || (data = '0');
              $(el).attr('title', origData);
              return $(el).text(data);
            }
          }
        });
      };

      GenericStatsView.prototype._updatePies = function(statData) {
        if (!this._pies) {
          this._pies = this._buildPies(80);
        }
        return _.each(this._pies, function(pie, statName) {
          pie.chart.setText(statData[statName] || '0', {
            shouldUpdate: false
          });
          pie.chart.setPercentage(statData[pie.stat] / statData[pie.total] * 100);
          return pie.chart.update();
        });
      };

      GenericStatsView.prototype._buildPies = function(width) {
        var pies,
          _this = this;
        pies = {};
        _.each($('.pie-chart', this.el), function(pieDiv) {
          var $canvas, statName, totalName;
          statName = $(pieDiv).attr('name');
          totalName = $(pieDiv).attr('total');
          $canvas = $('<canvas />').attr({
            width: "" + width + "px",
            height: "" + (width + 10) + "px"
          });
          $canvas.prependTo(pieDiv);
          return pies[statName] = {
            stat: statName,
            total: totalName,
            chart: new PieChart({
              canvas: $canvas[0],
              innerFill: '#fff',
              innerFillHover: '#fff',
              outerFill: '#c5c5c5',
              outerFillHover: '#c5c5c5',
              percentFill: '#ea5709',
              percentFillHover: '#ea5709',
              textFill: '#2b2b2b',
              textFillHover: '#2b2b2b'
            })
          };
        });
        return pies;
      };

      return GenericStatsView;

    })(Backbone.Marionette.ItemView);
  });

}).call(this);
