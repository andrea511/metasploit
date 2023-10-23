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

Dir["#{File.dirname(__FILE__)}/../arch-lib/#{arch}/*/lib"].each do |lib|
	$:.unshift File.expand_path(lib)
end

#
# Load various dependencies
#
Dir["#{File.dirname(__FILE__)}/../lib/*/lib"].each { |lib|
	$:.unshift File.expand_path(lib)
}

# Expand the search path
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'msf3', 'lib')))

require 'rex'
require 'pro/client'
require 'pp'

