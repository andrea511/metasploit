(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/apps/backbone/views/app_tabbed_modal-47bc923af640493921da87e077e6e91f982f1e34a731bbf5c8ee2b73d047af83.js'], function($, AppTabbedModalView) {
    var PND_START_URL, PassiveNetworkDiscoveryModalView;
    PND_START_URL = "/workspaces/" + WORKSPACE_ID + "/apps/passive_network_discovery/task_config/";
    return PassiveNetworkDiscoveryModalView = (function(_super) {

      __extends(PassiveNetworkDiscoveryModalView, _super);

      function PassiveNetworkDiscoveryModalView() {
        this.editBpfLink = __bind(this.editBpfLink, this);

        this.generatedBpfView = __bind(this.generatedBpfView, this);

        this.bpfTextArea = __bind(this.bpfTextArea, this);

        this.packetFilterType = __bind(this.packetFilterType, this);

        this.editBpfLinkClicked = __bind(this.editBpfLinkClicked, this);

        this.rewriteBpfString = __bind(this.rewriteBpfString, this);

        this.simpleCheckboxChanged = __bind(this.simpleCheckboxChanged, this);

        this.simpleAdvancedCheckboxChanged = __bind(this.simpleAdvancedCheckboxChanged, this);

        this.filterTypeChanged = __bind(this.filterTypeChanged, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);

        this.submitUrl = __bind(this.submitUrl, this);

        this.updateSliderValue = __bind(this.updateSliderValue, this);

        this.formOverrides = __bind(this.formOverrides, this);
        return PassiveNetworkDiscoveryModalView.__super__.constructor.apply(this, arguments);
      }

      PassiveNetworkDiscoveryModalView.TIMEOUT_SELECTOR = "task_config[timeout]";

      PassiveNetworkDiscoveryModalView.MAX_FILE_SIZE_SELECTOR = "task_config[max_file_size]";

      PassiveNetworkDiscoveryModalView.MAX_TOTAL_SIZE_SELECTOR = "task_config[max_total_size]";

      PassiveNetworkDiscoveryModalView.FILTER_TYPE_SELECTOR = "task_config[filter_type]";

      PassiveNetworkDiscoveryModalView.BPF_STRING_SELECTOR = "task_config[bpf_string]";

      PassiveNetworkDiscoveryModalView.prototype.initialize = function() {
        PassiveNetworkDiscoveryModalView.__super__.initialize.apply(this, arguments);
        this.setTitle('Passive Network Discovery');
        this.setDescription('Stealthily monitors broadcast traffic to identify the IP addresses ' + 'of hosts on the network and updates the Hosts page with the information ' + 'that it finds.');
        return this.setTabs([
          {
            name: 'Pcap Configuration'
          }, {
            name: 'Filters'
          }, {
            name: 'Generate Report',
            checkbox: true
          }
        ]);
      };

      PassiveNetworkDiscoveryModalView.prototype.events = _.extend({
        'change .simple-rows .simple-row > label > input[type=checkbox]': 'simpleCheckboxChanged',
        'change .simple-rows .simple-row div.advanced input[type=checkbox]': 'simpleAdvancedCheckboxChanged',
        'change input[type=checkbox]': 'rewriteBpfString',
        'change #task_config_filter_type_input': 'filterTypeChanged',
        'click span.editLink a': 'editBpfLinkClicked'
      }, AppTabbedModalView.prototype.events);

      PassiveNetworkDiscoveryModalView.prototype.formOverrides = function($node) {
        if ($node == null) {
          $node = null;
        }
        $node = $node != null ? $node : this.$modal;
        return {
          '[max_file_size]': $("[name='" + PassiveNetworkDiscoveryModalView.MAX_FILE_SIZE_SELECTOR + "']", $node).data('bytes'),
          '[max_total_size]': $("[name='" + PassiveNetworkDiscoveryModalView.MAX_TOTAL_SIZE_SELECTOR + "']", $node).data('bytes')
        };
      };

      PassiveNetworkDiscoveryModalView.prototype.updateSliderValue = function($input, value) {
        if ($input.attr('name').match(/timeout/i)) {
          return PassiveNetworkDiscoveryModalView.__super__.updateSliderValue.apply(this, arguments);
        } else {
          if (value.toString().match(/(B|KB|MB|GB|TB)/g) != null) {
            value = helpers.parseBytes(value);
          } else {
            $input.val(helpers.formatBytes(value).toUpperCase());
          }
          return $input.data('bytes', value);
        }
      };

      PassiveNetworkDiscoveryModalView.prototype.submitUrl = function() {
        return PND_START_URL;
      };

      PassiveNetworkDiscoveryModalView.prototype.formLoadedSuccessfully = function(html) {
        PassiveNetworkDiscoveryModalView.__super__.formLoadedSuccessfully.apply(this, arguments);
        this.filterTypeChanged();
        return $(this.el).trigger('tabbed-modal-loaded');
      };

      PassiveNetworkDiscoveryModalView.prototype.filterTypeChanged = function() {
        var showSimple;
        showSimple = this.packetFilterType() === 'simple';
        $('.simple-rows', this.$modal).toggle(showSimple);
        this.editBpfLink().toggle(showSimple);
        this.generatedBpfView().toggle(showSimple);
        this.bpfTextArea().parents('li.input').first().toggle(!showSimple);
        if (showSimple) {
          return this.rewriteBpfString();
        }
      };

      PassiveNetworkDiscoveryModalView.prototype.simpleAdvancedCheckboxChanged = function(e) {
        var $cbs, $checkedCbs, $parentCb, $row;
        $row = $(e.currentTarget).parents('.simple-row');
        $cbs = $row.find('.advanced input[type=checkbox]');
        $checkedCbs = $cbs.filter(':checked');
        $parentCb = $row.find('>label>input[type=checkbox]');
        return $parentCb.prop('checked', $checkedCbs.length > 0);
      };

      PassiveNetworkDiscoveryModalView.prototype.simpleCheckboxChanged = function(e) {
        var $boxes;
        $boxes = $(e.currentTarget).parents('.simple-row').find('.advanced input[type=checkbox]');
        return $boxes.prop('checked', $(e.currentTarget).is(':checked'));
      };

      PassiveNetworkDiscoveryModalView.prototype.rewriteBpfString = function() {
        var $sections, filter, str;
        if (this.packetFilterType() === 'simple') {
          $sections = $('.simple-rows div.advanced', this.$modal);
          str = _.compact(_.map($sections, function(sec) {
            var ports, protocols;
            protocols = _.map($(sec).find('.protocols input[type=checkbox]:checked'), function(cb) {
              return $(cb).attr('id');
            });
            ports = _.map($(sec).find('.ports input[type=checkbox]:checked'), function(cb) {
              return $(cb).attr('id').replace('_', ' ');
            });
            if (protocols.length + ports.length > 0) {
              return _.compact([protocols.join(' or '), ports.join(' or ')]).join(' ');
            } else {
              return null;
            }
          })).join(") or\n (");
          filter = _.isEmpty(str) ? "" : "(" + str + ")";
          this.bpfTextArea().val(filter);
          return this.generatedBpfView().find('pre').text(filter);
        }
      };

      PassiveNetworkDiscoveryModalView.prototype.editBpfLinkClicked = function() {
        var $cbs,
          _this = this;
        $cbs = $("[name='" + PassiveNetworkDiscoveryModalView.FILTER_TYPE_SELECTOR + "']", this.$modal);
        $(_.find($cbs, function(cb) {
          return $(cb).val() === 'manual';
        })).click();
        return _.defer(function() {
          return _this.bpfTextArea().focus();
        });
      };

      PassiveNetworkDiscoveryModalView.prototype.packetFilterType = function() {
        return $("[name='" + PassiveNetworkDiscoveryModalView.FILTER_TYPE_SELECTOR + "']:checked", this.$modal).val();
      };

      PassiveNetworkDiscoveryModalView.prototype.bpfTextArea = function() {
        return $("[name='" + PassiveNetworkDiscoveryModalView.BPF_STRING_SELECTOR + "']", this.$modal);
      };

      PassiveNetworkDiscoveryModalView.prototype.generatedBpfView = function() {
        return $('.generatedView', this.$modal);
      };

      PassiveNetworkDiscoveryModalView.prototype.editBpfLink = function() {
        return this._bpfLink || (this._bpfLink = $('<span class="editLink">[<a href="#">Edit</a>]</span>').appendTo('.generatedView label', this.$modal));
      };

      return PassiveNetworkDiscoveryModalView;

    })(AppTabbedModalView);
  });

}).call(this);
