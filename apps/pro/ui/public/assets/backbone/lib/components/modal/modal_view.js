(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_layout', 'base_itemview', 'lib/components/modal/templates/modal'], function($) {
    return this.Pro.module("Components.Modal", function(Modal, App) {
      return Modal.ModalLayout = (function(_super) {

        __extends(ModalLayout, _super);

        function ModalLayout() {
          this._escKeyHandler = __bind(this._escKeyHandler, this);

          this._unbindWindow = __bind(this._unbindWindow, this);

          this._bindWindow = __bind(this._bindWindow, this);

          this.center = __bind(this.center, this);
          return ModalLayout.__super__.constructor.apply(this, arguments);
        }

        ModalLayout.MODAL_CONFIRM_MSG = 'Are you sure you want to close this panel? Any text input will be lost.';

        ModalLayout.prototype.template = ModalLayout.prototype.templatePath("modal/modal");

        ModalLayout.prototype.ui = {
          showAgainOption: '[name="showOnce"]'
        };

        ModalLayout.prototype.regions = {
          content: '.content',
          buttons: '.modal-actions'
        };

        ModalLayout.prototype.events = {
          'click .header a.close, .modal-actions a.close': '_manualClose'
        };

        ModalLayout.prototype.triggers = {
          'click a.btn.primary': 'primaryClicked'
        };

        ModalLayout.prototype.center = function() {
          var $modal, modalHeight, modalWidth, offset, screenWidth;
          offset = this.model.get('showAgainOption') != null ? 133 : 113;
          $modal = $('.modal', this.$el).first();
          modalWidth = this.model.get('width') || $modal.width();
          modalHeight = this.model.get('height') || $modal.height();
          screenWidth = $(window).width();
          if (this.model.get('width')) {
            $modal.width(this.model.get('width'));
          }
          if (this.model.get('height')) {
            $modal.height(this.model.get('height'));
            $modal.find('.content').height(this.model.get('height') - offset);
          }
          $modal.css('left', parseInt(($(window).width() - modalWidth) / 2) + 'px');
          $modal.css('top', parseInt(($(window).height() - modalHeight) / 2) + 'px');
          $('ul.tabs>li:first-child', this.el).addClass('first-child');
          if (this.model.get('hideBorder')) {
            $('.content', this.el).css('border', 'none');
          }
          if (this.model.get('hideContent')) {
            return $('.content', this.el).hide();
          }
        };

        ModalLayout.prototype.onShow = function() {
          this.origConfirm = window.confirm;
          this._unbindWindow();
          return this._bindWindow();
        };

        ModalLayout.prototype.onDestroy = function() {
          if ((this.model.get('showAgainOption') != null) && this.ui.showAgainOption.prop('checked')) {
            localStorage.setItem(this.model.get('title'), false);
          }
          return this._unbindWindow();
        };

        ModalLayout.prototype._bindWindow = function() {
          window.origConfirm || (window.origConfirm = window.confirm);
          $(window).bind('resize.tabbedModal', this.center);
          return $(window).bind('keyup.modal', this._escKeyHandler);
        };

        ModalLayout.prototype._unbindWindow = function() {
          window.confirm = this.origConfirm;
          $(window).unbind('resize.tabbedModal', this.center);
          return $(window).unbind('keyup.modal', this._escKeyHandler);
        };

        ModalLayout.prototype._escKeyHandler = function(e) {
          var _ref, _ref1;
          if (((_ref = String.fromCharCode(e.keyCode)) != null ? (_ref1 = _ref.match(/[\w]+/)) != null ? _ref1.length : void 0 : void 0) > 0) {
            this._edited = true;
          }
          if (e.keyCode === 27) {
            if (this._edited) {
              if (window.confirm(Modal.MODAL_CONFIRM_MSG)) {
                this.destroy();
              }
            } else {
              this.destroy();
            }
            e.preventDefault();
            return e.stopImmediatePropagation();
          }
        };

        ModalLayout.prototype._manualClose = function() {
          this.trigger('closeClicked');
          return this.destroy();
        };

        return ModalLayout;

      })(App.Views.Layout);
    });
  });

}).call(this);
