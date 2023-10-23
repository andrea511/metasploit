require 'msf_autoload'

module ProLoadedPathsExtractor

  def extract(loader)
    framework_managed = []
    config_paths.each do |entry|
      framework_managed << Pathname.new(entry[:path]).realpath.to_s
    end
    loader.ignore(framework_managed)
  end

end

MsfAutoload.send(:prepend, ProLoadedPathsExtractor)
MsfAutoload.instance.extract(Rails.autoloaders.main)

