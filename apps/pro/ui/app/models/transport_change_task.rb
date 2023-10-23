require 'rex/post/meterpreter/client_core'
class TransportChangeTask < TaskConfig

  #@return [String] The path to an optional SSL cert to use for HTTPS
  attr_accessor :cert
  #@return [Integer] The Connection Timeout in seconds
  attr_accessor :comm_timeout
  #@return [String] The address of the LHOST to establish transport with
  attr_accessor :lhost
  #@return [Integer] The LPORT to establish transport over
  attr_accessor :lport
  #@return [String] The address of the host to use as a proxy
  attr_accessor :proxy_host
  #@return [String] The password to authenticate to the proxy with
  attr_accessor :proxy_pass
  #@return [Integer] The port to connect to for the proxy
  attr_accessor :proxy_port
  #@return [String] The type of proxy
  attr_accessor :proxy_type
  #@return [String] The username to authenticate to the proxy with
  attr_accessor :proxy_user
  #@return [Integer] The number of times to retry to establish the connection
  attr_accessor :retry_total
  #@return [Integer] The number of seconds to wait between retries
  attr_accessor :retry_wait
  #@return [Integer] the Session Expiration Timeout in seconds
  attr_accessor :session_exp
  #@return [Integer] The Local ID of the Msf::Session to change transport on
  attr_accessor :session_id
  #@return [String] The transport type to use (e.g. reverse_tcp, bind_tcp, reverse_http etc)
  attr_accessor :transport
  #@return [String] The User-Agent String to use for HTTP(S) transport
  attr_accessor :ua

  def initialize(attrs)
    super(attrs)

    @cert           = attrs[:cert]
    @comm_timeout   = attrs[:comm_timeout]
    @lhost          = attrs[:lhost]
    @lport          = attrs[:lport]
    @proxy_host     = attrs[:proxy_host]
    @proxy_pass     = attrs[:proxy_pass]
    @proxy_port     = attrs[:proxy_port]
    @proxy_type     = attrs[:proxy_type]
    @proxy_user     = attrs[:proxy_user]
    @retry_total    = attrs[:retry_total]
    @retry_wait     = attrs[:retry_wait]
    @session_exp    = attrs[:session_exp]
    @session_id     = attrs[:session_id]
    @transport      = attrs[:transport] || 'reverse_tcp'
    @ua             = attrs[:ua]

  end

  # Returns a hash representing all of the configuration options
  #
  # @return [Hash] The options hash for the TransportChange RPC call
  def config_to_hash
    conf = {
      cert: cert,
      comm_timeout: comm_timeout,
      lhost: lhost,
      lport: lport,
      proxy_host: proxy_host,
      proxy_pass: proxy_pass,
      proxy_port: proxy_port,
      proxy_type: proxy_type,
      proxy_user: proxy_user,
      retry_total: retry_total,
      retry_wait: retry_wait,
      session_exp: session_exp,
      transport: transport,
      ua: ua
    }
    conf.reject{ |key,value| value.blank? }
  end

  # Responsible for making the actual RPC call.
  # It passes in the session_id and the output from #config_to_hash
  # @return [Boolean] Whether the task was successful
  def rpc_call
    if valid?
      client.meterpreter_transport_change(session_id,config_to_hash)
    end
  end

  # Determines if the transport is a valid transport type for Meterpreter
  #
  # @param transport [String] The transport type to check
  # @return [Boolean] Whether the transport is valid
  def valid_transport?(transport)
    if transport.present?
      Rex::Post::Meterpreter::ClientCore::VALID_TRANSPORTS.include?(transport.downcase)
    else
      false
    end
  end

  def valid?
    unless valid_transport?(transport)
      @error = "You must select a valid Transport"
      return false
    end
    if transport.start_with? 'reverse' and lhost.blank?
      @error = "A reverse transport must have an LHOST set"
      return false
    end
    unless session_id.present?
      @error = "Invalid Session ID"
      return false
    end
    true
  end


end
