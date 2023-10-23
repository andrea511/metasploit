#!/usr/bin/env ruby

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__))))
require 'tool_dependency'


host = ARGV.shift || "127.0.0.1"
port = ARGV.shift || 3790
uri  = ARGV.shift || "/api"
ssl  = ((ARGV.shift || "true") =~ /^[1|y|T]/i) ? true : false


path = ::File.expand_path(::File.join(::File.dirname(__FILE__), "..", "tmp", "servicekey.txt"))
token = nil

if ::File.exist?(path)
	::File.open(path, "rb") do |fd|
		token = fd.read(fd.stat.size)
	end
end

rpc = Msf::RPC::Client.new(
	:host => host,
	:port => port,
	:uri  => uri,
	:ssl  => ssl
)

$stdout.puts "[*] Local token value is '#{token}'" if token
$stdout.puts "[*] RPC client is variable 'rpc'"
$stdout.puts "[*] Starting IRB shell..."
Rex::Ui::Text::IrbShell.new(binding).run

