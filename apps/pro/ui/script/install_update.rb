#!/usr/bin/env ruby
#
# $Id: diagnostic_logs.rb 2334 2010-06-25 17:07:47Z egypt $

def usage
	$stderr.puts "[*] Usage ./install_update.rb </path/to/201XXXXXXXXXX.zip>"
	exit(1)
end

root = File.expand_path(File.join(__FILE__, "..", "..", ".."))
path = ARGV.shift || usage()
revx = "manual" + rand(0x10000).to_s

install_path = nil

begin

update_path = path
pwd         = ::Dir.pwd.dup

install_path = ::File.join(root, "install", "#{rev}")
::FileUtils.rm_rf(install_path)
::FileUtils.mkdir_p(install_path)
::Dir.chdir(install_path)

::Open3.popen3("7za x \"#{update_path}\"") do |inp,out,err|
	install_log << out.read
	install_err << err.read
end

install_log.split("\n").each do |line|
	puts(">> Update Install: Extract Output: #{line}")
end

install_err.split("\n").each do |line|
	puts(">> Update Install: Extract Errors: #{line}")
end

install_log = ""
install_err = ""
::Open3.popen3("ruby \"#{::File.join(install_path, "install.rb") }\" ") do |inp,out,err|
	install_log << out.read
	install_err << err.read
end

install_log.split("\n").each do |line|
	puts(">> Update Install: Installer Output: #{line}")
end

install_err.split("\n").each do |line|
	puts(">> Update Install: Installer Errors: #{line}")
end


$stderr.puts "Installer Output: "
$stderr.puts "    #{install_log} "
$stderr.puts "    #{install_err} "

::FileUtils.rm_rf(install_path)
::FileUtils.chdir(pwd)

# Catch-all error handler
rescue ::Exception => e
	puts(">> Update Install: Error: #{e}")
ensure
	::FileUtils.rm_rf(install_path) if install_path
	::Dir.chdir(pwd)
end

