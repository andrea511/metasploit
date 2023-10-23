(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_itemview', 'apps/imports/sonar/templates/domain_input_view'], function() {
    return this.Pro.module('ImportsApp.Sonar', function(Sonar, App, Backbone, Marionette, $, _) {
      return Sonar.DomainInputView = (function(_super) {

        __extends(DomainInputView, _super);

        function DomainInputView() {
          return DomainInputView.__super__.constructor.apply(this, arguments);
        }

        DomainInputView.prototype.template = DomainInputView.prototype.templatePath('imports/sonar/domain_input_view');

        DomainInputView.prototype.ui = {
          inputText: '#sonar-domain-input-textbox',
          queryButton: '#sonar-domain-query-button',
          errors: '#sonar-domain-input-error-container',
          lastSeen: '#sonar-last-seen-input'
        };

        DomainInputView.prototype.events = {
          'click @ui.queryButton': '_queryClicked',
          'keyup @ui.inputText': '_inputChanged'
        };

        DomainInputView.prototype.modelEvents = {
          'change:domainUrl': '_domainChanged'
        };

        DomainInputView.prototype.onShow = function() {
          return this._initQueryTooltip();
        };

        DomainInputView.prototype._initQueryTooltip = function() {
          this.ui.queryButton.css('pointer-events', 'all');
          this.ui.queryButton.attr('title', "Must enter a domain");
          return this.ui.queryButton.tooltip();
        };

        DomainInputView.prototype._domainChanged = function(model, val) {
          if (val.length > 0) {
            this._enableQuery();
            return this.model.set('disableQuery', false);
          } else {
            this._disableQuery();
            return this.model.set('disableQuery', true);
          }
        };

        DomainInputView.prototype._queryClicked = function() {
          var domain;
          console.log('query clicked');
          domain = this.ui.inputText.val();
          return this._queryDomain(domain);
        };

        DomainInputView.prototype._inputChanged = function(e) {
          var text;
          text = e.target.value;
          this.model.set('domainUrl', text);
          return this.trigger('input:changed', text);
        };

        DomainInputView.prototype._disableQuery = function() {
          this._initQueryTooltip();
          return this.ui.queryButton.addClass('disabled');
        };

        DomainInputView.prototype._enableQuery = function() {
          this.ui.queryButton.tooltip('disable');
          return this.ui.queryButton.removeClass('disabled');
        };

        DomainInputView.prototype.getInputText = function() {
          return this.ui.inputText.val();
        };

        DomainInputView.prototype.getLastSeen = function() {
          return this.ui.lastSeen.val();
        };

        DomainInputView.prototype._queryDomain = function(domain) {
          if (!(domain.trim().length > 0)) {
            return;
          }
          if (this._validateDomain(domain)) {
            console.log("Querying Sonar for domain <" + domain + ">...");
            return this.trigger('query:submit', domain);
          } else {
            return this.showErrors("" + domain + " is not a valid domain");
          }
        };

        DomainInputView.prototype._validateDomain = function(domain) {
          return true;
        };

        DomainInputView.prototype.showErrors = function(errors) {
          this.ui.errors.css('display', 'block');
          this.ui.errors.addClass('errors');
          return this.ui.errors.html(_.escape(errors));
        };

        DomainInputView.prototype.clearErrors = function() {
          this.ui.errors.removeClass('errors');
          return this.ui.errors.html();
        };

        return DomainInputView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
