(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/services-5c30f096995b29c14cc9f8fb9a46433076790da154a2f0ae5146d63f9d360938.js', '/assets/shared/lib/jquery.dataTables.editable-b41b4d502a481c1e3c3df0aebfa23862293b0b801f5b2bc68d0f37551a28ad70.js', '/assets/shared/backbone/layouts/modal-57927538cf64c26b47a2f8f54fdef926ef3c906fba72986d69e71e13cfe4422f.js', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js', '/assets/hosts/backbone/views/item_views/service_form-909da796e03505f2e7799b9ddea8f521536dfd2287cf804b45f2d2f47f71bb0c.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, EditablePlugin, Modal, m, ServiceForm, EventAggregator) {
    var ServicesLayout;
    return ServicesLayout = (function(_super) {

      __extends(ServicesLayout, _super);

      function ServicesLayout() {
        this._addService = __bind(this._addService, this);

        this._showModal = __bind(this._showModal, this);

        this.onRender = __bind(this.onRender, this);

        this.isEditMode = __bind(this.isEditMode, this);

        this._reRender = __bind(this._reRender, this);

        this._countChanged = __bind(this._countChanged, this);

        this._rowAdded = __bind(this._rowAdded, this);

        this.onShow = __bind(this.onShow, this);

        this.hostServicesTableURL = __bind(this.hostServicesTableURL, this);

        this.hostServicesUpdateURL = __bind(this.hostServicesUpdateURL, this);

        this.hostServicesDeleteURL = __bind(this.hostServicesDeleteURL, this);

        this.hostServicesURL = __bind(this.hostServicesURL, this);
        return ServicesLayout.__super__.constructor.apply(this, arguments);
      }

      ServicesLayout.prototype.template = HandlebarsTemplates['hosts/layouts/services'];

      ServicesLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id, this.host_address = _arg.host_address;
      };

      ServicesLayout.prototype.hostServicesURL = function() {
        return "/hosts/" + this.host_id;
      };

      ServicesLayout.prototype.hostServicesDeleteURL = function() {
        return "" + (this.hostServicesURL()) + "/delete_service";
      };

      ServicesLayout.prototype.hostServicesUpdateURL = function() {
        return "" + (this.hostServicesURL()) + "/update_service.json";
      };

      ServicesLayout.prototype.hostServicesTableURL = function() {
        return "" + (this.hostServicesURL()) + "/show_services.json";
      };

      ServicesLayout.prototype.onShow = function() {
        EventAggregator.on("redrawTable", this.render);
        EventAggregator.on("tabs_layout:change:count", this._reRender);
        return EventAggregator.on("serviceForm:rowAdded", this._rowAdded);
      };

      ServicesLayout.prototype.onDestroy = function() {
        EventAggregator.off("redrawTable");
        EventAggregator.off("tabs_layout:change:count");
        return EventAggregator.off("serviceForm:rowAdded");
      };

      ServicesLayout.prototype.events = {
        'click .btn .new': '_addService',
        'rowDeleted table': '_countChanged',
        'rowAdded table': '_countChanged'
      };

      ServicesLayout.prototype._rowAdded = function() {
        var $table, count, records_total;
        $table = $('#services_table table', this.el).dataTable();
        records_total = $table.fnSettings().fnRecordsTotal();
        count = records_total + 1;
        return $table.trigger('rowAdded', count);
      };

      ServicesLayout.prototype._countChanged = function(e, count) {
        return $(this.el).trigger('tabcountUpdated', {
          count: count,
          name: 'Services'
        });
      };

      ServicesLayout.prototype._reRender = function(count) {
        if (!(this.modal != null) && !this.isEditMode() && $('#services_table table', this.el).dataTable().fnSettings().fnRecordsTotal() !== count.get("services")) {
          return this.render();
        }
      };

      ServicesLayout.prototype.isEditMode = function() {
        return $('.edit-table-row .save', this.el).length > 0;
      };

      ServicesLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      ServicesLayout.prototype._showModal = function(opts) {
        var model, parsedStates, services;
        if (opts == null) {
          opts = {};
        }
        if (this.modal) {
          this.modal.destroy();
        }
        this.modal = new Modal({
          "class": 'flat',
          title: "New Service",
          width: 300
        });
        this.modal.open();
        services = this._getServices();
        parsedStates = $.parseJSON('[{"value":"open","text":"open"},{"value":"closed","text":"closed"},{"value":"filtered","text":"filtered"},{"value":"unknown","text":"unknown"}]');
        model = new Backbone.Model({
          protocols: {
            protocols: [
              {
                value: 'tcp',
                text: 'tcp'
              }, {
                value: 'udp',
                text: 'udp'
              }
            ],
            title: 'tcp'
          },
          states: {
            states: parsedStates,
            selected: 'open'
          }
        });
        return this.modal.content.show(new ServiceForm({
          model: model,
          host_id: this.host_id
        }));
      };

      ServicesLayout.prototype._addService = function() {
        return this._showModal();
      };

      ServicesLayout.prototype._getServices = function() {
        return $('meta[name=services]').attr("content");
      };

      ServicesLayout.prototype._linkForServiceName = function(name, port, state) {
        var UriScheme, linkText, stateIsOpen;
        stateIsOpen = state === 'open';
        UriScheme = (function() {
          switch (name) {
            case 'http':
            case 'https':
            case 'ftp':
            case 'telnet':
            case 'ssh':
            case 'vnc':
            case 'smb':
              return name;
            case 'rlogin':
            case 'login':
              return 'rlogin';
            case 'msrdp':
              return 'rdp';
            default:
              return null;
          }
        })();
        linkText = "<a href='" + UriScheme + "://" + this.host_address + ":" + port + "/' target='_blank'>" + name + "</a>";
        if (UriScheme && stateIsOpen) {
          return linkText;
        } else {
          return name;
        }
      };

      ServicesLayout.prototype._loadTable = function() {
        var _this = this;
        return helpers.loadRemoteTable({
          sAjaxDestination: this.hostServicesUpdateURL(),
          sAjaxDelete: this.hostServicesDeleteURL(),
          editableOpts: [
            {
              type: "field",
              id: "name"
            }, {
              type: "field",
              id: "port"
            }, {
              type: "select",
              options: [
                {
                  value: "udp",
                  content: "udp"
                }, {
                  value: "tcp",
                  content: "tcp"
                }
              ]
            }, {
              type: "select",
              options: [
                {
                  "value": "open",
                  "content": "open"
                }, {
                  "value": "closed",
                  "content": "closed"
                }, {
                  "value": "filtered",
                  "content": "filtered"
                }, {
                  "value": "unknown",
                  "content": "unknown"
                }
              ]
            }, {
              type: "none"
            }, {
              type: "none"
            }, {
              type: "control"
            }, {
              type: "none"
            }
          ],
          el: $('#services_table', this.el),
          tableName: 'services',
          columns: {
            name: {
              name: "Name",
              bSortable: true,
              fnRender: function(o) {
                var name, port, sname, state;
                sname = _.escapeHTML(_.unescapeHTML(o.aData.name));
                if (sname == null) {
                  return "";
                } else {
                  name = sname;
                  port = o.aData.port;
                  state = o.aData.state;
                  return _this._linkForServiceName(name, port, state);
                }
              }
            },
            port: {
              name: "Port"
            },
            protocol: {
              name: "Protocol"
            },
            state: {
              name: "State"
            },
            info: {
              name: "Service Information",
              fnRender: function(o) {
                if (o.aData.info == null) {
                  return "";
                } else {
                  return _.escapeHTML(_.unescapeHTML(o.aData.info));
                }
              }
            },
            created_at: {
              bSortable: true,
              sTitle: "Created",
              sWidth: "200px",
              sClass: 'time',
              fnRender: function(o) {
                var time, _ref;
                time = (_ref = o.aData) != null ? _ref.created_at : void 0;
                return "<span title='" + (_.escape(time)) + "'>" + (_.escape(moment(time).fromNow())) + "</span>";
              }
            },
            edit: {
              sWidth: "120px",
              name: "",
              bSortable: false,
              mDataProp: null,
              fnRender: function(o) {
                return "";
              }
            },
            id: {
              bVisible: false
            }
          },
          dataTable: {
            bStateSave: true,
            oLanguage: {
              sEmptyTable: "No Services were found on this host."
            },
            bFilter: true,
            aaSorting: [[5, "desc"]],
            sPaginationType: "r7Style",
            sAjaxSource: this.hostServicesTableURL(),
            fnDrawCallback: function() {
              return $('table td.time', _this.el).tooltip();
            }
          }
        });
      };

      return ServicesLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
