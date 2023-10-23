(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignFactsRollupModalView = (function(_super) {

      __extends(CampaignFactsRollupModalView, _super);

      function CampaignFactsRollupModalView() {
        return CampaignFactsRollupModalView.__super__.constructor.apply(this, arguments);
      }

      CampaignFactsRollupModalView.prototype.initialize = function(opts) {
        _.bindAll(this, 'render');
        this.campaignSummary = opts['campaignSummary'];
        CampaignFactsRollupModalView.__super__.initialize.apply(this, arguments);
        return this.length = 1;
      };

      CampaignFactsRollupModalView.prototype.render = function() {
        var $content, factsView;
        CampaignFactsRollupModalView.__super__.render.apply(this, arguments);
        $content = $('div.content', this.el);
        factsView = new CampaignSlideFactsView({
          el: $content[0],
          campaignSummary: this.campaignSummary
        });
        factsView.render();
        return this.renderActionButtons();
      };

      CampaignFactsRollupModalView.prototype.events = _.extend({
        'click .actions span.done a': 'close'
      }, PaginatedRollupModalView.prototype.events);

      CampaignFactsRollupModalView.prototype.actionButtons = function() {
        return [[['done primary', 'Done']]];
      };

      return CampaignFactsRollupModalView;

    })(this.PaginatedRollupModalView);
  });

}).call(this);
