(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/apps/backbone/views/app_tabbed_modal-47bc923af640493921da87e077e6e91f982f1e34a731bbf5c8ee2b73d047af83.js'], function($, AppTabbedModalView) {
    var CRED_INTRUSION_URL, CredentialIntrusion;
    CRED_INTRUSION_URL = "/workspaces/" + WORKSPACE_ID + "/apps/credential_intrusion/task_config/";
    return CredentialIntrusion = (function(_super) {

      __extends(CredentialIntrusion, _super);

      function CredentialIntrusion() {
        this.submitUrl = __bind(this.submitUrl, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);
        return CredentialIntrusion.__super__.constructor.apply(this, arguments);
      }

      CredentialIntrusion.prototype.initialize = function() {
        CredentialIntrusion.__super__.initialize.apply(this, arguments);
        this.setTitle('Known Credentials Intrusion');
        this.setDescription('Uses known credentials to compromise hosts across ' + 'the entire network. You can run this MetaModule to reuse credentials ' + 'that you obtained from bruteforce attacks, phishing attacks, or exploited hosts.');
        return this.setTabs([
          {
            name: 'Scope'
          }, {
            name: 'Payload'
          }, {
            name: 'Generate Report',
            checkbox: true
          }
        ]);
      };

      CredentialIntrusion.prototype.formLoadedSuccessfully = function(html) {
        CredentialIntrusion.__super__.formLoadedSuccessfully.apply(this, arguments);
        return $(this.el).trigger('tabbed-modal-loaded');
      };

      CredentialIntrusion.prototype.submitUrl = function() {
        return CRED_INTRUSION_URL;
      };

      return CredentialIntrusion;

    })(AppTabbedModalView);
  });

}).call(this);
