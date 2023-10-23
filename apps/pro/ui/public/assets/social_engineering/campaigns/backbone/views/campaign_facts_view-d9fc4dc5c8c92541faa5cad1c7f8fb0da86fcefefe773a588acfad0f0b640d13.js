(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignFactsView = (function(_super) {

      __extends(CampaignFactsView, _super);

      function CampaignFactsView() {
        this.resize = __bind(this.resize, this);
        return CampaignFactsView.__super__.constructor.apply(this, arguments);
      }

      CampaignFactsView.prototype.initialize = function(opts) {
        this.actions = ['sent_emails', 'opened_emails', 'links_clicked', 'sent_emails', 'submitted_forms', 'opened_sessions', 'opened_sessions'];
        this.attributes = ['emails_sent', 'emails_opened', 'links_clicked', 'forms_started', 'forms_submitted', 'sessions_opened', 'sessions_opened', 'prone_to_bap'];
        this.campaignSummary = opts['campaignSummary'];
        this.tabView = opts['tabView'];
        _.bindAll(this, 'render', 'circleClicked');
        this.campaignSummary.bind('change', this.render);
        this.prevPercentages = {};
        this.canvWidth = 200;
        return $(window).resize(this.resize);
      };

      CampaignFactsView.prototype.template = _.template($('#campaign-facts').html());

      CampaignFactsView.prototype.circlesTemplate = _.template($('#campaign-facts-circles').html());

      CampaignFactsView.prototype.events = {
        'click .large-circles .circle': 'circleClicked',
        'click .campaign-facts-lvl2 .circle': 'subCircleClicked'
      };

      CampaignFactsView.prototype.getClickedCircle = function(e) {
        var $circle;
        this.tabView.setTabIndex(1);
        $circle = $(e.target).parent('.circle');
        if (!$circle.size()) {
          $circle = $(e.target);
        }
        return $circle;
      };

      CampaignFactsView.prototype.subCircleClicked = function(e) {
        var $circle, idx;
        $circle = this.getClickedCircle(e);
        idx = 6;
        return $(this.tabView).trigger('scrollToCircle', [$circle, idx]);
      };

      CampaignFactsView.prototype.circleClicked = function(e) {
        var $circle, idx;
        $circle = this.getClickedCircle(e);
        idx = $circle.parents('.cell').first().prevAll().size();
        return $(this.tabView).trigger('scrollToCircle', [$circle, idx]);
      };

      CampaignFactsView.prototype.addVisibilityClasses = function(campaignFacts) {
        var fact, factName, _results;
        _results = [];
        for (factName in campaignFacts) {
          if (!__hasProp.call(campaignFacts, factName)) continue;
          fact = campaignFacts[factName];
          fact['cellClass'] = fact.visible ? '' : 'hidden-cell';
          _results.push(fact['cellClass'] += " " + factName);
        }
        return _results;
      };

      CampaignFactsView.prototype.resetCircleClasses = function() {
        var $circs;
        $circs = $('.large-circles .cell', this.el).not('.hidden-cell').removeClass('first last');
        $circs.first().addClass('first');
        return $circs.last().addClass('last');
      };

      CampaignFactsView.prototype.visibleCircles = function() {
        return $('.large-circles .cell', this.el).not('.hidden-cell');
      };

      CampaignFactsView.prototype.leftMargin = function() {
        return (100 - (this.visibleCircles().size() * (11.66667 + 5) - 11.6667)) / 2;
      };

      CampaignFactsView.prototype.centerCircles = function() {
        var $circs;
        $circs = this.visibleCircles();
        $circs.removeAttr('style');
        return $circs.first().css('margin-left', this.leftMargin() + '%');
      };

      CampaignFactsView.prototype.anyCirclesVisible = function(campaignFacts) {
        return !!_.find(campaignFacts, function(fact) {
          return fact.visible;
        });
      };

      CampaignFactsView.prototype.setVisible = function(v) {
        var $facts;
        return $facts = $('.campaign-facts', this.el).toggle(v).prev('h3').toggle(v);
      };

      CampaignFactsView.prototype.renderPie = function(idx, perc) {
        var $canvases, attr, c, campaignFacts, total, w;
        if (typeof perc !== 'number') {
          attr = this.attributes[idx];
          campaignFacts = this.campaignSummary.get('campaign_facts');
          total = parseInt(campaignFacts['emails_sent'].count) || 0;
          if (campaignFacts[attr].count === '') {
            return;
          }
          perc = campaignFacts[attr].count / total * 100;
        }
        $canvases = $('canvas', this.el);
        if (!($canvases.size() > idx)) {
          return;
        }
        c = $canvases[idx].getContext('2d');
        if (!c) {
          return;
        }
        w = this.canvWidth;
        c.clearRect(0, 0, w, w);
        c.beginPath();
        c.moveTo(w / 2, w / 2);
        c.arc(w / 2, w / 2, w / 2, -Math.PI / 2, Math.PI * perc * 2 / (w / 2) - Math.PI / 2, false);
        c.closePath();
        c.fillStyle = '#bbb';
        if (idx === this.selIdx) {
          c.fillStyle = '#FF9327';
        }
        return c.fill();
      };

      CampaignFactsView.prototype.animatePie = function(idx) {
        var $canv, attr, campaignFacts, percent,
          _this = this;
        $canv = $('canvas', this.el).eq(idx);
        $canv.css('font-size', '0');
        attr = this.attributes[idx];
        campaignFacts = this.campaignSummary.get('campaign_facts');
        percent = campaignFacts[attr].percentage;
        return _.delay((function() {
          $canv.parent().css({
            'font-size': _this.prevPercentages[attr] || 0
          });
          $canv.parent().animate({
            'font-size': percent + 'px'
          }, {
            duration: 400,
            step: function(currSize) {
              var dur;
              dur = parseInt(currSize);
              return _this.renderPie(idx, dur);
            },
            queue: true
          });
          return _this.prevPercentages[attr] = percent;
        }), 300);
      };

      CampaignFactsView.prototype.resize = function() {
        var i, _i, _ref, _results;
        this.canvWidth = $('.circle:visible', this.el).first().width();
        $('canvas', this.el).attr('width', this.canvWidth).attr('height', this.canvWidth);
        _results = [];
        for (i = _i = 0, _ref = this.actions.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(this.animatePie(i));
        }
        return _results;
      };

      CampaignFactsView.prototype.render = function() {
        var campaignDetails, campaignFacts, i, _i, _ref, _results;
        campaignFacts = _.deepClone(this.campaignSummary.get('campaign_facts'));
        campaignDetails = _.deepClone(this.campaignSummary.get('campaign_details'));
        this.addVisibilityClasses(campaignFacts);
        this.dom || (this.dom = $(this.template({
          campaignFacts: campaignFacts,
          campaignDetails: campaignDetails
        })).appendTo(this.$el));
        $('.circles', this.el).html(this.circlesTemplate({
          campaignFacts: campaignFacts
        }));
        this.resetCircleClasses();
        this.centerCircles();
        _results = [];
        for (i = _i = 0, _ref = this.actions.length; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          _results.push(this.animatePie(i));
        }
        return _results;
      };

      return CampaignFactsView;

    })(Backbone.View);
  });

}).call(this);
