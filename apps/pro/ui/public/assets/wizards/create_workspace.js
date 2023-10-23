(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    var WORKSPACE_CREATE_URL;
    WORKSPACE_CREATE_URL = '/workspaces.json';
    this.CreateWorkspaceModal = (function(_super) {

      __extends(CreateWorkspaceModal, _super);

      function CreateWorkspaceModal() {
        this.render = __bind(this.render, this);

        this.workspaceSaved = __bind(this.workspaceSaved, this);

        this.submitButtonClicked = __bind(this.submitButtonClicked, this);

        this.someInputChanged = __bind(this.someInputChanged, this);
        return CreateWorkspaceModal.__super__.constructor.apply(this, arguments);
      }

      CreateWorkspaceModal.prototype._modelsToTabs = {
        workspace: 0
      };

      CreateWorkspaceModal.prototype.initialize = function() {
        var _this = this;
        CreateWorkspaceModal.__super__.initialize.apply(this, arguments);
        this.setTitle('Create Project');
        this.setDescription('');
        this.setTabs([
          {
            name: "Create Project"
          }
        ]);
        this.setButtons([
          {
            name: 'Cancel',
            "class": 'close'
          }, {
            name: 'Next',
            "class": 'btn primary'
          }
        ]);
        return _.defer(function() {
          return _this.formLoadedSuccessfully(_this.formTemplate(_this));
        });
      };

      CreateWorkspaceModal.prototype.formTemplate = _.template($('#create-workspace-form').html());

      CreateWorkspaceModal.prototype.someInputChanged = function(e) {
        if (event.keyCode === 13) {
          e.preventDefault();
          return this.submitButtonClicked(e);
        } else {
          return CreateWorkspaceModal.__super__.someInputChanged.call(this, e);
        }
      };

      CreateWorkspaceModal.prototype.submitButtonClicked = function(e) {
        var formData,
          _this = this;
        e.preventDefault();
        this.resetErrors();
        helpers.showLoadingDialog();
        formData = $('form', this.$modal).serialize();
        return $.ajax({
          url: WORKSPACE_CREATE_URL,
          type: 'POST',
          dataType: 'json',
          data: _.extend(formData, {
            '_method': 'CREATE'
          }),
          success: this.workspaceSaved,
          error: function(e) {
            var data;
            data = $.parseJSON(e.responseText);
            helpers.hideLoadingDialog();
            _this.handleErrors({
              errors: {
                workspace: data.errors
              }
            });
            $('.modal-actions a.btn.primary', _this.$modal).addClass('disabled');
            return $('.modal-actions a.close', _this.$modal).removeClass('ui-disabled');
          }
        });
      };

      CreateWorkspaceModal.prototype.workspaceSaved = function(data) {
        return window.location = data.path;
      };

      CreateWorkspaceModal.prototype.render = function() {
        CreateWorkspaceModal.__super__.render.apply(this, arguments);
        return this.$modal.addClass('create-project-modal');
      };

      return CreateWorkspaceModal;

    })(this.TabbedModalView);
    return this.QuickPhishModal = (function(_super) {

      __extends(QuickPhishModal, _super);

      function QuickPhishModal() {
        this.workspaceSaved = __bind(this.workspaceSaved, this);
        return QuickPhishModal.__super__.constructor.apply(this, arguments);
      }

      QuickPhishModal.prototype.initialize = function() {
        QuickPhishModal.__super__.initialize.apply(this, arguments);
        this.setTitle('Phishing Campaign');
        return this.setDescription('First, create a project to store the phishing campaign. ' + 'Then, click the Next button to launch the phishing campaign ' + 'configuration page.');
      };

      QuickPhishModal.prototype.workspaceSaved = function(data) {
        return window.location = data.path + '/social_engineering/campaigns';
      };

      return QuickPhishModal;

    })(this.CreateWorkspaceModal);
  });

}).call(this);
