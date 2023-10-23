(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignStatusStrip = (function(_super) {

      __extends(CampaignStatusStrip, _super);

      function CampaignStatusStrip() {
        return CampaignStatusStrip.__super__.constructor.apply(this, arguments);
      }

      CampaignStatusStrip.prototype.initialize = function(opts) {
        this.campaignSummary = opts['campaignSummary'];
        _.bindAll(this, 'render', 'updateStatusStrip');
        this.campaignSummary.bind('change', this.updateStatusStrip);
        this.prevId = null;
        return CampaignStatusStrip.__super__.initialize.apply(this, arguments);
      };

      CampaignStatusStrip.prototype.template = _.template($('#campaign-status').html());

      CampaignStatusStrip.prototype.setInitialCampaign = function(campaign) {
        return this.prevId = campaign.id;
      };

      CampaignStatusStrip.prototype.updateStatusStrip = function() {
        if (this.prevId !== null) {
          return this.render();
        }
      };

      CampaignStatusStrip.prototype.render = function() {
        var $next, campaignDetails, context, persisted;
        campaignDetails = this.campaignSummary.get('campaign_details');
        persisted = this.campaignSummary.id !== null;
        context = {
          campaignDetails: campaignDetails,
          persisted: persisted
        };
        if (this.dom) {
          $next = this.dom.next().first();
        }
        if (this.dom) {
          this.dom.remove();
        }
        if ($next && $next.size()) {
          this.dom = $($.parseHTML(this.template(context)));
          return this.dom.insertBefore($next);
        } else {
          this.dom = $($.parseHTML(this.template(context)));
          this.dom.appendTo($(this.el));
          return $(this.el).css({
            position: 'relative'
          });
        }
      };

      return CampaignStatusStrip;

    })(Backbone.View);
  });

}).call(this);
