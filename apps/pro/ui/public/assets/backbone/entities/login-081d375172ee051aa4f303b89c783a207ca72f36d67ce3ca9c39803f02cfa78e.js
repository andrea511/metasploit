(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'base_model', 'base_collection'], function($) {
    return this.Pro.module("Entities", function(Entities, App) {
      var API;
      Entities.Login = (function(_super) {

        __extends(Login, _super);

        function Login() {
          this._workspaceId = __bind(this._workspaceId, this);

          this._validateAuthenticationURL = __bind(this._validateAuthenticationURL, this);

          this._rootURL = __bind(this._rootURL, this);

          this.sessions = __bind(this.sessions, this);

          this.attemptSession = __bind(this.attemptSession, this);

          this.validateAuthentication = __bind(this.validateAuthentication, this);

          this.url = __bind(this.url, this);
          return Login.__super__.constructor.apply(this, arguments);
        }

        Login.Status = {
          "DENIED_ACCESS": "Denied Access",
          "DISABLED": "Disabled",
          "INCORRECT": "Incorrect",
          "ALL": ["Denied Access", "Disabled", "Incorrect", "Invalid Public Part", "Locked Out", "No Auth Required", "Successful", "Unable to Connect", "Untried"],
          "INVALID_PUBLIC_PART": "Invalid Public Part",
          "LOCKED_OUT": "Locked Out",
          "NO_AUTH_REQUIRED": "No Auth Required",
          "SUCCESSFUL": "Successful",
          "UNABLE_TO_CONNECT": "Unable to Connect",
          "UNTRIED": "Untried"
        };

        Login.Types = {
          Nil: 'none',
          SSHKey: 'ssh',
          PasswordHash: 'hash',
          NTLMHash: 'ntlm',
          Password: 'plaintext'
        };

        Login.prototype.defaults = {
          workspace_id: null,
          core_id: null,
          tags: [],
          attempting_login: false,
          authentication_task: null,
          taggingModalHelpContent: "<p>\n  A tag is an identifier that you can use to group together logins.\n  You apply tags so that you can easily search for logins.\n  For example, when you search for a particular tag, any login that\n  is labelled with that tag will appear in your search results.\n</p>\n<p>\n  To apply a tag, start typing the name of the tag you want to use in the\n  Tag field. As you type in the search box, Metasploit automatically predicts\n  the tags that may be similar to the ones you are searching for. If the tag\n  does not exist, Metasploit creates and adds it to the project.\n</p>"
        };

        Login.prototype.url = function(opts) {
          var _ref;
          if (opts == null) {
            opts = {};
          }
          if ((_ref = opts.extension) == null) {
            opts.extension = '.json';
          }
          if (this.id != null) {
            return "" + (this._rootURL()) + "/" + this.id + opts.extension;
          } else {
            return "" + (this._rootURL()) + opts.extension;
          }
        };

        Login.prototype.validateAuthentication = function() {
          var deferred,
            _this = this;
          deferred = $.Deferred();
          $.ajax({
            method: 'post',
            url: this._validateAuthenticationURL()
          }).done(function(response) {
            if (response.task_id != null) {
              return initProRequire(['entities/task'], function() {
                var task;
                task = new App.Entities.Task({
                  workspace_id: _this._workspaceId(),
                  id: response.task_id
                });
                return deferred.resolve(task);
              });
            }
          });
          return deferred;
        };

        Login.prototype.attemptSession = function(payloadModel) {
          var deferred,
            _this = this;
          deferred = $.Deferred();
          $.ajax({
            method: 'post',
            url: Routes.attempt_session_workspace_metasploit_credential_login_path(this._workspaceId(), this.get('id')) + ".json",
            data: payloadModel.toJSON()
          }).done(function(response) {
            if (response.task_id != null) {
              return initProRequire(['entities/task'], function() {
                var task;
                task = new App.Entities.Task({
                  workspace_id: _this._workspaceId(),
                  id: response.task_id
                });
                return deferred.resolve(task);
              });
            }
          });
          return deferred;
        };

        Login.prototype.sessions = function() {
          return $.ajax({
            method: 'get',
            url: Routes.get_session_workspace_metasploit_credential_login_path(WORKSPACE_ID, this.get('id')) + '.json'
          });
        };

        Login.prototype._rootURL = function() {
          return "/workspaces/" + (this._workspaceId()) + "/metasploit/credential/logins";
        };

        Login.prototype._validateAuthenticationURL = function() {
          return "" + (this._rootURL()) + "/" + this.id + "/validate_authentication.json";
        };

        Login.prototype._workspaceId = function() {
          return this.get('service.host.workspace_id') || window.WORKSPACE_ID;
        };

        Login.prototype.fetchTags = function(successCallback) {
          return this.fetch({
            success: successCallback,
            url: "/workspaces/" + (this.get('workspace_id')) + "/metasploit/credential/cores/" + (this.get('core_id')) + "/logins/" + this.id + "/tags.json"
          });
        };

        Login.prototype.removeTag = function(opts) {
          var success, tagId;
          if (opts == null) {
            opts = {};
          }
          tagId = opts.tagId, success = opts.success;
          return this.save({
            tagId: tagId
          }, {
            success: success,
            url: "/workspaces/" + (this.get('workspace_id')) + "/metasploit/credential/cores/" + (this.get('core_id')) + "/logins/" + this.id + "/remove_tag.json"
          });
        };

        Login.prototype.isTruncated = function() {
          var _ref, _ref1;
          return ((_ref = this.get('core.private.data')) != null ? _ref.length : void 0) > ((_ref1 = this.get('core.private.data_truncated')) != null ? _ref1.length : void 0);
        };

        Login.prototype.isSSHKey = function() {
          return this.get('core.private.type') === this.constructor.Types.SSHKey;
        };

        return Login;

      })(App.Entities.Model);
      Entities.LoginsCollection = (function(_super) {

        __extends(LoginsCollection, _super);

        function LoginsCollection() {
          return LoginsCollection.__super__.constructor.apply(this, arguments);
        }

        LoginsCollection.prototype.initialize = function(models, _arg) {
          this.core_id = _arg.core_id, this.workspace_id = _arg.workspace_id;
          return this.url = "/workspaces/" + this.workspace_id + "/metasploit/credential/cores/" + this.core_id + "/logins";
        };

        LoginsCollection.prototype.rebind = function() {
          return this.on('change:access_level', this.recalculateAccessLevels, this);
        };

        LoginsCollection.prototype.model = Entities.Login;

        LoginsCollection.prototype.recalculateAccessLevels = function() {
          var oldLevels;
          oldLevels = this.accessLevels;
          this.accessLevels = _(this.models).map(function(m) {
            return m.get('access_level');
          }).uniq().reject(function(m) {
            return _.contains(['admin', 'read only'], m != null ? typeof m.toLowerCase === "function" ? m.toLowerCase() : void 0 : void 0);
          }).sort();
          if (!_.isEmpty(_.difference(this.accessLevels, oldLevels))) {
            this.trigger('levelsChanged', this.accessLevels);
          }
          return this.accessLevels;
        };

        return LoginsCollection;

      })(App.Entities.Collection);
      Entities.HostAccessingLoginsCollection = (function(_super) {

        __extends(HostAccessingLoginsCollection, _super);

        function HostAccessingLoginsCollection() {
          this.url = __bind(this.url, this);
          return HostAccessingLoginsCollection.__super__.constructor.apply(this, arguments);
        }

        HostAccessingLoginsCollection.prototype.initialize = function(models, opts) {
          if (opts == null) {
            opts = {};
          }
          return this.host_id = opts.host_id || HOST_ID;
        };

        HostAccessingLoginsCollection.prototype.url = function() {
          return "/hosts/" + this.host_id + "/metasploit/credential/logins/accessing.json";
        };

        return HostAccessingLoginsCollection;

      })(Entities.LoginsCollection);
      API = {
        getLogins: function(opts) {
          if (opts == null) {
            opts = {};
          }
          return new Entities.LoginsCollection([], opts);
        },
        getAccessingLoginsForHost: function(host_id) {
          return new Entities.HostAccessingLoginsCollection([], {
            host_id: host_id
          });
        },
        getLogin: function(id) {
          return new Entities.Login({
            id: id
          });
        },
        newLogin: function(attributes) {
          if (attributes == null) {
            attributes = {};
          }
          return new Entities.Login(attributes);
        }
      };
      App.reqres.setHandler("logins:entities", function(opts) {
        var definedOpts, optionNames;
        if (opts == null) {
          opts = {};
        }
        optionNames = ['provide_access_to_host', 'workspace_id'];
        definedOpts = _.reject(optionNames, function(name) {
          return _.isUndefined(opts[name]);
        });
        if (definedOpts.length > 1) {
          throw new Entities.EntityCollection.ScopingError("Only one of the following arguments may be set: " + JSON.stringify(definedOpts));
        }
        if (opts.provide_access_to_host != null) {
          return API.getAccessingLoginsForHost(opts.provide_access_to_host);
        } else {
          return API.getLogins(opts);
        }
      });
      App.reqres.setHandler("logins:entity", function(id) {
        return API.getLogin(id);
      });
      return App.reqres.setHandler("new:login:entity", function(attributes) {
        return API.newLogin(attributes);
      });
    });
  });

}).call(this);
