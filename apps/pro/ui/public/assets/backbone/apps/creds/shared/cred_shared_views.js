(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_view', 'base_itemview', 'base_layout', 'apps/creds/shared/templates/clone_cell', 'apps/creds/shared/templates/private_cell', 'apps/creds/shared/templates/private_cell_disclosure_dialog', 'apps/creds/shared/templates/origin_cell', 'apps/creds/shared/templates/origin_cell_disclosure_dialog', 'entities/origin'], function() {
    return this.Pro.module('CredsApp.Shared', function(Shared, App, Backbone, Marionette, $, _) {
      var _this = this;
      Shared.CoresTableCloneCell = (function(_super) {

        __extends(CoresTableCloneCell, _super);

        function CoresTableCloneCell() {
          return CoresTableCloneCell.__super__.constructor.apply(this, arguments);
        }

        CoresTableCloneCell.prototype.template = JST['backbone/apps/creds/shared/templates/clone_cell'];

        CoresTableCloneCell.prototype.ui = {
          cloneButton: 'a.clone'
        };

        CoresTableCloneCell.prototype.events = {
          'click @ui.cloneButton': 'showCloneForm'
        };

        CoresTableCloneCell.prototype.initialize = function(opts) {
          this.credsCollection = opts.collection;
          return CoresTableCloneCell.__super__.initialize.call(this, opts);
        };

        CoresTableCloneCell.prototype.showCloneForm = function() {
          var $row;
          $row = $("<tr id='clone-form-" + this.model.id + "'></tr>");
          this.$el.closest('tr').before($row);
          return App.vent.trigger('clone:cred:clicked', this.model, this.credsCollection, $row);
        };

        return CoresTableCloneCell;

      })(App.Views.ItemView);
      Shared.CoresTablePublicCell = (function(_super) {

        __extends(CoresTablePublicCell, _super);

        function CoresTablePublicCell() {
          this.template = __bind(this.template, this);
          return CoresTablePublicCell.__super__.constructor.apply(this, arguments);
        }

        CoresTablePublicCell.prototype.events = {
          'click': "credClicked"
        };

        CoresTablePublicCell.prototype.initialize = function(opts) {
          this.opts = opts;
          return _.defaults(this.opts, {
            disableCredLinks: false
          });
        };

        CoresTablePublicCell.prototype.template = function() {
          var username;
          username = this.model.get('public.username');
          username = username != null ? username : '*BLANK*';
          if (this.opts.disableCredLinks) {
            return _.escape(username);
          } else {
            return "<a href='/workspaces/" + (_.escape(this.model.get('workspace_id'))) + "/credentials#creds/" + (_.escape(this.model.id)) + "'>" + (_.escape(username)) + "</a>";
          }
        };

        return CoresTablePublicCell;

      })(App.Views.ItemView);
      Shared.CoresTablePrivateCell = (function(_super) {

        __extends(CoresTablePrivateCell, _super);

        function CoresTablePrivateCell() {
          this.serializeData = __bind(this.serializeData, this);
          return CoresTablePrivateCell.__super__.constructor.apply(this, arguments);
        }

        CoresTablePrivateCell.prototype.template = JST['backbone/apps/creds/shared/templates/private_cell'];

        CoresTablePrivateCell.prototype.ui = {
          privateDisclosureLink: 'a.private-data-disclosure',
          filterEventLink: 'a.filter.event'
        };

        CoresTablePrivateCell.prototype.events = {
          'click @ui.privateDisclosureLink': 'showPrivateDataDialog',
          'click @ui.filterEventLink': 'navigateToIndexWithFilter'
        };

        CoresTablePrivateCell.prototype.initialize = function(opts) {
          return this.displayFilterLink = this.model.isSSHKey() ? false : !!opts.displayFilterLink;
        };

        CoresTablePrivateCell.prototype.showPrivateDataDialog = function() {
          var dialogView;
          dialogView = new Shared.CoresTablePrivateCellDisclosureDialog({
            model: this.model
          });
          return App.execute('showModal', dialogView, {
            modal: {
              title: 'Private Data',
              description: '',
              width: 600,
              height: 400
            },
            buttons: [
              {
                name: 'Close',
                "class": 'close'
              }
            ]
          });
        };

        CoresTablePrivateCell.prototype.navigateToIndexWithFilter = function(search) {
          if (this.model.isSSHKey()) {
            return;
          }
          return App.request('navigate:creds:index', {
            search: "private.data:'" + (this.model.get('private.data')) + "'"
          });
        };

        CoresTablePrivateCell.prototype.displayFilterEventLink = function() {
          return this.displayFilterLink && this.model.get('private.data') && !this.model.isSSHKey() && this.model.get('private.data').length > 50;
        };

        CoresTablePrivateCell.prototype.serializeData = function() {
          return _.extend(this.model.attributes, {
            truncated: this.model.isTruncated(),
            displayFilterLink: this.displayFilterLink,
            displayFilterEventLink: this.displayFilterEventLink()
          });
        };

        return CoresTablePrivateCell;

      })(App.Views.ItemView);
      Shared.CoresTablePrivateCellDisclosureDialog = (function(_super) {

        __extends(CoresTablePrivateCellDisclosureDialog, _super);

        function CoresTablePrivateCellDisclosureDialog() {
          return CoresTablePrivateCellDisclosureDialog.__super__.constructor.apply(this, arguments);
        }

        CoresTablePrivateCellDisclosureDialog.prototype.template = JST['backbone/apps/creds/shared/templates/private_cell_disclosure_dialog'];

        CoresTablePrivateCellDisclosureDialog.prototype.ui = {
          content: '.private-data'
        };

        CoresTablePrivateCellDisclosureDialog.prototype.onShow = function() {
          return this.selectText(this.ui.content[0]);
        };

        return CoresTablePrivateCellDisclosureDialog;

      })(App.Views.ItemView);
      Shared.CoresTableOriginCell = (function(_super) {

        __extends(CoresTableOriginCell, _super);

        function CoresTableOriginCell() {
          return CoresTableOriginCell.__super__.constructor.apply(this, arguments);
        }

        CoresTableOriginCell.prototype.template = JST['backbone/apps/creds/shared/templates/origin_cell'];

        CoresTableOriginCell.prototype.ui = {
          originDisclosureLink: 'a.origin-disclosure'
        };

        CoresTableOriginCell.prototype.events = {
          'click @ui.originDisclosureLink': 'showOriginDataDialog'
        };

        CoresTableOriginCell.prototype.showOriginDataDialog = function() {
          var dialogView;
          dialogView = new Shared.CoresTableOriginCellDisclosureDialog({
            model: this.model
          });
          return App.execute('showModal', dialogView, {
            modal: {
              title: 'Origin',
              description: '',
              width: 600,
              height: 200
            },
            buttons: [
              {
                name: 'Close',
                "class": 'close'
              }
            ]
          });
        };

        return CoresTableOriginCell;

      })(App.Views.ItemView);
      Shared.CoresTableOriginCellDisclosureDialog = (function(_super) {

        __extends(CoresTableOriginCellDisclosureDialog, _super);

        function CoresTableOriginCellDisclosureDialog() {
          return CoresTableOriginCellDisclosureDialog.__super__.constructor.apply(this, arguments);
        }

        CoresTableOriginCellDisclosureDialog.prototype.template = JST['backbone/apps/creds/shared/templates/origin_cell_disclosure_dialog'];

        CoresTableOriginCellDisclosureDialog.prototype.ui = {
          modalContent: '.origin-disclosure-modal'
        };

        CoresTableOriginCellDisclosureDialog.prototype.onShow = function() {
          var origin,
            _this = this;
          origin = App.request("origin:entity", this.model.id, this.model.get('origin_url'));
          return origin.fetch({
            success: function(model) {
              return _this.ui.modalContent.html(model.get('pretty_origin'));
            }
          });
        };

        return CoresTableOriginCellDisclosureDialog;

      })(App.Views.ItemView);
      App.reqres.setHandler('creds:shared:coresTableCloneCell', function(opts, config) {
        if (opts == null) {
          opts = {};
        }
        if (config == null) {
          config = {};
        }
        if (config.instantiate != null) {
          return new Shared.CoresTableCloneCell(opts);
        } else {
          return Shared.CoresTableCloneCell;
        }
      });
      App.reqres.setHandler('creds:shared:coresTablePrivateCell', function(opts, config) {
        if (opts == null) {
          opts = {};
        }
        if (config == null) {
          config = {};
        }
        if (config.instantiate != null) {
          return new Shared.CoresTablePrivateCell(opts);
        } else {
          return Shared.CoresTablePrivateCell;
        }
      });
      App.reqres.setHandler('creds:shared:coresTablePrivateCellDisclosureDialog', function(opts, config) {
        if (opts == null) {
          opts = {};
        }
        if (config == null) {
          config = {};
        }
        if (config.instantiate != null) {
          return new Shared.CoresTablePrivateCellDisclosureDialog(opts);
        } else {
          return Shared.CoresTablePrivateCellDisclosureDialog;
        }
      });
      App.reqres.setHandler('creds:shared:coresTableOriginCell', function(opts, config) {
        if (opts == null) {
          opts = {};
        }
        if (config == null) {
          config = {};
        }
        if (config.instantiate != null) {
          return new Shared.CoresTableOriginCell(opts);
        } else {
          return Shared.CoresTableOriginCell;
        }
      });
      App.reqres.setHandler('creds:shared:coresTablePublicCell', function(opts, config) {
        if (opts == null) {
          opts = {};
        }
        if (config == null) {
          config = {};
        }
        if (config.instantiate != null) {
          return new Shared.CoresTablePublicCell(opts);
        } else {
          return Shared.CoresTablePublicCell;
        }
      });
      return App.reqres.setHandler('creds:shared:coresTableOriginCellDisclosureDialog', function(opts, config) {
        if (opts == null) {
          opts = {};
        }
        if (config == null) {
          config = {};
        }
        if (config.instantiate != null) {
          return new Shared.CoresTableOriginCellDisclosureDialog(opts);
        } else {
          return Shared.CoresTableOriginCellDisclosureDialog;
        }
      });
    });
  });

}).call(this);
