#!/usr/bin/env ruby

#
# Run this with the Pro ruby wrapper:
# /opt/metasploit-3.5.1/ruby/bin/ruby /opt/metasploit-3.5.1/apps/pro/engine/simpleclient.rb [cmd] [workspace] [targets]
#

$:.unshift(File.join(File.dirname(__FILE__), "lib"))


#
# Load architecture specific library paths
#
arch = 'unknown'
case RUBY_PLATFORM
when /x86_64-linux/
	arch = "linux64"
when /i[3456]86-linux/
	arch = "linux32"
when /mingw32/
	arch = "win32"
end

Dir["#{File.dirname(__FILE__)}/arch-lib/#{arch}/*/lib"].each do |lib|
	$:.unshift File.expand_path(lib)
end


#
# Load additional search paths within the various gems
#
Dir["#{File.dirname(__FILE__)}/lib/*/lib"].each do |lib|
	$:.unshift File.expand_path(lib)
end

#
# Load the RPC client
#
require 'pro/client'

def usage
	$stderr.puts "[*] Usage #{$0} [PROJECT] [scan|exploit|collect|cleanup] [TARGETS]"
	exit(0)
end

project = ARGV.shift || usage
cmd     = ARGV.shift || usage
targets = ARGV.join(" ")


cnf = {}
pro = Pro::Client.new

users = pro.call('pro.get_users')['users']
r     = pro.call('pro.add_workspace', project)
u     = users.keys.select{|x| users[x]['admin'] }.first

res   = nil
case cmd
when 'scan'
	conf = {
			'workspace' => project,
			'username'  => u,
			'ips'       => targets,
			'DS_BLACKLIST_HOSTS'      => '',
			'DS_CustomNmap'           => '',
			'DS_PORTSCAN_SPEED'       => 'Aggressive',
			'DS_PORTS_EXTRA'          => '',
			'DS_PORTS_BLACKLIST'      => '',
			'DS_PORTS_CUSTOM'         => '',
			'DS_PORTSCAN_TIMEOUT'     => '10',
			'DS_PORTSCAN_SOURCE_PORT' => 0,
			'DS_UDP_PROBES'           => true,
			'DS_FINGER_USERS'         => true,
			'DS_SNMP_SCAN'            => true,
			'DS_IDENTIFY_SERVICES'    => true,
			'DS_SMBUser'              => '',
			'DS_SMBPass'              => '',
			'DS_SMBDomain'            => '',
			'DS_DRY_RUN'              => false,
			'DS_SINGLE_SCAN'          => false,
			'DS_FAST_DETECT'          => false
	}

	res = pro.start_discover(conf)
	
when 'exploit'
when 'collect'
when 'cleanup'
else
	$stderr.puts "[*] Unknown command #{cmd}"
end

