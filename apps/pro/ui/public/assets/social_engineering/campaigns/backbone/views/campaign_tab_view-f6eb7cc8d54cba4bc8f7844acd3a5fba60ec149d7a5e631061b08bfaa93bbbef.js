(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignTabView = (function(_super) {

      __extends(CampaignTabView, _super);

      function CampaignTabView() {
        return CampaignTabView.__super__.constructor.apply(this, arguments);
      }

      CampaignTabView.prototype.initialize = function() {
        CampaignTabView.activeView || (CampaignTabView.activeView = this);
        this.tabs = [new CampaignConfigurationTabPageView(), new CampaignListView(), new ReusableCampaignElementsView()];
        return CampaignTabView.__super__.initialize.apply(this, arguments);
      };

      CampaignTabView.prototype.userClickedTab = function(idx) {
        if (idx === 0 && idx !== this.index) {
          $(document).trigger('editCampaign', new CampaignSummary, false);
        }
        return CampaignTabView.__super__.userClickedTab.call(this, idx);
      };

      CampaignTabView.prototype.render = function() {
        return CampaignTabView.__super__.render.apply(this, arguments);
      };

      return CampaignTabView;

    })(this.TabView);
  });

}).call(this);
