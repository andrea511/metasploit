(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery'], function($) {
    var AppTabbedModalView;
    return AppTabbedModalView = (function(_super) {

      __extends(AppTabbedModalView, _super);

      function AppTabbedModalView() {
        this.toggleGenerateReport = __bind(this.toggleGenerateReport, this);

        this.handleErrors = __bind(this.handleErrors, this);

        this.layout = __bind(this.layout, this);

        this.formLoadedSuccessfully = __bind(this.formLoadedSuccessfully, this);
        return AppTabbedModalView.__super__.constructor.apply(this, arguments);
      }

      AppTabbedModalView.WIDTH = 800;

      AppTabbedModalView.prototype.initialize = function() {
        AppTabbedModalView.__super__.initialize.apply(this, arguments);
        this.setButtons([
          {
            name: 'Cancel',
            "class": 'close'
          }, {
            name: 'Launch',
            "class": 'btn primary'
          }
        ]);
        return this.loadForm(this.submitUrl());
      };

      AppTabbedModalView.prototype.events = _.extend({
        'change input#tab_generate_report': 'toggleGenerateReport'
      }, TabbedModalView.prototype.events);

      AppTabbedModalView.prototype.formLoadedSuccessfully = function(html) {
        var enabled,
          _this = this;
        AppTabbedModalView.__super__.formLoadedSuccessfully.apply(this, arguments);
        $('form.formtastic', this.el).removeClass('formtastic').addClass('metamodule');
        enabled = !!$("[name*='report_enabled']", this.$modal).attr('value');
        $('input#tab_generate_report', this.$modal).prop('checked', enabled);
        return _.defer(function() {
          var $secs;
          $secs = $('.report_formats>div, .report_sections>div, .report_options>div', _this.$modal);
          return $secs.addClass('active_report_option').show();
        });
      };

      AppTabbedModalView.prototype.layout = function() {
        this.$modal.width(this.constructor.WIDTH || AppTabbedModalView.WIDTH);
        return this.center();
      };

      AppTabbedModalView.prototype.handleErrors = function(errorsHash, tabIdx) {
        var $oldPage, $page,
          _this = this;
        this.errors = this.transformErrorData(errorsHash).errors;
        $oldPage = this.content().find('div.page').eq(tabIdx);
        $oldPage.find('p.inline-error,p.error-desc').remove();
        if (!tabIdx) {
          $page = $(this.pageAt(this._tabIdx));
          $('li.error', $page).removeClass("error");
        }
        _.each(this.errors, function(modelErrors, modelName) {
          return _.each(modelErrors, function(attrErrors, attrName) {
            var $input, $li;
            $input = $("[name='" + modelName + "[" + attrName + "]']", _this.$modal);
            $page = $input.parents('div.page').first();
            if (!(tabIdx != null) || $page.index('.page') === tabIdx) {
              _this.tabAt($page.index('.page')).find('.hasErrors').show();
              $li = $input.parents('li').first().addClass('error');
              return $("<p>").addClass('inline-error').appendTo($li).text(attrErrors[0]);
            }
          });
        });
        return null;
      };

      AppTabbedModalView.prototype.toggleGenerateReport = function(e) {
        var checked;
        if (!$(e.currentTarget).parents('li').first().hasClass('selected')) {
          return;
        }
        checked = $(e.currentTarget).is(':checked');
        $('.generate_report h3.enabled>span', this.$modal).removeClass('disabled enabled');
        if (checked) {
          $('.generate_report h3.enabled>span', this.$modal).text("enabled").addClass('enabled').removeClass('disabled');
          return $("[name*='report_enabled']", this.$modal).attr('value', '1');
        } else {
          $('.generate_report h3.enabled>span', this.$modal).text("disabled").addClass('disabled').removeClass('enabled');
          return $("[name*='report_enabled']", this.$modal).removeAttr('value');
        }
      };

      return AppTabbedModalView;

    })(TabbedModalView);
  });

}).call(this);
