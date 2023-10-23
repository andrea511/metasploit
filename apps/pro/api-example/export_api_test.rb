# Examples of export listing, download, and generation via
# RPC API.
#
# Usage:
#   ruby export_api_test.rb <SERVICE KEY> <MSPro instance> '<WorkspaceName>'
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


### Exports
## List current exports
export_list = client.call('pro.export_list', workspace_name)
puts "Existing Exports: #{export_list}"

## Create export
# export_types = ['zip_workspace','xml','replay_scripts','pwdump']
# export_config = {created_by: 'whoareyou',
#                 export_type: export_types[0],
#                 workspace: workspace_name}
# export_creation = client.call('pro.start_export', export_config)
# puts "Created export: #{export_creation}"

## Download export
# export_id = 1
# export = client.call('pro.export_download', export_id)
# tmp_path = "/tmp/export_test_#{export_id}#{File.extname(export['file_path'])}"
# File.open(tmp_path, 'w') {|c| c.write export['data']}
# puts "Wrote export #{export_id} to #{tmp_path}"