#
# Simple class wrapping Metasploit Pro RPC.
#
# See pro_test_client for example uses.
# See report_rpc_api_example for reporting specific examples.
#

begin
  require 'msgpack'       # provides serialization of Ruby data structures to and from msgpack format
  require 'rest-client'   # super-friendly HTTP access
rescue LoadError => e
  puts "Error loading deps:\n"
  puts e
  puts e.backtrace.join("\n")
end

class MetasploitRPCClient
  CLIENT_ATTRIBUTES = [:host, :port, :uri, :ssl, :token]

  # Make getters for each of the above
  CLIENT_ATTRIBUTES.each do |attr|
    attr_reader attr
  end

  # Default client settings
  DEFAULTS = { 
      host: '127.0.0.1',
      port: 3790,
      uri: 'api/',
      ssl: true,
    }

  # Setup a client, overriding any settings in args
  # "token" is a mandatory key
  def initialize(args)
    @token   = args.fetch(:token)
    defaults = DEFAULTS.dup
    defaults.merge! args

    # Dynamically set the ivars from the keys
    defaults.each do |k,v|
      instance_variable_set("@#{k}",v) if CLIENT_ATTRIBUTES.include? k
    end
  end

  # Prepends the token and RPC method name to the args and makes the HTTP request,
  # handling msgpack encoding/decoding on the fly.
  def call(method, *args)
    args.unshift self.token
    args.unshift method

    scheme          = self.ssl ? "https" : "http"
    url             = "#{scheme}://#{host}:#{port}/#{uri}"
    data            = args.to_msgpack
    ctype           = 'binary/message-pack'

    response        = RestClient.post(url, data, content_type: ctype)

    parsed_response = MessagePack.unpack response.body

    if parsed_response["error"]
      puts "#{parsed_response['error_code']} -- #{parsed_response['error_message']}"
    else
      parsed_response
    end
  end

end
