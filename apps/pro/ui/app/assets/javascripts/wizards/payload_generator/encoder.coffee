#
# Describes a single instance of an Encoder, with its own
# fullname and options. It can be linked to a Payload via
# matching architecture.
#

class @Encoder

  # Attributes
  fullname: ''
  refname: ''
  options: {}
  arch: []
  platform: []
  license: ''

  # @param [Object] opts initial attribute values
  constructor: (opts) ->
    DatastoreMixin.mixin(@) # add the Datastore mixin to get #filteredOptions
    _.extend(@, opts)
    # remove any initial "Msf::Module::Platform" on the platform
    @platform = _.map @platform, (plat) -> _.last(plat.split('::'))
    @refname = @fullname.replace(/^encoder\//, '')

  # @return [Object] a copy of this instance's key/values
  toJSON: ->
    _.extend({}, @)

