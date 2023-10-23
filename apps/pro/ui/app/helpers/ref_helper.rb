module RefHelper

	def link_for_ref(type,ref)
		vulnref = lookup_url(type,ref)
		url = vulnref[0]
		desc = vulnref[1]
		short_desc = vulnref[2]

		return h(desc) unless url.present?
			link_to(
				h(short_desc),
				h(url),
				:title => h(desc),
				:target => "_new",
			)
	end

	def url_for_ref(type, ref)
		ref = Msf::Module::SiteReference.new(type, ref)
		url = ref.site

		unless url.include?('://')
			url = case type
				when 'EDB'        then 'https://www.exploit-db.com/exploits/' + ref
				when 'CWE'        then 'https://cwe.mitre.org/data/definitions/' + ref + '.html'
				when 'ZDI'        then 'https://www.zerodayinitiative.com/advisories/ZDI-' + ref
				when 'WPVDB'      then 'https://wpscan.com/vulnerability/' + ref
				when 'PACKETSTORM'then 'https://packetstormsecurity.com/files/' + ref
				when 'CVE'        then 'https://cvedetails.com/cve/CVE-' + ref
				when 'BID'        then 'https://www.securityfocus.com/bid/' + ref
				when 'MSB'        then 'https://www.microsoft.com/technet/security/bulletin/' + ref + '.mspx'
				when 'MIL'        then 'https://milw0rm.com/metasploit/' + ref
				when 'WVE'        then 'https://www.wirelessve.org/entries/show/WVE-' + ref
				when 'US'         then 'https://www.kb.cert.org/vuls/id/' + ref.to_s.split("-", 3).last
				when 'BPS'        then 'https://strikecenter.bpointsys.com/bps/advisory/BPS-' + ref
				when 'NEXPOSE'    then 'https://www.rapid7.com/vulndb/lookup/' + ref
				when 'SECUNIA'    then 'https://secunia.com/advisories/' + ref
				when 'NSS'        then 'https://www.nessus.org/plugins/index.php?view=single&id=' + ref
				when 'URL'        then ref
				when 'GENERIC'    then '#'
				else
					''
				end
		end
		url
	end

	def lookup_url(type,ref)
		url = url_for_ref(type, ref)

		desc = case type
			when 'NEXPOSE'
				'Rapid7 VulnDB'
			when 'MSB'
				if ref =~ /(MS[0-9]{2}-[0-9]{3})/
					$1
				else
					"#{type}-#{ref}"
				end
			when 'URL'
				begin
					URI.parse(ref).host
				rescue ::Exception
					ref.to_s
				end
			when nil
				ref.to_s
			when 'GENERIC'
				"#{ref}"
			else
				"#{type}-#{ref}"
			end

		short_desc = desc[/^(.*)\.(.*)\.(com|net|org|gov|fr)/] ? $2 : desc

		if type == "URL"
			img = case desc.to_s.downcase
				when /blogs\.(msdn|technet)\.com/
					ref_to_icon('msb')
				when /oracle\.com/
					ref_to_icon('oracle')
				when /securityfocus\.com/
					ref_to_icon('bid')
				when /vupen\.com/, /frsirt\.com/
					ref_to_icon('vupen')
				when /lists\.grok\./, /marc\.info/
					ref_to_icon('email')
				when /red-database-security\.com/
					ref_to_icon('red')
				when /mysql\.com/
					ref_to_icon('mysql')
				when /apache\.org/
					ref_to_icon('apache')
				when /php\.net/
					ref_to_icon('php')
				when /debian\./
					ref_to_icon('debian')
				when /ubuntu/
					ref_to_icon('ubuntu')
				else
					ref_to_icon(type)
			end
		else
			img = ref_to_icon(type)
		end

		[url,desc,short_desc,img]
	end

	def ref_to_icon(str)
		ico = case str.to_s.downcase
					when /^cve/
						'cve_logo.png'
					when /^osvdb/
						'osvdb_logo.png'
					when /^edb/
						'exploit-db_logo.png'
					when /^bid/
						'securityfocus_logo.png'
					when /^msb/
						'microsoft_logo.png'
					when /^nexpose/
						'rapid7_logo.png'
					when /^secunia/
						'secunia_logo.png'
					when "oracle"
						'oracle_logo.png'
					when "vupen"
						'vupen_logo.png'
					when "email"
						'email.png'
					when "red"
						'red_logo.png'
					when "apache"
						'apache_logo.png'
					when "php"
						'php_logo.png'
					when "mysql"
						'mysql_logo.png'
					when "debian"
						'debian_logo.png'
					when "ubuntu"
						'ubuntu_logo.png'
					when "nss"
						'tenable.png'
					else
						'w3_logo.png'
					end
		'icons/ref/' + ico
	end


end

