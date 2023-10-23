(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_view', 'base_itemview', 'base_layout', 'apps/logins/new/templates/new_layout', 'apps/logins/new/templates/form'], function() {
    return this.Pro.module('LoginsApp.New', function(New, App, Backbone, Marionette, $, _) {
      New.Form = (function(_super) {

        __extends(Form, _super);

        function Form() {
          return Form.__super__.constructor.apply(this, arguments);
        }

        Form.prototype.template = Form.prototype.templatePath('logins/new/form');

        Form.prototype.regions = {
          accessLevelRegion: '.access-level-region'
        };

        Form.prototype.ui = {
          host: 'select.host'
        };

        Form.prototype.triggers = {
          'change @ui.host': 'updateServices'
        };

        Form.prototype.updateService = function() {
          return this.ui.host.trigger('change');
        };

        Form.prototype.hideHost = function() {
          return this.ui.host.parent().hide();
        };

        return Form;

      })(App.Views.Layout);
      return New.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('logins/new/new_layout');

        Layout.prototype.regions = {
          tags: '.tags',
          form: 'form'
        };

        Layout.prototype.ui = {
          tags: '.tag-container'
        };

        Layout.prototype.className = 'tab-loading';

        Layout.prototype.removeTags = function() {
          return this.ui.tags.remove();
        };

        Layout.prototype.removeLoading = function() {
          return this.$el.removeClass('tab-loading');
        };

        Layout.prototype.updateErrors = function(errors) {
          var _this = this;
          $('.error').remove();
          if (errors != null) {
            return _.each(errors, function(v, k) {
              var $msg, error, name, _i, _len, _results;
              _results = [];
              for (_i = 0, _len = v.length; _i < _len; _i++) {
                error = v[_i];
                if (k === 'port' || k === 'proto') {
                  k = 'service';
                }
                name = "" + k;
                $msg = $('<div />', {
                  "class": 'error'
                }).text(error);
                _results.push($("[name='" + name + "']", _this.el).addClass('invalid').parent('div').after($msg));
              }
              return _results;
            });
          }
        };

        return Layout;

      })(App.Views.Layout);
    });
  });

}).call(this);
