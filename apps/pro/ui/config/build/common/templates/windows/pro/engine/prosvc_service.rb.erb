#!ruby.exe

require 'rubygems'
require 'win32/daemon'

::MSF_BASE = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", ".."))
::PRO_BASE = File.dirname(__FILE__)
::PRO_LOG  = File.join(::PRO_BASE, 'prosvc.log')

$main_thread = Thread.current

$pro_log = File.open(::PRO_LOG , 'a')
$stdout.reopen $pro_log
$stderr = $stdout

# Configure the path on Windows installations
if RUBY_PLATFORM =~ /mingw32/
	ENV['PATH'] =
		"#{MSF_BASE}\\nmap;" +
		"#{MSF_BASE}\\ruby\\bin;" +
		"#{MSF_BASE}\\postgresql\\bin;" +
 		ENV['PATH']

	ENV['SSL_CERT_FILE'] = "#{MSF_BASE}\\apps\\pro\\engine\\certs\\cacert.pem"
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

	def service_init
		log("Initializing Pro Service...")
		@child = Thread.new do
			begin
				load("prosvc.rb")
      rescue Exception => error
        lines = []
        lines << 'Pro Service error:'
        lines << error.class
        lines << error
        lines += error.backtrace

        formatted = lines.join("\n")
        log(formatted)
			end
		end

		log("Pro Service started with thread #{@child.inspect}")
	end

	def service_main(*args)
		while running?
			sleep 1
		end
	end

	def service_stop
		log("Pro Service stopping...")

		log("NginX stopping...")
		system("%SystemRoot%/System32/taskkill.exe /F /IM nginxr7.exe")

		# Shut down all open files
		::ObjectSpace.each_object(IO).map do |io|
			next if [::STDIN,::STDERR,::STDOUT].include?(io)
			io.close rescue nil
		end

		Thread.list.each do |t|
			next if t == $main_thread
			t.kill rescue nil
		end
	end
end

begin
   MSFDaemon.mainloop
rescue Exception => err
   File.open(::PRO_LOG, 'a'){ |fh| fh.puts "Pro Service Error: #{err.class} #{err.inspect} #{err.backtrace}" }
end

