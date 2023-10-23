#!/usr/bin/env ruby

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__))))
require 'tool_dependency'
require 'readline'


$stderr.puts %Q{*
* Warning: This tool is not complete and contains a number of bugs and missing components
*}

# Takes a space-delimited set of ips and ranges, and subjects
# them to RangeWalker for validation. Returns true or false.
def validate_ips(ips)
		ret = true
		begin
				ips.split(' ').each {|ip|
						unless Rex::Socket::RangeWalker.new(ip).ranges
								ret = false
								break
						end
				}
		rescue => e
				ret = false
		end
		return ret
end

def is_valid_session?(session_id)
	r = @pro.call('session.list')
	r.keys.sort{|a,b| a.to_i <=> b.to_i}.each do |sid|
		if session_id == r[sid]
			return true
		end
	end
end


def run_cmd(cmd, *args)
		case cmd

		when 'help'
				#puts 'Commands: help, about, ps, kill, getworkspace, setworkspace, addworkspace, delworkspace, import, discover, bruteforce, exploit'
				puts "todo"
		when 'exit', 'quit'
				exit(0)
		when 'about'
				r = @pro.about
				puts "PRO: "+ r['pro'].inspect + " MetasploitCore:" + r['core'].inspect + ' Ruby:' + r['ruby'].inspect

		when 'ps','tasks'
				s = @pro.call("pro.task_list")
				s.keys.sort{|a,b| a.to_i <=> b.to_i}.each do |tid|
						puts "#{tid}\t#{s[tid]['status']}\t%#{s[tid]['progress']}\t#{s[tid]['error']}\t#{s[tid]['info']}\t#{s[tid]['desc']}\t#{s[tid]['result']}"
				end
		when 'kill'
				args.each do |tid|
						@pro.call("pro.task_stop", tid)
				end
		when 'workspace_add'
				r = @pro.call('pro.workspace_add', args[0])
				puts r.inspect

		when 'workspace_del'
				r = @pro.call('pro.workspace_del', args[0])
				puts r.inspect

		when 'workspaces'
				r = @pro.call('pro.workspaces', args[0])
				puts r.inspect

		when "nexpose"
				if args[0] == "help" || args.compact.size != 1
						puts "  Usage: nexpose <whitelist>"
						puts "  Example: nexpose 10.0.0.0/24"
				else
						conf = {
					       		'username'            => "rpc",
							'DS_WHITELIST_HOSTS'  => args[0],
							'DS_BLACKLIST_HOSTS'  => "",
							'DS_NEXPOSE_HOST'     => "nexpose",
					       	 	'DS_NEXPOSE_PORT'     => "3780",
					       	 	'DS_NEXPOSE_USER'     => "nxadmin" ,
							'DS_SCAN_TEMPLATE'    => "full-audit",
							'nexpose_pass'        => "",
					       		'nexpose_credentials' => "",
							'DS_NEXPOSE_PURGE_SITE' => "false"
						}

						if validate_ips(conf['DS_WHITELIST_HOSTS'])
								puts "Nexposing with options: #{conf.inspect}"
								r = @pro.start_nexpose(conf)
								puts "task: #{r['task_id']}"
						else
								puts "Invalid IP address or range: '#{conf['ips'].first}'"
						end
				end
		when 'import'
				conf = {}
				wl = args[0]
				bl = args[1]
				conf['DS_PATH'] = args[0]
				r = @pro.start_import(conf)
				puts "task: #{r['task_id']}"
		when 'discover'
				conf = {}
				if args[0] == "help" || args.compact.size != 1
						puts "  Usage: discover <whitelist>"
						puts "  Example: discover 10.0.0.0/24"
				else
						conf['RHOSTS'] = args.map{|x| x.split(",").join(" ") }
						if validate_ips(conf['RHOSTS'].first)
								puts "Discovering with options: #{conf.inspect}"
								r = @pro.start_discover(conf)
								puts "task: #{r['task_id']}"
						else
								puts "Invalid IP address or range: '#{conf['RHOSTS'].first}'"
						end
				end
		when 'bruteforce', 'brute'
				conf = {}
				if args[0] == "help" || !(2..3).include?(args.compact.size)
						puts "  Usage: #{cmd} <services> <whitelist> [blacklist]"
						puts "  Example: brute SMB,Postgres,DB2,MySQL,MSSQL,HTTP,Tomcat,SSH,Telnet 10.0.0.0/24 10.0.0.0-1,10.0.0.255"
				else
						sv = args[0]
						wl = args[1]
						bl = args[2]
						conf['DS_WHITELIST_HOSTS'] = wl.split(",").join(" ") if wl
						conf['DS_BLACKLIST_HOSTS'] = bl.split(",").join(" ") if bl
						conf['DS_BRUTEFORCE_SERVICES'] = sv.split(",").join(" ")
						good_wl = validate_ips(conf['DS_WHITELIST_HOSTS'])
						good_bl = bl ? validate_ips(conf['DS_BLACKLIST_HOSTS']) : true
						if good_wl && good_bl
								puts "Bruteforcing with options: #{conf.inspect}"
								r = @pro.start_bruteforce(conf)
								puts "task: #{r['task_id']}"
						elsif !good_wl
								puts "Invalid IP address or range for whitelist: '#{conf['DS_WHITELIST_HOSTS']}'"
						else

		puts "Invalid IP address or range for blacklist: '#{conf['DS_BLACKLIST_HOSTS']}'"
						end
				end

		when 'exploit'
				conf = {}
				if args[0] == "help" || !(1..2).include?(args.compact.size)
						puts "  Usage: exploit <whitelist> [blacklist]"
						puts "  Example: exploit 10.0.0.0/24 10.0.0.0-1,10.0.0.255"
				else
						wl = args[0]
						bl = args[1]
						conf['DS_WHITELIST_HOSTS'] = wl.split(",").join(" ") if wl
						conf['DS_BLACKLIST_HOSTS'] = bl.split(",").join(" ") if bl
						good_wl = validate_ips(conf['DS_WHITELIST_HOSTS'])
						good_bl = bl ? validate_ips(conf['DS_BLACKLIST_HOSTS']) : true
						if good_wl && good_bl
								puts "Exploiting with options: #{conf.inspect}"
								r = @pro.start_exploit(conf)
								puts "task: #{r['task_id']}"
						elsif !good_wl
								puts "Invalid IP address or range for whitelist: '#{conf['DS_WHITELIST_HOSTS']}'"
						else
								puts "Invalid IP address or range for blacklist: '#{conf['DS_BLACKLIST_HOSTS']}'"
						end
				end

		when 'collect'
				if args[0] == "help" || args.compact.size != 1
						puts "  Usage: collect <session>"
						puts "  Example: collect 1"
				else
						conf = {
							'username' 		    => "rpc",
							'DS_SESSIONS'               => args[0],
							'DS_COLLECT_SYSINFO'        => true,
							'DS_COLLECT_PASSWD'         => true,
							'DS_COLLECT_SCREENSHOTS'    => true,
							'DS_COLLECT_SSH'            => true,
							'DS_COLLECT_FILES'          => false,
							'DS_COLLECT_FILES_PATTERN'  => "boot.ini",
							'DS_COLLECT_FILES_COUNT'    => "10",
							'DS_COLLECT_FILES_SIZE'     => "100"
						}

						if is_valid_session?(conf['DS_SESSIONS'])
								puts "Collecting with options: #{conf.inspect}"
								r = @pro.start_collect(conf)
								puts "task: #{r['task_id']}"
						else
								puts "Invalid session ID"
						end
				end
		when 'sessions'
				r = @pro.call('session.list')
				r.keys.sort{|a,b| a.to_i <=> b.to_i}.each do |sid|
					pp r[sid]
				end

		when 'upload'
				puts "not implemented"
		when 'download'
				puts "not implemented"
		when 'update'
				puts "not implementeD"
		when "single_module"
				puts "not implemented"
		when "cleanup"
				puts "not implemented"
		when 'webscan'
				if args[0] == "help" || args.compact.size != 1
						puts "  Usage: webscan <url>"
						puts "  Example: webscan www.fbi.gov"
				else
						conf = {
					       		'username'      	      	=> "rpc",
							'DS_DRY_RUN'  			=> "false",
							'DS_URLS'			=> args[0],
							'DS_MAX_PAGES'			=> 500,
							'DS_MAX_MINUTES'		=> 5,
							'DS_MAX_THREADS'		=> 4,
						}

						puts "Webscanning with options: #{conf.inspect}"
						r = @pro.start_webscan(conf)
						puts "task: #{r['task_id']}"
				end
		when 'webaudit'
				if args[0] == "help" || args.compact.size != 1
						puts "  Usage: webaudit <url>"
						puts "  Example: webaudit www.fbi.gov"
				else
						conf = {
					       		'username'      	      	=> "rpc",
							'DS_DRY_RUN'  			=> "false",
							'DS_URLS'			=> args[0],
							'DS_MAX_PAGES'			=> 500,
							'DS_MAX_MINUTES'		=> 5,
							'DS_MAX_THREADS'		=> 4,
						}

						puts "Auditing with options: #{conf.inspect}"
						r = @pro.start_webaudit(conf)
						puts "task: #{r['task_id']}"
				end
		when 'websploit'
				puts "not implemented"
		when 'sessions'
				r = @pro.call('session.list')
				r.keys.sort{|a,b| a.to_i <=> b.to_i}.each do |sid|
						pp r[sid]
				end

		when 'stopsession'
				r = @pro.call('session.stop', args[0])

		when 'readsession'
				r = @pro.call('session.shell_read', args[0])
				puts r['data']

		when 'writesession'
				r = @pro.call('session.shell_write', args.shift!, args.join(" ") +"\n")
				puts r['write_count'].to_s

		when 'readmeterp'
				r = @pro.call('session.meterpreter_read')
				puts r['data']

		when 'writemeterp'
				r = @pro.call('session.meterpreter_write', args.join(" ") +"\n")
				puts r['write_count'].to_s

		end
end

@pro = Pro::Client.new(
	'ServerHost' => '127.0.0.1',
	'ServerPort' => 3790,
	'URL'  => '/api/1.0',
	'SSL'  => true
)

$stdout.puts "*** RPCShell ***"
run_cmd("getworkspace")

while(line = Readline.readline("rpcshell > "))
		cmd,*args= line.strip.split(/\s+/)
		begin
			run_cmd(cmd,*args)
		rescue ::Interrupt
				raise $!
		rescue ::SystemExit
				raise $!
		rescue ::XMLRPC::FaultException => e
				puts "error: #{e.faultCode} #{e.faultString}"
		rescue ::Exception => e
				puts "error: #{e} #{e.backtrace}"
		end
end

