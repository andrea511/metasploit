#!ruby.exe

::MSF_BASE = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", ".."))
::RAILS_BASE = File.expand_path(File.dirname(__FILE__))
::WORKER_LOG = File.join(::RAILS_BASE, 'log', 'delayed_job.log')
::WORKER_PID = File.join(::RAILS_BASE, 'tmp', 'pids', 'delayed_job.pid')
ENV['BUNDLE_GEMFILE'] ||= File.join(::RAILS_BASE, '..', 'Gemfile-pro')
ENV['RAILS_ENV'] ||= 'production'

ENV['PATH'] =
  "#{MSF_BASE}\\nmap;" +
  "#{MSF_BASE}\\ruby\\bin;" +
  "#{MSF_BASE}\\postgresql\\bin;" +
  ENV['PATH']

$worker_log = File.open(::WORKER_LOG, 'a')
$stdout.reopen $worker_log
$stderr = $stdout

require 'win32/daemon'
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
    log "Starting worker thread"
    start_worker
  end

  def service_main
    while running?
      unless child && child.alive?
        log "Restarting worker thread"
        start_worker
      end
      sleep 60
    end
  end

  def service_stop
    log "Stopping worker"
    begin
      if child && child.alive?
        child.exit
      end
      #pid = File.read(::WORKER_PID).to_s.to_i
      #system("%SystemRoot%/System32/taskkill.exe /F /PID #{pid}")
      File.delete(::WORKER_PID)
    rescue => e
      log "Worker service kill exception: #{e}"
    end
    exit
  end

  def start_worker
    self.child = Thread.new do
      # Write pid file
      File.open(::WORKER_PID, "w") {|fd| fd.write($$.to_s)}

      # Wait for thin to boot
      log "Waiting for prosvc and thin"
      require 'timeout'
      require 'socket'
      timeout = 600
      start_time = Time.now.to_i
      prosvc_ready = false
      thin_ready = false
      while(Time.now.to_i < (start_time + timeout)) do
        begin
          unless prosvc_ready
            Timeout::timeout(1) do
              TCPSocket.new('localhost', 50505).close
              prosvc_ready = true
            end
          end
          unless thin_ready
            Timeout::timeout(1) do
              TCPSocket.new('localhost', 3001).close
              thin_ready = true
            end
          end
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
        end
        break if prosvc_ready && thin_ready
        sleep 1
      end
      if prosvc_ready && thin_ready
        log "Prosvc and thin started in #{Time.now.to_i - start_time} seconds"
      else
        log "Prosvc and thin didn't start in #{Time.now.to_i - start_time} seconds."
      end

      log "Starting delayed_job worker"
      ENV['MSFRPC_SKIP'] = 'yes'
      require 'rubygems'
      require 'bundler/setup'
      require File.join(::RAILS_BASE, "config", "environment")
      Delayed::Worker.logger ||= Logger.new($stdout)
      Delayed::Worker.new.start
    end
  end
end

begin
  MSFDaemon.mainloop
rescue => e
  File.open(::WORKER_LOG, 'a') {|fd| fd.puts "Worker Service Error: #{e}"}
end
