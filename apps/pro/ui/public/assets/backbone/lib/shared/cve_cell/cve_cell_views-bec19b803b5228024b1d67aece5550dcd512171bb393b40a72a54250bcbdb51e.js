(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_itemview', 'lib/shared/cve_cell/templates/view', 'lib/shared/cve_cell/templates/single_cve_cell_view', 'lib/shared/cve_cell/templates/empty_cve_cell_view', 'lib/shared/cve_cell/templates/modal_view'], function($) {
    return this.Pro.module("Shared.CveCell", function(CveCell, App, Backbone, Marionette, $, _) {
      CveCell.View = (function() {

        function View(opts) {
          var ViewClass, refCount;
          refCount = parseInt(opts.model.get('ref_count'));
          ViewClass = (function() {
            switch (refCount) {
              case 0:
                return CveCell.EmptyView;
              case 1:
                return CveCell.SingleView;
              default:
                return CveCell.MultiView;
            }
          })();
          return new ViewClass(opts);
        }

        return View;

      })();
      CveCell.BaseView = (function(_super) {

        __extends(BaseView, _super);

        function BaseView() {
          return BaseView.__super__.constructor.apply(this, arguments);
        }

        BaseView.prototype.className = 'shared cve-cell';

        BaseView.prototype.templateHelpers = {
          parsedRefs: function() {
            return this.ref_names;
          },
          refCount: function() {
            return this.ref_count;
          }
        };

        return BaseView;

      })(App.Views.Layout);
      CveCell.MultiView = (function(_super) {

        __extends(MultiView, _super);

        function MultiView() {
          return MultiView.__super__.constructor.apply(this, arguments);
        }

        MultiView.prototype.template = MultiView.prototype.templatePath("cve_cell/view");

        MultiView.prototype.triggers = {
          'click a': 'refs:clicked'
        };

        return MultiView;

      })(CveCell.BaseView);
      CveCell.SingleView = (function(_super) {

        __extends(SingleView, _super);

        function SingleView() {
          return SingleView.__super__.constructor.apply(this, arguments);
        }

        SingleView.prototype.template = SingleView.prototype.templatePath("cve_cell/single_cve_cell_view");

        return SingleView;

      })(CveCell.BaseView);
      CveCell.EmptyView = (function(_super) {

        __extends(EmptyView, _super);

        function EmptyView() {
          return EmptyView.__super__.constructor.apply(this, arguments);
        }

        EmptyView.prototype.template = EmptyView.prototype.templatePath("cve_cell/empty_cve_cell_view");

        return EmptyView;

      })(CveCell.BaseView);
      return CveCell.ModalView = (function(_super) {

        __extends(ModalView, _super);

        function ModalView() {
          return ModalView.__super__.constructor.apply(this, arguments);
        }

        ModalView.prototype.template = ModalView.prototype.templatePath("cve_cell/modal_view");

        ModalView.prototype.className = 'shared cve-cell modal-content';

        return ModalView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
