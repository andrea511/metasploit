(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var DEFAULT_NOTIFICATION_MESSAGE, DEFAULT_NOTIFICATION_SUBJECT;
    DEFAULT_NOTIFICATION_MESSAGE = 'This is to let you know that we are about to launch ' + 'a social engineering campaign from Metasploit. ' + 'For more information, please contact ' + '[INSERT YOUR CONTACT NAME HERE.]';
    DEFAULT_NOTIFICATION_SUBJECT = 'Launching Metasploit social engineering campaign';
    return this.CampaignNotificationView = (function(_super) {

      __extends(CampaignNotificationView, _super);

      function CampaignNotificationView() {
        this.update = __bind(this.update, this);

        this.notificationsEnabledChanged = __bind(this.notificationsEnabledChanged, this);
        return CampaignNotificationView.__super__.constructor.apply(this, arguments);
      }

      CampaignNotificationView.prototype.initialize = function(opts) {
        return this.campaignSummary = opts['campaignSummary'];
      };

      CampaignNotificationView.prototype.createModal = function() {
        var email, msg, subject,
          _this = this;
        this.modal = $('#notification-dialog').dialog({
          modal: true,
          title: 'Notification Settings',
          autoOpen: false,
          closeOnEscape: false,
          width: 475,
          buttons: {
            "Cancel": function() {
              var $checkbox;
              $(_this.modal).dialog("close");
              if (_this.formSuccessRequired) {
                $checkbox = $('input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']', _this.el);
                $checkbox.removeAttr('checked');
                return _this.notificationsEnabledChanged({
                  target: $checkbox[0]
                });
              }
            },
            "Save": function() {
              return _this.saveNotificationSetup();
            }
          }
        });
        email = this.campaignSummary.get('notification_email_address');
        msg = this.campaignSummary.get('notification_email_message') || DEFAULT_NOTIFICATION_MESSAGE;
        subject = this.campaignSummary.get('notification_email_subject') || DEFAULT_NOTIFICATION_SUBJECT;
        this.setFormValue('notification_email_address', email);
        this.setFormValue('notification_email_message', msg);
        return this.setFormValue('notification_email_subject', subject);
      };

      CampaignNotificationView.prototype.setModalLoading = function(loading) {
        if (loading == null) {
          loading = false;
        }
        this.loadingModal || (this.loadingModal = $('<div class="loading">').dialog({
          modal: true,
          title: 'Loading...',
          autoOpen: false,
          resizable: false,
          closeOnEscape: false,
          width: 300
        }));
        if (loading) {
          this.modal.dialog('close');
          return this.loadingModal.dialog('open');
        } else {
          this.modal.dialog('open');
          return this.loadingModal.dialog('close');
        }
      };

      CampaignNotificationView.prototype.setFormValue = function(name, value) {
        return $("[name='social_engineering_campaign[" + name + "]']", this.modal).val(value);
      };

      CampaignNotificationView.prototype.getFormValue = function(name) {
        return $("[name='social_engineering_campaign[" + name + "]']", this.modal).val();
      };

      CampaignNotificationView.prototype.template = _.template($('#campaign-notification').html());

      CampaignNotificationView.prototype.events = {
        'change input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']': 'notificationsEnabledChanged',
        'click a.notification-settings': 'showNotificationSetup'
      };

      CampaignNotificationView.prototype.toggleNotificationsEnabled = function(enabled) {
        var $checkbox;
        if (enabled == null) {
          enabled = true;
        }
        $checkbox = $('input[name=\'social_engineering_campaign[prefs][notifications_enabled]\']', this.el);
        if (enabled) {
          return $checkbox.attr('checked', 'checked');
        } else {
          return $checkbox.removeAttr('checked');
        }
      };

      CampaignNotificationView.prototype.notificationsEnabledChanged = function(e) {
        var $checkbox, enabled,
          _this = this;
        $checkbox = $(e.target);
        enabled = $checkbox.is(':checked');
        this.campaignSummary.set('notification_enabled', enabled);
        $('.notification-settings', this.el).toggle(enabled);
        if (enabled) {
          this.formSuccessRequired = true;
          return this.showFormModal();
        } else {
          this.setModalLoading(true);
          return this.campaignSummary.save({
            success: function() {
              return $(_this.loadingModal).dialog('close');
            },
            error: function() {
              return $(_this.loadingModal).dialog('close');
            }
          });
        }
      };

      CampaignNotificationView.prototype.showNotificationSetup = function(e) {
        e.preventDefault();
        if (e && e.target && $(e.target).hasClass('ui-disabled')) {
          return;
        }
        this.formSuccessRequired = false;
        return this.showFormModal();
      };

      CampaignNotificationView.prototype.showFormModal = function() {
        this.createModal();
        $('.errors', this.modal).hide();
        return this.modal.dialog('open');
      };

      CampaignNotificationView.prototype.saveNotificationSetup = function() {
        var enabled, oldEmail, oldMsg, oldSubject,
          _this = this;
        this.setModalLoading(true);
        enabled = $('input[type=checkbox]', this.dom).is(':checked');
        oldEmail = this.campaignSummary.get('notification_email_address');
        oldMsg = this.campaignSummary.get('notification_email_message');
        oldSubject = this.campaignSummary.get('notification_email_subject');
        this.campaignSummary.set('notification_email_address', this.getFormValue('notification_email_address'));
        this.campaignSummary.set('notification_email_message', this.getFormValue('notification_email_message'));
        this.campaignSummary.set('notification_email_subject', this.getFormValue('notification_email_subject'));
        return this.campaignSummary.save({
          success: function(data) {
            _this.setModalLoading(false);
            if (data['success']) {
              return _this.modal.dialog('close');
            } else {
              $('.errors', _this.modal).show().html(data['message']);
              _this.campaignSummary.set('notification_email_address', oldEmail);
              _this.campaignSummary.set('notification_email_message', oldMsg);
              return _this.campaignSummary.set('notification_email_subject', oldSubject);
            }
          },
          error: function() {
            _this.setModalLoading(false);
            return _this.modal.dialog('close');
          }
        });
      };

      CampaignNotificationView.prototype.update = function() {
        var enabled, newDom;
        if (this.dom) {
          newDom = $($.parseHTML(this.template(this))[1]);
          this.dom.replaceWith(newDom);
          this.dom = newDom;
        }
        if (this.dom && this.campaignSummary) {
          this.dom.toggle(this.campaignSummary.id !== null);
        }
        enabled = this.campaignSummary.get('notification_enabled');
        if (enabled) {
          $('input[type=checkbox]', this.dom).attr('checked', 'checked');
        } else {
          $('input[type=checkbox]', this.dom).removeAttr('checked');
        }
        return $('.notification-settings', this.el).toggle(enabled);
      };

      CampaignNotificationView.prototype.render = function() {
        return this.dom = $($.parseHTML(this.template(this))[1]).appendTo($(this.el));
      };

      return CampaignNotificationView;

    })(Backbone.View);
  });

}).call(this);
