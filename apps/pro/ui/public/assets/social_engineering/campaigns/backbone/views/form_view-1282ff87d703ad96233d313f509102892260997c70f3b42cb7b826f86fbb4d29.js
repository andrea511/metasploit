(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.FormView = (function(_super) {

      __extends(FormView, _super);

      function FormView() {
        return FormView.__super__.constructor.apply(this, arguments);
      }

      FormView.prototype.initialize = function(opts) {
        this.options = opts;
        this.saveCallback = this.options['save'] || this.saveCallback;
        this.length = 1;
        _.bindAll(this, 'save', 'onLoad');
        return FormView.__super__.initialize.apply(this, arguments);
      };

      FormView.prototype.events = _.extend({
        'click .actions a.cancel': 'close',
        'click .actions a.save': 'save'
      }, PaginatedRollupModalView.prototype.events);

      FormView.prototype.save = function() {
        if (this.saveCallback) {
          return this.saveCallback.call(this);
        }
      };

      FormView.prototype.onLoad = function() {
        var $form, currAction, setInputChangedFn,
          _this = this;
        this.inputChanged = false;
        setInputChangedFn = function(e) {
          var str;
          str = String.fromCharCode(e.keyCode);
          if (str.match(/\w/) || str === ' ') {
            return _this.inputChanged = true;
          }
        };
        $('input,select,textarea', this.el).keydown(setInputChangedFn);
        $('select,input,textarea', this.el).change(function() {
          return _this.inputChanged = true;
        });
        if (this.options['formQuery']) {
          $form = $('form', this.el).first();
          currAction = $form.attr('action');
          $form.attr('action', "" + currAction + this.options['formQuery']);
        }
        _.each($('select>option', this.el), function(item) {
          if ($(item).val() === '') {
            return $(item).removeAttr('value');
          }
        });
        if (!this.dontRenderSelect2) {
          $('select', this.el).select2(DEFAULT_SELECT2_OPTS);
        }
        return FormView.__super__.onLoad.apply(this, arguments);
      };

      FormView.prototype.close = function(opts) {
        var optionsConfirm, optsConfirm;
        if (opts == null) {
          opts = {};
        }
        if (this.inputChanged) {
          return FormView.__super__.close.call(this, opts);
        } else {
          optionsConfirm = this.options.confirm;
          this.options.confirm = null;
          optsConfirm = opts.confirm;
          opts.confirm = null;
          FormView.__super__.close.call(this, opts);
          this.options.confirm = optionsConfirm;
          return opts.confirm = optsConfirm;
        }
      };

      FormView.prototype.actionButtons = function() {
        return [[['cancel link3 no-span', 'Cancel'], ['save primary', 'Save']]];
      };

      return FormView;

    })(this.PaginatedRollupModalView);
  });

}).call(this);
