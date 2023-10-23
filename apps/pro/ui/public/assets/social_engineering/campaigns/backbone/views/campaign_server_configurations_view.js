(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignServerConfigurationsView = (function(_super) {

      __extends(CampaignServerConfigurationsView, _super);

      function CampaignServerConfigurationsView() {
        return CampaignServerConfigurationsView.__super__.constructor.apply(this, arguments);
      }

      CampaignServerConfigurationsView.prototype.SMTP_CHECK_URL = "email_server_config/check_smtp";

      CampaignServerConfigurationsView.prototype.initialize = function(opts) {
        _.bindAll(this, 'render', 'update', 'webServerConfigClicked', 'emailServerConfigClicked');
        this.campaignSummary = opts['campaignSummary'];
        return this.campaignSummary.bind('change', this.update);
      };

      CampaignServerConfigurationsView.prototype.events = {
        'click ul li a': 'implicitlyCreateCampaign',
        'click .web-server-config-open-modal': 'webServerConfigClicked',
        'click .email-server-config-open-modal': 'emailServerConfigClicked'
      };

      CampaignServerConfigurationsView.prototype.baseURL = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + this.campaignSummary.id;
      };

      CampaignServerConfigurationsView.prototype.configModalOpts = function() {
        var opts,
          _this = this;
        return opts = {
          confirm: 'Are you sure you want to close? Your unsaved changes will be lost.',
          save: function() {
            var $form, data;
            $form = $('form', _this.modal.el).first();
            Placeholders.submitHandler($form[0]);
            if ($(':file', $form).size() > 0) {
              data = $(':input', $form[0]).not(':file').serializeArray();
              return $.ajax({
                url: $form.attr('action'),
                type: $form.attr('method'),
                data: data,
                iframe: true,
                files: $(':file', $form),
                processData: false,
                complete: function(data) {
                  data = $.parseJSON(data.responseText);
                  if (data.success === true) {
                    return _this._successCallback(data);
                  } else {
                    return _this._errorCallback(data.error);
                  }
                }
              });
            } else {
              return $.ajax({
                url: $form.attr('action'),
                type: $form.attr('method'),
                data: $form.serialize(),
                success: function(data) {
                  return _this._successCallback(data);
                },
                error: function(response) {
                  return _this._errorCallback(response.responseText);
                }
              });
            }
          }
        };
      };

      CampaignServerConfigurationsView.prototype._errorCallback = function(error) {
        $('.content-frame>.content', this.modal.el).html(error);
        this.modal.onLoad();
        if (this.modal.options['onLoad']) {
          return this.modal.options['onLoad'].call(this);
        }
      };

      CampaignServerConfigurationsView.prototype._successCallback = function(data) {
        this.campaignSummary.set(data);
        this.update();
        return this.modal.close({
          confirm: false
        });
      };

      CampaignServerConfigurationsView.prototype.implicitlyCreateCampaign = function(e) {
        var data;
        if (this.campaignSummary.id === null) {
          e.stopImmediatePropagation();
          e.stopPropagation();
          e.preventDefault();
          data = $('form.social_engineering_campaign', this.el).serialize();
          return $(document).trigger('createCampaign', {
            data: data,
            callback: function() {
              return $(e.target).click();
            }
          });
        }
      };

      CampaignServerConfigurationsView.prototype.webServerConfigClicked = function(e) {
        var bapExists, opts, saveCallback, shouldShowBapOptions, url;
        url = "" + (this.baseURL()) + "/web_server_config/edit";
        bapExists = _.any(this.campaignSummary.get('campaign_components'), function(comp) {
          return comp.type === 'web_page' && comp.attack_type.toLowerCase() === 'bap';
        });
        shouldShowBapOptions = !this.campaignSummary.usesWizard() && bapExists;
        opts = this.configModalOpts();
        opts['onLoad'] = function() {
          var $customCertCheckbox, $sslCheckbox, $textField,
            _this = this;
          $("[name='social_engineering_campaign[web_host]']", this.el).last().bind('click focus', function() {
            return $("input[name='social_engineering_campaign[web_host_custom]']", _this.el).focus();
          });
          $("[name='social_engineering_campaign[web_host]'][checked]", this.el).focus();
          $sslCheckbox = $("[name='social_engineering_campaign[web_ssl]']", this.el);
          $sslCheckbox.change(function(e) {
            var $port, ssl;
            ssl = $(e.target).is(':checked');
            $('div.ssl-options').toggle(ssl);
            $port = $("[name='social_engineering_campaign[web_port]']", this.el);
            if (ssl && $port.val() === '80') {
              $port.val('443');
            }
            if (!ssl && $port.val() === '443') {
              return $port.val('80');
            }
          });
          $sslCheckbox.change();
          $customCertCheckbox = $("[name='social_engineering_campaign[web_ssl_use_custom_cert]']", this.el);
          $customCertCheckbox.change(function(e) {
            var $tf, checked;
            checked = $(e.target).is(':checked');
            $tf = $("[name='social_engineering_campaign[web_ssl_cert]']", this.el);
            return $tf.toggle(checked);
          });
          $customCertCheckbox.change();
          $textField = $("input[name='social_engineering_campaign[web_host_custom]']", this.el);
          $("label[for=social_engineering_campaign_web_host_custom_value]", this.el).append($textField);
          return $('.bap-options', this.el).toggle(shouldShowBapOptions);
        };
        saveCallback = opts['save'];
        opts['save'] = function() {
          var $lastRadio, $textField;
          $lastRadio = $("[name='social_engineering_campaign[web_host]']", this.el).last();
          if ($lastRadio.prop('checked')) {
            $textField = $("input[name='social_engineering_campaign[web_host_custom]']", this.el);
            $lastRadio.val($textField.val());
            $textField.remove();
          }
          Placeholders.submitHandler($('form', this.el)[0]);
          if (saveCallback) {
            return saveCallback.call(this);
          }
        };
        this.modal = new FormView(opts);
        return this.modal.load(url);
      };

      CampaignServerConfigurationsView.prototype.emailServerConfigClicked = function(e) {
        var opts, saveCallback, smtpCheckUrl, url;
        url = "" + (this.baseURL()) + "/email_server_config/edit";
        smtpCheckUrl = "" + (this.baseURL()) + "/" + this.SMTP_CHECK_URL;
        opts = this.configModalOpts();
        saveCallback = opts['save'];
        opts['save'] = function() {
          var $form, data,
            _this = this;
          $form = $('form', this.el).first();
          data = $form.serialize();
          $('.validate-box .status', this.el).removeClass('bad ok').text('Verifying SMTP settings...').addClass('spinning');
          $('a.save.primary', this.el).addClass('ui-disabled').parent('span').addClass('ui-disabled');
          return $.ajax({
            url: smtpCheckUrl,
            type: 'POST',
            data: data,
            success: function(resp) {
              var $status;
              if (!_this.opened) {
                return;
              }
              $status = $('.validate-box .status', _this.el);
              $status.removeClass('spinning bad').addClass('ok');
              data = $.parseJSON(resp.responseText);
              $status.text('Connection successful');
              $('a.save.primary', _this.el).removeClass('ui-disabled').parent('span').removeClass('ui-disabled');
              return saveCallback();
            },
            error: function(resp) {
              var $status;
              if (!_this.opened) {
                return;
              }
              $status = $('.validate-box .status', _this.el);
              $status.removeClass('spinning ok').addClass('bad');
              data = $.parseJSON(resp.responseText);
              $status.text(data['error_msg']);
              $('a.save.primary', _this.el).removeClass('ui-disabled').parent('span').removeClass('ui-disabled');
              if (!confirm("We were unable to connect to the provided SMTP server." + " Do you want to save anyway?")) {
                return;
              }
              return saveCallback();
            }
          });
        };
        opts['onLoad'] = function() {
          var $smtpPassField, TAB_KEY_CODE;
          TAB_KEY_CODE = 9;
          $smtpPassField = $("input[name='social_engineering_campaign[smtp_password]']", this.el);
          return $smtpPassField.keydown(function(e) {
            if (e.keyCode !== TAB_KEY_CODE && !e.shiftKey && $(e.target).val() === PASSWORD_UNCHANGED) {
              return $(e.target).val('');
            }
          });
        };
        this.modal = new FormView(opts);
        return this.modal.load(url);
      };

      CampaignServerConfigurationsView.prototype.template = _.template($('#campaign-server-configurations').html());

      CampaignServerConfigurationsView.prototype.update = function() {
        var $li, components, configData, configType, emailCount, showWebConfigured, webCount;
        components = this.campaignSummary.get('campaign_components');
        configType = this.campaignSummary.get('config_type');
        webCount = components.filter(function(c) {
          return c.type === 'web_page';
        }).length;
        emailCount = components.filter(function(c) {
          return c.type === 'email';
        }).length;
        configData = this.campaignSummary.get('campaign_configuration');
        if (configType !== 'wizard' && (!this.campaignSummary.id || (webCount + emailCount === 0))) {
          return $('.campaign-server-config-div', this.el).addClass('disabled');
        } else {
          $('.campaign-server-config-div', this.el).removeClass('disabled');
          $('ul.campaign-server-config-items>li', this.el).hide();
          if (configType === 'wizard' || webCount > 0) {
            $li = $('li.web-server-config-open-modal', this.el);
            $li.show().removeClass('unconfigured');
            showWebConfigured = configType === 'wizard' && this.campaignSummary.id === null;
            if (!(showWebConfigured || configData['web_config']['configured'])) {
              $li.addClass('unconfigured');
            }
          }
          if (configType === 'wizard' || emailCount > 0) {
            $li = $('li.email-server-config-open-modal', this.el);
            $li.show().removeClass('unconfigured');
            if (!configData['smtp_config']['configured']) {
              return $li.addClass('unconfigured');
            }
          }
        }
      };

      CampaignServerConfigurationsView.prototype.render = function() {
        this.dom = $($.parseHTML(this.template(this))[1]).appendTo($(this.el));
        return this.update();
      };

      return CampaignServerConfigurationsView;

    })(Backbone.View);
  });

}).call(this);
