(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', '/assets/templates/shared/modal-31a2e1e13e88841ef0041a4396939f897c9bd91aa069c99441b2598732a00ce1.js'], function($, tmpl) {
    var EmptyView, Modal;
    EmptyView = (function(_super) {

      __extends(EmptyView, _super);

      function EmptyView() {
        return EmptyView.__super__.constructor.apply(this, arguments);
      }

      EmptyView.prototype.template = _.template('');

      return EmptyView;

    })(Backbone.Marionette.ItemView);
    return Modal = (function(_super) {

      __extends(Modal, _super);

      function Modal() {
        this._center = __bind(this._center, this);

        this._stubCustomConfirm = __bind(this._stubCustomConfirm, this);

        this._escKeyHandler = __bind(this._escKeyHandler, this);

        this._bindWindow = __bind(this._bindWindow, this);

        this._unbindWindow = __bind(this._unbindWindow, this);

        this.onShow = __bind(this.onShow, this);

        this._modalDiv = __bind(this._modalDiv, this);

        this._modalRegion = __bind(this._modalRegion, this);

        this._updateWidth = __bind(this._updateWidth, this);

        this._close = __bind(this._close, this);

        this.primaryClicked = __bind(this.primaryClicked, this);

        this.serializeData = __bind(this.serializeData, this);

        this.open = __bind(this.open, this);

        this.initialize = __bind(this.initialize, this);
        return Modal.__super__.constructor.apply(this, arguments);
      }

      Modal.MODAL_CONFIRM_MSG = 'Are you sure you want to close this panel? Any text input will be lost.';

      Modal.prototype.template = HandlebarsTemplates['shared/modal'];

      Modal.prototype.regions = {
        content: '.content'
      };

      Modal.prototype.title = null;

      Modal.prototype.description = null;

      Modal.prototype.bg = true;

      Modal.prototype.events = {
        'destroy': '_close',
        'center': '_center',
        'updateWidth': '_updateWidth',
        'click a.close': '_close',
        'click a.btn.primary': 'primaryClicked'
      };

      Modal.prototype.initialize = function(opts) {
        if (opts == null) {
          opts = {};
        }
        this["class"] = '';
        $.extend(this, opts);
        this.origConfirm = window.confirm;
        return Modal.__super__.initialize.apply(this, arguments);
      };

      Modal.prototype.open = function() {
        var _this = this;
        this._modalRegion().show(this, {
          preventDestroy: true
        });
        this._unbindWindow();
        this._bindWindow();
        this._stubCustomConfirm();
        this.$el.hide();
        _.defer(function() {
          _this.$el.show();
          return _this._center();
        });
        $('#modals').appendTo(document.body);
        return $('#modals').removeClass('empty');
      };

      Modal.prototype.buttons = [
        {
          name: 'Cancel',
          "class": 'close'
        }, {
          name: 'Submit',
          "class": 'btn primary'
        }
      ];

      Modal.prototype.serializeData = function() {
        return this;
      };

      Modal.prototype.primaryClicked = function(e) {
        e.preventDefault();
        return $('form', this.el).first().submit();
      };

      Modal.prototype._close = function(e) {
        var $modalDiv;
        this.trigger('destroy');
        if (((e != null ? e.target : void 0) != null) && $(e.target).is('.disabled')) {
          return;
        }
        $modalDiv = this._modalRegion();
        if ($modalDiv.$el.is('.my_modal')) {
          $modalDiv.$el.remove();
        }
        $modalDiv.show(new EmptyView(), {
          preventDestroy: true
        });
        this._unbindWindow();
        if ($('#modals').is(':empty')) {
          return $('#modals').addClass('empty');
        }
      };

      Modal.prototype._updateWidth = function(e, w) {
        this.width = w;
        return this._center();
      };

      Modal.prototype._modalRegion = function() {
        var $modalDiv, $myDiv;
        if (this.region != null) {
          return this.region;
        }
        $modalDiv = $('#modals');
        if ($modalDiv.is(':empty')) {
          return this.region = new Backbone.Marionette.Region({
            el: $('#modals')
          });
        } else {
          $myDiv = $('<div />', {
            "class": 'my_modal'
          }).appendTo($modalDiv);
          return this.region = new Backbone.Marionette.Region({
            el: $myDiv
          });
        }
      };

      Modal.prototype._modalDiv = function() {
        return $('.modal', this.el).first();
      };

      Modal.prototype.onShow = function() {
        return _.defer(this._center);
      };

      Modal.prototype._escEnabled = true;

      Modal.prototype._unbindWindow = function() {
        window.confirm = this.origConfirm;
        $(window).unbind('resize.tabbedModal', this._center);
        return $(window).unbind('keyup.modal', this._escKeyHandler);
      };

      Modal.prototype._bindWindow = function() {
        window.origConfirm || (window.origConfirm = window.confirm);
        $(window).bind('resize.tabbedModal', this._center);
        return $(window).bind('keyup.modal', this._escKeyHandler);
      };

      Modal.prototype._escKeyHandler = function(e) {
        var _ref, _ref1;
        if (((_ref = String.fromCharCode(e.keyCode)) != null ? (_ref1 = _ref.match(/[\w]+/)) != null ? _ref1.length : void 0 : void 0) > 0) {
          this._edited = true;
        }
        if (e.keyCode === 27 && this._escEnabled) {
          if (this._edited) {
            if (window.confirm(Modal.MODAL_CONFIRM_MSG)) {
              this._close();
            }
          } else {
            this._close();
          }
          e.preventDefault();
          return e.stopImmediatePropagation();
        }
      };

      Modal.prototype._stubCustomConfirm = function() {
        var _this = this;
        return window.confirm = function() {
          if (_this._modalDiv().is(':visible')) {
            _this._escEnabled = false;
            _.delay((function() {
              return _this._escEnabled = true;
            }), 300);
            return window.origConfirm.apply(window, arguments);
          } else {
            return window.origConfirm.apply(window, arguments);
          }
        };
      };

      Modal.prototype._center = function() {
        var $modal, modalHeight, modalWidth, screenWidth;
        $modal = this._modalDiv();
        modalWidth = this.width || $modal.width();
        modalHeight = this.height || $modal.height();
        screenWidth = $(window).width();
        if (this.width) {
          $modal.width(this.width);
        }
        if (this.height) {
          $modal.height(this.height);
          $modal.find('.content').height(this.height - 110);
        }
        $modal.css('left', parseInt(($(window).width() - modalWidth) / 2) + 'px');
        $modal.css('top', parseInt(($(window).height() - modalHeight) / 2) + 'px');
        return $('ul.tabs>li:first-child', this.el).addClass('first-child');
      };

      return Modal;

    })(Backbone.Marionette.LayoutView);
  });

}).call(this);
