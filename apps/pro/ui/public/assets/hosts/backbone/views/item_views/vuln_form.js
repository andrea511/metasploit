(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/shared/backbone/views/modal_form-a8fcc1003908ec851dabba8dcccd809004d4ff400643d83bac7fe2661ec929df.js', '/assets/shared/notification-center/backbone/event_aggregators/event_aggregator-aaf737212decc864bf321c2e97db0fff23791a0271c939abc3da67cee19fcd44.js'], function($, ModalForm, EventAggregator) {
    var PLACEHOLDER, VulnForm;
    PLACEHOLDER = 'Vuln Reference ID or URL';
    return VulnForm = (function(_super) {

      __extends(VulnForm, _super);

      function VulnForm() {
        this._renderErrors = __bind(this._renderErrors, this);

        this._postForm = __bind(this._postForm, this);

        this.onRender = __bind(this.onRender, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);
        return VulnForm.__super__.constructor.apply(this, arguments);
      }

      VulnForm.prototype.events = _.extend({}, ModalForm.prototype.events, {
        "click .add-ref": '_addRef'
      });

      VulnForm.prototype.initialize = function(opts) {
        this.options = opts;
        $.extend(this, opts);
        return this;
      };

      VulnForm.prototype._addRef = function() {
        return this.addRefInput();
      };

      VulnForm.prototype.formLoadedSuccessfully = function() {
        var _this = this;
        VulnForm.__super__.formLoadedSuccessfully.apply(this, arguments);
        _.defer(function() {
          return $(':input:visible', _this.el).first().focus();
        });
        _.defer(function() {
          if (_this.hideRefs) {
            return $('.vuln-refs-container', _this.el).hide();
          }
        });
        return _.defer(function() {
          if (_this.hideVuln) {
            return $('.vuln-form-container', _this.el).hide();
          }
        });
      };

      VulnForm.prototype.action = 'new';

      VulnForm.prototype.actionUrl = function() {
        switch (this.options.action) {
          case "edit":
            return "" + (this.URL()) + "/" + this.options.id + "/" + this.options.action;
          case "new":
            return "" + (this.URL()) + "/" + this.options.action;
        }
      };

      VulnForm.prototype.onRender = function() {
        if (this.options.action != null) {
          this.setLoading(true);
          return this.loadForm(this.actionUrl());
        }
      };

      VulnForm.prototype.addRefInput = function() {
        var fragment, html;
        html = '<input id="vuln_new_ref_attributes__name" name="vuln[new_ref_attributes][][name]" size="60" type="text">';
        fragment = $(html).attr('placeholder', PLACEHOLDER).insertAfter($('.add-ref', this.el));
        return this.initEditInput(fragment);
      };

      VulnForm.prototype._postForm = function(defer) {
        var data;
        data = $('form', this.el).serialize();
        switch (this.options.action) {
          case "edit":
            return $.ajax({
              url: "" + (this.URL()) + "/" + this.options.id + ".json",
              type: 'PUT',
              data: data,
              defer: defer,
              _this: this,
              error: this._failureCallback,
              success: this._successCallback
            });
          case "new":
            return $.ajax({
              url: "" + (this.URL()) + ".json",
              type: 'POST',
              data: data,
              _this: this,
              defer: defer,
              error: this._failureCallback,
              success: this._successCallback
            });
        }
      };

      VulnForm.prototype._failureCallback = function(xhr) {
        var json;
        json = $.parseJSON(xhr.responseText);
        return this._this._renderErrors(json.error);
      };

      VulnForm.prototype._successCallback = function(xhr) {
        var _ref;
        EventAggregator.trigger('redrawTable');
        this._this.$el.trigger('destroy');
        return (_ref = this.defer) != null ? _ref.resolve() : void 0;
      };

      VulnForm.prototype._renderErrors = function(errors) {
        var _this = this;
        $('.error', this.el).remove();
        return _.each(errors, function(v, k) {
          var $msg, name;
          name = "vuln[" + k + "]";
          $msg = $('<div />', {
            "class": 'error'
          }).text(v[0]);
          return $("input[name='" + name + "']", _this.el).addClass('invalid').after($msg);
        });
      };

      VulnForm.prototype.onFormSubmit = function() {
        var defer;
        defer = $.Deferred();
        defer.promise();
        this._postForm(defer);
        return defer;
      };

      VulnForm.prototype._formSubmit = function(e) {
        e.preventDefault();
        return this._postForm();
      };

      VulnForm.prototype.URL = function() {
        if (this.host_id) {
          return "/hosts/" + this.host_id + "/vulns";
        } else {
          return "/hosts/" + HOST_ID + "/vulns";
        }
      };

      return VulnForm;

    })(ModalForm);
  });

}).call(this);
