require 'rubygems'
require 'bundler/setup'

# TODO: Port the Windows and non-systemd Linux ruby control scripts to use this

cnf = File.read("#{File.dirname(__FILE__)}/conf/metasploit.conf") rescue ""
if m = cnf.match(/BalancerMember\s+http:\/\/127.0.0.1:(?<port>\d+)/)
  port = m[:port]
else
  port = 3001
end

ARGV.prepend 'start', '-p', port, '-a', '127.0.0.1',
             '-e', ENV['RAILS_ENV'] || 'development', '-l', 'log/thin.log'

gem 'thin', '>=0'
load Gem.bin_path('thin', 'thin', '>=0')
