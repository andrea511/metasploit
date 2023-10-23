(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['base_model', 'base_collection', 'lib/concerns/entities/fetch_ids'], function() {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Cred = (function(_super) {

        __extends(Cred, _super);

        function Cred() {
          return Cred.__super__.constructor.apply(this, arguments);
        }

        Cred.Realms = {
          "ORACLE_SYSTEM_IDENTIFIER": "Oracle System Identifier",
          "WILDCARD": "*",
          "ALL": ["Active Directory Domain", "DB2 Database", "Oracle System Identifier", "PostgreSQL Database", "RSYNC Module", "*"],
          "DB2_DATABASE": "DB2 Database",
          "ACTIVE_DIRECTORY_DOMAIN": "Active Directory Domain",
          "POSTGRESQL_DATABASE": "PostgreSQL Database",
          "RSYNC_MODULE": "RSYNC Module",
          "SHORT_NAMES": {
            "domain": "Active Directory Domain",
            "db2db": "DB2 Database",
            "sid": "Oracle System Identifier",
            "pgdb": "PostgreSQL Database",
            "rsync": "RSYNC Module",
            "wildcard": "*"
          }
        };

        Cred.Origins = {
          ALL: ["Cracked password", "Import", "Manual", "Service", "Session"]
        };

        Cred.Types = {
          Nil: 'none',
          SSHKey: 'ssh',
          PasswordHash: 'hash',
          NTLMHash: 'ntlm',
          Password: 'plaintext'
        };

        Cred.prototype.defaults = {
          workspace_id: WORKSPACE_ID,
          realm: {
            key: "None"
          },
          "public": {
            username: ''
          },
          "private": {
            type: 'none'
          },
          "import": {
            password_type: "plaintext",
            type: 'csv'
          },
          tags: [],
          taggingModalHelpContent: "<p>\n  A tag is an identifier that you can use to group together credentials.\n  You apply tags so that you can easily search for credentials.\n  For example, when you search for a particular tag, any login that\n  is labelled with that tag will appear in your search results.\n</p>\n<p>\n  To apply a tag, start typing the name of the tag you want to use in the\n  Tag field. As you type in the search box, Metasploit automatically predicts\n  the tags that may be similar to the ones you are searching for. If the tag\n  does not exist, Metasploit creates and adds it to the project.\n</p>"
        };

        Cred.prototype.url = function() {
          if (this.id != null) {
            return "/workspaces/" + (this.get('workspace_id')) + "/metasploit/credential/cores/" + this.id + ".json";
          } else {
            return "/workspaces/" + (this.get('workspace_id')) + "/metasploit/credential/cores.json";
          }
        };

        Cred.prototype.tagUrl = function() {
          return "/workspaces/" + (this.get('workspace_id')) + "/metasploit/credential/cores/quick_multi_tag.json";
        };

        Cred.prototype.isTruncated = function() {
          var _ref, _ref1;
          return ((_ref = this.get('private.data')) != null ? _ref.length : void 0) > ((_ref1 = this.get('private.data_truncated')) != null ? _ref1.length : void 0);
        };

        Cred.prototype.isSSHKey = function() {
          return this.get('private.type') === this.constructor.Types.SSHKey;
        };

        Cred.prototype.clone = function() {
          return new Entities.Cred({
            "public": {
              username: this.get('public.username')
            },
            "private": {
              data: this.get('private.data'),
              type: this.get('private.type')
            },
            realm: {
              key: this.get('realm.key'),
              value: this.get('realm.value')
            }
          });
        };

        Cred.prototype.fetchTags = function(successCallback) {
          return this.fetch({
            success: successCallback,
            url: "/workspaces/" + (this.get('workspace_id')) + "/metasploit/credential/cores/" + this.id + "/tags.json"
          });
        };

        Cred.prototype.removeTag = function(opts) {
          var success, tagId;
          if (opts == null) {
            opts = {};
          }
          tagId = opts.tagId, success = opts.success;
          return this.save({
            tagId: tagId
          }, {
            success: success,
            url: "/workspaces/" + (this.get('workspace_id')) + "/metasploit/credential/cores/" + this.id + "/remove_tag.json"
          });
        };

        Cred.prototype.parse = function(response) {
          if (response["private"]) {
            response['private.data'] = response["private"].data;
            response['private.data_truncated'] = response["private"].data_truncated;
            response['private.type'] = response["private"].type;
            response['private.full_fingerprint'] = response["private"].full_fingerprint;
          }
          return response;
        };

        return Cred;

      })(App.Entities.Model);
      Entities.CredsCollection = (function(_super) {
        var ScopingError;

        __extends(CredsCollection, _super);

        function CredsCollection() {
          this.url = __bind(this.url, this);
          return CredsCollection.__super__.constructor.apply(this, arguments);
        }

        (ScopingError = (function() {

          function ScopingError() {}

          return ScopingError;

        })()) < Error;

        CredsCollection.include('FetchIDs');

        CredsCollection.prototype.model = Entities.Cred;

        CredsCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          return _.defaults(this, {
            workspace_id: WORKSPACE_ID
          });
        };

        CredsCollection.prototype.url = function() {
          return "/workspaces/" + this.workspace_id + "/metasploit/credential/cores.json";
        };

        return CredsCollection;

      })(App.Entities.Collection);
      Entities.CredsGroup = (function(_super) {

        __extends(CredsGroup, _super);

        function CredsGroup() {
          return CredsGroup.__super__.constructor.apply(this, arguments);
        }

        return CredsGroup;

      })(App.Entities.Model);
      Entities.HostOriginatingCredsCollection = (function(_super) {

        __extends(HostOriginatingCredsCollection, _super);

        function HostOriginatingCredsCollection() {
          this.url = __bind(this.url, this);
          return HostOriginatingCredsCollection.__super__.constructor.apply(this, arguments);
        }

        HostOriginatingCredsCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          return this.host_id = opts.host_id || HOST_ID;
        };

        HostOriginatingCredsCollection.prototype.url = function() {
          return "/hosts/" + this.host_id + "/metasploit/credential/cores/originating.json";
        };

        return HostOriginatingCredsCollection;

      })(Entities.CredsCollection);
      API = {
        getCreds: function(workspace_id) {
          var creds;
          creds = new Entities.CredsCollection([], {
            workspace_id: workspace_id
          });
          return creds;
        },
        getOriginatingCredsForHost: function(host_id) {
          var creds;
          creds = new Entities.HostOriginatingCredsCollection([], {
            host_id: host_id
          });
          return creds;
        },
        getCred: function(id) {
          var cred;
          cred = new Entities.Cred({
            id: id
          });
          cred.fetch();
          return cred;
        },
        newCred: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Cred(attributes);
        }
      };
      App.reqres.setHandler("creds:entities", function(opts) {
        var definedOpts, optionNames, wid;
        if (opts == null) {
          opts = {};
        }
        optionNames = ['provide_access_to_host', 'originating_from_host', 'workspace_id'];
        definedOpts = _.reject(optionNames, function(name) {
          return _.isUndefined(opts[name]);
        });
        if (definedOpts.length > 1) {
          throw new Entities.CredsCollection.ScopingError("Only one of the following arguments may be set: " + JSON.stringify(definedOpts));
        }
        if (opts.originating_from_host != null) {
          return API.getOriginatingCredsForHost(opts.originating_from_host);
        } else {
          wid = opts.workspace_id ? opts.workspace_id : WORKSPACE_ID;
          return API.getCreds(wid);
        }
      });
      App.reqres.setHandler("cred:entity", function(id) {
        return API.getCred(id);
      });
      return App.reqres.setHandler("new:cred:entity", function(attributes) {
        if (attributes == null) {
          attributes = {};
        }
        return API.newCred(attributes);
      });
    });
  });

}).call(this);
