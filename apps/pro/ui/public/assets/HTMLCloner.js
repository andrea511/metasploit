(function() {

  jQuery(function($) {
    return $(function() {
      var HTMLCloner;
      return window.HTMLCloner = HTMLCloner = (function() {

        function HTMLCloner(args) {
          this.origin = args['origin'];
          this.success = args['success'];
          this.error = args['error'];
          this.redirects = [];
        }

        HTMLCloner.prototype.fixURL = function(url) {
          if (url.match(/https:\/\//)) {
            return url;
          }
          if (!url.match(/\w+:\/\//)) {
            return 'http://' + url;
          }
          return url;
        };

        HTMLCloner.prototype.cloneURL = function(args) {
          args[0]['value'] = this.fixURL(args[0]['value']);
          return $.ajax({
            type: 'POST',
            url: this.origin,
            data: $.param(args),
            dataType: 'json',
            success: this.success,
            error: this.error
          });
        };

        return HTMLCloner;

      })();
    });
  });

}).call(this);
