require 'rex/logging'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap
module Daemon

#
# A superclass for TAP interfaces and not to be instanciated, use the TAP Factory instead.
#
class Tap
	
	def initialize( mac, mtu )
		# the name of the local virtual interface
		@name   = ""
		# the MAC address we will use for this interface
		@mac    = mac
		# the MTU we will use for this interface
		@mtu    = mtu
		# the handle for the local TAP driver we are using for the local virtual network interface 
		@handle = nil
		# keep a record of if the tap has been closed
		@closed = false
	end

	def is_closed?
		return @closed
	end

	#
	# Open a TAP driver on the local host to create a local virtual interface.
	#
	def open
		false
	end
	
	#
	# Add an ARP entry to the hosts ARP table for this interface.
	#
	def add_ip4_arp_entry( ip, mac )
		return false
	end
	
	#
	# Remove an ARP entry from the hosts ARP table for this interface.
	#
	def remove_ip4_arp_entry( ip )
		return false
	end
	
	#
	# Add a DNS nameserver to the hosts list of nameservers.
	#
	def add_ip4_dns( nameserver )
		return false
	end
	
	#
	# Remove the DNS nameserver from the hosts list of nameservers.
	#
	def remove_ip4_dns( nameserver )
		return false
	end
	
	#
	# Set the IPv4 address and netmask for this local virtual network interface to use.
	#
	def set_ip4_address( address, netmask )
		false
	end
	
	#
	# Set the IPv6 address for this local virtual network interface to use.
	#
	def set_ip6_address( address )
		false
	end
	
	#
	# Set an IPv4 route in the routing table for this local virtual network interface.
	#
	def add_ip4_route( network, netmask )
		false
	end
	
	#
	# Removes an IPv4 route in the routing table for this local virtual network interface.
	#
	def remove_ip4_route( network, netmask )
		false
	end
	
	#
	# Set the default gateway in the routing table for the host OS
	#
	def set_ip4_default_gateway( gateway )
		return false
	end
	
	#
	# Set an IPv6 route in the routing table for this local virtual network interface.
	#
	def add_ip6_route( network, gateway )
		false
	end
	
	#
	# 
	#
	def remove_ip6_route( network, netmask )
		false
	end

	#
	# Read a frame of data from a TAP driver.
	#
	def read_frame
		return nil
	end
	
	#
	# Write a frame of data to a TAP driver.
	#
	def write_frame( frame )
		return 0
	end

	#
	# Wrapper for OS specific select operations on the TAP handle.
	#
	def select( timeout=0.2 )
		false
	end
	
	#
	# Close the TAP driver handle, destroying the virtual interface.
	#
	def close
	
		return true if( self.is_closed? )
		
		begin
			if( @handle )
				@handle.close
				@handle = nil
			end
		rescue ::Exception => e
			wlog( "Exception caught in TAP.close - @handle.close: #{e}" )
		end
		
		@closed = true
		
		return true  
	end

	attr_reader :name, :mac, :mtu

end



end; end; end; end; end; end; end
