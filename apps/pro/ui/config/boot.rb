#
# Standard Library
#

require 'rubygems'

#
# Gems
#

require 'bundler'

# Set up gems list in the Gemfile
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __FILE__)

bundler_extensions_load_path = Pathname.new(__FILE__).parent.parent.parent.join('bundler-extensions', 'lib').expand_path.to_path
unless $LOAD_PATH.include? bundler_extensions_load_path
  $LOAD_PATH.unshift bundler_extensions_load_path
end
require 'bundler/extensions/setup'
