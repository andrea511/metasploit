(function() {
  var DATASTORE_DEFAULT_OVERRIDES, DEFAULT_SKIPPED_DATASTORE_OPTIONS;

  DEFAULT_SKIPPED_DATASTORE_OPTIONS = ['WORKSPACE', 'VERBOSE'];

  DATASTORE_DEFAULT_OVERRIDES = {
    LHOST: '0.0.0.0'
  };

  this.DatastoreMixin = {
    mixin: function(instance) {
      return _.extend(instance, _.omit(DatastoreMixin, 'mixin'));
    },
    skippedDatastoreOptions: DEFAULT_SKIPPED_DATASTORE_OPTIONS,
    showAdvancedOptions: false,
    filteredOptions: function(clause) {
      var opts;
      _.each(this.options, function(v, k) {
        return v.name = k;
      });
      opts = _.chain(this.options).omit(this.skippedDatastoreOptions);
      if (clause != null) {
        opts = opts.where(clause);
      }
      return opts.value();
    }
  };

}).call(this);
