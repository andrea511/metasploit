(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignConfigurationView = (function(_super) {

      __extends(CampaignConfigurationView, _super);

      function CampaignConfigurationView() {
        return CampaignConfigurationView.__super__.constructor.apply(this, arguments);
      }

      CampaignConfigurationView.prototype.initialize = function(opts) {
        this.campaignSummary = opts['campaignSummary'];
        _.bindAll(this, 'render', 'update', 'radioChanged');
        this.campaignSummary.bind('change', this.update);
        return this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Submitting... ',
          autoOpen: false,
          closeOnEscape: false
        });
      };

      CampaignConfigurationView.prototype.template = _.template($('#campaign-configuration').html());

      CampaignConfigurationView.prototype.events = {
        'keydown [name^=\'social_engineering_campaign\']': 'nameChanged',
        'keydown input[type=radio]': 'radioKeyPress',
        'change input[type=radio]': 'radioChanged'
      };

      CampaignConfigurationView.prototype.nameChanged = function(e) {
        $('~p.inline-errors', e.target).remove();
        if (e.keyCode === 9 || e.which === 9) {
          if (!$('input[type=radio]', this.el).first().attr('disabled')) {
            $('input[type=radio]', this.el).first().focus();
          }
          e.preventDefault();
          e.stopImmediatePropagation();
          e.stopPropagation();
          return false;
        }
      };

      CampaignConfigurationView.prototype.radioKeyPress = function(e) {
        if (e.keyCode === 9 || e.which === 9) {
          if (e.shiftKey) {
            return;
          }
          return e.preventDefault();
        }
      };

      CampaignConfigurationView.prototype.radioChanged = function(e) {
        var components, configType, confirmMsg, name,
          _this = this;
        configType = $('[name="social_engineering_campaign[config_type]"]:checked', this.el).val();
        if (configType === this.campaignSummary.get('config_type')) {
          return;
        }
        name = $("[name='social_engineering_campaign[name]']", this.el).val();
        if (this.campaignSummary.get('id') === null) {
          return this.campaignSummary.set({
            config_type: configType,
            name: name
          });
        } else {
          components = this.campaignSummary.get('campaign_components');
          confirmMsg = ("Are you sure you want to switch this campaign to " + configType + " mode? ") + "This will destroy any web pages, emails, or portable files that " + "are currently associated with the campaign.";
          if (components.length > 0 && !confirm(confirmMsg)) {
            $('[name="social_engineering_campaign[config_type]"]:not(:checked)', this.el).attr('checked', 'checked');
            return;
          }
          this.campaignSummary.set({
            config_type: configType,
            campaign_components: []
          });
          this.loadingModal.dialog('open');
          return this.campaignSummary.save({
            success: function() {
              return _this.loadingModal.dialog('close');
            },
            error: function() {
              return _this.loadingModal.dialog('close');
            }
          });
        }
      };

      CampaignConfigurationView.prototype.update = function() {
        var $radioBtns, name, radioIdx;
        name = this.campaignSummary.get('name');
        $("[name='social_engineering_campaign[name]']", this.el).val(name).nextAll('p.inline-errors').fadeOut().delay(200).remove();
        radioIdx = this.campaignSummary.usesWizard() ? 0 : 1;
        $radioBtns = $("input[name='social_engineering_campaign[config_type]']");
        $radioBtns.prop('checked', false);
        return $radioBtns.eq(radioIdx).prop('checked', true);
      };

      CampaignConfigurationView.prototype.render = function() {
        if (this.dom) {
          this.dom.remove();
        }
        this.campaignConfig = this.campaignSummary.get('campaign_configuration');
        return this.dom = $($.parseHTML(this.template(this))[1]).appendTo($(this.el));
      };

      return CampaignConfigurationView;

    })(Backbone.View);
  });

}).call(this);
