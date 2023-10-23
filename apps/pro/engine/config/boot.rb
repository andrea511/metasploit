#
# Gems
#

require 'bundler'

bundle_gemfile = ENV['BUNDLE_GEMFILE']
root = Pathname.new(__FILE__).expand_path.parent.parent

if bundle_gemfile
  bundle_gemfile = Pathname.new(bundle_gemfile)
else
  bundle_gemfile = root.parent.join('Gemfile')
end

if bundle_gemfile.exist?
  ENV['BUNDLE_GEMFILE'] = bundle_gemfile.to_path

  bundler_extensions_load_path = Pathname.new(__FILE__).parent.parent.parent.join('bundler-extensions', 'lib').expand_path.to_path
  unless $LOAD_PATH.include? bundler_extensions_load_path
    $LOAD_PATH.unshift bundler_extensions_load_path
  end
  require 'bundler/extensions/setup'
end

lib_path = root.join('lib').to_path

unless $LOAD_PATH.include? lib_path
  $LOAD_PATH.unshift lib_path
end
