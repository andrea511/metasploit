(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignSummary = (function(_super) {

      __extends(CampaignSummary, _super);

      function CampaignSummary() {
        return CampaignSummary.__super__.constructor.apply(this, arguments);
      }

      CampaignSummary.prototype.defaults = {
        name: '',
        config_type: 'wizard',
        web_host: '',
        web_port: 80,
        notification_enabled: false,
        notification_email_address: '',
        notification_email_subject: '',
        notification_email_message: '',
        id: null,
        campaign_facts: {
          emails_sent: {
            visible: false,
            count: ''
          },
          emails_opened: {
            visible: false,
            count: ''
          },
          links_clicked: {
            visible: false,
            count: ''
          },
          forms_started: {
            visible: false,
            count: ''
          },
          forms_submitted: {
            visible: false,
            count: ''
          },
          prone_to_bap: {
            visible: false,
            count: ''
          },
          sessions_opened: {
            visible: false,
            count: ''
          }
        },
        campaign_details: {
          current_status: '',
          email_count: '',
          web_page_count: '',
          portable_file_count: '',
          email_targets_count: '',
          started_at: '',
          evidence_collected: '',
          name: ''
        },
        campaign_components: [],
        campaign_configuration: {
          web_config: {
            configured: false
          },
          smtp_config: {
            configured: false
          }
        }
      };

      CampaignSummary.prototype.webPages = function() {
        var components;
        components = this.get('campaign_components');
        return _.filter(components, function(c) {
          return c.type === 'web_page';
        });
      };

      CampaignSummary.prototype.emails = function() {
        var components;
        components = this.get('campaign_components');
        return _.filter(components, function(c) {
          return c.type === 'email';
        });
      };

      CampaignSummary.prototype.hasWebPagesOrEmails = function() {
        var cd;
        cd = this.get('campaign_details');
        return cd.email_count + cd.web_page_count > 0;
      };

      CampaignSummary.prototype.hasBeenLaunched = function() {
        return this.get('campaign_details').started_at.toLowerCase() !== 'not started';
      };

      CampaignSummary.prototype.running = function() {
        return this.get('campaign_details').current_status.toLowerCase() === 'running';
      };

      CampaignSummary.prototype.preparing = function() {
        return this.get('campaign_details').current_status.toLowerCase() === 'preparing';
      };

      CampaignSummary.prototype.launchable = function() {
        return this.get('campaign_details').startable;
      };

      CampaignSummary.prototype.usesWizard = function() {
        return this.get('config_type') === 'wizard';
      };

      CampaignSummary.prototype.save = function(opts) {
        var name, paramNames, params, url, _i, _len;
        if (opts == null) {
          opts = {};
        }
        url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + this.id + ".json";
        paramNames = ['config_type', 'name', 'notification_enabled', 'notification_email_message', 'notification_email_address', 'notification_email_subject'];
        params = [];
        for (_i = 0, _len = paramNames.length; _i < _len; _i++) {
          name = paramNames[_i];
          params.push({
            name: "social_engineering_campaign[" + name + "]",
            value: this.get(name)
          });
        }
        params.push({
          name: '_method',
          value: 'PUT'
        });
        return $.ajax({
          url: url,
          data: params,
          type: 'POST',
          success: opts['success'],
          error: opts['success']
        });
      };

      return CampaignSummary;

    })(Backbone.Model);
  });

}).call(this);
