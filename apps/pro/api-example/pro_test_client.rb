#
#
#
# Usage:
#   ruby pro_test_client.rb <SERVICE KEY> <MSPro instance> '<WorkspaceName>'
#
# Service key: Generate an API token from Global Settings, requires
# Pro licensed instance.
# MSPro instance: 127.0.0.1 if running locally
#
#

require_relative 'metasploit_rpc_client'

# Setup stuff from CLI
api_token = ARGV[0]
host      = ARGV[1]
workspace_name = ARGV[2]

# Make the client
client    = MetasploitRPCClient.new(host:host, token:api_token, ssl:false, port:50505)


### Examples: Uncomment, update and rerun:

## License
license_info = client.call('pro.license')
puts "#{license_info['product_type']} -- v#{license_info['product_version']}-#{license_info['product_revision']}"
puts "Product Key: #{license_info['product_key']}"
puts "Product SN: #{license_info['product_serial']}"

## Loots
#loots = client.call('pro.loot_list', workspace_name)
#puts "\n\nLoots list: #{loots}\n"
#loot_id = 1
#loot = client.call('pro.loot_download', loot_id)
#puts "\n\nGot some loot: #{loot}"
#File.open('/tmp/lootz', 'w') {|c| c.write loot['data']}
