require_relative 'metasploit_rpc_client'

# This gets used as a key, so must be a string
task_id = (36).to_s

# Setup stuff from CLI
api_token = ARGV[0]
host      = ARGV[1]

client    = MetasploitRPCClient.new(host:host, token:api_token, ssl:false, port:50505)
client.call "pro.task_pause", task_id
