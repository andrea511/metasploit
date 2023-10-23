(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/shared/backbone/views/modal_form-a8fcc1003908ec851dabba8dcccd809004d4ff400643d83bac7fe2661ec929df.js', '/assets/templates/reports/views/report_form-91676c67a8a79ff848fd826ea7c2cad120b78cb22c38e73500cc2a6386c8198d.js', 'form_helpers'], function($, ModalForm, Template) {
    var ReportForm;
    return ReportForm = (function(_super) {

      __extends(ReportForm, _super);

      function ReportForm() {
        this._formSubmitted = __bind(this._formSubmitted, this);

        this.initialize = __bind(this.initialize, this);
        return ReportForm.__super__.constructor.apply(this, arguments);
      }

      ReportForm.prototype.template = HandlebarsTemplates['reports/views/report_form'];

      ReportForm.prototype.events = _.extend({}, ModalForm.prototype.events, {
        'submit form': '_formSubmitted'
      });

      ReportForm.prototype.initialize = function(_arg) {
        this.url = _arg.url;
      };

      ReportForm.prototype._formSubmitted = function(e) {
        var $form, data,
          _this = this;
        e.preventDefault();
        $form = $('form', this.el);
        data = $(':input', $form[0]).not(':file').serializeArray();
        data.push({
          name: 'authenticity_token',
          value: $('meta[name=csrf-token]').attr('content')
        });
        this.setLoading(true);
        return $.ajax({
          url: this.url,
          type: 'POST',
          processData: false,
          data: data,
          files: $form.find(':file').removeAttr('disabled'),
          iframe: true
        }).complete(function(data) {
          var json;
          _this.setLoading(false);
          json = $.parseJSON(data.responseText);
          if (json.success) {
            _this.$el.trigger('destroy');
            return window.location.reload();
          } else {
            _this._clearErrors();
            return _this._renderErrors(json);
          }
        });
      };

      return ReportForm;

    })(ModalForm);
  });

}).call(this);
