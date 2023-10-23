(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/shared/backbone/views/modal_form-a8fcc1003908ec851dabba8dcccd809004d4ff400643d83bac7fe2661ec929df.js', '/assets/templates/hosts/item_views/service_form-323d6c14dacbf7d03ca18c9ce1a84e6bec16d23686ea78b243952b41944a09f9.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, ModalForm, Template, EventAggregator) {
    var ServiceForm;
    return ServiceForm = (function(_super) {

      __extends(ServiceForm, _super);

      function ServiceForm() {
        this.submitURL = __bind(this.submitURL, this);

        this._renderErrors = __bind(this._renderErrors, this);

        this._update_table = __bind(this._update_table, this);

        this._formSubmitted = __bind(this._formSubmitted, this);

        this._postForm = __bind(this._postForm, this);

        this.onRender = __bind(this.onRender, this);
        return ServiceForm.__super__.constructor.apply(this, arguments);
      }

      ServiceForm.prototype.template = HandlebarsTemplates['hosts/item_views/service_form'];

      ServiceForm.prototype.events = _.extend({}, ModalForm.prototype.events, {
        'submit form': '_formSubmitted'
      });

      ServiceForm.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      ServiceForm.prototype.onRender = function() {
        var _this = this;
        return _.defer(function() {
          return $(':input:visible', _this.el).first().focus();
        });
      };

      ServiceForm.prototype._postForm = function() {
        var data,
          _this = this;
        data = $('form', this.el).serialize();
        return $.ajax({
          url: this.submitURL(),
          method: 'post',
          data: data,
          dataType: 'json',
          success: this._update_table,
          error: function(xhr) {
            var json;
            json = $.parseJSON(xhr.responseText);
            return _this._renderErrors(json.error);
          }
        });
      };

      ServiceForm.prototype._formSubmitted = function(e) {
        e.preventDefault();
        return this._postForm();
      };

      ServiceForm.prototype._update_table = function() {
        EventAggregator.trigger('serviceForm:rowAdded');
        EventAggregator.trigger('redrawTable');
        return this.$el.trigger('destroy');
      };

      ServiceForm.prototype._renderErrors = function(errors) {
        var _this = this;
        $('.error', this.el).remove();
        return _.each(errors, function(v, k) {
          var $msg, name;
          name = "aaData[" + k + "]";
          $msg = $('<div />', {
            "class": 'error'
          }).text(v[0]);
          return $("input[name='" + name + "']", _this.el).addClass('invalid').after($msg);
        });
      };

      ServiceForm.prototype.submitURL = function() {
        return "/hosts/" + this.host_id + "/create_service.json";
      };

      return ServiceForm;

    })(ModalForm);
  });

}).call(this);
