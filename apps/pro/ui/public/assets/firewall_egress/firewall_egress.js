(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/apps/backbone/views/app_tabbed_modal-47bc923af640493921da87e077e6e91f982f1e34a731bbf5c8ee2b73d047af83.js'], function($, AppTabbedModalView) {
    var EGADZ_START_URL, FirewallEgressModalView;
    EGADZ_START_URL = '/workspaces/' + ("" + WORKSPACE_ID) + '/apps/firewall_egress/task_config/';
    return FirewallEgressModalView = (function(_super) {

      __extends(FirewallEgressModalView, _super);

      function FirewallEgressModalView() {
        this.customScanTarget = __bind(this.customScanTarget, this);

        this.manualMode = __bind(this.manualMode, this);

        this.scanTargetTypeChanged = __bind(this.scanTargetTypeChanged, this);

        this.portTypeChanged = __bind(this.portTypeChanged, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

        this.submitUrl = __bind(this.submitUrl, this);
        return FirewallEgressModalView.__super__.constructor.apply(this, arguments);
      }

      FirewallEgressModalView.prototype.events = _.extend({
        'change #task_config_port_type_input input': 'portTypeChanged',
        'change #task_config_scan_target_type_input input': 'scanTargetTypeChanged'
      }, AppTabbedModalView.prototype.events);

      FirewallEgressModalView.prototype.initialize = function() {
        FirewallEgressModalView.__super__.initialize.apply(this, arguments);
        this.setTitle('Segmentation and Firewall Testing');
        this.setDescription('Runs an Nmap SYN scan against an egress target to identify the ' + 'ports that allow egress traffic out of the network.');
        return this.setTabs([
          {
            name: 'Scan Config'
          }, {
            name: 'Generate Report',
            checkbox: true
          }
        ]);
      };

      FirewallEgressModalView.prototype.submitUrl = function() {
        return EGADZ_START_URL;
      };

      FirewallEgressModalView.prototype.formLoadedSuccessfully = function(html) {
        FirewallEgressModalView.__super__.formLoadedSuccessfully.apply(this, arguments);
        this.portTypeChanged();
        this.scanTargetTypeChanged();
        return $(this.el).trigger('tabbed-modal-loaded');
      };

      FirewallEgressModalView.prototype.portTypeChanged = function() {
        var $portRanges, $startPortInput;
        $portRanges = $('.advanced.port_ranges', this.$modal);
        $startPortInput = $('#task_config_nmap_start_port', this.$modal);
        if (this.manualMode()) {
          $portRanges.show();
          return $startPortInput.select();
        } else {
          return $portRanges.hide();
        }
      };

      FirewallEgressModalView.prototype.scanTargetTypeChanged = function() {
        var $customHostInput, $scanTargets;
        $scanTargets = $('.advanced.scan_targets', this.$modal);
        $customHostInput = $('input#task_config_dst_host', this.$modal);
        if (this.customScanTarget()) {
          $scanTargets.show();
          return $customHostInput.select();
        } else {
          return $scanTargets.hide();
        }
      };

      FirewallEgressModalView.prototype.manualMode = function() {
        return $('input#task_config_port_type_custom_range', this.$modal).is(':checked');
      };

      FirewallEgressModalView.prototype.customScanTarget = function() {
        return $('input#task_config_scan_target_type_custom_scan_target', this.$modal).is(':checked');
      };

      return FirewallEgressModalView;

    })(AppTabbedModalView);
  });

}).call(this);
