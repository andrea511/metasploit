#!/usr/bin/env ruby
#

require 'socket'
base = File.expand_path(File.join(File.dirname(__FILE__)))

# Linux
lin_path = File.join(base, "scripts", "ctl.sh")
lin_path_ui = File.expand_path(File.join(base, "..", "ui", "scripts", "ctl.sh"))
lin_path_worker = File.expand_path(File.join(base, "..", "ui", "scripts", "worker_ctl.sh"))

# Windows
win_path = File.join(base, "scripts", "servicerun.bat")
win_path_ui = File.expand_path(File.join(base, "..", "ui", "scripts", "servicerun.bat"))
win_path_worker = File.expand_path(File.join(base, "..", "ui", "scripts", "worker_servicerun.bat"))

if RUBY_PLATFORM =~ /linux/i
	$0 = "restarter"

	Process.setsid rescue nil

  if File.exist?(File.expand_path(File.join(base, '..', '..', '..', '.systemd_enabled')))
    system('systemctl restart metasploit.target')
  else
    system("#{lin_path} stop")
    system("#{lin_path_ui} stop")
    system("#{lin_path_worker} stop")
    sleep(5)

    system("#{lin_path} start")
    system("#{lin_path_ui} start")
    system("#{lin_path_worker} start")
  end
  exit(0)
else
	system("cmd.exe /c #{win_path} STOP")
	system("cmd.exe /c #{win_path_ui} STOP")
	system("cmd.exe /c #{win_path_worker} STOP")

	sleep(10)

	# Forcefully kill any left-over Ruby processes that are not our own
	begin
		pids = ::IO.popen("tasklist").readlines.grep(/ruby/i).map{|x| x.split(/\s+/)[1].to_i }
		pids -= [$$]
		pids.each do |pid|
			system("%SystemRoot%/System32/taskkill.exe /F /PID #{pid}")
		end
	rescue ::Exception => e
		$stdout.puts "[-] Exception while attempting to kill the process: #{e.to_s}"
	end

	sleep(1)

	system("cmd.exe /c #{win_path} START")
	system("cmd.exe /c #{win_path_ui} START")
	system("cmd.exe /c #{win_path_worker} START")
	exit(0)
end


## Note the exit(0) calls above. This only apply in development, and requires pidof to work properly
pid = `pidof prosvc`
Process.kill(9, pid.to_i)

# Restart prosvc
$stderr.puts "[*] Warning: the user interface must be restarted manually"
system("ruby", ::File.join(base, "prosvc.rb"), "-E", "production")

