(function() {

  window.Helpers = {
    truncate: function(string, limit) {
      if (string.length > limit) {
        return string.substring(0, limit).replace(/[\s+]$/g, '') + '...';
      } else {
        return string;
      }
    }
  };

}).call(this);
