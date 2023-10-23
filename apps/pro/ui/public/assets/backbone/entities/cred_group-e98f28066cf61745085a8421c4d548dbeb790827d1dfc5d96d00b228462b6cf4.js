(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_model', 'base_collection'], function($) {
    return this.Pro.module('Entities', function(Entities, App) {
      Entities.CredGroup = (function(_super) {

        __extends(CredGroup, _super);

        function CredGroup() {
          this.groupURL = __bind(this.groupURL, this);

          this.coresURL = __bind(this.coresURL, this);

          this.url = __bind(this.url, this);

          this.loadCredIDs = __bind(this.loadCredIDs, this);

          this.initialize = __bind(this.initialize, this);
          return CredGroup.__super__.constructor.apply(this, arguments);
        }

        CredGroup.STATES = ['new', 'loading', 'loaded'];

        CredGroup.prototype.defaults = {
          name: '',
          id: null,
          creds: null,
          cred_ids: null,
          workspace_id: null,
          working: false,
          expanded: false,
          state: 'new'
        };

        CredGroup.prototype.initialize = function(opts) {
          if (opts == null) {
            opts = {};
          }
          return this.set('creds', new App.Entities.CredsCollection([]));
        };

        CredGroup.prototype.loadCredIDs = function() {
          var _this = this;
          this.set({
            state: 'loading'
          });
          return $.getJSON(this.coresURL()).done(function(ids) {
            _this.set({
              state: 'loaded',
              cred_ids: ids
            });
            return _this.trigger('creds:loaded', {
              ids: ids
            });
          }).error(function() {
            return _.delay(_this.loadCredIDs, 3000);
          });
        };

        CredGroup.prototype.url = function() {
          return "" + (this.groupURL()) + ".json";
        };

        CredGroup.prototype.coresURL = function() {
          return "/workspaces/" + (this.get('workspace_id')) + "/metasploit/credential/cores.json?ids_only=1&group_id=" + this.id;
        };

        CredGroup.prototype.groupURL = function() {
          return "/workspaces/" + (this.get('workspace_id')) + "/brute_force/reuse/groups/" + this.id;
        };

        return CredGroup;

      })(App.Entities.Model);
      return Entities.CredGroupsCollection = (function(_super) {

        __extends(CredGroupsCollection, _super);

        function CredGroupsCollection() {
          this.url = __bind(this.url, this);
          return CredGroupsCollection.__super__.constructor.apply(this, arguments);
        }

        CredGroupsCollection.prototype.model = Entities.CredGroup;

        CredGroupsCollection.prototype.workspace_id = null;

        CredGroupsCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          return this.workspace_id = opts.workspace_id;
        };

        CredGroupsCollection.prototype.add = function(model, opts) {
          if (opts == null) {
            opts = {};
          }
          if (!this.hasId(model.id)) {
            return CredGroupsCollection.__super__.add.apply(this, arguments);
          }
        };

        CredGroupsCollection.prototype.hasId = function(id) {
          id = Math.floor(id);
          return _.any(this.models, function(m) {
            return id === m.id;
          });
        };

        CredGroupsCollection.prototype.url = function() {
          return "/workspaces/" + this.workspace_id + "/brute_force/reuse/groups.json";
        };

        return CredGroupsCollection;

      })(App.Entities.Collection);
    });
  });

}).call(this);
