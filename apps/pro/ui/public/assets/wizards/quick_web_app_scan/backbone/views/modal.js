(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var QUICK_WEB_APP_SCAN_URL;
    QUICK_WEB_APP_SCAN_URL = '/wizards/quick_web_app_scan/form/';
    return this.QuickWebAppScanModal = (function(_super) {

      __extends(QuickWebAppScanModal, _super);

      function QuickWebAppScanModal() {
        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

        this.render = __bind(this.render, this);

        this.submitButtonClicked = __bind(this.submitButtonClicked, this);

        this.generateToggleCallback = __bind(this.generateToggleCallback, this);

        this.toggleFindVulns = __bind(this.toggleFindVulns, this);

        this.authTypeChanged = __bind(this.authTypeChanged, this);

        this.scanTypeChanged = __bind(this.scanTypeChanged, this);
        return QuickWebAppScanModal.__super__.constructor.apply(this, arguments);
      }

      QuickWebAppScanModal.prototype._modelsToTabs = {
        workspace: 0,
        web_scan_task: 0,
        import_task: 0,
        web_audit_task: 2,
        web_sploit_task: 3,
        report: 4
      };

      QuickWebAppScanModal.prototype.initialize = function() {
        QuickWebAppScanModal.__super__.initialize.apply(this, arguments);
        this.setTitle('Web App Test');
        this.setDescription('To start, choose a scan option to bring web application ' + 'data into the project. Then, complete the required fields ' + 'on the General tab to create a project. If you want to use ' + 'the default settings for the scan, you can launch the scan ' + 'immediately after you complete the required fields. However, ' + 'to customize the scan, click on the option tabs on the left ' + 'to enable/disable options and to configure them.');
        this.setTabs([
          {
            name: 'General'
          }, {
            name: 'Authentication',
            checkbox: true
          }, {
            name: 'Find Vulnerabilities',
            checkbox: true
          }, {
            name: 'Exploit Vulnerabilities',
            checkbox: true
          }, {
            name: 'Generate Report',
            checkbox: true
          }
        ]);
        this.setButtons([
          {
            name: 'Cancel',
            "class": 'close'
          }, {
            name: 'Start Scan',
            "class": 'btn primary'
          }
        ]);
        this.loadForm(QUICK_WEB_APP_SCAN_URL);
        this.toggleGenerateReport = this.generateToggleCallback('report_enabled');
        this._toggleFindVulns = this.generateToggleCallback('web_audit_enabled');
        this.toggleExploitVulns = this.generateToggleCallback('web_sploit_enabled');
        return this.toggleAuth = this.generateToggleCallback('toggle_auth', 'auth_enabled');
      };

      QuickWebAppScanModal.prototype.events = _.extend({
        'click input#tab_generate_report': 'toggleGenerateReport',
        'click input#tab_authentication': 'toggleAuth',
        'click input#tab_find_vulnerabilities': 'toggleFindVulns',
        'click input#tab_exploit_vulnerabilities': 'toggleExploitVulns',
        'change .configure_auth .radio input[type=checkbox]': 'authTypeChanged',
        'change #quick_web_app_scan_scan_type_input input': 'scanTypeChanged'
      }, TabbedModalView.prototype.events);

      QuickWebAppScanModal.prototype.scanTypeChanged = function(e) {
        var $checkedInput;
        $checkedInput = $('#quick_web_app_scan_scan_type_input input:checked', this.$modal);
        $('#web_scan_task_urls_input,div.advanced #scan_now_advanced', this.$modal).toggle($checkedInput.val() === 'scan_now');
        $('#import_task_file_input,#import_file_big_header,div.advanced #import_advanced', this.$modal).toggle($checkedInput.val() !== 'scan_now');
        return $('.page.create_project a.advanced', this.$modal).toggleClass('import', $checkedInput.val() !== 'scan_now');
      };

      QuickWebAppScanModal.prototype.authTypeChanged = function(e) {
        $('#basic_auth_row>div, #cookie_auth_row>div', this.$modal).removeClass('disabled').find(':input').removeAttr('disabled');
        if (!$('#basic_auth_row input[type=checkbox]', this.$modal).first().is(':checked')) {
          $('#basic_auth_row>div:not(:first)', this.$modal).addClass('disabled').find(':input').attr('disabled', 'disabled');
          if (e && $(e.currentTarget).is('#basic_auth_row input[type=checkbox]')) {
            $('#basic_auth_row :text, #basic_auth_row :password').val('');
          }
        }
        if (!$('#cookie_auth_row input[type=checkbox]', this.$modal).first().is(':checked')) {
          $('#cookie_auth_row>div:not(:first)', this.$modal).addClass('disabled').find(':input').attr('disabled', 'disabled');
          if (e && $(e.currentTarget).is('#cookie_auth_row input[type=checkbox]')) {
            $('#cookie_auth_row textarea').val('');
          }
        }
        if (e) {
          return $(e.currentTarget).parents('.cell').first().siblings().first().find(':input').focus();
        }
      };

      QuickWebAppScanModal.prototype.toggleFindVulns = function(e) {
        $('input#tab_exploit_vulnerabilities', this.$modal).parents('li').first().toggleClass('tab-click-disabled', !$(e.target).is(':checked'));
        return this._toggleFindVulns.apply(this, arguments);
      };

      QuickWebAppScanModal.prototype.generateToggleCallback = function(name, input_name) {
        var _this = this;
        input_name || (input_name = name);
        return function(e) {
          var $page, $targ, checked, idx;
          $targ = $(e.currentTarget);
          checked = $targ.is(':checked');
          idx = $targ.parents('li').first().index();
          $page = _this.content().find('div.page').eq(idx);
          $('h3.enabled>span', $page).removeClass('disabled enabled');
          if (checked) {
            $('h3.enabled>span', $page).text("enabled").addClass('enabled');
            return $("[name='quick_web_app_scan[" + input_name + "]']", _this.$modal).attr('value', '1');
          } else {
            $('h3.enabled>span', $page).text("disabled").addClass('disabled');
            return $("[name='quick_web_app_scan[" + input_name + "]']", _this.$modal).removeAttr('value');
          }
        };
      };

      QuickWebAppScanModal.prototype.submitButtonClicked = function() {
        var $form;
        $form = $('form', this.$modal).first();
        $form.attr('action', QUICK_WEB_APP_SCAN_URL);
        return QuickWebAppScanModal.__super__.submitButtonClicked.apply(this, arguments);
      };

      QuickWebAppScanModal.prototype.render = function() {
        QuickWebAppScanModal.__super__.render.apply(this, arguments);
        return this.$modal.addClass('quick-web-app-scan-modal');
      };

      QuickWebAppScanModal.prototype.transformFormData = function($inputs) {
        $inputs = QuickWebAppScanModal.__super__.transformFormData.apply(this, arguments);
        $inputs.filter("[value='" + INFINITY + "']").val("" + INFINITY_DISCRETE);
        $inputs = $inputs.add($("li#quick_web_app_scan_scan_type_input input:checked", this.$modal));
        return $inputs;
      };

      QuickWebAppScanModal.prototype.transformErrorData = function(errorsHash) {
        var ws;
        errorsHash = QuickWebAppScanModal.__super__.transformErrorData.apply(this, arguments);
        ws = errorsHash.errors['web_scan_task'];
        if (ws === 'No valid URLs have been provided') {
          errorsHash.errors['web_scan_task'] = {
            urls: [ws]
          };
        }
        return errorsHash;
      };

      QuickWebAppScanModal.prototype.formLoadedSuccessfully = function(html) {
        if (!this.content().is(':visible')) {
          return;
        }
        QuickWebAppScanModal.__super__.formLoadedSuccessfully.apply(this, arguments);
        if ($("[name='quick_web_app_scan[report_enabled]']", this.$modal).val() === "true") {
          $("#tab_generate_report", this.$modal).prop('checked', true);
        }
        if ($("[name='quick_web_app_scan[auth_enabled]']", this.$modal).val() === "true") {
          $("#tab_authentication", this.$modal).prop('checked', true);
        }
        if ($("[name='quick_web_app_scan[web_audit_enabled]']", this.$modal).val() === "true") {
          $("#tab_find_vulnerabilities", this.$modal).prop('checked', true);
        }
        if ($("[name='quick_web_app_scan[web_sploit_enabled]']", this.$modal).val() === "true") {
          $("#tab_exploit_vulnerabilities", this.$modal).prop('checked', true);
        }
        $('form.quick_pentest>div.page', this.$el).hide().first().show();
        this.authTypeChanged();
        $('.report_sections,.report_options', this.$modal).find('ol li label').removeAttr('for');
        return $('li#quick_web_app_scan_scan_type_input', this.$modal).insertAfter($('h1:first', this.$modal));
      };

      return QuickWebAppScanModal;

    })(this.TabbedModalView);
  });

}).call(this);
