(function() {

  define([], function() {
    return this.Pro.module("Concerns", function(Concerns) {
      var DEFAULT_TIMEOUT;
      DEFAULT_TIMEOUT = 5000;
      return Concerns.Pollable = {
        polling: false,
        startPolling: function() {
          var clearId, errorMsg, pollForever,
            _this = this;
          if (this.polling) {
            return;
          }
          this.polling = true;
          errorMsg = 'Concerns.Pollable: Client class must have a poll() method that returns a $.Deferred object';
          if (this.poll == null) {
            throw new Error(errorMsg);
          }
          clearId = null;
          this.stopPolling = function() {
            _this.polling = false;
            clearTimeout(clearId);
            return _this.stopPolling = function() {};
          };
          pollForever = function() {
            var deferred;
            if (!_this.polling) {
              return;
            }
            deferred = _this.poll();
            if ((deferred != null ? deferred.then : void 0) == null) {
              return;
            }
            if (deferred.then == null) {
              throw new Error(errorMsg);
            }
            return deferred.then(function() {
              return clearId = setTimeout(pollForever, _this.pollInterval || DEFAULT_TIMEOUT);
            });
          };
          return pollForever();
        },
        stopPolling: function() {}
      };
    });
  });

}).call(this);
