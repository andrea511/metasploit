#!ruby.exe

require 'rubygems'
require 'win32/daemon'

::MSF_BASE = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", ".."))
::THIN_BASE = File.dirname(__FILE__)
::THIN_LOG  = File.join(::THIN_BASE, 'thin.log')
ENV['RAILS_ENV'] ||= 'production'

tport = 3001

begin
	buff = File.read(File.join(::THIN_BASE, "conf", "metasploit.conf"))
	if buff =~ /BalancerMember.*127.0.0.1:(\d+)/
		tport = $1.to_i
	end
rescue ::Exception
end

THIN_PORT = tport.to_s

while ARGV.shift
  # Clear any additional arguments
end

$thin_log = File.open(::THIN_LOG , 'a')
$stdout.reopen $thin_log
$stderr = $stdout

$main_thread = ::Thread.current

# Configure the path on Windows installations
if RUBY_PLATFORM =~ /mingw32/
	ENV['PATH'] =
		"#{MSF_BASE}\\nmap;" +
		"#{MSF_BASE}\\ruby\\bin;" +
		"#{MSF_BASE}\\postgresql\\bin;" +
		ENV['PATH']
	ENV['BUNDLE_GEMFILE'] = "#{MSF_BASE}\\apps\\pro\\Gemfile-pro"
end

class MSFDaemon < Win32::Daemon
	attr_accessor :child

	def log(msg)
		begin
			$stdout.write("#{Time.now.to_s} #{msg}\n")
			$stdout.flush
		rescue ::Exception
		end
	end

	# TODO: port this to use UI's proui.rb script currently used by systemd Linux
	def service_init
		log("Initializing Thin Service...")
		@child = Thread.new do
			begin

			ARGV.push("start", "-e", "production", "-a", "127.0.0.1", "-c", ::THIN_BASE, "-p", ::THIN_PORT)
			File.open(File.join(::THIN_BASE, "tmp", "pids", "thin.pid"), "w") do |fd|
				fd.write($$.to_s)
			end
			version = ">= 0"

			require 'rubygems'
			require 'bundler/setup'
			gem 'thin', version
			load Gem.bin_path('thin', 'thin', version)

			rescue Exception => e
				log("Thin Service error: #{e.class} #{e} #{e.backtrace}")
			end
		end

		log("Thin Service started with thread #{@child.inspect}")
		log("Thin Service associated with PID #{$$}")
	end

	def service_main(*args)
		while running?
			sleep 1
		end
	end

	def service_stop
		log("Thin Service stopping...")
=begin
		begin
			# Shut down all open files
			::ObjectSpace.each_object(IO).map do |io|
				next if [::STDIN,::STDERR,::STDOUT].include?(io)
				io.close rescue nil
			end

			Thread.list.each do |t|
				next if t == $main_thread
				t.kill rescue nil
			end
		rescue ::Exception => e
			log("Thing Service stop exception: #{e}")
		end

		sleep(2)
=end

		begin
			pid = File.read(File.join(::THIN_BASE, "tmp", "pids", "thin.pid")).to_s.to_i
			Process.kill('TERM', pid)
		rescue SignalException => e
			log("Thin Service kill exception: #{e}")
			log("Force killing Thin Service with PID #{pid}")
			Process.kill('KILL', pid)
		end
	end
end

begin
   MSFDaemon.mainloop
rescue Exception => err
   File.open(::THIN_LOG, 'a'){ |fh| fh.puts "Thin Service Error: #{err.class} #{err.inspect} #{err.backtrace}" }
end

