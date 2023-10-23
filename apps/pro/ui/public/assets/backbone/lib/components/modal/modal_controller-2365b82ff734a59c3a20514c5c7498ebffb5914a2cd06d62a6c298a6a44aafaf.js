(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_controller', 'base_model', 'lib/components/modal/modal_view', 'lib/components/buttons/buttons_controller', 'entities/abstract/modal', 'lib/regions/dialog_region'], function() {
    return this.Pro.module("Components.Modal", function(Modal, App) {
      Modal.ModalController = (function(_super) {

        __extends(ModalController, _super);

        function ModalController() {
          return ModalController.__super__.constructor.apply(this, arguments);
        }

        ModalController.prototype.defaults = function() {
          return {
            proxy: false,
            loading: false
          };
        };

        ModalController.prototype.initialize = function(options) {
          var config, modal,
            _this = this;
          if (options == null) {
            options = {};
          }
          this.contentView = options.contentView, this.modal = options.modal, this.buttons = options.buttons, this.doneCallback = options.doneCallback, this.closeCallback = options.closeCallback, this.loading = options.loading;
          config = this.getConfig(options);
          modal = App.request("component:modal:entities", this.modal);
          this.setMainView(new Modal.ModalLayout({
            model: modal
          }));
          if (config.proxy) {
            this.parseProxys(config.proxy);
          }
          this.listenTo(this._mainView, "show", function() {
            _this.modalRegion();
            _this._mainView.center();
            _this.buttons = App.request("buttons:component", {
              buttons: _this.buttons
            });
            return _this.show(_this.buttons, {
              region: _this._mainView.buttons
            });
          });
          this.listenTo(this._mainView, "primaryClicked", function(e) {
            var formSubmit;
            if (_this.contentView.onFormSubmit == null) {
              throw new Error("onFormSubmit method not defined on Content Region View/Controller");
            } else {
              formSubmit = _this.contentView.onFormSubmit(e);
              if (formSubmit != null) {
                formSubmit.done(function() {
                  if (typeof _this.doneCallback === "function") {
                    _this.doneCallback();
                  }
                  return _this.region.reset();
                });
              }
              return typeof formSubmit === "function" ? formSubmit() : void 0;
            }
          });
          this.listenTo(this._mainView, "closeClicked", function(e) {
            return typeof _this.closeCallback === "function" ? _this.closeCallback() : void 0;
          });
          this.listenTo(this.contentView, "btn:disable:modal", function(btnName) {
            return _this.buttons.disableBtn(btnName);
          });
          this.listenTo(this.contentView, "btn:enable:modal", function(btnName) {
            return _this.buttons.enableBtn(btnName);
          });
          return this.show(this._mainView);
        };

        ModalController.prototype.modalRegion = function() {
          var _this = this;
          this.listenTo(this.contentView, 'center', function() {
            return _this._mainView.center();
          });
          return this.show(this.contentView, {
            region: this.getMainView().content,
            loading: this.loading
          });
        };

        ModalController.prototype.getConfig = function(options) {
          var config, modalView;
          modalView = _.result(this.contentView, "_mainView");
          config = this.mergeDefaultsInto(modalView);
          return _.extend(config, _(options).omit("contentView", "model", "collection", "proxy"));
        };

        ModalController.prototype.parseProxys = function(proxys) {
          var proxy, _i, _len, _ref, _results;
          _ref = _([proxys]).flatten();
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            proxy = _ref[_i];
            _results.push(this._mainView[proxy] = _.result(this.contentView, proxy));
          }
          return _results;
        };

        return ModalController;

      })(App.Controllers.Application);
      App.reqres.setHandler("modal:component", function(contentView, options) {
        if (options == null) {
          options = {};
        }
        if (!contentView) {
          throw new Error("Modal Component requires a contentView to be passed in");
        }
        options.contentView = contentView;
        return new Modal.ModalController(options);
      });
      App.commands.setHandler('showModal', function(contentView, options) {
        if (options == null) {
          options = {};
        }
        if (localStorage.getItem(options.modal.title) !== "false") {
          options = _.defaults(options, {
            region: App.dialogRegion
          });
          if (options.region == null) {
            App.addRegions({
              dialogRegion: {
                selector: "#dialog-region",
                regionType: App.Regions.Dialog
              }
            });
            options.region = App.dialogRegion;
          }
          return App.request("modal:component", contentView, options);
        }
      });
      App.commands.setHandler('closeModal', function() {
        var _ref;
        return (_ref = App.dialogRegion) != null ? _ref.reset() : void 0;
      });
      return App.on("initialize:after", function(options) {
        return this.addRegions({
          dialogRegion: {
            selector: "#dialog-region",
            regionType: App.Regions.Dialog
          }
        });
      });
    });
  });

}).call(this);
