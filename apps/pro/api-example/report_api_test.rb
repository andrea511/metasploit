# Examples of report listing, download, and generation via
# RPC API.
#
# Usage:
#   ruby report_api_test.rb <SERVICE KEY> <MSPro instance> '<WorkspaceName>'
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


## Reports
# List report types
type_list = client.call('pro.list_report_types')
puts "Allowed Report types: \n#{type_list}"

# List current reports
#report_list = client.call('pro.report_list', workspace_name)
#puts "\n\nExisting Reports: #{report_list}\n"

# Download report artifact
#report_artifact_id = 1
#artifact = client.call('pro.report_artifact_download', report_artifact_id)
#tmp_path = "/tmp/report_#{report_artifact_id}#{File.extname(artifact['file_path'])}"
#File.open(tmp_path, 'w') {|c| c.write artifact['data']}
#puts "Wrote report artifact #{report_artifact_id} to #{tmp_path}"

# Create a report
#report_hash = {workspace: workspace_name,
#               name: "SuperTest_#{Time.now.to_i}",
#               report_type: :audit,
#               #se_campaign_id: 1,
#               created_by: 'whoareyou',
#               file_formats: [:pdf]
#}
#report_creation = client.call('pro.start_report', report_hash)
#puts "\n\nCreated report: \n#{report_creation}"

## Download report and child artifacts
#report_id = 1
#report = client.call('pro.report_download', report_id)
#report['report_artifacts'].each_with_index do |a, i|
#  tmp_path = "/tmp/report_test_#{i}_#{Time.now.to_i}#{File.extname(a['file_path'])}"
#  File.open(tmp_path, 'w') {|c| c.write a['data']}
#  puts "Wrote report artifact #{report_id} to #{tmp_path}"
#end
