(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/loots/form-539a55b4544ecc5279614d2590c704e318ba8e6b1f95221f483002f23ba66086.js', '/assets/shared/backbone/views/modal_form-a8fcc1003908ec851dabba8dcccd809004d4ff400643d83bac7fe2661ec929df.js', '/assets/loots/backbone/models/loot-f22bf4ca974e640afc1c24f81f9410523c69cfae37c705e799e1c1749b3dcc70.js'], function($, Template, ModalForm, Loot) {
    var LootForm;
    return LootForm = (function(_super) {

      __extends(LootForm, _super);

      function LootForm() {
        this.formSubmitted = __bind(this.formSubmitted, this);

        this.fileChanged = __bind(this.fileChanged, this);

        this.onRender = __bind(this.onRender, this);

        this.postURL = __bind(this.postURL, this);

        this.initialize = __bind(this.initialize, this);
        return LootForm.__super__.constructor.apply(this, arguments);
      }

      LootForm.prototype.template = HandlebarsTemplates['loots/form'];

      LootForm.prototype.events = _.extend({}, ModalForm.prototype.events, {
        'submit form': 'formSubmitted',
        'change input[type=file]': 'fileChanged'
      });

      LootForm.prototype.initialize = function(opts) {
        if (opts == null) {
          opts = {};
        }
        $.extend(this, opts);
        this.model || (this.model = new Loot);
        return LootForm.__super__.initialize.apply(this, arguments);
      };

      LootForm.prototype.postURL = function() {
        return "/hosts/" + (this.model.get('host_id')) + "/add_loot";
      };

      LootForm.prototype.onRender = function() {
        var _this = this;
        _.defer(function() {
          return $('input:visible', _this.el).first().focus();
        });
        return $('input:file', this.el).each(function() {
          var $label, $p, $span, origText;
          $label = $(this).prev();
          origText = $label.text() || 'file';
          $(this).attr('size', '50').css({
            overflow: 'hidden'
          });
          $p = $('<p>').text('No file selected');
          $span = $('<span>').text("Choose " + origText + "...");
          $label.html('').append($p).append($span);
          return $(this).change(function() {
            var path;
            path = $(this).val().replace(/.*(\\|\/)/g, '');
            if (path && path.length > 0) {
              return $p.text(path);
            } else {
              return $p.html('&nbsp;');
            }
          });
        });
      };

      LootForm.prototype.fileChanged = function() {
        var m, path;
        path = $('input[type=file]', this.el).val();
        if (m = path.match(/\\*([^\\]*)?$/)) {
          return $('input[name*=name]', this.el).val(m[1]);
        }
      };

      LootForm.prototype.formSubmitted = function(e) {
        var $form, data,
          _this = this;
        e.preventDefault();
        e.stopPropagation();
        $form = $('form', this.el);
        data = $(':text, textarea', $form[0]).serializeArray();
        data.push({
          name: 'authenticity_token',
          value: $('meta[name=csrf-token]').attr('content')
        }, {
          name: 'feature_flag',
          value: true
        });
        $.ajax({
          url: this.postURL(),
          type: 'POST',
          data: data,
          files: $(':file', $form[0]),
          iframe: true,
          processData: false
        }).complete(function(data) {
          data = $.parseJSON(data.responseText);
          if (data.success === true) {
            $(_this.el).trigger('destroy');
            return _this.trigger('success');
          } else {
            _this.setLoading(false);
            return $('.errors', _this.el).show().text(data.error);
          }
        });
        return this.setLoading(true);
      };

      return LootForm;

    })(ModalForm);
  });

}).call(this);
