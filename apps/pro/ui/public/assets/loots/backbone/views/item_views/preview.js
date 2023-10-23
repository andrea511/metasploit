(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/loots/preview-f5c2c867bbbb04ea6e82419dce8ee708149c52039942e988602b2c97a91b6247.js', '/assets/shared/backbone/views/modal_form-a8fcc1003908ec851dabba8dcccd809004d4ff400643d83bac7fe2661ec929df.js', '/assets/loots/backbone/models/loot-f22bf4ca974e640afc1c24f81f9410523c69cfae37c705e799e1c1749b3dcc70.js'], function($, Template, ModalForm, Loot) {
    var IMG_PADDING, LootPreview, MODAL_WINDOW_PADDING;
    MODAL_WINDOW_PADDING = 100;
    IMG_PADDING = 20;
    return LootPreview = (function(_super) {

      __extends(LootPreview, _super);

      function LootPreview() {
        this._imgbox = __bind(this._imgbox, this);

        this._textarea = __bind(this._textarea, this);

        this.serializeData = __bind(this.serializeData, this);

        this.loadLoot = __bind(this.loadLoot, this);

        this.textareaClicked = __bind(this.textareaClicked, this);

        this.preventKey = __bind(this.preventKey, this);

        this.onRender = __bind(this.onRender, this);

        this.initialize = __bind(this.initialize, this);
        return LootPreview.__super__.constructor.apply(this, arguments);
      }

      LootPreview.prototype.template = HandlebarsTemplates['loots/preview'];

      LootPreview.prototype.events = _.extend({}, ModalForm.prototype.events, {
        'submit form': 'formSubmitted',
        'keypress textarea': 'preventKey',
        'click textarea': 'textareaClicked'
      });

      LootPreview.prototype.initialize = function(opts) {
        if (opts == null) {
          opts = {};
        }
        $.extend(this, opts);
        this.model || (this.model = new Loot);
        return LootPreview.__super__.initialize.apply(this, arguments);
      };

      LootPreview.prototype.onRender = function() {
        return this.loadLoot();
      };

      LootPreview.prototype.preventKey = function(e) {
        return e.preventDefault();
      };

      LootPreview.prototype.textareaClicked = function() {
        return this._textarea().focus().select();
      };

      LootPreview.prototype.loadLoot = function() {
        var $img,
          _this = this;
        if (this.text && !this.img && !this.binary) {
          this.setLoading(true);
          return $.ajax({
            url: this.path,
            success: function(data) {
              _this.setLoading(false);
              _this._imgbox().hide();
              _this._textarea().text(data);
              $(_this.el).trigger('center');
              $(_this.el).trigger('updateWidth', 600);
              return _this._textarea().focus();
            }
          });
        } else if (this.img) {
          this.setLoading(true);
          this._textarea().hide();
          $img = this._imgbox().find('img').hide();
          $img.on('load', function() {
            var maxHeight, maxWidth;
            _this.setLoading(false);
            maxHeight = Math.min($img.height(), $(window).height() - MODAL_WINDOW_PADDING * 1.5);
            maxWidth = Math.min($img.width(), $(window).width() - MODAL_WINDOW_PADDING);
            $img.show();
            $img.css({
              'max-width': maxWidth,
              'max-height': maxHeight,
              height: 'auto'
            });
            $(_this.el).trigger('center');
            return $(_this.el).trigger('updateWidth', Math.max(_this.$el.width(), maxWidth));
          });
          return $img.attr('src', this.path);
        }
      };

      LootPreview.prototype.serializeData = function() {
        return this;
      };

      LootPreview.prototype._textarea = function() {
        return $('.text_dump', this.el);
      };

      LootPreview.prototype._imgbox = function() {
        return $('.img_box', this.el);
      };

      return LootPreview;

    })(ModalForm);
  });

}).call(this);
