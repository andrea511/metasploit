(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_layout', 'base_view', 'base_itemview', 'apps/imports/index/templates/index_layout', 'apps/imports/index/templates/type_selection_layout', 'apps/imports/index/type'], function() {
    return this.Pro.module('ImportsApp.Index', function(Index, App, Backbone, Marionette, $, _) {
      Index.Layout = (function(_super) {

        __extends(Layout, _super);

        function Layout() {
          return Layout.__super__.constructor.apply(this, arguments);
        }

        Layout.prototype.template = Layout.prototype.templatePath('imports/index/index_layout');

        Layout.prototype.className = 'foundation';

        Layout.prototype.ui = {
          importBtn: '.import-btn',
          tagsLabel: '.tags-label',
          tagsPane: '.tags-pane',
          expandArrow: 'span.expand',
          collapseArrow: 'span.collapse',
          autoTagOs: '[name="imports[autotag_os]"]',
          preserveHosts: '#update_hosts'
        };

        Layout.prototype.events = {
          'click @ui.tagsLabel': '_toggleTags'
        };

        Layout.prototype.modelEvents = {
          'change:showAutoTagByOS': '_updateAutoTagOS',
          'change:showDontChangeExistingHosts': '_updateDontChangeExistingHosts'
        };

        Layout.prototype.triggers = {
          'click @ui.importBtn': 'import:start'
        };

        Layout.prototype.regions = {
          importTypeSelectRegion: '.import-type-select-region',
          mainImportViewRegion: '.main-import-view-region',
          tagsRegion: '.tags-region'
        };

        Layout.prototype._updateAutoTagOS = function(model, visible) {
          if (visible) {
            return this.ui.autoTagOs.parent().show();
          } else {
            return this.ui.autoTagOs.parent().hide();
          }
        };

        Layout.prototype._updateDontChangeExistingHosts = function(model, visible) {
          if (visible) {
            return this.ui.preserveHosts.parent().show();
          } else {
            return this.ui.preserveHosts.parent().hide();
          }
        };

        Layout.prototype._toggleTags = function() {
          this.ui.expandArrow.toggle();
          this.ui.collapseArrow.toggle();
          return this.ui.tagsPane.slideToggle('fast');
        };

        Layout.prototype.enableImportButton = function() {
          return this.ui.importBtn.removeClass('disabled');
        };

        Layout.prototype.disableImportButton = function() {
          return this.ui.importBtn.addClass('disabled');
        };

        Layout.prototype.expandTagSection = function() {
          this.ui.expandArrow.hide();
          this.ui.collapseArrow.show();
          return this.ui.tagsPane.show();
        };

        return Layout;

      })(App.Views.Layout);
      return Index.TypeSelectionView = (function(_super) {

        __extends(TypeSelectionView, _super);

        function TypeSelectionView() {
          this._importTypeChanged = __bind(this._importTypeChanged, this);
          return TypeSelectionView.__super__.constructor.apply(this, arguments);
        }

        TypeSelectionView.prototype.template = TypeSelectionView.prototype.templatePath('imports/index/type_selection_layout');

        TypeSelectionView.prototype.ui = {
          nexposeRadioButton: '#import-from-nexpose',
          fileRadioButton: '#import-from-file',
          sonarRadioButton: '#import-from-sonar',
          importType: '[name="imports[type]"]',
          selectedImportType: '[name="imports[type]"]:checked'
        };

        TypeSelectionView.prototype.events = {
          'change @ui.importType': '_importTypeChanged'
        };

        TypeSelectionView.prototype.onRender = function() {
          return this._setRadioButton();
        };

        TypeSelectionView.prototype._importTypeChanged = function(e) {
          var currentSelection;
          this._bindUIElements();
          currentSelection = e.currentTarget.value;
          switch (currentSelection) {
            case this.ui.fileRadioButton.val():
              this.model.set('type', Index.Type.File);
              break;
            case this.ui.nexposeRadioButton.val():
              this.model.set('type', Index.Type.Nexpose);
              break;
            case this.ui.sonarRadioButton.val():
              this.model.set('type', Index.Type.Sonar);
              break;
            default:
              throw "Invalid import selection [" + currentSelection + "]";
          }
          return this.trigger('import:typeChange', this.model);
        };

        TypeSelectionView.prototype._getFileRadioButtonVal = function() {
          return this.ui.fileRadioButton.val();
        };

        TypeSelectionView.prototype._setRadioButton = function() {
          var type;
          this._clearRadioButtons();
          type = this.model.get('type');
          switch (type) {
            case Index.Type.File:
              return this._selectFileRadioButton();
            case Index.Type.Nexpose:
              return this._selectNexposeRadioButton();
            case Index.Type.Sonar:
              return this._selectSonarRadioButton();
            default:
              throw "Error setting radio button [" + type + "]";
          }
        };

        TypeSelectionView.prototype._clearRadioButtons = function() {
          return this.ui.importType.prop('checked', false);
        };

        TypeSelectionView.prototype._selectFileRadioButton = function() {
          return this.ui.fileRadioButton.prop('checked', true);
        };

        TypeSelectionView.prototype._selectNexposeRadioButton = function() {
          return this.ui.nexposeRadioButton.prop('checked', true);
        };

        TypeSelectionView.prototype._selectSonarRadioButton = function() {
          return this.ui.sonarRadioButton.prop('checked', true);
        };

        return TypeSelectionView;

      })(App.Views.ItemView);
    });
  });

}).call(this);
