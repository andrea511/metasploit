#! ruby
#
# This file was generated by RubyGems.
#
# The application 'network_interface' is installed as part of a gem, and
# this file is here to facilitate running it.
#

require 'rubygems'

version = ">= 0.a"

str = ARGV.first
if str
  str = str.b[/\A_(.*)_\z/, 1]
  if str and Gem::Version.correct?(str)
    version = str
    ARGV.shift
  end
end

if Gem.respond_to?(:activate_bin_path)
load Gem.activate_bin_path('network_interface', 'list_interfaces.rb', version)
else
gem "network_interface", version
load Gem.bin_path("network_interface", "list_interfaces.rb", version)
end
