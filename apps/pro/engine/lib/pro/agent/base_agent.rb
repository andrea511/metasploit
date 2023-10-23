require 'rex'
require 'metasm'

module Pro
module Agent
class BaseAgent

	def self.pro_root_directory
		::File.expand_path( ::File.join( ::File.dirname( __FILE__ ), "..", "..", "..", ".." ) )
	end

	def self.pro_data_directory
		::File.join( self.pro_root_directory, "data")
	end

end
end
end

