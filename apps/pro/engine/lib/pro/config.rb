module Msf
###
#
# This module provides Pro-specific overrides to the Msf::Config class
#
###
class Config
	def loot_directory
		::File.expand_path(::File.join(::File.dirname(__FILE__), '..', '..', '..', 'loot'))
	end
	
	def self.loot_directory
		self.new.loot_directory
	end
end
end
