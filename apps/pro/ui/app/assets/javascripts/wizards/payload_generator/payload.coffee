#
# Describes a single instance of a Payload, with its own
#   fullname, name, rank, etc.
#
# This class is not a Backbone model for a couple reasons:
#  - It contains static data
#  - There is a fixed set of Payloads
#  - You will typically never render a Payload in the UI,
#    but will usually need to query the set for different options
#

class @Payload

  # Attributes
  fullname: ''
  refname:  ''
  type: 'payload'
  name: ''
  rank: 0
  description: ''
  license: ''
  filepath: ''
  arch: []
  platform: []
  references: []
  authors: []
  privileged: false
  stager: false
  single: false
  options: {}

  # @param [Object] opts initial attribute values
  constructor: (opts) ->
    DatastoreMixin.mixin(@) # add the Datastore mixin to get #filteredOptions
    _.extend(@, opts)
    # remove any initial "Msf::Module::Platform" on the platform
    @platform = _.map @platform, (plat) -> _.last(plat.split('::'))
    @refname = @fullname.replace(/^payload\//, '')
    @stager = @_isStager()
    @single = @_isSingle()
    @stageName = @fullname.split('/').slice(1,-1).join('/') if @stager

  # @return [Object] a copy of this instance's key/values
  toJSON: => _.extend({}, @)

  _isStager: =>
    @filepath.indexOf('/modules/payloads/stagers/') > -1

  _isSingle: =>
    @filepath.indexOf('/modules/payloads/singles/') > -1
