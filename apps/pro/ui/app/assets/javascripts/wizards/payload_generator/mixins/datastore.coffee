#
# The Datastore mixin is used by Payload and Encoder to access
# and filter datastore options. It adds a #filteredOptions method,
# along with #skippedDatastoreOptions and #showAdvancedOptions attrs.
#

# these datastore options are excluded from the Payload
DEFAULT_SKIPPED_DATASTORE_OPTIONS = [
  'WORKSPACE',
  'VERBOSE'
]

DATASTORE_DEFAULT_OVERRIDES = {
  LHOST: '0.0.0.0'
}

@DatastoreMixin =

  # This method is called by #constructor of the class we are mixing into
  mixin: (instance) ->
    _.extend instance, _.omit(DatastoreMixin, 'mixin')

  #
  # Instance properties
  #

  # @return [Array] of datastore keys to omit
  skippedDatastoreOptions: DEFAULT_SKIPPED_DATASTORE_OPTIONS

  # @return [Boolean] show advanced options
  showAdvancedOptions: false

  # @param [Hash] clause a hash of key=>value to match (e.g. {advanced:true})
  # @return [Array] the applicable datastore options
  filteredOptions: (clause) ->
    _.each @options, (v,k) -> v.name = k # save the name in the option
    opts = _.chain(@options)
      .omit(@skippedDatastoreOptions)
    opts = opts.where(clause) if clause?
    opts.value()

