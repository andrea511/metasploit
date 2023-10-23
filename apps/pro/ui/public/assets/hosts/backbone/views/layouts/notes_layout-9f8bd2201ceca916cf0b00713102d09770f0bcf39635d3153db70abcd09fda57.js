(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/notes-dda48f3864b78630ea26bbac281917489013221f27320cff1c633ff0464c27f6.js', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, Template, m, EventAggregator) {
    var NotesLayout;
    return NotesLayout = (function(_super) {

      __extends(NotesLayout, _super);

      function NotesLayout() {
        this._loadTable = __bind(this._loadTable, this);

        this._fixJSON = __bind(this._fixJSON, this);

        this.hostNotesURL = __bind(this.hostNotesURL, this);
        return NotesLayout.__super__.constructor.apply(this, arguments);
      }

      NotesLayout.prototype.template = HandlebarsTemplates['hosts/layouts/notes'];

      NotesLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      NotesLayout.prototype.hostNotesURL = function() {
        return "/hosts/" + this.host_id + "/show_notes.json";
      };

      NotesLayout.prototype.onShow = function() {
        return EventAggregator.on("tabs_layout:change:count", this.render);
      };

      NotesLayout.prototype.onDestroy = function() {
        return EventAggregator.off("tabs_layout:change:count");
      };

      NotesLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      NotesLayout.prototype._fixJSON = function(json) {
        var hash,
          _this = this;
        if (json && _.size(json) > 0 && !_.isString(json) && !_.isNumber(json)) {
          hash = {};
          _.map(json, function(v, k) {
            return hash[k] = _this._fixJSON(v);
          });
          return hash;
        } else {
          try {
            if (_.isString(json)) {
              return $.parseJSON(json || "null");
            } else {
              return json;
            }
          } catch (e) {
            return json;
          }
        }
      };

      NotesLayout.prototype._loadTable = function() {
        var _this = this;
        return helpers.loadRemoteTable({
          el: $('#notes_table', this.el),
          tableName: 'notes',
          columns: {
            ntype: {
              sTitle: 'Name',
              fnRender: function(o) {
                return _.escapeHTML(o.aData.ntype);
              }
            },
            data: {
              bSortable: false,
              sClass: 'break-all info',
              sWidth: "50%",
              fnRender: function(o) {
                var d;
                if (!_.isString(o.aData.data)) {
                  d = JSON.stringify(o.aData.data);
                } else {
                  d = o.aData.data;
                }
                return _.escapeHTML(d);
              }
            },
            updated_at: {
              sTitle: "Updated",
              sWidth: "200px",
              sClass: 'time',
              fnRender: function(o) {
                var time, _ref;
                time = (_ref = o.aData) != null ? _ref.updated_at : void 0;
                return "<span title='" + (_.escape(time)) + "'>" + (_.escape(moment(time).fromNow())) + "</span>";
              }
            }
          },
          dataTable: {
            bFilter: true,
            oLanguage: {
              sEmptyTable: "No Notes were found for this host."
            },
            aaSorting: [[2, 'desc']],
            sAjaxSource: this.hostNotesURL(),
            sPaginationType: "r7Style",
            fnDrawCallback: function() {
              $('table td.time', _this.el).tooltip();
              $(_this.el).trigger('tabload');
              return _.each($('#notes_table', _this.el).find('td.info'), function(td) {
                var $data, d, node;
                try {
                  d = $.parseJSON(_.unescapeHTML($(td).text()));
                  try {
                    d = _this._fixJSON(d);
                    node = new PrettyJSON.view.Node({
                      el: $(td),
                      level: 0,
                      data: d
                    });
                    $data = $(td).find('.node-container').first();
                    $data.addClass('inline').click(function() {
                      if ($(this).hasClass('inline')) {
                        node.expandAll();
                        return $(this).removeClass('inline');
                      }
                    });
                    return $data.css({
                      'max-width': 'none',
                      width: $(td).width() + 'px',
                      'box-sizing': 'border-box'
                    });
                  } catch (_error) {}
                } catch (_error) {}
              });
            }
          }
        });
      };

      return NotesLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
