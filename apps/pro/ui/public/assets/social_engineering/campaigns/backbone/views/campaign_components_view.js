(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  jQueryInWindow(function($) {
    return this.CampaignComponentsView = (function(_super) {

      __extends(CampaignComponentsView, _super);

      function CampaignComponentsView() {
        return CampaignComponentsView.__super__.constructor.apply(this, arguments);
      }

      CampaignComponentsView.prototype.initialize = function(opts) {
        this.editing = false;
        this.campaignSummary = opts['campaignSummary'];
        this.currComponentType = 'email';
        _.bindAll(this, 'render', 'implicitlyCreateCampaign', 'toggleTray', 'renderComponentInModal');
        return this.campaignSummary.bind('change:campaign_components change:config_type', this.render);
      };

      CampaignComponentsView.prototype.template = _.template($('#campaign-components').html());

      CampaignComponentsView.prototype.baseURL = function() {
        return "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + this.campaignSummary.id;
      };

      CampaignComponentsView.prototype.implicitlyCreateCampaign = function(e) {
        var data;
        if (this.campaignSummary.id === null) {
          e.stopImmediatePropagation();
          e.stopPropagation();
          e.preventDefault();
          data = $('form.social_engineering_campaign', this.el).serialize();
          return $(document).trigger('createCampaign', {
            data: data,
            callback: function() {
              return $(e.target).click();
            }
          });
        }
      };

      CampaignComponentsView.prototype.openModalWindow = function(url, cb) {
        var formViewClass, opts,
          _this = this;
        if (cb == null) {
          cb = function() {};
        }
        formViewClass = this.currComponentType === 'portable_file' ? FormView : PaginatedFormView;
        opts = {
          campaignSummary: this.campaignSummary,
          formQuery: this.editFormQuery,
          confirm: 'Are you sure you want to close? Your unsaved changes will be lost.',
          save: function() {
            var $form;
            $form = $('form', _this.modal.el);
            Placeholders.submitHandler($form[0]);
            $('textarea.to-code-mirror', $form).trigger('loadFromEditor');
            $form.trigger('syncWysiwyg');
            return $.ajax({
              url: $form.attr('action'),
              type: $form.attr('method'),
              data: $form.serialize(),
              success: function(data) {
                _this.campaignSummary.set(data);
                _this.render();
                return _this.modal.close({
                  confirm: false
                });
              },
              error: function(response) {
                var $errs, $page, pageIdx;
                $('.content-frame>.content', _this.modal.el).html(response.responseText);
                $errs = $('p.inline-errors', _this.modal.el);
                $page = $errs.first().parents('.page>div.cell').first();
                pageIdx = $page.index();
                _this.renderComponentInModal();
                return _this.modal.onLoad();
              }
            });
          }
        };
        if (this.currComponentType === 'portable_file') {
          this.modal = new FormView(opts);
        } else if (this.currComponentType === 'email') {
          this.modal = new EmailFormView(opts);
        } else if (this.currComponentType === 'web_page') {
          this.modal = new WebPageFormView(opts);
        }
        return this.modal.load(url, cb);
      };

      CampaignComponentsView.prototype.renderComponentInModal = function() {
        if (this.currComponentType === 'web_page') {
          window.renderCodeMirror();
          window.renderWebPageEdit();
          return window.renderAttributeDropdown();
        } else if (this.currComponentType === 'portable_file') {
          return window.renderPortableFileEdit();
        }
      };

      CampaignComponentsView.prototype.setCurrComponentType = function(currComponentType) {
        this.currComponentType = currComponentType;
      };

      CampaignComponentsView.prototype.setEditFormQuery = function(editFormQuery) {
        this.editFormQuery = editFormQuery;
      };

      CampaignComponentsView.prototype.calculateEditFormQuery = function(name) {
        var query;
        if (!this.campaignSummary.usesWizard()) {
          return '';
        }
        query = '?hide_name=true';
        if (name) {
          query += "&init_name=" + name;
        }
        if (this.currComponentType === 'web_page' && name === encodeURIComponent('Landing Page')) {
          query += '&attack_type=phishing&disable_attack_type=true';
          query += '&show_only_custom_redirect_page=true';
        }
        return query;
      };

      CampaignComponentsView.prototype.getComponentPath = function(target) {
        var $a, $li, id, name, query;
        $li = $(target).parents('ul.add-nav li');
        if (!$li.size()) {
          $li = $(target);
        }
        $a = $('a', $li);
        id = $a.attr('component-id');
        name = encodeURIComponent($('p', $li).text());
        query = this.calculateEditFormQuery(name);
        this.setEditFormQuery(query);
        if (id && id.length > 0) {
          return "" + id + "/edit" + query;
        } else {
          return "new" + query;
        }
      };

      CampaignComponentsView.prototype.addEmailButtonClicked = function(e) {
        var path;
        e.preventDefault();
        if (this.editing) {
          return;
        }
        this.setCurrComponentType('email');
        path = this.getComponentPath(e.target);
        return this.openModalWindow("" + (this.baseURL()) + "/emails/" + path, this.renderComponentInModal);
      };

      CampaignComponentsView.prototype.addWebPageButtonClicked = function(e) {
        var path;
        e.preventDefault();
        if (this.editing) {
          return;
        }
        this.setCurrComponentType('web_page');
        path = this.getComponentPath(e.target);
        return this.openModalWindow("" + (this.baseURL()) + "/web_pages/" + path, this.renderComponentInModal);
      };

      CampaignComponentsView.prototype.addPortableKeyButtonClicked = function(e) {
        var path;
        e.preventDefault();
        if (this.editing) {
          return;
        }
        this.setCurrComponentType('portable_file');
        path = this.getComponentPath(e.target);
        return this.openModalWindow("" + (this.baseURL()) + "/portable_files/" + path, this.renderComponentInModal);
      };

      CampaignComponentsView.prototype.resetShadowArrowPosition = function() {
        var pos;
        pos = $('.inline-add', this.el).position();
        return $('.shadow-arrow', this.el).css({
          left: "" + (pos.left + 53) + "px"
        });
      };

      CampaignComponentsView.prototype.toggleTray = function(e) {
        e.preventDefault();
        $('.shadow-arrow', this.el).toggle();
        this.resetShadowArrowPosition();
        return $('.component-buttons', this.el).animate({
          height: 'toggle'
        }, 200);
      };

      CampaignComponentsView.prototype.events = {
        'click .component-buttons ul.add-nav li.component a': 'implicitlyCreateCampaign',
        'click .campaign-components ul.add-nav li a': 'implicitlyCreateCampaign',
        'click li .add-portable_file': 'addPortableKeyButtonClicked',
        'click li .add-email': 'addEmailButtonClicked',
        'click li .add-web_page': 'addWebPageButtonClicked',
        'click .toggle-component-edit-mode': 'toggleComponentEditMode',
        'click a.add-component': 'toggleTray',
        'click div.delete': 'deleteComponent'
      };

      CampaignComponentsView.prototype.findOrCreateComponentByName = function(name, type) {
        if (type == null) {
          type = '';
        }
        return _.find(this.campaignComponents, function(comp) {
          return comp.name === name;
        }) || {
          name: name,
          id: null,
          type: type,
          classText: 'unconfigured'
        };
      };

      CampaignComponentsView.prototype.deleteComponent = function(e) {
        var component, id, type, url,
          _this = this;
        id = $(e.target).parents('li.component').find('a').attr('component-id');
        if (!(id && id.length > 0)) {
          return;
        }
        id = parseInt(id);
        component = _.find(this.campaignSummary.get('campaign_components'), (function(comp) {
          return comp.id === id;
        }));
        if (!component) {
          return;
        }
        if (!confirm("Are you sure you want to delete this " + (_.str.humanize(component.type)) + "?")) {
          return;
        }
        type = component.type;
        type = type === 'portable_file' ? 'portable_file' : type;
        url = "" + (this.baseURL()) + "/" + type + "s/" + id;
        return $.ajax({
          url: url,
          type: 'POST',
          data: {
            '_method': 'DELETE'
          },
          success: function() {
            var newComponents, originalComponents;
            originalComponents = _this.campaignSummary.get('campaign_components');
            newComponents = _.without(originalComponents, component);
            if (newComponents.length === 0) {
              _this.editing = false;
            }
            return _this.campaignSummary.set({
              'campaign_components': newComponents
            });
          },
          error: function() {
            var newComponents, originalComponents;
            originalComponents = _this.campaignSummary.get('campaign_components');
            newComponents = _.without(originalComponents, component);
            if (newComponents.length === 0) {
              _this.editing = false;
            }
            return _this.campaignSummary.set({
              'campaign_components': newComponents
            });
          }
        });
      };

      CampaignComponentsView.prototype.setEditing = function(editing) {
        this.editing = editing;
        $('.campaign-components a.toggle-component-edit-mode', this.el).toggleClass('active', this.editing);
        $('.campaign-components .add-nav', this.el).toggleClass('editing', this.editing);
        $('.campaign-components .inline-add', this.el).toggleClass('editing', this.editing);
        if (this.editing) {
          return $('.campaign-components .component-buttons, .shadow-arrow', this.el).hide();
        }
      };

      CampaignComponentsView.prototype.toggleComponentEditMode = function() {
        this.setEditing(!this.editing);
        return false;
      };

      CampaignComponentsView.prototype.pollForPortableFilesIfNecessary = function() {
        var components, pFiles, url,
          _this = this;
        components = this.campaignSummary.get('campaign_components');
        if (this.portableFilePoller) {
          this.portableFilePoller.stop();
        }
        this.portableFilePoller = null;
        pFiles = _.filter(components, function(c) {
          return c.type === 'portable_file' && !c.download;
        });
        url = "/workspaces/" + WORKSPACE_ID + "/social_engineering/campaigns/" + this.campaignSummary.id + ".json";
        if (!(pFiles.length > 0)) {
          return;
        }
        this.portableFilePoller = new SingleModelPoller(this.campaignSummary, url, 2000, function() {
          if (_this.portableFilePoller && CampaignTabView.activeView.index !== 0) {
            _this.portableFilePoller.stop();
            return _this.portableFilePoller = null;
          }
        });
        return this.portableFilePoller.start();
      };

      CampaignComponentsView.prototype.render = function() {
        var $next, component1, component2, component3, pdo;
        this.campaignComponents = this.campaignSummary.get('campaign_components');
        this.wrapperClass = '';
        if (this.campaignSummary.get('config_type') === 'wizard') {
          component1 = this.findOrCreateComponentByName('Landing Page', 'web_page');
          pdo = component1['phishing_redirect_origin'];
          if (pdo && pdo === 'phishing_wizard_redirect_page') {
            component2 = this.findOrCreateComponentByName('Redirect Page', 'web_page');
          }
          component3 = this.findOrCreateComponentByName('E-mail', 'email');
          this.wizardComponents = [component3];
          this.wizardComponents.push(component1);
          if (component2) {
            this.wizardComponents.push(component2);
          }
          this.wrapperClass = 'wizard';
        }
        if (this.dom) {
          $next = this.dom.next().first();
        }
        if (this.dom) {
          this.dom.remove();
        }
        if ($next && $next.size()) {
          this.dom = $($.parseHTML(this.template(this))[1]);
          this.dom.insertBefore($next);
        } else {
          this.dom = $($.parseHTML(this.template(this))[1]);
          this.dom.appendTo($(this.el));
        }
        this.setEditing(this.editing);
        return this.pollForPortableFilesIfNecessary();
      };

      return CampaignComponentsView;

    })(Backbone.View);
  });

}).call(this);
