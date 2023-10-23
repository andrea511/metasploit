(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/hosts/item_views/form-989bc81712ed00ce7932a4ac94719d41514050f9c9f8882d4c97552afa950e8e.js', 'form_helpers', '/assets/shared/backbone/views/modal_form-a8fcc1003908ec851dabba8dcccd809004d4ff400643d83bac7fe2661ec929df.js'], function($, Template, FormHelpers, ModalForm) {
    var HostForm, RETURN_KEY_CODE;
    RETURN_KEY_CODE = 13;
    return HostForm = (function(_super) {

      __extends(HostForm, _super);

      function HostForm() {
        this._renderErrors = __bind(this._renderErrors, this);

        this._keypress = __bind(this._keypress, this);

        this._saveClicked = __bind(this._saveClicked, this);

        this._cancelCommentsClicked = __bind(this._cancelCommentsClicked, this);

        this._cancelClicked = __bind(this._cancelClicked, this);

        this._toggleCommentsClicked = __bind(this._toggleCommentsClicked, this);

        this._toggleEditLinkClicked = __bind(this._toggleEditLinkClicked, this);

        this._killClickWhenDisabled = __bind(this._killClickWhenDisabled, this);

        this.onShow = __bind(this.onShow, this);

        this.initialize = __bind(this.initialize, this);
        return HostForm.__super__.constructor.apply(this, arguments);
      }

      HostForm.prototype.template = HandlebarsTemplates['hosts/item_views/form'];

      HostForm.prototype.events = _.extend({}, ModalForm.prototype.events, {
        'click a': '_killClickWhenDisabled',
        'click a.edit': '_toggleEditLinkClicked',
        'click a.edit.comments': '_toggleCommentsClicked',
        'click a.cancel': '_cancelClicked',
        'click .actions.comments a.cancel': '_cancelCommentsClicked',
        'click a.save': '_saveClicked',
        'keypress input[type=text]': '_keypress'
      });

      HostForm.prototype.initialize = function(opts) {
        if (opts == null) {
          opts = {};
        }
        return $.extend(this, opts);
      };

      HostForm.prototype.onShow = function() {
        return $(this.el).parents('.content').css({
          padding: 0
        });
      };

      HostForm.prototype._killClickWhenDisabled = function(e) {
        if ($(e.currentTarget).is('.disabled')) {
          e.stopPropagation();
          e.stopImmediatePropagation();
          return e.preventDefault();
        }
      };

      HostForm.prototype._enableIfSaved = function() {
        if ($('a.save:not(:hidden)', this.el).size() < 1) {
          return $('.modal-actions>a.close').removeClass('disabled');
        }
      };

      HostForm.prototype._toggleEditLinkClicked = function(e) {
        var $btnWrap, name;
        $('.modal-actions>a.close').addClass('disabled');
        name = $(e.currentTarget).attr('for');
        $("form li > a.edit[for='" + name + "']", this.el).hide();
        $("form [name='" + name + "']", this.el).show().focus();
        $btnWrap = $("form .btns a.edit[for='" + name + "']", this.el).hide().parent('.btns');
        return $btnWrap.find('.actions').show();
      };

      HostForm.prototype._toggleCommentsClicked = function(e) {
        var $p, name, value;
        $('.modal-actions>a.close').addClass('disabled');
        $(e.currentTarget).hide();
        name = $(e.currentTarget).attr('for');
        $p = $('p.comments', this.el).hide();
        $('.actions.comments', this.el).show();
        value = _.string.trim($p.text());
        if (value === 'No Comments') {
          value = '';
        }
        return $("form [name='" + name + "']", this.el).text(value);
      };

      HostForm.prototype._cancelClicked = function(e) {
        var $actions, $btns, $input, name;
        $btns = $(e.currentTarget).parents('.btns');
        $actions = $(e.currentTarget).parents('.actions').hide();
        name = $(e.currentTarget).attr('for');
        $("a[for='" + name + "']", this.el).show();
        $input = $("form [name='" + name + "']", this.el).hide();
        $input.val(this.model.get(name.match(/\[(.*)\]/)[1]));
        $input.removeClass('invalid');
        $btns.siblings('.error').remove();
        return this._enableIfSaved();
      };

      HostForm.prototype._cancelCommentsClicked = function(e) {
        $('p.comments', this.el).show();
        return this._enableIfSaved();
      };

      HostForm.prototype._saveClicked = function(e) {
        var $all, $input, fixDisabled, name, updateHash, value,
          _this = this;
        updateHash = {};
        name = $(e.currentTarget).attr('for');
        $input = $("[name='" + name + "']", this.el).prop('disabled', true);
        value = $input.val();
        $all = $("[for='" + name + "'], [name='" + name + "']", this.el).addClass('disabled');
        $input.siblings('.error').remove();
        $input.removeClass('invalid');
        updateHash[name] = value;
        fixDisabled = function() {
          $input.prop('disabled', false);
          return $all.removeClass('disabled');
        };
        return this.model.update({
          params: updateHash,
          success: function(json) {
            fixDisabled();
            $all.parents('.btns').find('.actions').hide().end().find('a.pencil.edit').show();
            $all.filter('li>a.edit').show().text(value);
            $input.hide();
            if (name === 'host[comments]') {
              $('p.comments', _this.el).show().text(value);
              $('.actions.comments', _this.el).hide();
              $('.edit.comments', _this.el).show();
            }
            _this.model.trigger('change');
            return _this._enableIfSaved();
          },
          error: function(json) {
            fixDisabled();
            return _this._renderErrors(json.errors);
          }
        });
      };

      HostForm.prototype._keypress = function(e) {
        if (e.keyCode === RETURN_KEY_CODE) {
          e.preventDefault();
          return $(e.currentTarget).siblings('div.btns').find('a.save').click();
        }
      };

      HostForm.prototype._renderErrors = function(errors) {
        var _this = this;
        return _.each(errors, function(v, k) {
          var $msg, name;
          name = "host[" + k + "]";
          $msg = $('<div />', {
            "class": 'error'
          }).text(v);
          return $("input[name='" + name + "']", _this.el).addClass('invalid').siblings('.btns').after($msg);
        });
      };

      return HostForm;

    })(ModalForm);
  });

}).call(this);
