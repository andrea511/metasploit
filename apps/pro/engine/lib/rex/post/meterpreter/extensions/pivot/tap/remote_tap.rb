require 'rex/logging'
require 'rex/socket'
require 'rex/post/meterpreter/extensions/pivot/tap/basic_tap'
require 'rex/post/meterpreter/extensions/pivot/tap/proto'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap

#
# The Framework client side implementation of a virtual interface, backed by a 
# TAP driver which we communicate via the MSF TAP Daemon and a Meterpreter server 
# side implementation which bridges with a real interface to a network we want to 
# tunnel to.
#
class RemoteTap < Proto
	
	include BasicTap
	
	#
	#
	#
	def initialize( client, cid, bridge, opts={}, packet, **_ )
		super( nil )
		defaults = { 
			'msftapd_host'    => '127.0.0.1',
			'msftapd_port'    => 55552,
			'msftapd_ssl'     => false,
			'msftapd_timeout' => 60,
		}
		opts = defaults.merge( opts )
		initialize_tap( client, cid, bridge, opts, packet, **_ )
	end
	
	#
	# Add an ARP entry to the hosts ARP table for this interface.
	#
	def add_ip4_arp_entry( ip, mac )
		request = Packet.create_request( 'add_ip4_arp_entry' )
		request.add_tlv( TLV_TYPE_ADDRESS, ip )
		request.add_tlv( TLV_TYPE_MAC, mac )
		response = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end
	
	#
	# Remove an ARP entry from the hosts ARP table for this interface.
	#
	def remove_ip4_arp_entry( ip )
		request = Packet.create_request( 'remove_ip4_arp_entry' )
		request.add_tlv( TLV_TYPE_ADDRESS, ip )
		response = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end
	
	#
	# Add a DNS nameserver to the hosts list of nameservers.
	#
	def add_ip4_dns( nameserver )
		request = Packet.create_request( 'add_ip4_dns' )
		request.add_tlv( TLV_TYPE_NAMESERVER, nameserver )
		response = send_request( request )
		if( response.result == RESULT_SUCCESS )
			@opts['ip4_dns'] = nameserver
			return true
		end
		return false
	end
	
	#
	# Remove the DNS nameserver from the hosts list of nameservers.
	#
	def remove_ip4_dns( nameserver=nil )
		nameserver = nameserver ? nameserver : @opts['ip4_dns']
		return false if not nameserver
		request    = Packet.create_request( 'remove_ip4_dns' )
		request.add_tlv( TLV_TYPE_NAMESERVER, nameserver )
		response   = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end

	#
	# Set the IPv4 address and netmask for this local virtual network interface to use.
	#
	def set_ip4_address( address, netmask )
		request = Packet.create_request( 'set_ip4_address' )
		request.add_tlv( TLV_TYPE_ADDRESS, address )
		request.add_tlv( TLV_TYPE_NETMASK, netmask )
		response = send_request( request )
		if( response.result == RESULT_SUCCESS )
			@opts['ip4_address']    = address
			@opts['ip4_subnetmask'] = netmask
			return true
		end
		return false
	end
	
	#
	# Set the IPv6 address for this local virtual network interface to use.
	#
	def set_ip6_address( address )
		request = Packet.create_request( 'set_ip6_address' )
		request.add_tlv( TLV_TYPE_ADDRESS, address )
		response = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end
	
	#
	# Set an IPv4 route in the routing table for this local virtual network interface.
	#
	def add_ip4_route( network, netmask )
		request = Packet.create_request( 'add_ip4_route' )
		request.add_tlv( TLV_TYPE_NETWORK, network )
		request.add_tlv( TLV_TYPE_NETMASK, netmask )
		response = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end
	
	#
	# Removes an IPv4 route in the routing table for this local virtual network interface.
	#
	def remove_ip4_route( network, netmask )
		request = Packet.create_request( 'remove_ip4_route' )
		request.add_tlv( TLV_TYPE_NETWORK, network )
		request.add_tlv( TLV_TYPE_NETMASK, netmask )
		response = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end
	
	#
	# Set the default gateway in the routing table for the host OS
	#
	def set_ip4_default_gateway( gateway )
		request = Packet.create_request( 'set_ip4_default_gateway' )
		request.add_tlv( TLV_TYPE_GATEWAY, gateway )
		response = send_request( request )
		if( response.result == RESULT_SUCCESS )
			@opts['ip4_gateway'] = gateway
			return true
		end
		return false
	end
	
	#
	# Set an IPv6 route in the routing table for this local virtual network interface.
	#
	def add_ip6_route( network, gateway )
		request = Packet.create_request( 'add_ip6_route' )
		request.add_tlv( TLV_TYPE_NETWORK, network )
		request.add_tlv( TLV_TYPE_GATEWAY, gateway )
		response = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end
	
	#
	# Remove an IPv6 route 
	#
	def remove_ip6_route( network, netmask )
		request = Packet.create_request( 'remove_ip6_route' )
		request.add_tlv( TLV_TYPE_NETWORK, network )
		request.add_tlv( TLV_TYPE_NETMASK, netmask )
		response = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end
	
	#
	# Write a group of received frames out to the msftapd. We send the request but dont expect a response to improve performance.
	#
	def rx_frames( frames )
		raise "TAP has been closed (RemoteTap.rx_frames)." if( self.is_closed? )
		request = Packet.create_request( 'rx_frames' )
		request.add_tlv( TLV_TYPE_FRAMES, filter( false, frames ) )
		send_packet( request )
		return true
	end
	
	#
	# Open a TAP driver on the msftapd host to create a new virtual interface.
	#
	def open
		if( self.start )
			if( not self.create_tap )
				self.close
			end
		else
			self.close
		end
		return !self.is_closed?
	end
	
	#
	#
	#
	def close
	
		return true if( self.is_closed? )
			
		# bring down any services running...
		@services.each do | name, service |
			begin
				service.stop if service.respond_to?( 'stop' )
			rescue ::Exception => e
				wlog( "Exception caught in RemoteTap.close - @services[#{name}].stop: #{e}" )
			end
		end
		@services.clear
			
		# bring down the msftapd side virtual interface...
		begin
			# if a dns entry was set, remove it...
			self.remove_ip4_dns()
			# destroy the virtual interface
			self.destroy_tap
			# close the connection to the msftapd
			self.stop
		rescue ::Exception => e
			wlog( "Exception caught in RemoteTap.close - daemon: #{e}" )
		end
			
		# close the channel which inturn will bring down the meterpreter side virtual interface (and its respective network bridge)...
		begin
			@channel.close
			@channel = nil
		rescue ::Exception => e
			wlog( "Exception caught in RemoteTap.close - @channel.close: #{e}" )
		end
			
		@closed = true
			
		return true  
	end

	protected
	
	#
	# Connect to a msftapd
	#
	def start
		success = false
		
		begin
		
			@sock = Rex::Socket::Tcp.create(
				'PeerHost' => @opts['msftapd_host'],
				'PeerPort' => @opts['msftapd_port'],
				'SSL'      => @opts['msftapd_ssl'],
				'Timeout'  => @opts['msftapd_timeout']
			)
			
			# disable the nagle algorithm on this socket to help reduce latency
			begin
				@sock.setsockopt( ::Socket::SOL_TCP, ::Socket::TCP_NODELAY, true )
			rescue
			end
			
			success = super()
			
		rescue ::Exception => e
			wlog( "Exception in RemoteTap.start - #{e}" )
			self.stop
		end
		
		return success
	end
	
	#
	# The handler for incoming requests from the msftapd
	#
	def request_handler( client, packet )
		case packet.method
			when 'tx_frames'
				begin
					frames = packet.get_tlv_value( TLV_TYPE_FRAMES )
					# write a group of transmited frames out the virtual interface
					self.tx_frames( frames )
				rescue
					p "Exception in RemoteTap.request_handler - write_frames- #{e}"
					wlog( "Exception in RemoteTap.request_handler - write_frames- #{e}" )
				end
				return true
		end
		return false
	end

	#
	# Create a new virtual interface via the msfrpcd
	#
	def create_tap
		request  = Packet.create_request( 'create_tap' )
		request.add_tlv( TLV_TYPE_MTU, @opts['mtu'] )
		request.add_tlv( TLV_TYPE_MAC, @opts['mac'] )
		response = send_request( request )
		if( response.result == RESULT_SUCCESS )
			@name = response.get_tlv_value( TLV_TYPE_NAME )
			return true
		end
		return false
	end
	
	#
	# Destroy a new virtual interface via the msfrpcd
	#
	def destroy_tap
		request  = Packet.create_request( 'destroy_tap' )
		response = send_request( request )
		response.result == RESULT_SUCCESS ? true : false
	end
end

end; end; end; end; end; end
