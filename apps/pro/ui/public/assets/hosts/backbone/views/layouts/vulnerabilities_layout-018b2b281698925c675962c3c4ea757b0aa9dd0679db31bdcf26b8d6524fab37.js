(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/vulnerabilities-d73d4704e2d889af22443dead9e54a508793d966a8d400676f0b685fc2b781ef.js', '/assets/hosts/backbone/views/item_views/vuln_form-1cc7b36421c773badb5827996b6c4a19d59df0e3943ca7e7df6ef280d88f7247.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, VulnForm, Modal, EventAggregator) {
    var VulnerabilitiesLayout;
    return VulnerabilitiesLayout = (function(_super) {

      __extends(VulnerabilitiesLayout, _super);

      function VulnerabilitiesLayout() {
        this._initDataTable = __bind(this._initDataTable, this);

        this._newVuln = __bind(this._newVuln, this);

        this._deleteVuln = __bind(this._deleteVuln, this);

        this._editVuln = __bind(this._editVuln, this);

        this._reRender = __bind(this._reRender, this);

        this.hostVulnsURL = __bind(this.hostVulnsURL, this);
        return VulnerabilitiesLayout.__super__.constructor.apply(this, arguments);
      }

      VulnerabilitiesLayout.prototype.template = HandlebarsTemplates['hosts/layouts/vulnerabilities'];

      VulnerabilitiesLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      VulnerabilitiesLayout.prototype.hostVulnsURL = function() {
        return "/hosts/" + this.host_id + "/vulns";
      };

      VulnerabilitiesLayout.prototype.events = {
        'click .vulns a.new': '_newVuln',
        'click .vulns .edit-table-row .pencil': '_editVuln',
        'click .vulns .details': '_editVuln',
        'click .vulns .edit-table-row .garbage': '_deleteVuln',
        'rowDeleted table': '_countChanged'
      };

      VulnerabilitiesLayout.prototype.onShow = function() {
        EventAggregator.on("redrawTable", this.render);
        return EventAggregator.on("tabs_layout:change:count", this._reRender);
      };

      VulnerabilitiesLayout.prototype._reRender = function(count) {
        var countChanged, settings;
        settings = $('#vulns-table table', this.el).dataTable().fnSettings();
        countChanged = settings != null ? settings.fnRecordsTotal() !== count.get("vulnerabilities") : false;
        if (!(this.modal != null) && !this.isEditMode() && countChanged) {
          return this.render();
        }
      };

      VulnerabilitiesLayout.prototype._countChanged = function(e, count) {
        return $(this.el).trigger('tabcountUpdated', {
          count: count,
          name: 'Disclosed Vulnerabilities'
        });
      };

      VulnerabilitiesLayout.prototype.isEditMode = function() {
        return $('.edit-table-row .save', this.el).length > 0;
      };

      VulnerabilitiesLayout.prototype.onDestroy = function() {
        EventAggregator.off("tabs_layout:change:count");
        return EventAggregator.off("redrawTable", this.render);
      };

      VulnerabilitiesLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      VulnerabilitiesLayout.prototype._showModal = function(opts) {
        var title;
        if (opts == null) {
          opts = {};
        }
        title = "" + (_.str.humanize(opts.action)) + " Vulnerability";
        if (this.modal) {
          this.modal.destroy();
        }
        this.modal = new Modal({
          "class": 'flat',
          title: title,
          width: 500
        });
        this.modal.open();
        return this.modal.content.show(new VulnForm(opts));
      };

      VulnerabilitiesLayout.prototype._editVuln = function(e) {
        var vuln_id;
        vuln_id = $('.id', $(e.target).closest('tr')).html();
        return this._showModal({
          action: "edit",
          id: vuln_id
        });
      };

      VulnerabilitiesLayout.prototype._deleteVuln = function(e) {
        var vuln_id,
          _this = this;
        vuln_id = $('.id', $(e.target).closest('tr')).html();
        if (window.confirm("Are you sure you want to delete?")) {
          return $.ajax({
            url: "" + (this.hostVulnsURL()) + "/" + vuln_id + ".json",
            type: 'DELETE',
            success: function() {
              var $row, $table, count, records_total, rowId;
              $table = $('#vulns-table', _this.el).dataTable();
              $row = $(e.currentTarget).closest('tr');
              rowId = $table.fnGetPosition($row[0]);
              $table.fnDeleteRow(rowId, 0, true);
              records_total = $table.fnSettings().fnRecordsTotal();
              count = records_total > 0 ? records_total : 0;
              $table.trigger('rowDeleted', count);
              return $row.remove();
            }
          });
        }
      };

      VulnerabilitiesLayout.prototype._newVuln = function(e) {
        e.preventDefault();
        return this._showModal({
          action: "new"
        });
      };

      VulnerabilitiesLayout.prototype._loadTable = function() {
        var _this = this;
        return $.get(this.hostVulnsURL(), function(data) {
          $('.vulns', _this.el).html(data);
          _this._initDataTable();
          return $('.edit-table-row').off('click');
        });
      };

      VulnerabilitiesLayout.prototype._initDataTable = function() {
        var $table;
        $('.control-bar', this.el).remove();
        $table = $('#vulns-table', this.el).dataTable({
          oSettings: {
            sInstance: "vulns"
          },
          sDom: 'ft<"list-table-footer clearfix"ip <"sel" l>>r',
          aoColumns: [
            {
              bSortable: false
            }, {}, {
              bSortable: false
            }, {}, {}, {}, {
              bSortable: false,
              sWidth: '120px',
              fnRender: function() {
                return "<div class='edit-table-row'><a class='pencil' href='javascript:void(0)'></a><a href='javascript:void(0)' class='garbage'></a></span></div>";
              }
            }
          ],
          sPaginationType: "r7Style"
        });
        return $(this.el).trigger('tabload');
      };

      return VulnerabilitiesLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
