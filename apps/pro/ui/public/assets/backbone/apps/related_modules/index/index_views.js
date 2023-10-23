(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_layout', 'base_view', 'base_itemview'], function() {
    return this.Pro.module('RelatedModulesApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      Index.NameCellView = (function(_super) {

        __extends(NameCellView, _super);

        function NameCellView() {
          this.template = __bind(this.template, this);
          return NameCellView.__super__.constructor.apply(this, arguments);
        }

        NameCellView.prototype.initialize = function(attribute, idAttribute) {
          var _ref, _ref1;
          this.attribute = attribute;
          this.idAttribute = idAttribute;
          if ((_ref = this.attribute) == null) {
            this.attribute = 'name';
          }
          return (_ref1 = this.idAttribute) != null ? _ref1 : this.idAttribute = 'id';
        };

        NameCellView.prototype.template = function(data) {
          var id, maxLength, text, truncatedText, workspaceRelatedModulesPath;
          maxLength = 75;
          id = data[this.idAttribute];
          workspaceRelatedModulesPath = _.escape(Routes.workspace_related_modules_path(WORKSPACE_ID));
          text = data.name || '';
          truncatedText = text.length > maxLength ? text.substring(0, maxLength) + '…' : text;
          return "<a href='" + workspaceRelatedModulesPath + "#vulns/" + id + "'> " + truncatedText + " </a>";
        };

        return NameCellView;

      })(Pro.Views.ItemView);
      Index.DateCellView = (function(_super) {

        __extends(DateCellView, _super);

        function DateCellView() {
          this.template = __bind(this.template, this);
          return DateCellView.__super__.constructor.apply(this, arguments);
        }

        DateCellView.prototype.template = function(data) {
          return "<div>" + (data.disclosure_date.split(' ').join('&nbsp')) + "</div>";
        };

        return DateCellView;

      })(App.Views.ItemView);
      Index.AddressCellView = (function(_super) {

        __extends(AddressCellView, _super);

        function AddressCellView() {
          return AddressCellView.__super__.constructor.apply(this, arguments);
        }

        AddressCellView.prototype.template = function(data) {
          var hosts, mapped_hosts;
          hosts = JSON.parse(data.hosts);
          mapped_hosts = hosts.map(function(h) {
            return h.address;
          });
          return "<a title='" + (_.escape(data.info)) + "' href='" + (Routes.new_module_run_path({
            workspace_id: WORKSPACE_ID,
            path: data["module"]
          })) + "?target_host=" + (mapped_hosts.join(", ")) + "'>" + data["name"] + "</a>";
        };

        return AddressCellView;

      })(App.Views.ItemView);
      Index.VulnerabilityCellView = (function(_super) {

        __extends(VulnerabilityCellView, _super);

        function VulnerabilityCellView() {
          return VulnerabilityCellView.__super__.constructor.apply(this, arguments);
        }

        VulnerabilityCellView.prototype.template = function(data) {
          var module_vulns, module_vulns_mapped, uniqueVulns;
          module_vulns = JSON.parse(data.module_vulns);
          uniqueVulns = _.uniq(module_vulns, function(m) {
            return m.name;
          });
          module_vulns_mapped = uniqueVulns.map(function(vuln) {
            var safe_name, vuln_display, vuln_title;
            safe_name = _.escapeHTML(_.unescapeHTML(vuln.name));
            vuln_display = safe_name.match(/(CVE|USN|MS)((-\d{4}-\d{1,7})|(\d{2}-\d{1,4}))/g) || safe_name;
            vuln_title = safe_name;
            return ("<a title='" + (_.escape(vuln_title)) + "' href='" + (Routes.workspace_vuln_path(WORKSPACE_ID, vuln.id)) + "'>") + vuln_display + '</a>';
          });
          return "" + (module_vulns_mapped.join(', ')) + "&nbsp(" + data.module_vulns_count + ")";
        };

        return VulnerabilityCellView;

      })(App.Views.ItemView);
      return Index.HostAddressCellView = (function(_super) {

        __extends(HostAddressCellView, _super);

        function HostAddressCellView() {
          return HostAddressCellView.__super__.constructor.apply(this, arguments);
        }

        HostAddressCellView.prototype.template = function(data) {
          var hosts, hosts_mapped, lessThanThreeHosts;
          hosts = JSON.parse(data.hosts);
          lessThanThreeHosts = hosts.length > 3 ? hosts.slice(0, 3) : hosts;
          hosts_mapped = lessThanThreeHosts.map(function(host) {
            return ("<a title='" + host.address + ": " + (host.service_names.join(", ")) + "' href='" + (Routes.host_path(host.id)) + "'>") + (host.name || host.address) + '</a>';
          });
          return "" + (hosts_mapped.join(', ')) + (hosts.length > 3 ? '...' : '') + "&nbsp(" + data.module_hosts_count + ")";
        };

        return HostAddressCellView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
