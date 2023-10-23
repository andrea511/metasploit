(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var CampaignSummaryList;
    CampaignSummaryList = (function(_super) {

      __extends(CampaignSummaryList, _super);

      function CampaignSummaryList() {
        return CampaignSummaryList.__super__.constructor.apply(this, arguments);
      }

      CampaignSummaryList.prototype.model = CampaignSummary;

      CampaignSummaryList.prototype.url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns.json";

      return CampaignSummaryList;

    })(Backbone.Collection);
    return this.CampaignListView = (function(_super) {

      __extends(CampaignListView, _super);

      function CampaignListView() {
        return CampaignListView.__super__.constructor.apply(this, arguments);
      }

      CampaignListView.DISABLE_CLICK_FN = function(e) {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        return false;
      };

      CampaignListView.MAX_CAMPAIGNS_RUNNING = 1;

      CampaignListView.CAMPAIGN_RUN_LIMIT_MSG = "Cannot run more than " + CampaignListView.MAX_CAMPAIGNS_RUNNING + " campaign at a time.";

      CampaignListView.checkForInitializationErrors = function(opts) {
        var url;
        url = ("/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/") + ("" + opts.campaign.id + "/check_for_configuration_errors");
        return $.ajax({
          url: url,
          success: opts['success'] || function() {},
          error: opts['error'] || function() {}
        });
      };

      CampaignListView.prototype.initialize = function() {
        var jsonBlob, models;
        _.bindAll(this, 'render', 'testClicked', 'findingsClicked', 'editClicked', 'previewClicked', 'deleteClicked', 'renderIfVisible', 'willDisplay');
        jsonBlob = $.parseJSON($('meta[name=campaign-summaries-init]').attr('content'));
        $('meta[name=campaign-summaries-init]').remove();
        models = _.map(jsonBlob, function(modelAttrs) {
          return new CampaignSummary(modelAttrs);
        });
        this.disabledRows = {};
        this.collection = new CampaignSummaryList(models);
        this.collection.bind('change', this.renderIfVisible);
        this.poller = new Poller(this.collection);
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Loading... ',
          closeOnEscape: false,
          autoOpen: false
        });
        return CampaignListView.__super__.initialize.apply(this, arguments);
      };

      CampaignListView.prototype.willDisplay = function() {
        this.visible = true;
        this.poller.start();
        return this.render();
      };

      CampaignListView.prototype.willHide = function() {
        this.visible = false;
        if (this.poller) {
          return this.poller.stop();
        }
      };

      CampaignListView.prototype.renderIfVisible = function(e) {
        if (this.visible) {
          return this.render();
        }
      };

      CampaignListView.prototype.tblTemplate = _.template($('#campaign-list').html());

      CampaignListView.prototype.ajaxAlertOnError = function(opts) {
        return $.ajax({
          url: opts['url'],
          data: opts['data'] || {},
          dataType: opts['dataType'] || 'json',
          type: opts['type'] || 'get',
          success: opts['success'],
          error: function(e) {
            var fail;
            fail = $.parseJSON(e.responseText);
            if (fail && fail['error']) {
              alert(fail['error']);
            }
            if (opts['error']) {
              return opts['error'].call(this);
            }
          }
        });
      };

      CampaignListView.prototype.events = {
        'click .row': 'editClicked',
        'click .row .actions': 'stopPropagation',
        'click .row a.start': 'stopPropagation',
        'click .row .cell .actions a.test': 'testClicked',
        'click .row .cell .actions a.findings': 'findingsClicked',
        'click .row .cell .actions a.edit': 'editClicked',
        'click .row .cell .actions a.delete': 'deleteClicked',
        'click .row .cell .actions a.reset': 'resetClicked',
        'click .row .cell .actions a.preview': 'previewClicked',
        'click .row .cell a.start': 'startClicked',
        'click .row .cell a.stop-campaign': 'stopClicked',
        'click .new-action .btn a.new': 'newCampaignClicked',
        'click .row .cell .actions a.download-portable-file': 'showPortableFileDownloads'
      };

      CampaignListView.prototype.stopPropagation = function(e) {
        return e.stopPropagation();
      };

      CampaignListView.prototype.flashCampaign = function(id) {
        var _this = this;
        if (!id) {
          return;
        }
        return _.delay((function() {
          var $row;
          $row = $("div.row[campaign-id=" + id + "]", _this.el);
          $('html,body').animate({
            scrollTop: $row.offset().top - 0.35 * ($(window).height())
          }, 200);
          return $row.stop().css("background-color", "#DFF0D8").animate({
            backgroundColor: "#F8F8F8"
          }, 1600);
        }), 100);
      };

      CampaignListView.prototype.rowForClickTarget = function(e) {
        var $row;
        $row = $(e.target).parents('.row').first();
        if (!($row.size() > 0)) {
          $row = $(e.target);
        }
        if ($(e.target).hasClass('row')) {
          $row = $(e.target);
        }
        return $row;
      };

      CampaignListView.prototype.rowIndexForClickTarget = function(e) {
        var $row;
        $row = this.rowForClickTarget(e);
        return $row.first().prevAll().size();
      };

      CampaignListView.prototype.testClicked = function(e) {
        var idx;
        idx = this.rowIndexForClickTarget(e);
        return e.preventDefault();
      };

      CampaignListView.prototype.findingsClicked = function(e) {
        var facts, idx;
        idx = this.rowIndexForClickTarget(e);
        facts = new CampaignFactsRollupModalView({
          campaignSummary: this.collection.models[idx]
        });
        facts.open();
        return e.preventDefault();
      };

      CampaignListView.prototype.showPortableFileDownloads = function(e) {
        var campaign, idx, url,
          _this = this;
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        url = "" + (this.baseURL()) + "/" + campaign.id + "/portable_file_downloads";
        this.loadingModal.dialog('open');
        $.ajax({
          url: url,
          success: function(data) {
            var newModal;
            _this.loadingModal.dialog('close');
            return newModal = $('<div></div>').html(data).dialog({
              modal: true,
              title: 'Portable File Downloads'
            });
          },
          error: function() {
            return _this.loadingModal.dialog('close');
          }
        });
        return e.preventDefault();
      };

      CampaignListView.prototype.editClicked = function(e) {
        var $row, campaign, idx;
        e.preventDefault();
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!(campaign.running() || campaign.preparing())) {
          $row = this.rowForClickTarget(e);
          if ($row.hasClass('ui-disabled') || $(e.target).hasClass('ui-disabled')) {
            return;
          }
          if (!this.rowIsEnabled(campaign.id)) {
            return;
          }
          return $(document).trigger('editCampaign', campaign);
        }
      };

      CampaignListView.prototype.newCampaignClicked = function() {
        var campaign;
        campaign = new CampaignSummary;
        return $(document).trigger('editCampaign', campaign);
      };

      CampaignListView.prototype.deleteClicked = function(e) {
        var campaign, idx, url,
          _this = this;
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        if (!confirm('Are you sure you want to delete this campaign? ' + 'All associated campaign data will also be deleted.')) {
          return;
        }
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!this.rowIsEnabled(campaign.id)) {
          return;
        }
        url = "" + (this.baseURL()) + "/" + campaign.id;
        this.ajaxAlertOnError({
          url: url,
          type: 'post',
          data: {
            _method: 'delete'
          },
          success: function(resp) {
            var $row;
            $row = $("div.row[campaign-id=" + campaign.id + "]", _this.el);
            $row.fadeOut(200);
            $('a', $row).addClass('ui-disabled').click(CampaignListView.DISABLE_CLICK_FN);
            return _.delay((function() {
              _this.collection.remove(campaign);
              return _this.render();
            }), 200);
          }
        });
        return e.preventDefault();
      };

      CampaignListView.prototype.baseURL = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns";
      };

      CampaignListView.prototype.toggleLaunchButtons = function(id, enabled) {
        var $row;
        if (enabled == null) {
          enabled = false;
        }
        $row = $("div.row[campaign-id=" + id + "]", this.el);
        return $('div.launch a', $row).toggleClass('ui-disabled', !enabled);
      };

      CampaignListView.prototype.startClicked = function(e) {
        var campaign, idx,
          _this = this;
        e.preventDefault();
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!this.rowIsEnabled(campaign.id)) {
          return;
        }
        this.toggleLaunchButtons(campaign.id, false);
        return $(document).trigger('launchCampaign', {
          campaign: campaign,
          error: function() {
            return _this.toggleLaunchButtons(campaign.id, true);
          }
        });
      };

      CampaignListView.prototype.stopClicked = function(e) {
        var campaign, idx, url;
        e.preventDefault();
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!this.rowIsEnabled(campaign.id)) {
          return;
        }
        this.toggleLaunchButtons(campaign.id, false);
        url = "" + (this.baseURL()) + "/" + campaign.id + "/execute";
        return $.ajax({
          url: url,
          type: 'POST',
          dataType: 'json',
          success: function(data) {
            return campaign.set(data);
          }
        });
      };

      CampaignListView.prototype.resetClicked = function(e) {
        var $row, campaign, idx, newCampaign,
          _this = this;
        e.preventDefault();
        if ($(e.target).hasClass('ui-disabled')) {
          return;
        }
        $row = this.rowForClickTarget(e);
        idx = this.rowIndexForClickTarget(e);
        campaign = this.collection.models[idx];
        if (!this.rowIsEnabled(campaign.id)) {
          return;
        }
        if (!confirm('Are you sure you want to reset your campaign? This will ' + 'clear all findings and data discovered by the campaign.')) {
          return;
        }
        this.disableRow(campaign.id);
        newCampaign = new CampaignSummary;
        campaign.set('campaign_facts', newCampaign.get('campaign_facts'));
        return $.ajax({
          type: "POST",
          url: "" + (this.baseURL()) + "/" + campaign.id + "/reset",
          success: function() {
            return _this.enableRow(campaign.id);
          },
          error: function() {
            return _this.enableRow(campaign.id);
          }
        });
      };

      CampaignListView.prototype.previewClicked = function(e) {
        var idx, modal;
        e.preventDefault();
        idx = this.rowIndexForClickTarget(e);
        modal = new CampaignPreviewModal({
          campaignSummary: this.collection.models[idx]
        });
        return modal.open();
      };

      CampaignListView.prototype.disableRow = function(id, doUpdate) {
        if (doUpdate == null) {
          doUpdate = true;
        }
        this.disabledRows[id + ''] = true;
        if (!doUpdate) {
          return this.update();
        }
      };

      CampaignListView.prototype.enableRow = function(id, doUpdate) {
        if (doUpdate == null) {
          doUpdate = true;
        }
        delete this.disabledRows[id + ''];
        if (!doUpdate) {
          return this.update();
        }
      };

      CampaignListView.prototype.rowIsEnabled = function(id) {
        return !this.disabledRows[id + ''];
      };

      CampaignListView.prototype.update = function() {
        var key, val, _ref, _results;
        _ref = this.disabledRows;
        _results = [];
        for (key in _ref) {
          if (!__hasProp.call(_ref, key)) continue;
          val = _ref[key];
          _results.push($(".row[campaign-id=" + key + "]", this.el).addClass('ui-disabled'));
        }
        return _results;
      };

      CampaignListView.prototype.render = function() {
        this.dom || (this.dom = CampaignListView.__super__.render.apply(this, arguments));
        if (this.tblDom) {
          this.tblDom.remove();
        }
        this.tblDom = $($.parseHTML(this.tblTemplate(this))).appendTo(this.dom);
        $('.campaign-list .row', this.el).last().addClass('last');
        $('.campaign-list .row', this.el).first().addClass('first');
        $('.campaign-list .row', this.el).parents('.cell').first().css({
          'padding-top': '0',
          'padding-bottom': '0'
        });
        return this.update();
      };

      return CampaignListView;

    })(SingleTabPageView);
  });

}).call(this);
