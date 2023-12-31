(function() {

  (function(Backbone) {
    var methods, _sync;
    _sync = Backbone.sync;
    Backbone.sync = function(method, entity, options) {
      var sync;
      if (options == null) {
        options = {};
      }
      _.defaults(options, {
        beforeSend: _.bind(methods.beforeSend, entity),
        complete: _.bind(methods.complete, entity)
      });
      sync = _sync(method, entity, options);
      if (!entity._fetch && method === "read") {
        entity._fetch = sync;
      }
      return sync;
    };
    return methods = {
      beforeSend: function() {
        return this.trigger("sync:start", this);
      },
      complete: function() {
        return this.trigger("sync:stop", this);
      }
    };
  })(Backbone);

}).call(this);
