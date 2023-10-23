(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/captured_data-9d2b5742b98443d81d70b2c5a05039cb6d0b740f2255bfa90bf62abbf3cafa85.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js', '/assets/loots/backbone/views/item_views/form-45ce8f2c7e4ba257e90fb9dcd0033f273862fb9d02d43bdf013247dc6f4ff06b.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js', '/assets/loots/backbone/models/loot-f22bf4ca974e640afc1c24f81f9410523c69cfae37c705e799e1c1749b3dcc70.js', '/assets/loots/backbone/views/item_views/preview-68ede3df6254526232e9f2ea51e199bfe566a6bac4ee8737ea13fb338a4c03ec.js'], function($, Template, EventAggregator, LootForm, Modal, m, Loot, LootPreview) {
    var CapturedDataLayout;
    return CapturedDataLayout = (function(_super) {

      __extends(CapturedDataLayout, _super);

      function CapturedDataLayout() {
        this._loadTable = __bind(this._loadTable, this);

        this._lootFromRow = __bind(this._lootFromRow, this);

        this.viewClicked = __bind(this.viewClicked, this);

        this._removeRow = __bind(this._removeRow, this);

        this.deleteClicked = __bind(this.deleteClicked, this);

        this._addRow = __bind(this._addRow, this);

        this.addClicked = __bind(this.addClicked, this);

        this._reRender = __bind(this._reRender, this);

        this.hostLootURL = __bind(this.hostLootURL, this);
        return CapturedDataLayout.__super__.constructor.apply(this, arguments);
      }

      CapturedDataLayout.prototype.template = HandlebarsTemplates['hosts/layouts/captured_data'];

      CapturedDataLayout.prototype.hostLootURL = function() {
        return "/hosts/" + this.host_id + "/show_captured_data.json";
      };

      CapturedDataLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      CapturedDataLayout.prototype.onShow = function() {
        return EventAggregator.on("tabs_layout:change:count", this._reRender);
      };

      CapturedDataLayout.prototype.onDestroy = function() {
        return EventAggregator.off("tabs_layout:change:count");
      };

      CapturedDataLayout.prototype._reRender = function(count) {
        if ($('#loot_table table', this.el).dataTable().fnSettings().fnRecordsTotal() !== count.get("captured_data")) {
          return this.render();
        }
      };

      CapturedDataLayout.prototype.events = {
        'click a.new': 'addClicked',
        'click a.garbage': 'deleteClicked',
        'click a.view': 'viewClicked',
        'rowDeleted table': '_countChanged',
        'rowAdded table': '_countChanged'
      };

      CapturedDataLayout.prototype._countChanged = function(e, count) {
        return $(this.el).trigger('tabcountUpdated', {
          count: count,
          name: 'Captured Data'
        });
      };

      CapturedDataLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      CapturedDataLayout.prototype.addClicked = function(e) {
        var form, modal;
        modal = new Modal({
          "class": 'flat',
          title: 'New Captured Data',
          width: 600
        });
        form = new LootForm({
          model: new Loot({
            host_id: this.host_id
          })
        });
        modal.open();
        modal.content.show(form);
        modal._center();
        return form.on('success', this._addRow);
      };

      CapturedDataLayout.prototype._addRow = function() {
        var $table, count, records_total;
        $table = $('#loot_table table', this.el).dataTable();
        records_total = $table.fnSettings().fnRecordsTotal();
        count = records_total + 1;
        $table.trigger('rowAdded', count);
        return $table.fnDraw();
      };

      CapturedDataLayout.prototype.deleteClicked = function(e) {
        var $row, loot;
        if (!confirm('Are you sure you want to delete this captured data?')) {
          return;
        }
        $row = $(e.currentTarget).parents('tr').first();
        loot = this._lootFromRow($row);
        return loot.destroy({
          success: this._removeRow
        });
      };

      CapturedDataLayout.prototype._removeRow = function() {
        var $table, count, records_total;
        $table = $('#loot_table table', this.el).dataTable();
        records_total = $table.fnSettings().fnRecordsTotal();
        count = records_total > 0 ? records_total - 1 : 0;
        $table.trigger('rowDeleted', count);
        return this._loadTable();
      };

      CapturedDataLayout.prototype.viewClicked = function(e) {
        var $row, modal, preview;
        modal = new Modal({
          "class": 'flat',
          title: 'View Captured Data',
          width: 400,
          buttons: [
            {
              name: 'Done',
              "class": 'close btn primary'
            }
          ]
        });
        modal.open();
        $row = $(e.currentTarget).parents('tr').first();
        preview = new LootPreview({
          model: this._lootFromRow($row),
          text: $(e.currentTarget).attr('data-text') === 'true',
          img: $(e.currentTarget).attr('data-img') === 'true',
          binary: $(e.currentTarget).attr('data-binary') === 'true',
          path: $(e.currentTarget).attr('data-url')
        });
        modal.content.show(preview);
        return modal._center();
      };

      CapturedDataLayout.prototype._lootFromRow = function($row) {
        var rowData;
        rowData = function(klass) {
          return $row.find("." + klass).text();
        };
        return new Loot({
          host_id: this.host_id,
          workspace_id: window.WORKSPACE_ID,
          content_type: rowData('content_type'),
          name: rowData('name'),
          info: rowData('info'),
          id: $row.find('a.garbage').attr('data-id')
        });
      };

      CapturedDataLayout.prototype._loadTable = function() {
        var _this = this;
        return helpers.loadRemoteTable({
          el: $('#loot_table', this.el),
          tableName: 'capturedData',
          columns: {
            content_type: {
              name: "Content Type",
              sWidth: "200px",
              sClass: 'content_type',
              fnRender: function(o) {
                return _.escapeHTML(_.unescapeHTML(o.aData.content_type));
              }
            },
            name: {
              name: "Name",
              sClass: 'name',
              fnRender: function(o) {
                return _.escapeHTML(_.unescapeHTML(o.aData.name));
              }
            },
            ltype: {
              name: "Type"
            },
            info: {
              name: "Info",
              sClass: 'info',
              fnRender: function(o) {
                return _.escapeHTML(_.unescapeHTML(o.aData.info));
              }
            },
            created_at: {
              name: "Created",
              sClass: "time",
              fnRender: function(o) {
                var time, _ref;
                time = (_ref = o.aData) != null ? _ref.created_at : void 0;
                return "<span title='" + (_.escape(time)) + "'>" + (_.escape(moment(time).fromNow())) + "</span>";
              }
            },
            size: {
              sWidth: '90px',
              bSortable: false,
              sClass: 'size',
              fnRender: function(o) {
                var size;
                size = o.aData.size;
                return "<span title='" + (_.escape(size)) + " bytes'>" + (_.escape(helpers.formatBytes(size))) + "</span>";
              }
            },
            actions: {
              bSortable: false,
              sWidth: "130px",
              name: "",
              sClass: 'actions',
              fnRender: function(o) {
                var a, html;
                html = "<a href='" + (_.escape(o.aData.path)) + "?disposition=attachment' style='margin-right: 20px;'>Download</a>";
                a = ("<a href='javascript:void(0)' data-id='" + o.aData.id + "' ") + ("data-url='" + o.aData.path + "' data-img='" + o.aData.is_binary + "' ") + ("data-text='" + o.aData.is_text + "' data-img='" + o.aData.is_img + "' class='view'>");
                if (o.aData.is_text || (o.aData.is_binary && o.aData.is_img)) {
                  html += a + "View</a> ";
                }
                return html;
              }
            },
            edit: {
              sWidth: "35px",
              name: "",
              bSortable: false,
              mDataProp: null,
              fnRender: function(o) {
                return '<div class="edit-table-row">' + '<a class="garbage" data-id="' + o.aData.id + '" href="javascript:void(0)"></a>' + '</div>';
              }
            },
            id: {
              bVisible: false
            },
            path: {
              bVisible: false
            },
            is_img: {
              bVisible: false
            },
            is_text: {
              bVisible: false
            },
            is_binary: {
              bVisible: false
            }
          },
          dataTable: {
            bStateSave: true,
            oLanguage: {
              sEmptyTable: "No Captured Data was found for this host."
            },
            bFilter: true,
            sPaginationType: "r7Style",
            sAjaxSource: this.hostLootURL(),
            aaSorting: [[5, "desc"]],
            fnDrawCallback: function() {
              return $('table td.time, table td.size', _this.el).tooltip();
            }
          }
        });
      };

      return CapturedDataLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
