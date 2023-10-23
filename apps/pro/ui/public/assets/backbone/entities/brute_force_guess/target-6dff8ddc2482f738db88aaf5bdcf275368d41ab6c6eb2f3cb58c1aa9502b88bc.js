(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['base_model', 'base_collection'], function() {
    return this.Pro.module("Entities.BruteForceGuess", function(BruteForceGuess, App) {
      var API;
      BruteForceGuess.Target = (function(_super) {

        __extends(Target, _super);

        function Target() {
          return Target.__super__.constructor.apply(this, arguments);
        }

        Target.prototype.defaults = {
          SERVICES: ["AFP", "DB2", "FTP", "HTTP", "HTTPS", "MSSQL", "MySQL", "POP3", "Postgres", "SMB", "SNMP", "SSH", "SSH_PUBKEY", "Telnet", "VNC", "WinRM"]
        };

        return Target;

      })(App.Entities.Model);
      API = {
        getTarget: function(opts) {
          return new BruteForceGuess.Target(opts);
        }
      };
      return App.reqres.setHandler("bruteForceGuess:target:entities", function(opts) {
        if (opts == null) {
          opts = {};
        }
        return API.getTarget(opts);
      });
    });
  });

}).call(this);
