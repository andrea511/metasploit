#
# NOTE: Workspace and Project are the same thing.
#
require_relative 'metasploit_rpc_client'

workspace_attrs = {
  name: "FooCorp Pentest",
  limit_to_network: true,
  boundary: "10.2.3.1-10.2.3.24",
  description: "A test of FooCorp's mission-critical internal Quake LAN."
}

# Setup stuff from CLI
api_token = ARGV[0]
host      = ARGV[1]

# Make the client - set ssl to true in install environments
client    = MetasploitRPCClient.new(host:host, token:api_token, ssl:false, port:50505)
client.call "pro.workspace_add", workspace_attrs

