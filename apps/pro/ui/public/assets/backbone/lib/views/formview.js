(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_itemview', 'lib/concerns/views/spinner'], function() {
    return this.Pro.module("Views", function(Views, App, Backbone, Marionette, $, _) {
      return Views.FormView = (function(_super) {

        __extends(FormView, _super);

        function FormView() {
          this._renderErrors = __bind(this._renderErrors, this);
          return FormView.__super__.constructor.apply(this, arguments);
        }

        FormView.include("Spinner");

        FormView.prototype.events = {
          'change form': 'updateModel',
          'input form': 'updateModel'
        };

        FormView.prototype.modelEvents = {
          'change:errors': 'updateErrors',
          'request': 'disableForm',
          'sync': 'enableForm'
        };

        FormView.prototype.ui = {
          'form': 'form',
          'inputs': 'input, textarea'
        };

        FormView.prototype.onShow = function() {
          Backbone.Syphon.deserialize(this, this.model.toJSON());
          return this.updateErrors(null, this.model.get('errors'));
        };

        FormView.prototype.onDestroy = function() {
          return this.updateModel();
        };

        FormView.prototype.updateModel = function() {
          var data;
          data = Backbone.Syphon.serialize(this);
          return this.model.set(data);
        };

        FormView.prototype.updateErrors = function(model, errors) {
          var _this = this;
          this.enableForm();
          if (this.nestedAttributeName != null) {
            errors = _.filter(errors, function(error) {
              return error[_this.nestedAttributeName] != null;
            });
            if (!_.isEmpty(errors) && (errors[0][this.nestedAttributeName] != null)) {
              errors = errors[0][this.nestedAttributeName];
            }
          }
          return this._renderErrors(errors);
        };

        FormView.prototype.disableForm = function() {
          this.ui.form.css('opacity', '0.5');
          if (this.ui.inputs.size > 0) {
            this.ui.inputs.disable();
          }
          return this.showSpinner();
        };

        FormView.prototype.enableForm = function() {
          this.ui.form.css('opacity', '1');
          if (this.ui.inputs.size > 0) {
            this.ui.inputs.enable();
          }
          return this.hideSpinner();
        };

        FormView.prototype._renderErrors = function(errors) {
          var _this = this;
          $('.error', this.el).remove();
          return _.each(errors, function(v, k) {
            var $msg, error, name, _i, _len, _results;
            _results = [];
            for (_i = 0, _len = v.length; _i < _len; _i++) {
              error = v[_i];
              name = _this.nestedAttributeName != null ? "" + _this.nestedAttributeName + "[" + k + "]" : k;
              $msg = $('<div />', {
                "class": 'error'
              }).text(error);
              _results.push($("[name='" + name + "']", _this.el).addClass('invalid').after($msg));
            }
            return _results;
          });
        };

        return FormView;

      })(Views.ItemView);
    });
  });

}).call(this);
