#!/usr/bin/env ruby

#
# Run this with the Pro ruby wrapper:
# /opt/metasploit-*/ruby/bin/ruby /opt/metasploit-*/apps/pro/engine/update.rb
#

$:.unshift(File.join(File.dirname(__FILE__), "lib"))


#
# Load architecture specific library paths
#
arch = 'unknown'
case RUBY_PLATFORM
when /x86_64-linux/
  arch = "linux64"
when /i[3456]86-linux/
  arch = "linux32"
when /mingw32/
  arch = "win32"
end

Dir["#{File.dirname(__FILE__)}/arch-lib/#{arch}/*/lib"].each do |lib|
  $:.unshift File.expand_path(lib)
end


#
# Load additional search paths within the various gems
#
Dir["#{File.dirname(__FILE__)}/lib/*/lib"].each do |lib|
  $:.unshift File.expand_path(lib)
end

# Load bundler gems
require 'bundler/setup'

#
# Load the RPC client
#
client_path = File.expand_path(File.join("..","ui","lib","pro", "client.rb"))
load client_path

cnf = {}
pro = Pro::Client.new
path = ARGV.shift

if path
  $stderr.puts "[*] Installing update #{path}..."
  r = pro.update_install_offline(File.expand_path(path))
else
  begin
    r = pro.update_available(cnf)
  rescue ::Rex::SocketError => e
    $stderr.puts "[-] Raised an exception when trying to update:"
    $stderr.puts "[-] #{e.inspect}"
    $stderr.puts "[-]"
    $stderr.puts "[-] To update your binary installation, please make"
    $stderr.puts "[-] sure the required Metasploit services are running."
  end

  if r['result'] == 'failed' and r['reason'] =~ /(no|invalid) product key/i
    $stderr.puts "[-] To update your binary installation, please"
    $stderr.puts "[-] register your version of Metasploit through"
    $stderr.puts "[-] the UI, here: https://localhost:3790 (note,"
    $stderr.puts "[-] Metasploit Community Edition is totally free"
    $stderr.puts "[-] and takes just a few seconds to register!)"
    exit(2)
  end

  if r['result'] != 'update'
    $stderr.puts "[*] No updates available"
    exit(0)
  end

  v = r['version']
  $stderr.puts "[*] Installing update #{v}..."
  r = pro.update_install(cnf.merge({ 'version' => v }))
end

if arch =~ /win/
  $stderr.puts "\n[!] This script may stop before the update is complete.\n" \
    "    If you do not see an \"Installation complete.\" message, please\n" \
    "    wait 5 minutes before accessing Metasploit or restarting your\n" \
    "    computer.\n\n"
end


last_result = 'installing'
unavail_count = 0
while true
  begin
    r = pro.update_status(cnf)
  rescue Rex::ConnectionRefused, Errno::ECONNRESET => e
    # Some updates shut down prosvc.  Ignore up to 15
    # minutes of prosvc being unavailable.
    unavail_count += 1
    r = {"status"=>"success", "result"=>last_result, "error"=>""}
    raise if unavail_count > 900
  rescue RuntimeError => e
    # Sometimes the rpc client will error out before prosvc finishes starting
    # accelerate the counter in this case since it can also indicate a real
    # failure
    unavail_count += 2
    r = {"status"=>"success", "result"=>last_result, "error"=>""}
    raise if unavail_count > 900
  end

  if last_result == 'downloading' || last_result != r['result']
    case r['result']
    when 'querying'
      $stderr.puts "[*] Querying the update server..."
    when 'downloading'
      $stderr.puts "[*] Downloading (%#{r['download_pcnt']} complete)"
    when 'installing'
      $stderr.puts "[*] Installing the update..."
    when 'complete'
      $stderr.puts "[*] Restarting Metasploit..."
      pro.restart_service(cnf)
      r['result'] = 'restarting'
      sleep(4)
    when 'restarting'
      $stderr.puts "[*] Restarting Metasploit..."
    when ''
      $stderr.puts "[*] Installation complete."
      break
    when 'error'
      $stderr.puts "[*] Error occurred: #{r.inspect}"
      exit(1)
    end
  end
  last_result = r['result']
  sleep(1)
end
