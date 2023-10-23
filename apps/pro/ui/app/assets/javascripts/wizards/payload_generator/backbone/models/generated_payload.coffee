#
# The GeneratedPayload backbone model contains the payload information
# and datastore options needed to generate a msf payload
#
# See: msf3/lib/msf/core/payload_generator.rb
#
# Dependencies: Payload, PayloadCache

$ = jQuery

class @GeneratedPayload extends Backbone.Model
  defaults:

    # Attributes that are persisted to db in generated_payload.rb#options
    platform:        'Windows'
    arch:            'x86'
    datastore:       {}
    encoder:         'x86/shikata_ga_nai'
    iterations:      1
    space:           null
    format:         'exe'
    keep:            false
    template:        null
    nops:            null
    badchars:        null
    payload:         'windows/meterpreter/reverse_tcp'
    encoder_options: {}
    payload_options: {}

    # Attributes used only by the UI
    outputType:     'exe' # raw|exe|buffer
    useStager:      true
    useEncoder:     true
    stager:         'reverse_tcp'
    stage:          'windows/meterpreter'
    single:         null

  initialize: =>
    @on('change', @onChange)    

  # Updates and caches the derived field "options.payload", which
  # contains the refname of the payload
  onChange: =>
    newPayload = @findModule(cache: false)
    if @get('useStager') == 'true'
      @set(useStager: true)
    else if @get('useStager') == 'false'
      @set(useStager: false)
    if newPayload? and @get('payload') != newPayload.refname
      @set('payload', newPayload.refname)

  # Looks in the PayloadCache and finds the module that matches
  #   this payload.
  # @option [Boolean] cache (false) enable/disable caching of module lookup
  # @return [Payload] payload module
  findModule: (opts={}) =>
    opts.cache = true unless opts?.cache?
    return @_payload if @_payload? and opts.cache
    payload = _.find PayloadCache.payloads(@attributes), (p) =>
      if @get('useStager')
        stagerMatch = _.str.endsWith(p.refname, @get('stager'))
        stageMatch  = _.str.include(p.fullname, @get('stage'))
        p.stager and stagerMatch and stageMatch
      else
        p.single and p.refname == @get('single')
    @_payload = payload unless opts.cache
    payload

  # Looks in the PayloadCache and finds the encoder module (if any
  #  has been selected) that matches this payload
  # @option [Boolean] cache (false) enable/disable caching of module lookup
  # @return [Encoder] applicable encoder
  # @return [null] no encoder selected
  findEncoder: (opts={}) =>
    opts.cache = true unless opts?.cache?
    return null unless @get('useEncoder')
    return @_encoder if @_encoder? and opts.cache
    encoder = _.find PayloadCache.encoders(@attributes), (p) =>
      p.refname == @get('encoder')
    @_encoder = encoder unless opts.cache
    encoder

  # @return [Boolean] outputType is exe
  isOutputExe: => @get('outputType') == 'exe'

  # return [Boolean] outputType is source code
  isOutputBuffer: => @get('outputType') == 'buffer'

  # return [Boolean] outputType is raw
  isOutputRaw: => @get('outputType') == 'raw'
