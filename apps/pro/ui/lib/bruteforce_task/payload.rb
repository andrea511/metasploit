module BruteforceTask::Payload
  extend ActiveSupport::Concern

  include ActiveModel::Validations
  include Metasploit::Pro::AttrAccessor::Boolean

  #
  # CONSTANTS
  #

  CONNECTIONS = ['Auto', 'Reverse', 'Bind']
  DEFAULT_CONNECTION = 'Auto'
  DEFAULT_PAYLOAD_TYPE = 'Meterpreter'
  DEFAULT_PAYLOAD_PORTS = '1024-65535'
  PAYLOAD_TYPES = ['Meterpreter', 'Meterpreter 64-bit', 'Command shell', 'Powershell']

  included do
    #
    # Boolean Attributes
    #

    boolean_attr_accessor :dynamic_stager, :default => true
    boolean_attr_accessor :stage_encoding, :default => false
    #
    # Validations
    #

    validates :connection, :inclusion => { :in => CONNECTIONS }
    validates :macro_name, :allow_blank => true, :macro_name => true
    validates :payload_lhost, :allow_nil => true, :ip_range => true
    validates :payload_ports, :portspec => true
    validates :payload_type, :inclusion => { :in => PAYLOAD_TYPES }
  end

  #
  # Instance Methods
  #

  def connection
    @connection ||= DEFAULT_CONNECTION
  end

  def connection=(connection)
    @connection = connection || DEFAULT_CONNECTION
  end

  def macro_name
    @macro_name ||= ''
  end

  def macro_name=(macro_name)
    @macro_name = macro_name || ''
  end

  attr_reader :payload_lhost

  def payload_lhost=(payload_lhost)
    payload_lhost = payload_lhost.to_s

    if payload_lhost.blank?
      @payload_lhost = nil
    else
      @payload_lhost = payload_lhost
    end
  end

  def payload_ports
    @payload_ports ||= DEFAULT_PAYLOAD_PORTS
  end

  def payload_ports=(payload_ports)
    @payload_ports = payload_ports || DEFAULT_PAYLOAD_PORTS
  end

  def payload_type
    @payload_type ||= DEFAULT_PAYLOAD_TYPE
  end

  def payload_type=(payload_type)
    @payload_type = payload_type || DEFAULT_PAYLOAD_TYPE
  end
end