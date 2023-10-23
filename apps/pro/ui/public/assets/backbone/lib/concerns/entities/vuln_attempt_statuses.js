(function() {

  define([], function() {
    return this.Pro.module("Concerns", function(Concerns, App, Backbone, Marionette, $, _) {
      return Concerns.VulnAttemptStatuses = {
        STATUSES: {
          EXPLOITED: 'Exploited',
          NOT_EXPLOITABLE: 'Not Exploitable'
        },
        isExploited: function() {
          return this.get('status') === this.STATUSES.EXPLOITED || this.get('vuln_attempt_status') === this.STATUSES.EXPLOITED;
        },
        isNotExploitable: function() {
          return this.get('status') === this.STATUSES.NOT_EXPLOITABLE || this.get('vuln_attempt_status') === this.STATUSES.NOT_EXPLOITABLE;
        }
      };
    });
  });

}).call(this);
