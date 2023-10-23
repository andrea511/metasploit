(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'form_helpers', '/assets/templates/tasks/new_nexpose_exception_push/layouts/exception-2bd1a4583e372c637fc69a22df926689a7ec0459a9da16dc13842efbc499959f.js', '/assets/tasks/new_nexpose_exception_push/backbone/views/collections/vulns_collection-bae31ba269847b05e2691c240f2979ba23e6c8c634d9acf6bd87b978299da1e3.js', '/assets/tasks/new_nexpose_exception_push/backbone/models/result_exception-68bf2e51dbc7c5eb77b5e65c9cd1798d6c6750b00251fd3b54b412c592f28026.js', '/assets/shared/backbone/views/empty_view-9e4ad20fbd7ef94c863eb380c9a0d30109e0bf67e898f79f446c3ab3f9160f9b.js'], function($, FormHelpers, Template, VulnsCollectionView, ResultException, EmptyView) {
    var ExceptionLayout;
    return ExceptionLayout = (function(_super) {

      __extends(ExceptionLayout, _super);

      function ExceptionLayout() {
        this.onShow = __bind(this.onShow, this);
        return ExceptionLayout.__super__.constructor.apply(this, arguments);
      }

      ExceptionLayout.prototype.template = HandlebarsTemplates['tasks/new_nexpose_exception_push/layouts/exception'];

      ExceptionLayout.prototype.initialize = function(opts) {
        return $.extend(this, opts);
      };

      ExceptionLayout.prototype.events = {
        'change input[name="select_hosts"]': '_selectAllHosts',
        'change input[name="global_datepicker"]': '_setGlobalDate',
        'change input[name="expire"]': '_setExpireMode',
        'dateSet': '_dateSet'
      };

      ExceptionLayout.prototype._dateSet = function(e) {
        $('input[name="global_datepicker"]', this.el).val('');
        return $('input[name="expire"]:checked').prop("checked", false);
      };

      ExceptionLayout.prototype._selectAllHosts = function(e) {
        if ($(e.target).prop("checked")) {
          return $('.host_checkbox', this.el).prop("checked", true);
        } else {
          return $('.host_checkbox', this.el).prop("checked", false);
        }
      };

      ExceptionLayout.prototype._setGlobalDate = function(e) {
        var val;
        val = $(e.target).val();
        $('.datetime', this.el).val(val);
        return $('input[value="all"][name="expire"]', this.el).prop('checked', true);
      };

      ExceptionLayout.prototype._setExpireMode = function(e) {
        var val;
        if ($(e.target).prop('value') === 'never') {
          $('.global-datepicker', this.el).val('');
          return $('.datetime', this.el).val('');
        } else {
          val = $('.global-datepicker', this.el).val();
          return $('.datetime', this.el).val(val);
        }
      };

      ExceptionLayout.prototype.regions = {
        vulns: '.vulns'
      };

      ExceptionLayout.prototype.onShow = function() {
        var console_id, result_exceptions,
          _this = this;
        $(".global-datepicker", this.el).datepicker({
          minDate: 1
        });
        result_exceptions = new ResultException.collection();
        console_id = $('select[name="console"]').val();
        return result_exceptions.fetch({
          data: {
            vuln_ids: this.controller.VULN_IDS,
            console_id: console_id,
            match_set_id: this.controller.MATCH_SET_ID
          },
          success: function(collection) {
            if (collection.length < 1) {
              $(_this.el).trigger("disablePushButton");
              _this.vulns.show(new EmptyView({
                model: new Backbone.Model({
                  message: "The selected vulnerabilities were not sourced from a Nexpose Scan or Import."
                })
              }));
            } else {
              $(_this.el).trigger("enablePushButton");
              $('a.nexpose', _this.el).removeClass("disabled");
              _this.vulns.show(new VulnsCollectionView({
                collection: collection,
                controller: _this.controller
              }));
              $('.header', _this.el).removeClass("invisible");
            }
            return $(_this.vulns.el).trigger('tabload');
          }
        });
      };

      return ExceptionLayout;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
