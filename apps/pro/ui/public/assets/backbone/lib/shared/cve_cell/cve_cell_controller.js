(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'entities/module_detail', 'entities/related_modules', 'lib/components/modal/modal_controller', 'lib/shared/cve_cell/cve_cell_views', 'css!css/shared/cve_cell'], function() {
    return this.Pro.module("Shared.CveCell", function(CveCell, App) {
      CveCell.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.defaults = function() {
          return {};
        };

        Controller.prototype.initialize = function(options) {
          var config, view,
            _this = this;
          if (options == null) {
            options = {};
          }
          config = _.defaults(options, this._getDefaults());
          this.model = new Backbone.Model(config).get('model');
          view = new CveCell.View({
            model: this.model
          });
          this.setMainView(view);
          return this.listenTo(this._mainView, 'refs:clicked', function() {
            var dialogView, refModel;
            if (_this.model.constructor === App.Entities.Vuln) {
              refModel = _this.model;
            } else if (_this.model.constructor === App.Entities.RelatedModules) {
              refModel = App.request('module:detail:entity', {
                id: _this.model.id,
                refsOnly: true
              });
            } else if (_this.model.constructor === App.Entities.WorkspaceRelatedModules) {
              refModel = App.request('module:detail:entity', {
                id: _this.model.id,
                refsOnly: true
              });
            } else {
              throw "Model for CveCell.Controller must be a Vuln or RelatedModules";
            }
            dialogView = new CveCell.ModalView({
              model: refModel
            });
            refModel.fetch({
              data: {
                refsOnly: true
              },
              processData: true
            });
            return App.execute('showModal', dialogView, {
              modal: {
                title: 'References',
                description: '',
                width: 260,
                height: 300
              },
              buttons: [
                {
                  name: 'Close',
                  "class": 'close'
                }
              ],
              loading: true
            });
          });
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('cveCell:component', function(options) {
        if (options == null) {
          options = {};
        }
        return new CveCell.Controller(options);
      });
    });
  });

}).call(this);
