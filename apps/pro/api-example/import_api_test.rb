#
# Example of data import via the RPC API.
#
# Usage:
#   ruby import_api_test.rb <Service key> <MSPro instance> \
#     '<Project name>' \
#     '<Full path to import file>'
#
# Service key: Generate an API token from Global Settings, requires
#   Pro licensed instance.
# MSPro instance: 127.0.0.1, if running locally
# Project name: name of an existing workspace into which to import
# Import file path: fully qualified path to import file of supported
#   format
#


require_relative 'metasploit_rpc_client'

# CLI arguments
api_token = ARGV[0]
host      = ARGV[1]
workspace_name   = ARGV[2]
import_file_path = ARGV[3]

unless api_token && host && workspace_name
  raise Exception, 'You must specify an API token, an instance address, and a workspace name.'
end
unless import_file_path
  raise Exception, 'You must specify an import file path.'
end

# Make the client
client = MetasploitRPCClient.new(host:host, token:api_token, ssl:false, port:50505)

# Import config
import_hash = {
  workspace: workspace_name,
  # Toggle datastore options (documented, with some exceptions, like
  # this handy one) thusly:
  # DS_AUTOTAG_OS: true,
  # TODO Update with correct path:
  DS_PATH: import_file_path
}

import = client.call('pro.start_import', import_hash)
puts "\nStarted import: \n#{import}"

