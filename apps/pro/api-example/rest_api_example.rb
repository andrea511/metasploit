#
# Trivial example of using the REST-based API
#
#

begin
  require 'json'         # provides serialization of Ruby data structures to and from JSON format
  require 'rest-client'  # super-friendly HTTP access
rescue LoadError
  puts "please install deps:\n"
  puts "gem install json"
  puts "gem install rest-client"
end

class MetasploitRestClient
  attr_reader :token

  def initialize(opts)
    @token  = opts.fetch(:token)
  end
  
  def get(url, headers={}, params={})
    RestClient.get(url, headers.merge({token:token}))
  end
end


token     = ARGV[0]
client    = MetasploitRestClient.new(token:token)

# NB: in production, host/port/scheme should be "https//<HOST>:3790"
url = "http://localhost:3000/rest_api/v1/social_engineering/campaigns.json"

campaigns = JSON.parse client.get(url)
p campaigns



