(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_controller', 'lib/components/tags/new/new_view'], function($) {
    return this.Pro.module("Components.Tags.New", function(New, App, Backbone, Marionette, $, _) {
      New.Controller = (function(_super) {

        __extends(Controller, _super);

        function Controller() {
          this.onFormSubmit = __bind(this.onFormSubmit, this);
          return Controller.__super__.constructor.apply(this, arguments);
        }

        Controller.prototype.initialize = function(options) {
          var content,
            _this = this;
          _.defaults(options, {
            selectAllState: false,
            q: '',
            url: '',
            content: "Default Text"
          });
          this.q = options.q, this.url = options.url, this.entity = options.entity, this.selectAllState = options.selectAllState, this.selectedIDs = options.selectedIDs, this.deselectedIDs = options.deselectedIDs, content = options.content, this.serverAPI = options.serverAPI, this.ids_only = options.ids_only, this.tagSingle = options.tagSingle;
          this.tagForm = new New.TagForm({
            model: new Backbone.Model({
              content: content
            })
          });
          this.listenTo(this.tagForm, 'token:changed', function() {
            return _this.tagCount = _this.tagForm.tokenInput.tokenInput('get').length;
          });
          return this.setMainView(this.tagForm);
        };

        Controller.prototype.getDataOptions = function() {
          var selectionOpts, tokens, _ref;
          tokens = _.map(this.getTokens(), function(tok) {
            return tok.name;
          });
          if (this.selectAllState != null) {
            selectionOpts = {
              select_all_state: this.selectAllState,
              selected_ids: this.selectedIDs,
              deselected_ids: this.deselectedIDs
            };
          } else {
            selectionOpts = {
              ignore_if_no_selections: true
            };
          }
          return {
            entity_ids: this.entity.map(function(entity) {
              return entity.id;
            }),
            new_entity_tags: tokens.join(','),
            preserve_existing: true,
            q: this.q,
            search: (_ref = this.serverAPI) != null ? _ref.search : void 0,
            ids_only: this.ids_only,
            tag_single: this.tagSingle,
            selections: selectionOpts
          };
        };

        Controller.prototype.getTokens = function() {
          return this._mainView._nameField().data('tokenInputObject').getTokens();
        };

        Controller.prototype.clearTokens = function() {
          return this._mainView._nameField().data('tokenInputObject').clear();
        };

        Controller.prototype.restoreTokens = function(tokens) {
          var token, _i, _len, _results;
          if (tokens == null) {
            tokens = [];
          }
          _results = [];
          for (_i = 0, _len = tokens.length; _i < _len; _i++) {
            token = tokens[_i];
            _results.push(this.tagForm.tokenInput.tokenInput('add', {
              id: token.id,
              name: token.name
            }));
          }
          return _results;
        };

        Controller.prototype.addTokens = function(tokens) {
          var token, _i, _len, _results;
          if (tokens == null) {
            tokens = [];
          }
          _results = [];
          for (_i = 0, _len = tokens.length; _i < _len; _i++) {
            token = tokens[_i];
            _results.push(this.tagForm.tokenInput.tokenInput('add', {
              name: token
            }));
          }
          return _results;
        };

        Controller.prototype.onFormSubmit = function() {
          var defer, formSubmit,
            _this = this;
          this._mainView._removeError();
          defer = $.Deferred();
          formSubmit = function() {
            return $.ajax({
              url: _this.url,
              method: 'POST',
              data: _this.getDataOptions(),
              success: function(x) {
                if (x.error) {
                  return _this._mainView._showError(x.error);
                } else {
                  return defer.resolve("success");
                }
              },
              error: function(x) {
                var json;
                defer.reject("failure");
                json = $.parseJSON(x.responseText);
                return _this._mainView._showError(json.error);
              }
            });
          };
          defer.promise(formSubmit);
          return formSubmit;
        };

        return Controller;

      })(App.Controllers.Application);
      return App.reqres.setHandler('tags:new:component', function(entity, options) {
        if (options == null) {
          options = {};
        }
        options.entity = entity;
        return new New.Controller(options);
      });
    });
  });

}).call(this);
