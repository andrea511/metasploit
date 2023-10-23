require 'singleton'
require 'rex/logging'
require 'rex/post/meterpreter/extensions/pivot/tap/daemon/windows'
require 'rex/post/meterpreter/extensions/pivot/tap/daemon/linux'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap
module Daemon

#
# Factory to create a TAP bound to a remote interface.
#
class Factory
	
	include Singleton
	
	#
	# Create a new local virtual network interface (via a TAP driver)...
	#
	def create( mac, mtu )
		
		tap = nil
		
		# get the TAP driver to use for the current OS
		if( Rex::Compat.is_windows or Rex::Compat.is_cygwin or is_mingw32 )
			tap = WindowsTap.new( mac, mtu )
		elsif( Rex::Compat.is_linux )
			tap = LinuxTap.new( mac, mtu )
		else
			raise ::NotImplementedError, "Unsupported Platform. No suitable TAP driver interface available."
		end
		
		# open the TAP driver, creating the new local virtual interface
		if( not tap.open )
			wlog( "[TAP DAEMON] Factory.create -> tap.open failed. Closing tap..." )
			# if we cant open the new TAP, close it gracefully
			tap.close
			# return nil to indicate we failed.
			tap = nil
		end
		
		return tap
	end

	def is_mingw32
		return RUBY_PLATFORM =~ /mingw32/ ? true : false
	end	

end

end; end; end; end; end; end; end
