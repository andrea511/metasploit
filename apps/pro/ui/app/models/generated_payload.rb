require 'json'
require 'state_machines'
require 'carrierwave/orm/activerecord'
require 'cgi'
require 'fileutils'

class GeneratedPayload < ApplicationRecord
  include Metasploit::Pro::AttrAccessor::Boolean

  # "Orphaned" payloads that do not belong to a workspace will be
  # destroyed after this amount of time
  DESTROY_AFTER = 2.hours.freeze

  # Options that should be coerced to an integer in the constructor
  INTEGER_KEYS  = %w(iterations space nops).freeze

  # Options that should be coerced to booleans in the constructor
  BOOLEAN_KEYS  = %w(keep).freeze

  # Raised when #generate! is called in the wrong state
  class InvalidStateException < Exception; end
  class InvalidPayloadClassException < Exception; end

  #
  # Callbacks
  #
  after_destroy :cleanup_files

  #
  # Associations
  #

  # @!attribute [rw] vuln
  #   The (optional) workspace that this GeneratedPayload belongs to
  #   @return [Mdm::Workspace]
  belongs_to :workspace, :class_name => "Mdm::Workspace", optional: true

  #
  # Attributes
  #

  # @!attribute [rw] state
  #   The state of the payload 
  #   @return [String] ready|generating|finished|failed

  # @!attribute [rw] options
  #   A JSON serialized hash of the payload datastore options
  #   @return [Hash] options hash

  # @!attribute [rw] file
  #   The file path to the generated payload file
  #   @return [String] path to the generated payload file
  #   @return nil if the payload has not yet been generated

  # Save options hash as JSON
  serialize :options, JSON

  #
  # Validations
  #

  mount_uploader :file, PayloadUploader
  validates :file, presence: true, if: :finished?
  validates :options, presence: true
  validate  :normalize_payload_debugging
  validate  :rpc_validate

  #
  # State Machine
  #
  state_machine :state, initial: :ready do
    event(:start!)  { transition ready: :generating }
    event(:finish!) { transition generating: :finished }
    event(:fail!)   { transition [:ready, :generating] => :failed }
    event(:reset!)  { transition any => :ready }
  end

  def initialize(attrs={})
    super
    self.options ||= {}
    self.payload_class ||= 'classic_payload'
    self.options[:file_name] = generate_file_name
    self.options.delete_if { |k,v| v.blank? }

    # coerce certain keys to specific types
    INTEGER_KEYS.each { |k| options[k] = options[k].to_i if options[k].present? }
    BOOLEAN_KEYS.each { |k| options[k] = set_default_boolean(options[k], false) }

    # DynamicStagers uses some different keys
    normalize_dynamic_stager_options if dynamic_stager?
  end

  # Kicks off payload generation
  # The state will become :finished when the payload is generated
  # @raise [InvalidStateException] when called in a state besides :ready
  def generate!
    unless ready?
      raise InvalidStateException.new("#generate! can only be called in the :ready state")
    end

    start!

    rpc_client = Pro::Client.get
    if dynamic_stager?
      rpc_client.generate_dynamic_stager(self.id)
    elsif classic_payload?
      rpc_client.generate_classic_payload(self.id)
    else
      raise InvalidPayloadClassException, "Payload class was not recognized"
    end
  end

  # Schedules a delayed_job to destroy thyself in 2 hours
  def schedule_destruction
    destroy
  end
  handle_asynchronously :schedule_destruction, run_at: ->{ DESTROY_AFTER.from_now }

  # Stuff the payload file size into the JSON representation
  def as_json(opts={})
    super.merge(size: file.size)
  end

  # @return [Boolean] payload does not use DynamicStager
  def classic_payload?
    payload_class == 'classic_payload'
  end

  # @return [Boolean] payload uses DynamicStager
  def dynamic_stager?
    payload_class == 'dynamic_stager'
  end

  private

  # @return [Array<String>] of all files "attached" to this payload
  def all_files
    created_files = options['created_files'] || []
    created_files.push(file.to_s) if file.present?
    created_files
  end

  # @return [Array<String>] of all directories "attached" to this payload
  def all_dirs
    if file.to_s.present? then [File.dirname(file.to_s)] else [] end
  end

  # DynamicStagers has a :host, :ssl, and :port option, while the form
  # just passes payload datastore info
  def normalize_dynamic_stager_options
    options['arch'].downcase!
    dstore = options['payload_datastore'] || {}
    options.merge!(
      'host' => dstore['RHOST'] || dstore['LHOST'],
      'port' => dstore['RPORT'] || dstore['LPORT'],
      'ssl'  => options['payload'] =~ /ssl/i
    )
  end

  # Destroys all files needed to create this payload
  def cleanup_files
    # clean up leftover files, then their parent dirs
    all_files.each do |file|
      File.unlink(file) if File.exist?(file)
    end

    all_dirs.each do |dir|
      FileUtils.rm_rf(dir) if File.directory?(dir)
    end
  end

  #
  # Custom validations
  #

  # Asks prosvc if the payload + datastore options are valid
  def rpc_validate
    unless options.has_key?('payload') and options['payload'].present?
      errors.add(:payload, 'must be specified')
    else
      ret = Pro::Client.get.validate_classic_payload(options)
      if ret['result'] == 'failure'
        # ahem.
        flattened_hash = flatten_hash({ payload: { options: ret['errors'] }})
        flattened_hash.each do |key, val|
          errors.add(key, val)
        end
      end
    end
  end

  # If MeterpreterDebugBuild is not set persisting `MeterpreterDebugLogging` value should be suppressed
  # An error is set when a logging value is provided and debugging is not requested.
  def normalize_payload_debugging
    if options.has_key?('payload_datastore') and options['payload_datastore'].present?
      payload_datastore = options['payload_datastore']

      # if 'MeterpreterDebugLogging' is empty delete it
      if payload_datastore.has_key?('MeterpreterDebugLogging') && payload_datastore['MeterpreterDebugLogging'].empty?
        payload_datastore.delete('MeterpreterDebugLogging')
      end

      # if NOT requesting a debug build error on any provided 'MeterpreterDebugLogging' value
      unless payload_datastore['MeterpreterDebugBuild']
        if payload_datastore.has_key?('MeterpreterDebugLogging')
          errors.add('MeterpreterDebugLogging', 'Logging can only be set for debug build')
        end
      end
    end
  end

  # Helper method to convert a nested hash: {a:{b:{c:1}}}
  # into the HTML form style: {'a[b][c]':1}
  # @param [Hash] errors
  def flatten_hash(errors)
    errors.to_param.split('&').each_with_object({}) do |str, obj|
      key, val = str.split('=').map { |str| CGI::unescape(str) }
      obj[key] = val
    end
  end

  def generate_file_name
    arch = (self.options['arch'] || "").downcase
    arch = "-#{arch}" if arch.present?
    format = case self.options['format']
      when 'psh'
        'ps1'
      when 'psh-cmd'
        'cmd'
      when 'psh-net'
        'ps1'
      when 'psh-reflection'
        'ps1'
      else
        (self.options['format'] || 'exe').downcase
    end
    "payload#{arch}.#{format}"
  end
end
