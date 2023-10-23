(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var CREATE_URL;
    CREATE_URL = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns.js";
    return this.CampaignConfigurationTabPageView = (function(_super) {

      __extends(CampaignConfigurationTabPageView, _super);

      function CampaignConfigurationTabPageView() {
        return CampaignConfigurationTabPageView.__super__.constructor.apply(this, arguments);
      }

      CampaignConfigurationTabPageView.prototype.initialize = function() {
        var opts;
        this.campaign = new CampaignSummary;
        _.bindAll(this, 'setCampaign', 'createCampaignEvent', 'updateButtons', 'launchCampaignEvent');
        $(document).bind('createCampaign', this.createCampaignEvent);
        $(document).bind('launchCampaign', this.launchCampaignEvent);
        $(document).bind('editCampaign', this.setCampaign);
        this.campaign.bind('change', this.updateButtons);
        opts = {
          el: this.el,
          campaignSummary: this.campaign
        };
        this.serverConfigView = new CampaignServerConfigurationsView(opts);
        this.campaignStatusStrip = new CampaignStatusStrip(opts);
        this.campaignComponentsView = new CampaignComponentsView(opts);
        this.campaignConfigView = new CampaignConfigurationView(opts);
        this.campaignNotificationView = new CampaignNotificationView(opts);
        this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Creating campaign... ',
          autoOpen: false,
          closeOnEscape: false
        });
        return CampaignConfigurationTabPageView.__super__.initialize.apply(this, arguments);
      };

      CampaignConfigurationTabPageView.prototype.events = {
        'click .save-campaign': 'saveCampaignClicked',
        'click .cancel-campaign': 'cancelCampaignClicked',
        'click .launch-campaign': 'launchCampaignClicked'
      };

      CampaignConfigurationTabPageView.prototype.btnsTemplate = _.template($('#edit-buttons').html());

      CampaignConfigurationTabPageView.prototype.willDisplay = function() {
        var _this = this;
        return _.defer(function() {
          return $('form input[type=text]', _this.el).first().focus();
        });
      };

      CampaignConfigurationTabPageView.prototype.createCampaignEvent = function(e, opts) {
        return this.createCampaign(opts['data'], opts['callback']);
      };

      CampaignConfigurationTabPageView.prototype.createCampaign = function(data, callback) {
        var _this = this;
        if (this.creatingCampaign) {
          return;
        }
        $("[name^='social_engineering_campaign']~p.inline-errors").remove();
        this.creatingCampaign = true;
        this.loadingModal.dialog('open');
        return $.ajax({
          type: 'POST',
          url: CREATE_URL,
          data: data,
          dataType: 'json',
          async: false,
          success: function(data) {
            _this.creatingCampaign = false;
            _this.loadingModal.dialog('close');
            if (_this.campaign.usesWizard()) {
              _this.campaign.get('campaign_configuration')['web_config']['configured'] = true;
            }
            _this.campaign.set(data);
            _this.updateButtons();
            _this.campaignConfigView.update();
            _this.campaignNotificationView.update();
            return callback.call(_this);
          },
          error: function(err) {
            var $input, errHash, key, msgArray, _results;
            _this.creatingCampaign = false;
            _this.loadingModal.dialog('close');
            errHash = $.parseJSON(err.responseText)['error'];
            if (!errHash) {
              return;
            }
            _results = [];
            for (key in errHash) {
              if (!__hasProp.call(errHash, key)) continue;
              msgArray = errHash[key];
              $input = $("[name='social_engineering_campaign[" + key + "]']").focus();
              _results.push($("<p class='inline-errors'>" + msgArray[0] + "</p>").insertAfter($input).hide().slideDown().fadeIn());
            }
            return _results;
          }
        });
      };

      CampaignConfigurationTabPageView.prototype.baseURL = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns";
      };

      CampaignConfigurationTabPageView.prototype.ajaxAlertOnError = function(opts) {
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

      CampaignConfigurationTabPageView.prototype.launchCampaignEvent = function(e, opts) {
        return this.launchCampaign(opts['campaign'], opts);
      };

      CampaignConfigurationTabPageView.prototype.checkForInitializationErrors = function(opts) {
        var url;
        url = ("/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/") + ("" + opts.campaign.id + "/check_for_configuration_errors");
        return $.ajax({
          url: url,
          success: opts['success'] || function() {},
          error: opts['error'] || function() {}
        });
      };

      CampaignConfigurationTabPageView.prototype.launchCampaign = function(campaign, opts) {
        var _this = this;
        if (opts == null) {
          opts = {};
        }
        return this.checkForInitializationErrors({
          campaign: campaign,
          error: function(e) {
            var data;
            data = $.parseJSON(e.responseText);
            alert(data['error']);
            if (opts['error']) {
              return opts['error'].call(_this);
            }
          },
          success: function() {
            var emailsText, firstEmail, listName, numTargets, url;
            numTargets = campaign.get('campaign_details').email_targets_count;
            firstEmail = _.find(campaign.get('campaign_components'), (function(comp) {
              return comp.type === 'email';
            }));
            if (numTargets > 0 && firstEmail) {
              emailsText = numTargets === 1 ? 'e-mail' : 'e-mails';
              listName = firstEmail.target_list_name;
              if (!confirm("You are about to send " + numTargets + " " + emailsText + " to the '" + listName + "' target list.  Are you sure?")) {
                if (opts['error']) {
                  opts['error'].call(_this);
                }
                return;
              }
            }
            url = "" + (_this.baseURL()) + "/" + campaign.id + "/execute";
            return _this.ajaxAlertOnError({
              type: 'POST',
              url: url,
              success: function(data) {
                var facts, listView, newCampaign;
                listView = CampaignTabView.activeView.tabs[1];
                newCampaign = _.find(listView.collection.models, function(c) {
                  return c.id === campaign.id;
                });
                if (!newCampaign) {
                  listView.collection.unshift(campaign);
                  newCampaign = campaign;
                }
                newCampaign.set(data);
                facts = new CampaignFactsRollupModalView({
                  campaignSummary: newCampaign
                });
                facts.open();
                if (opts['success']) {
                  return opts['success'].call(this);
                }
              },
              error: opts['error'] || function() {}
            });
          }
        });
      };

      CampaignConfigurationTabPageView.prototype.saveCampaignClicked = function(e) {
        var data, listView, name,
          _this = this;
        if (this.campaign.id === null) {
          this.loadingModal.dialog('open');
          data = $('form.social_engineering_campaign', this.el).serialize();
          this.createCampaign(data, function() {
            var listView;
            CampaignTabView.activeView.setTabIndex(1);
            listView = CampaignTabView.activeView.tabs[1];
            return listView.flashCampaign(_this.campaign.id);
          });
        } else {
          name = $("[name='social_engineering_campaign[name]']", this.el).val();
          if (name !== this.campaign.get('name')) {
            this.campaign.set('name', name);
            this.campaign.save();
          }
          CampaignTabView.activeView.setTabIndex(1);
          listView = CampaignTabView.activeView.tabs[1];
          listView.flashCampaign(this.campaign.id);
        }
        return e.preventDefault();
      };

      CampaignConfigurationTabPageView.prototype.cancelCampaignClicked = function(e) {
        var listView;
        e.preventDefault();
        CampaignTabView.activeView.setTabIndex(1);
        listView = CampaignTabView.activeView.tabs[1];
        listView.flashCampaign(this.campaign.id);
        return this.setCampaign(null, new CampaignSummary(CampaignSummary.defaults), false);
      };

      CampaignConfigurationTabPageView.prototype.launchCampaignClicked = function(e) {
        var $launchBtn,
          _this = this;
        $launchBtn = $('a.launch-campaign', this.el);
        if ($launchBtn.hasClass('ui-disabled')) {
          return;
        }
        $launchBtn.addClass('ui-disabled').parent('span').addClass('ui-disabled');
        this.launchCampaign(this.campaign, {
          success: function(data) {
            var listView;
            CampaignTabView.activeView.setTabIndex(1);
            listView = CampaignTabView.activeView.tabs[1];
            return listView.flashCampaign(_this.campaign.id);
          },
          error: function() {
            return $('a.launch-campaign', _this.el).removeClass('ui-disabled').parent('span').removeClass('ui-disabled');
          }
        });
        return e.preventDefault();
      };

      CampaignConfigurationTabPageView.prototype.setCampaign = function(e, newCampaign, slide) {
        if (slide == null) {
          slide = true;
        }
        if (slide) {
          CampaignTabView.activeView.setTabIndex(0);
        }
        this.campaign.set(newCampaign.attributes);
        this.campaignComponentsView.render();
        this.campaignComponentsView.setEditing(false);
        this.campaignConfigView.update();
        this.campaignStatusStrip.setInitialCampaign(newCampaign);
        this.campaignStatusStrip.render();
        this.campaignNotificationView.update(this.campaign);
        return this.updateButtons();
      };

      CampaignConfigurationTabPageView.prototype.updateButtons = function() {
        var actionBtn, btnsHtml;
        actionBtn = 'Save';
        btnsHtml = this.btnsTemplate({
          actionBtnTitle: actionBtn
        });
        return $('.buttons-go-here', this.el).html(btnsHtml);
      };

      CampaignConfigurationTabPageView.prototype.render = function() {
        var el;
        el = CampaignConfigurationTabPageView.__super__.render.apply(this, arguments);
        _.each([this.campaignStatusStrip, this.campaignConfigView, this.campaignComponentsView, this.serverConfigView, this.campaignNotificationView], function(view) {
          view.setElement(el);
          return view.render();
        });
        $('<div class="buttons-go-here">').appendTo(el);
        return this.updateButtons();
      };

      return CampaignConfigurationTabPageView;

    })(SingleTabPageView);
  });

}).call(this);
