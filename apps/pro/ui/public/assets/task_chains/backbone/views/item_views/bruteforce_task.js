(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', '/assets/templates/task_chains/item_views/bruteforce_task-e94d8a00af7e43b440aed1a9d219d4b210bdce9a390d5c918b207f234a189db8.js', '/assets/task_chains/backbone/views/item_views/task_config-458520c231172701b05b17eb4ec828171c6e0745e4b3d3c11327d01af916a52e.js', 'apps/brute_force_guess/brute_force_guess_app'], function($, Template, TaskConfigView) {
    var BruteforceTask;
    return BruteforceTask = (function(_super) {

      __extends(BruteforceTask, _super);

      function BruteforceTask() {
        this._triggerValidated = __bind(this._triggerValidated, this);

        this.loadPartial = __bind(this.loadPartial, this);
        return BruteforceTask.__super__.constructor.apply(this, arguments);
      }

      BruteforceTask.prototype.template = HandlebarsTemplates['task_chains/item_views/bruteforce_task'];

      BruteforceTask.prototype.VALIDATION_URL = "/workspaces/" + WORKSPACE_ID + "/tasks/validate_bruteforce";

      BruteforceTask.prototype.ui = _.extend({}, TaskConfigView.prototype.ui, {
        file_label: '.file-upload-region label p',
        file_input: '.file-upload-region input'
      });

      BruteforceTask.prototype.onShow = function() {
        var _ref;
        if (this.model.get('clonedModel')) {
          this.payloadModel = Pro.request('shared:payloadSettings:entities', this.model.get('clonedModel').get('payloadModel'));
          this.mutationModel = Pro.request('mutationOptions:entities', this.model.get('clonedModel').get('mutationModel'));
        }
        if ((this.model.get('task') != null) && !(this.form_cache != null)) {
          if (this.model.get('task').form_hash.payload_settings != null) {
            this.payloadModel = Pro.request('shared:payloadSettings:entities', _.pick(this.model.get('task').form_hash, 'payload_settings'));
          }
          if (this.model.get('task').form_hash.mutation_options != null) {
            this.mutationModel = Pro.request('mutationOptions:entities', _.pick(this.model.get('task').form_hash, 'mutation_options'));
          }
        }
        if ((_ref = this.storedModel) == null) {
          this.storedModel = new Backbone.Model({});
        }
        this.controller = new Pro.BruteForceGuessApp.Index.Controller({
          taskChain: true,
          region: this.configRegion,
          payloadModel: this.payloadModel,
          mutationModel: this.mutationModel
        });
        return _.defer(this.loadPartial);
      };

      BruteforceTask.prototype.loadPartial = function(url, func, args) {
        var excludeInputs, _ref;
        if ((this.model.get('task') != null) && !(this.form_cache != null)) {
          Backbone.Syphon.deserialize(this.controller._mainView, this.model.get('task').form_hash, {
            exclude: ["quick_bruteforce[file]"]
          });
          this.controller.quickBruteforce.useLastUploaded(((_ref = this.model.get('task').file_upload) != null ? _ref.url : void 0) || this.model.get('task').form_hash.quick_bruteforce.use_last_uploaded);
          this.controller.quickBruteforce.restoreUIState({
            restoreFileInput: false
          });
          this._initErrorMessages();
          this.trigger('loaded');
        } else {
          if ((this.form_cache != null) && !(this.model.get('cloned') != null)) {
            this._applyStashedFileInput(this.$el);
            this._restoreFileLabel();
            this.controller.quickBruteforce.file_input.rebindFileInput();
            Backbone.Syphon.deserialize(this.controller._mainView, this.storedModel.toJSON(), {
              exclude: ["quick_bruteforce[file]", "clone_file_warning"]
            });
            this.controller.quickBruteforce.restoreUIState();
            $('[name="clone_file_warning"]', this.controller._mainView.$el).val(this.storedModel.get('clone_file_warning'));
            this._initErrorMessages();
          } else {
            if (this.model.get('cloned') != null) {
              excludeInputs = ["quick_bruteforce[file]"];
              if (this.model.get('clonedModel').get('bruteforce').quick_bruteforce.use_last_uploaded === '') {
                excludeInputs << "quick_bruteforce[use_last_uploaded]";
              }
              if (this.model.get('clonedModel').get('bruteforce').quick_bruteforce.creds.import_cred_pairs.use_file_contents && this.model.get('clonedModel').get('bruteforce').quick_bruteforce.use_last_uploaded === '') {
                excludeInputs = excludeInputs.concat(["quick_bruteforce[creds][import_cred_pairs][data]", "text_area_status", "import_pair_count"]);
              }
              this.model.get('clonedModel').get('bruteforce').import_pair_count = this.model.get('clonedModel').get('bruteforce').text_area_count;
              Backbone.Syphon.deserialize(this.controller._mainView, this.model.get('clonedModel').get('bruteforce'), {
                exclude: excludeInputs
              });
              this.model.set('cloned', null);
              this.controller.quickBruteforce.restoreUIState();
              if (func) {
                func.call(args);
              }
            } else {
              this.trigger('loaded');
              this._initErrorMessages();
            }
          }
        }
        return this.trigger('loaded');
      };

      BruteforceTask.prototype._initErrorMessages = function() {
        if (typeof this.ui.errors !== "string") {
          if (this.errors) {
            return this.controller.quickBruteforce._mainView.showErrors(this.errors);
          }
        }
      };

      BruteforceTask.prototype._setCache = function() {
        return BruteforceTask.__super__._setCache.apply(this, arguments);
      };

      BruteforceTask.prototype.formModel = function() {
        var _ref, _ref1, _ref2;
        this.payloadModel = this.controller.quickBruteforce.payloadModel;
        this.mutationModel = this.controller.quickBruteforce.mutationModel;
        return Pro.request("new:brute_force_guess_form:entity", {
          bruteforce: (_ref = this.storedModel) != null ? _ref.toJSON() : void 0,
          payloadModel: (_ref1 = this.payloadModel) != null ? _ref1.toJSON() : void 0,
          mutationModel: (_ref2 = this.mutationModel) != null ? _ref2.toJSON() : void 0
        });
      };

      BruteforceTask.prototype._storeForm = function(opts) {
        var _ref, _ref1, _ref2;
        if (opts == null) {
          opts = {
            callSuper: true
          };
        }
        if (opts.callSuper) {
          BruteforceTask.__super__._storeForm.apply(this, arguments);
        }
        this.storedModel.set(Backbone.Syphon.serialize(this.controller._mainView, {
          exclude: ["quick_bruteforce[file]"]
        }));
        return this.storedForm = Pro.request("new:brute_force_guess_form:entity", {
          bruteforce: (_ref = this.storedModel) != null ? _ref.toJSON() : void 0,
          payloadModel: (_ref1 = this.controller.quickBruteforce.payloadModel) != null ? _ref1.toJSON() : void 0,
          mutationModel: (_ref2 = this.controller.quickBruteforce.mutationModel) != null ? _ref2.toJSON() : void 0
        });
      };

      BruteforceTask.prototype.onBeforeClose = function() {
        BruteforceTask.__super__.onBeforeClose.apply(this, arguments);
        this._validate("URL");
        this.payloadModel = this.controller.quickBruteforce.payloadModel;
        return this.mutationModel = this.controller.quickBruteforce.mutationModel;
      };

      BruteforceTask.prototype._restoreFileLabel = function() {
        return this.controller.quickBruteforce.file_input.resetLabel();
      };

      BruteforceTask.prototype._triggerValidated = function(model, response, options) {
        var _ref;
        if ((_ref = response.responseJSON) != null ? _ref.errors : void 0) {
          this.errors = response.responseJSON.errors;
          $(document).trigger('showErrorPie', this);
        } else {
          this.errors = null;
        }
        return $(document).trigger('validated', this);
      };

      BruteforceTask.prototype._validate = function(url, overrides) {
        if (overrides == null) {
          overrides = [];
        }
        if (this.storedForm != null) {
          this.controller.quickBruteforce.validateBruteForce(this._triggerValidated);
        }
        this.bindUIElements();
        return this._stashFileInput();
      };

      return BruteforceTask;

    })(TaskConfigView);
  });

}).call(this);
