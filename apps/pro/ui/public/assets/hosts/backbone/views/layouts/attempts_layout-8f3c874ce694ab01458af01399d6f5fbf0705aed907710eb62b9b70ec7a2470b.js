(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/attempts-c410f8a0d2c00b451a1767b0b2986757fe65060af9b99b2abf4e6ab51c81e27f.js', '/assets/moment.min-aa3316a30cb0566d61d84b77a5d88e9231af0cd943597bcd86239076a2ad2c5d.js'], function($, Template, m) {
    var AttemptsLayout;
    return AttemptsLayout = (function(_super) {

      __extends(AttemptsLayout, _super);

      function AttemptsLayout() {
        this._loadTable = __bind(this._loadTable, this);

        this.onRender = __bind(this.onRender, this);

        this.attemptsURL = __bind(this.attemptsURL, this);
        return AttemptsLayout.__super__.constructor.apply(this, arguments);
      }

      AttemptsLayout.prototype.template = HandlebarsTemplates['hosts/layouts/attempts'];

      AttemptsLayout.prototype.attemptsURL = function() {
        return "/hosts/" + this.host_id + "/attempts";
      };

      AttemptsLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      AttemptsLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      AttemptsLayout.prototype._loadTable = function() {
        var _this = this;
        return $.get(this.attemptsURL(), function(data) {
          var $table, $wrapper;
          $wrapper = $('.attempts-table .table', _this.el);
          $wrapper.html(data);
          $table = $wrapper.find('table');
          $table.trigger('tabload');
          return $table.dataTable({
            sDom: 'ft<"list-table-footer clearfix"ip <"sel" l>>r',
            oSettings: {
              sInstance: 'attempts'
            },
            oLanguage: {
              sEmptyTable: "No Attempts have been made against this host."
            },
            sPaginationType: "r7Style",
            aaSorting: [[6, 'desc']],
            bStateSave: true,
            aoColumns: [
              {
                mDataProp: "user"
              }, {
                mDataProp: "exploit"
              }, {
                mDataProp: "port"
              }, {
                mDataProp: "proto"
              }, {
                mDataProp: "result"
              }, {
                mDataProp: "detail"
              }, {
                mDataProp: "created_at",
                sTitle: "Created",
                sClass: 'time',
                fnRender: function(o) {
                  var time, _ref;
                  time = (_ref = o.aData) != null ? _ref.created_at : void 0;
                  return "<span title='" + (_.escape(time)) + "'>" + (_.escape(moment(time).fromNow())) + "</span>";
                }
              }
            ],
            fnDrawCallback: function() {
              $('table td.time', _this.el).tooltip();
              return $(_this.el).trigger('tabload');
            }
          });
        });
      };

      return AttemptsLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
