(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/shared/backbone/views/modal_form-a8fcc1003908ec851dabba8dcccd809004d4ff400643d83bac7fe2661ec929df.js', '/assets/templates/hosts/item_views/cred_form-e03dc8d7bb774a788288a3a3182b106ea1f70fa8c67863165acc6593b3512e32.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, ModalForm, Template, EventAggregator) {
    var CredForm;
    return CredForm = (function(_super) {

      __extends(CredForm, _super);

      function CredForm() {
        this.submitURL = __bind(this.submitURL, this);

        this.onRender = __bind(this.onRender, this);

        this._formSubmitted = __bind(this._formSubmitted, this);

        this._updateTable = __bind(this._updateTable, this);

        this._postForm = __bind(this._postForm, this);

        this._typeChanged = __bind(this._typeChanged, this);
        return CredForm.__super__.constructor.apply(this, arguments);
      }

      CredForm.prototype.template = HandlebarsTemplates['hosts/item_views/cred_form'];

      CredForm.prototype.events = _.extend({}, ModalForm.prototype.events, {
        'submit form': '_formSubmitted',
        'change li.ptype select': '_typeChanged'
      });

      CredForm.prototype.initialize = function(_arg) {
        this.host_id = _arg.host_id;
      };

      CredForm.prototype._typeChanged = function(e) {
        var type, words;
        words = $(e.currentTarget).find('option:selected').text().split(/\s+/);
        type = _.str.capitalize(words[words.length - 1]);
        return $('li.port label', this.el).text(type);
      };

      CredForm.prototype._postForm = function() {
        var data,
          _this = this;
        data = $('form', this.el).serialize();
        this.setLoading(true);
        return $.ajax({
          url: this.submitURL(),
          method: 'post',
          data: data,
          success: function() {
            _this.setLoading(false);
            _this._updateTable();
            return _this.$el.trigger('close');
          },
          error: function(data) {
            _this.setLoading(false);
            _this._clearErrors();
            return _this._renderErrors($.parseJSON(data));
          }
        });
      };

      CredForm.prototype._updateTable = function() {
        EventAggregator.trigger('redrawTable');
        return $(this.el).trigger('close');
      };

      CredForm.prototype._formSubmitted = function(e) {
        e.preventDefault();
        return this._postForm();
      };

      CredForm.prototype.onRender = function() {
        var _this = this;
        return _.defer(function() {
          return $(':input:visible', _this.el).first().focus();
        });
      };

      CredForm.prototype.submitURL = function() {
        return "/hosts/" + this.host_id + "/create_cred.json";
      };

      return CredForm;

    })(ModalForm);
  });

}).call(this);
