require 'rex/socket'
require 'rex/logging'
require 'rex/post/meterpreter/extensions/pivot/tap/daemon/tap'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap
module Daemon

#
# A subclass for Linux TAP interfaces and not to be instanciated directly, use the TAP Factory instead.
#
class LinuxTap < Tap

	TAP_DEVICE				= "/dev/net/tun"
	RESOLVE_CONF			= "/etc/resolv.conf"

	TUNSETIFF				= 0x400454CA

	IFF_TUN					= 0x0001
	IFF_TAP					= 0x0002
	IFF_NO_PI				= 0x1000
	IFF_ONE_QUEUE			= 0x2000
	IFF_VNET_HDR			= 0x4000
	IFF_TUN_EXCL			= 0x8000

	#
	# Open a TAP driver on the local host to create a local virtual interface.
	#
	def open
	
		begin
			# open the device...
			@handle = ::Kernel.open( TAP_DEVICE, ::File::RDWR | ::File::NONBLOCK )
			raise if( @handle == nil )
			# set it to be a TAP and not to return some packet info
			mode = IFF_TAP | IFF_NO_PI
			iff  = [ "", mode ].pack( "a16S" )
			# config the new virtual interface
			@handle.ioctl( TUNSETIFF, iff )
			# get back the name of this interface (e.g. tap0)
			@name = iff[ 0 , iff.index( "\x00" ) ]
		rescue
			wlog( "[TAP DAEMON] LinuxTap.open - 1 - #{$!}" )
			@handle = nil
			@name   = nil
			return false
		end

		# Disable IPv6 on this interface by default
 		begin
			::File.open("/proc/sys/net/ipv6/conf/#{@name}/disable_ipv6", "w") do |fd|
				fd.write("1")
			end
		rescue ::Exception
		end
	
		begin
			# set the MAC address for the new local virtual network interface to use.
			`/sbin/ifconfig #{@name} hw ether #{@mac} up`
			# set the new local virtual network interface's MTU.
			`/sbin/ifconfig #{@name} mtu #{ @mtu }`
		rescue
			wlog( "[TAP DAEMON] LinuxTap.open - 2 - #{$!}" )
		end
		
		return true
	end
	
	#
	# Wrapper for Linux specific select operations on the TAP handle.
	#
	def select( timeout=0.2 )
		result = ::IO.select( [ @handle ], nil, nil, timeout )
		if( result == nil or result[0] == nil )
			return false
		end
		return true
	end
	
	#
	# Read a frame of data from the TAP driver. Please note, this method is non-blocking
	# so handle accordingly.
	#
	def read_frame
		return @handle.read_nonblock( @mtu )
	end
	
	#
	# Write a frame of data to the TAP driver
	#
	def write_frame( frame )
		return @handle.syswrite( frame )
	end
	
	#
	# Add an ARP entry to the hosts ARP table for this interface.
	#
	def add_ip4_arp_entry( ip, mac )
		begin
			`/sbin/arp -i #{@name} -s #{ip} #{mac}`
		rescue
			return false
		end
		return true
	end

	#
	# Remove an ARP entry from the hosts ARP table for this interface.
	#
	def remove_ip4_arp_entry( ip )
		begin
			`/sbin/arp -i #{@name} -d #{ip}`
		rescue
			return false
		end
		return true
	end

	#
	# Add a DNS nameserver to the hosts list of nameservers.
	#
	def add_ip4_dns( nameserver )
		begin
			::File.open( RESOLVE_CONF, 'a' ) do | f |
				f.write( "nameserver #{nameserver}\n" )
			end
			# Note: Ubuntu does not have nscd so we test accordingly.
			if( ::File.exist?( "/etc/init.d/nscd" ) )
				`/etc/init.d/nscd restart`
			end
		rescue
			return false
		end
		return true
	end

	#
	# Remove the DNS nameserver from the hosts list of nameservers.
	#
	def remove_ip4_dns( nameserver )
		begin
			resolve = ""

			::File.open( RESOLVE_CONF, ::File::RDONLY | ::File::APPEND | ::File::CREAT ) do | f |
				f.each do | line |
					if( not line =~ /nameserver #{nameserver}/i )
						resolve += line
					end
				end
			end

			::File.open( RESOLVE_CONF, ::File::WRONLY | ::File::TRUNC | ::File::CREAT ) do | f |
				f.write( resolve )
			end
		rescue
			return false
		end
		return true
	end

	#
	# Set the IPv4 address and netmask for this local virtual network interface to use.
	#
	def set_ip4_address( address, netmask )
		begin
			`/sbin/ifconfig #{@name} #{address} netmask #{netmask}`
		rescue
			return false
		end
		return true
	end

	#
	# Set the IPv6 address for this local virtual network interface to use.
	#
	def set_ip6_address( address )
		begin
			`/sbin/ifconfig #{@name} inet6 add #{address}`
		rescue
			return false
		end
		return true
	end

	#
	# Set an IPv4 route in the main routing table for this local virtual network interface.
	#
	def add_ip4_route( network, netmask )
		begin
			`/sbin/route add -net #{network} netmask #{netmask} dev #{@name}`
		rescue
			return false
		end
		return true
	end

	#
	# Removes an IPv4 route in the routing table for this local virtual network interface.
	#
	def remove_ip4_route( network, netmask )
		begin
			`/sbin/route del -net #{network} netmask #{netmask} dev #{@name}`
		rescue
			return false
		end
		return true
	end

	#
	# Set the default gateway in the routing table for the host OS
	#
	def set_ip4_default_gateway( gateway )
		begin
			`/sbin/route add default gw #{gateway}`
		rescue
			return false
		end
		return true
	end

	#
	# Set an IPv6 route in the routing table for this local virtual network interface.
	#
	def set_ip6_route( network, gateway )
		begin
			`/sbin/route -A inet6 add #{network} gw #{gateway} dev #{@name}`
		rescue
			return false
		end
		return true
	end

end

end; end; end; end; end; end; end

