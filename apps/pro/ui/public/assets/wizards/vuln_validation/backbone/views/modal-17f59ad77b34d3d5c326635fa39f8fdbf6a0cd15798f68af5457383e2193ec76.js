(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var CONSOLE_TAB_IDX, NEXPOSE_SITE_FAILED_STATE, NEXPOSE_SITE_POLL_URL, NEXPOSE_SITE_READY_STATE, NEXPOSE_SITE_URL, PIE_CHART_SIZE, TAG_PAGE, VULN_VALIDATION_URL;
    VULN_VALIDATION_URL = '/wizards/vuln_validation/form/';
    NEXPOSE_SITE_URL = '/wizards/vuln_validation/form/nexpose_sites.json';
    NEXPOSE_SITE_POLL_URL = '/wizards/vuln_validation/form/import_run.json';
    NEXPOSE_SITE_READY_STATE = 'ready_to_import';
    NEXPOSE_SITE_FAILED_STATE = 'failed';
    CONSOLE_TAB_IDX = 1;
    PIE_CHART_SIZE = 80;
    TAG_PAGE = 2;
    return this.VulnValidationModal = (function(_super) {

      __extends(VulnValidationModal, _super);

      function VulnValidationModal() {
        this._emptyMessage = __bind(this._emptyMessage, this);

        this._consoleId = __bind(this._consoleId, this);

        this._consoleSelect = __bind(this._consoleSelect, this);

        this._additionalCreds = __bind(this._additionalCreds, this);

        this._gatherType = __bind(this._gatherType, this);

        this._scanDiv = __bind(this._scanDiv, this);

        this._importDiv = __bind(this._importDiv, this);

        this._warnDiv = __bind(this._warnDiv, this);

        this._templateDropdown = __bind(this._templateDropdown, this);

        this.toggleGenerateReport = __bind(this.toggleGenerateReport, this);

        this.renderErrors = __bind(this.renderErrors, this);

        this.resizeNexposeAdvanced = __bind(this.resizeNexposeAdvanced, this);

        this.index = __bind(this.index, this);

        this.layout = __bind(this.layout, this);

        this.useCustomTagChanged = __bind(this.useCustomTagChanged, this);

        this.renderSites = __bind(this.renderSites, this);

        this.siteLoadFailed = __bind(this.siteLoadFailed, this);

        this.loadSites = __bind(this.loadSites, this);

        this.updateNexposeAdvanced = __bind(this.updateNexposeAdvanced, this);

        this.gatherTypeChanged = __bind(this.gatherTypeChanged, this);

        this.consoleChanged = __bind(this.consoleChanged, this);

        this.additionalNexposeCredsChanged = __bind(this.additionalNexposeCredsChanged, this);

        this.addNexposeConsoleToDropdown = __bind(this.addNexposeConsoleToDropdown, this);

        this.nexposeConsoleAdded = __bind(this.nexposeConsoleAdded, this);

        this.selectAllSites = __bind(this.selectAllSites, this);

        this.newConsoleClicked = __bind(this.newConsoleClicked, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);
        return VulnValidationModal.__super__.constructor.apply(this, arguments);
      }

      VulnValidationModal.WIDTH = 840;

      VulnValidationModal.prototype._url = VULN_VALIDATION_URL;

      VulnValidationModal.prototype._modelsToTabs = {
        workspace: 0,
        nexpose: 1,
        exploit_task: 3,
        report: 4
      };

      VulnValidationModal.prototype.initialize = function() {
        VulnValidationModal.__super__.initialize.apply(this, arguments);
        this.setTitle('Vulnerability Validation');
        this.setDescription('This wizard imports, exploits, and validates vulnerabilities discovered by Nexpose.');
        this.setTabs([
          {
            name: 'Create Project'
          }, {
            name: 'Pull from Nexpose'
          }, {
            name: 'Tag'
          }, {
            name: 'Exploit'
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
            name: 'Start',
            "class": 'btn primary'
          }
        ]);
        return this.loadForm(VULN_VALIDATION_URL);
      };

      VulnValidationModal.prototype.events = _.extend({}, TabbedModalView.prototype.events, {
        'change input#tab_generate_report': 'toggleGenerateReport',
        'change .tag': 'taggingOptionChanged',
        'click .pull_nexpose a.new, .pull_nexpose a.green-add': 'newConsoleClicked',
        'change select#vuln_validation_nexpose_console_id': 'consoleChanged',
        "change input[name='vuln_validation[use_custom_tag]']": 'useCustomTagChanged',
        "change input[name='vuln_validation[nexpose_gather_type]']": 'gatherTypeChanged',
        "change li#additional_creds_checkbox_input input[type=checkbox]": 'additionalNexposeCredsChanged',
        "change .pull_nexpose .advanced .sites input.select-all": 'selectAllSites'
      });

      VulnValidationModal.prototype.formLoadedSuccessfully = function(html) {
        var enabled;
        VulnValidationModal.__super__.formLoadedSuccessfully.apply(this, arguments);
        enabled = !!$("[name*='report_enabled']", this.$modal).attr('value');
        $('input#tab_generate_report', this.$modal).prop('checked', enabled);
        $('input#tab_tag', this.$modal).prop('checked', enabled);
        this._cachedSitesDiv = $('.sites', this.el).html();
        this.toggleGenerateReport(true);
        return $('.report_sections,.report_options', this.$modal).find('ol li label').removeAttr('for');
      };

      VulnValidationModal.prototype.taggingOptionChanged = function() {
        if ($('.tag>li input:checked', this.$modal).size() > 0) {
          return $("[name*='tagging_enabled']", this.$modal).attr('value', '1');
        } else {
          return $("[name*='tagging_enabled']", this.$modal).removeAttr('value');
        }
      };

      VulnValidationModal.prototype.newConsoleClicked = function(e) {
        var _this = this;
        return initProRequire(['base_layout', 'base_itemview', 'lib/shared/nexpose_console/nexpose_console_controller', 'lib/components/modal/modal_controller'], function() {
          var nexposeConsole;
          nexposeConsole = Pro.request('nexposeConsole:shared', {});
          Pro.execute('show:nexposeConsole', nexposeConsole);
          return nexposeConsole.on('consoleAdded:nexposeConsole', _this.nexposeConsoleAdded);
        });
      };

      VulnValidationModal.prototype.selectAllSites = function(e) {
        var checked;
        checked = $(e.currentTarget).is(':checked');
        return this._importDiv().find('table tbody tr input[type=checkbox]').prop('checked', checked);
      };

      VulnValidationModal.prototype.nexposeConsoleAdded = function(json) {
        return this.addNexposeConsoleToDropdown(json);
      };

      VulnValidationModal.prototype.addNexposeConsoleToDropdown = function(opts) {
        var $option;
        $option = $('<option />', {
          value: opts.id
        }).text(opts.name);
        this._consoleSelect().append($option);
        $option.prop('selected', true);
        return this._consoleSelect().trigger('change');
      };

      VulnValidationModal.prototype.additionalNexposeCredsChanged = function(e) {
        return this._additionalCreds().toggle($(e.currentTarget).is(':checked'));
      };

      VulnValidationModal.prototype.consoleChanged = function(e) {
        return this.updateNexposeAdvanced();
      };

      VulnValidationModal.prototype.gatherTypeChanged = function(e) {
        return this.updateNexposeAdvanced();
      };

      VulnValidationModal.prototype.updateNexposeAdvanced = function() {
        var $page, console;
        this._warnDiv().hide();
        $page = $('.pull_nexpose.page', this.el);
        $page.find('.advanced>div').hide();
        console = this._consoleId();
        if (!console || ('' + console).length === 0) {
          return $page.find('.empty_msg').show();
        } else {
          $page.find("." + (this._gatherType())).show();
          return this.loadSites(console);
        }
      };

      VulnValidationModal.prototype.loadSites = function(consoleId) {
        var $div, delay, loadFailed, load_msg, xhr,
          _this = this;
        this.pageAt(CONSOLE_TAB_IDX).css({
          opacity: 0.4,
          'pointer-events': 'none'
        });
        $div = this._gatherType() === 'import' ? this._importDiv() : this._scanDiv();
        $div.addClass('tab-loading').find('.sites').hide().end().find('table>*').remove().end().find('table').css({
          width: '100%'
        }).end().find('*').css({
          opacity: 0
        }).end();
        if (this._gatherType() === 'import') {
          load_msg = "Importing Sites...";
        } else {
          load_msg = "Importing Scan Templates...";
        }
        $div.prepend("<div class='tab-loading-text'>" + load_msg + "</div>");
        $('p.error-desc', this.pageAt(CONSOLE_TAB_IDX)).remove();
        this._warnDiv().hide();
        loadFailed = function() {
          loadFailed = null;
          return _.once(_this.siteLoadFailed, $div);
        };
        delay = 1000;
        xhr = $.ajax({
          url: NEXPOSE_SITE_URL,
          type: 'GET',
          data: {
            nexpose_console_id: consoleId
          },
          success: function(importRun) {
            var poll;
            poll = function() {
              var pollXhr;
              return pollXhr = $.ajax({
                url: NEXPOSE_SITE_POLL_URL,
                type: 'GET',
                data: {
                  id: importRun.id,
                  cache: new Date().getTime()
                },
                success: function(json) {
                  var $select;
                  if (json.state !== NEXPOSE_SITE_READY_STATE && json.state !== NEXPOSE_SITE_FAILED_STATE) {
                    if (loadFailed != null) {
                      return setTimeout(poll, 1000);
                    }
                  } else if (json.state === NEXPOSE_SITE_FAILED_STATE) {
                    if (loadFailed != null) {
                      return loadFailed(pollXhr);
                    }
                  } else {
                    loadFailed = null;
                    $div.removeClass('tab-loading').find('.sites').show();
                    $div.find('*').css({
                      opacity: 1
                    });
                    $('.tab-loading-text', $div).remove();
                    _this.pageAt(CONSOLE_TAB_IDX).css({
                      opacity: 1,
                      'pointer-events': 'auto'
                    });
                    _this.pageAt(CONSOLE_TAB_IDX).find("[name*='import_run_id']").val(importRun.id);
                    if (_this._gatherType() === 'import') {
                      return _this.renderSites(json.sites);
                    } else {
                      json.templates || (json.templates = []);
                      $select = _this._templateDropdown();
                      $select.html('');
                      return _.each(json.templates.reverse(), function(template) {
                        var $option;
                        $option = $('<option />', {
                          value: template.scan_template_id
                        }).text(template.name);
                        return $select.append($option);
                      });
                    }
                  }
                },
                error: function() {
                  if (loadFailed != null) {
                    return loadFailed(pollXhr);
                  }
                }
              });
            };
            return setTimeout(poll, delay);
          },
          error: function() {
            if (loadFailed != null) {
              return loadFailed(xhr);
            }
          }
        });
        return setTimeout((function() {
          return delay = 30 * 1000;
        }), 60 * 1000);
      };

      VulnValidationModal.prototype.siteLoadFailed = function(xhr, div) {
        this._warnDiv().show();
        $div.removeClass('tab-loading').show();
        $('.tab-loading-text', $div).remove();
        $div.find('*').css({
          opacity: 0
        });
        return this.pageAt(CONSOLE_TAB_IDX).css({
          opacity: 1,
          'pointer-events': 'auto'
        });
      };

      VulnValidationModal.prototype.renderSites = function(sites) {
        var $nexpose, $table,
          _this = this;
        $nexpose = $('.page.pull_nexpose .advanced.nexpose', this.el);
        $nexpose.find('.import .sites').html(this._cachedSitesDiv);
        $table = $nexpose.find('table');
        sites = _.map(sites, function(site) {
          return [site.id, site.name, site.summary.assets_count, site.summary.vulnerabilities_count, site.last_scan_date];
        });
        this._warnDiv().hide();
        return $table.dataTable({
          aaData: sites,
          bPaginate: false,
          aaSorting: [[4, 'asc']],
          aoColumns: [
            {
              sTitle: '<input type="checkbox" class="select-all" />',
              sWidth: '30px',
              bSortable: false,
              fnRender: function(row) {
                return "<input type='checkbox' value='" + row.aData[0] + "' name='vuln_validation[nexpose_sites][]' />";
              }
            }, {
              sTitle: 'Name'
            }, {
              sTitle: 'Assets'
            }, {
              sTitle: 'Vulns'
            }, {
              sTitle: 'Last Scan',
              sWidth: '150px',
              sType: 'title-string',
              fnRender: function(row) {
                var time;
                time = row.aData[row.aData.length - 1];
                if (time != null) {
                  return "<span title='" + (_.escape(time)) + "'>" + (_.escape(moment(time).fromNow())) + "</span>";
                } else {
                  return "";
                }
              }
            }
          ]
        });
      };

      VulnValidationModal.prototype.useCustomTagChanged = function(e) {
        return $('.advanced.custom_tag', this.el).toggle($(e.target).is(':checked'));
      };

      VulnValidationModal.prototype.layout = function() {
        this.$modal.width(VulnValidationModal.WIDTH);
        return this.center();
      };

      VulnValidationModal.prototype.index = function(idx) {
        VulnValidationModal.__super__.index.apply(this, arguments);
        if (idx === CONSOLE_TAB_IDX) {
          return this.resizeNexposeAdvanced();
        }
      };

      VulnValidationModal.prototype.resizeNexposeAdvanced = function() {
        var $page, padTop;
        $page = this.pageAt(CONSOLE_TAB_IDX);
        padTop = _.inject($page.find('.foundation .row'), (function(m, el) {
          return m + $(el).height();
        }), 0);
        return $page.find('div.advanced').height($page.parents('.content').first().height() - padTop - 43);
      };

      VulnValidationModal.prototype.renderErrors = function(errs) {
        VulnValidationModal.__super__.renderErrors.apply(this, arguments);
        return this.resizeNexposeAdvanced();
      };

      VulnValidationModal.prototype.toggleGenerateReport = function(e) {
        var checked;
        if (!$(e.currentTarget).parents('li').first().hasClass('selected')) {
          if (e !== true) {
            return;
          }
        }
        checked = (e === true) || $(e.currentTarget).is(':checked');
        $('.generate_report h3.enabled>span', this.$modal).removeClass('disabled enabled');
        if (checked) {
          $('.generate_report h3.enabled>span', this.$modal).text("enabled").addClass('enabled').removeClass('disabled');
          return $("[name*='report_enabled']", this.$modal).attr('value', '1');
        } else {
          $('.generate_report h3.enabled>span', this.$modal).text("disabled").addClass('disabled').removeClass('enabled');
          return $("[name*='report_enabled']", this.$modal).removeAttr('value');
        }
      };

      VulnValidationModal.prototype._templateDropdown = function() {
        return $('#nexpose_scan_task_scan_template', this.el);
      };

      VulnValidationModal.prototype._warnDiv = function() {
        return $('.page.pull_nexpose .advanced.nexpose .warn', this.el);
      };

      VulnValidationModal.prototype._importDiv = function() {
        return $('.page.pull_nexpose .advanced.nexpose .import', this.el);
      };

      VulnValidationModal.prototype._scanDiv = function() {
        return $('.page.pull_nexpose .advanced.nexpose .scan', this.el);
      };

      VulnValidationModal.prototype._gatherType = function() {
        return $("[name='vuln_validation[nexpose_gather_type]']:checked", this.$modal).val();
      };

      VulnValidationModal.prototype._additionalCreds = function() {
        return $('.page.pull_nexpose .additional_creds_fields', this.$modal);
      };

      VulnValidationModal.prototype._consoleSelect = function() {
        return $('.page.pull_nexpose select#vuln_validation_nexpose_console_id', this.$modal);
      };

      VulnValidationModal.prototype._consoleId = function() {
        return this._consoleSelect().find('option:selected').val();
      };

      VulnValidationModal.prototype._emptyMessage = function() {
        return $('.page.pull_nexpose .nexpose .empty_msg', this.$modal);
      };

      return VulnValidationModal;

    })(this.TabbedModalView);
  });

}).call(this);
