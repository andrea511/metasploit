(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/layouts/modules-293e355959fa3206bf6c99a5437f3fc10ca580350132d99b22cbe5b2a35517b0.js'], function($, Template, RowDropdownLayout, Exploit) {
    var ModulesLayout;
    return ModulesLayout = (function(_super) {

      __extends(ModulesLayout, _super);

      function ModulesLayout() {
        this._initDataTable = __bind(this._initDataTable, this);

        this.hostModulesURL = __bind(this.hostModulesURL, this);

        this.initialize = __bind(this.initialize, this);
        return ModulesLayout.__super__.constructor.apply(this, arguments);
      }

      ModulesLayout.prototype.template = HandlebarsTemplates['hosts/layouts/modules'];

      ModulesLayout.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      ModulesLayout.prototype.hostModulesURL = function() {
        return "/hosts/" + this.host_id + "/exploits.json";
      };

      ModulesLayout.prototype.onRender = function() {
        return this._loadTable();
      };

      ModulesLayout.prototype._loadTable = function() {
        var _this = this;
        return $.get(this.hostModulesURL(), function(data) {
          $('.modules', _this.el).html('<table class="list" id="modules-table">');
          _this._initDataTable(data);
          return $(_this.el).trigger('tabload');
        });
      };

      ModulesLayout.prototype._initDataTable = function(data) {
        var $table, data_mapped,
          _this = this;
        data_mapped = data.map(function(m) {
          return [
            '<a data-name="' + m.name + '" title="' + m.description + '" style="visibility: visible" href="' + Routes.new_module_run_path({
              workspace_id: WORKSPACE_ID,
              path: m.fullname
            }) + '?target_host=' + _this.options.host_address + '">' + m.name + '</a>', m.mtype, m.refname, m.stance, m.privileged, m.module_star_icons, m.readiness_state
          ];
        });
        $('.control-bar', this.el).remove();
        $table = $('#modules-table', this.el).dataTable({
          oSettings: {
            sInstance: "modules"
          },
          sDom: 'ft<"list-table-footer clearfix"ip <"sel" l>>r',
          aaData: data_mapped,
          aoColumns: [
            {
              sTitle: "Name",
              sWidth: 'auto'
            }, {
              sTitle: "Type"
            }, {
              sTitle: "Ref"
            }, {
              sTitle: "Stance",
              bSortable: false
            }, {
              sTitle: "Privileged",
              bSortable: false
            }, {
              sTitle: "Rank",
              sWidth: 'auto',
              bSortable: false
            }, {
              sTitle: "Readiness State",
              sWidth: 'auto',
              bSortable: true
            }
          ],
          sPaginationType: "r7Style"
        });
        return $(this.el).trigger('tabload');
      };

      return ModulesLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
