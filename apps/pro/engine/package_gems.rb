#!/usr/bin/env ruby

require 'fileutils'

def clean_gem_dir(base)
	Dir.glob("#{base}/*").each do |ent|
		name = ent.split("/").last	
		next if name =~ /^[A-Z]{2}/
		next if name == "lib"
		next if name == "frameworks"  # Compass
		next if name == "init.rb"
		next if name == "rails"
		next if name == "rack"

		FileUtils.rm_rf(ent)
	end
end


bpath = ::File.expand_path(::File.join(::File.dirname(__FILE__)))

Dir["#{bpath}/gems/*"].each do |ent|
	clean_gem_dir( ent )
end

Dir["#{bpath}/gems-binary/*/*"].each do |ent|
	clean_gem_dir( ent )
end

