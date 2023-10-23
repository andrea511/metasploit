require 'rex/post/meterpreter/extensions/pivot/tap/local_tap'
require 'rex/post/meterpreter/extensions/pivot/tap/remote_tap'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot

# ID for the extension (needs tob e a multiple of 1000)
# We've extended this well beyond the existing public extensions
# to avoid possible clashes down the track
EXTENSION_ID_PIVOT               = 30000

# Associated command ids
COMMAND_ID_PIVOT_CREATE_PIVOT    = EXTENSION_ID_PIVOT + 1
COMMAND_ID_PIVOT_LIST_INTERFACES = EXTENSION_ID_PIVOT + 2

###
#
# This meterpreter extension can be used to create vlan's to pivot via remote network interface's.
#
###
class Pivot < Extension

	INTERFACE_TYPE_ETHERNET                   = 1 # 802.3 - Only supported interface type for now.
	INTERFACE_TYPE_TOKENRING                  = 2 # 802.5
	INTERFACE_TYPE_FDDI                       = 3 #
	INTERFACE_TYPE_WAN                        = 4 #
	INTERFACE_TYPE_WIRELESS                   = 5 # 802.11
	
	TLV_TYPE_EXTENSION_PIVOT                  = 0
	
	TLV_TYPE_PIVOT_INTERFACES                 = ( TLV_META_TYPE_GROUP  | ( TLV_TYPE_EXTENSION_PIVOT +  1 ) )
	TLV_TYPE_PIVOT_INTERFACE_TYPE             = ( TLV_META_TYPE_UINT   | ( TLV_TYPE_EXTENSION_PIVOT +  2 ) )
	TLV_TYPE_PIVOT_INTERFACE_NAME             = ( TLV_META_TYPE_STRING | ( TLV_TYPE_EXTENSION_PIVOT +  3 ) )
	TLV_TYPE_PIVOT_INTERFACE_DESCRIPTION      = ( TLV_META_TYPE_STRING | ( TLV_TYPE_EXTENSION_PIVOT +  4 ) )
	TLV_TYPE_PIVOT_INTERFACE_PHYSICAL_ADDRESS = ( TLV_META_TYPE_STRING | ( TLV_TYPE_EXTENSION_PIVOT +  5 ) )
	TLV_TYPE_PIVOT_INTERFACE_IP4_ADDRESS      = ( TLV_META_TYPE_STRING | ( TLV_TYPE_EXTENSION_PIVOT +  6 ) )
	TLV_TYPE_PIVOT_INTERFACE_IP4_SUBNETMASK   = ( TLV_META_TYPE_STRING | ( TLV_TYPE_EXTENSION_PIVOT +  7 ) )
	TLV_TYPE_PIVOT_INTERFACE_IP4_GATEWAY      = ( TLV_META_TYPE_STRING | ( TLV_TYPE_EXTENSION_PIVOT +  8 ) )
	TLV_TYPE_PIVOT_INTERFACE_IP4_DNS          = ( TLV_META_TYPE_STRING | ( TLV_TYPE_EXTENSION_PIVOT +  9 ) )
	TLV_TYPE_PIVOT_INTERFACE_IP4_DHCP         = ( TLV_META_TYPE_STRING | ( TLV_TYPE_EXTENSION_PIVOT + 10 ) )
	TLV_TYPE_PIVOT_INTERFACE_CID              = ( TLV_META_TYPE_UINT   | ( TLV_TYPE_EXTENSION_PIVOT + 11 ) )
	TLV_TYPE_PIVOT_INTERFACE_ID               = ( TLV_META_TYPE_UINT   | ( TLV_TYPE_EXTENSION_PIVOT + 12 ) )
	TLV_TYPE_PIVOT_INTERFACE_BRIDGED          = ( TLV_META_TYPE_BOOL   | ( TLV_TYPE_EXTENSION_PIVOT + 13 ) )
	TLV_TYPE_PIVOT_INTERFACE_MTU              = ( TLV_META_TYPE_UINT   | ( TLV_TYPE_EXTENSION_PIVOT + 14 ) )
	TLV_TYPE_PIVOT_INTERFACE_COMPRESSION      = ( TLV_META_TYPE_BOOL   | ( TLV_TYPE_EXTENSION_PIVOT + 15 ) )

	def self.extension_id
		EXTENSION_ID_PIVOT
	end
	
	#
	#
	#
	def initialize( client )
		super( client, 'pivot')
		
		@taps = ::Array.new
		
		client.register_extension_aliases(
			[
				{ 
					'name' => 'pivot',
					'ext'  => self
				},
			])
			
	end

	def iface_type_to_s(type)
		case type.to_i
		when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_ETHERNET
			itype = "Ethernet (802.3)"
		when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_TOKENRING
			itype = "TokenRing (802.5)"
		when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_FDDI
			itype = "FDDI"
		when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_WAN
			itype = "WAN"
		when Rex::Post::Meterpreter::Extensions::Pivot::Pivot::INTERFACE_TYPE_WIRELESS
			itype = "Wireless (802.11)"
		else
			itype = "Unknown"
		end
		itype
	end
	
	#
	# The host meterpreter instance is being shutdown and cleaned up, so we
	# should cleanup any remaining local virtual interfaces from this instance.
	#
	def cleanup
		ids = ::Array.new
		# get a list of IDs first as destroy_pivot() calls @taps.delete which 
		# will only remove odd entries if called inside a @taps.each block.
		@taps.each do | tap |
			ids << tap.bridge['id']
		end
		ids.each do | id |
			destroy_pivot( id )
		end
	end
	
	#
	# List the available remote network interfaces that can be used for pivoting.
	#
	def list_interfaces
		
		request = Packet.create_request(COMMAND_ID_PIVOT_LIST_INTERFACES)
		
		interfaces = []
		
		response = client.send_request( request )
		
		if( response.result == 0 )
			response.each( TLV_TYPE_PIVOT_INTERFACES ) do | interface |
			
				ip4_address = []
				if( interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_ADDRESS ) )
					ip4_address = interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_ADDRESS ).split( "," )
				end
				
				ip4_subnetmask = []
				if( interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_SUBNETMASK ) )
					ip4_subnetmask = interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_SUBNETMASK ).split( "," )
				end

				ip4_gateway = []
				if( interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_GATEWAY ) )
					ip4_gateway = interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_GATEWAY ).split( "," )
				end
				
				ip4_dns = []
				if( interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_DNS ) )
					ip4_dns = interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_DNS ).split( "," )
				end
				
				ip4_dhcp = []
				if( interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_DHCP ) )
					ip4_dhcp = interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_IP4_DHCP ).split( "," )
				end
				
				def ip4_address.to_line x    = ''; each do | i | x += i + ", " end; x.chomp(", "); end
				def ip4_subnetmask.to_line x = ''; each do | i | x += i + ", " end; x.chomp(", "); end  
				def ip4_gateway.to_line x    = ''; each do | i | x += i + ", " end; x.chomp(", "); end
				def ip4_dns.to_line x        = ''; each do | i | x += i + ", " end; x.chomp(", "); end
				def ip4_dhcp.to_line x       = ''; each do | i | x += i + ", " end; x.chomp(", "); end

				interfaces << 
				{
					'id'               => interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_ID ),
					'type'             => interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_TYPE ),
					'name'             => interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_NAME ),
					'description'      => interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_DESCRIPTION ),
					'bridged'          => interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_BRIDGED ),
					'physical_address' => interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_PHYSICAL_ADDRESS ),
					'mtu'              => interface.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_MTU ),
					'ip4_address'      => ip4_address,
					'ip4_subnetmask'   => ip4_subnetmask,
					'ip4_gateway'      => ip4_gateway,
					'ip4_dns'          => ip4_dns,
					'ip4_dhcp'         => ip4_dhcp,
				}
				
			end
		end
		
		return interfaces
		
	end
	
	#
	# Helper function to generate a random MAC address (ensuring we clear the multicast bit in the address)
	#
	def random_mac
		mac = ""
		multicast_bit = true
		1.upto(6) do
			byte  = rand(256)
			byte &= 0xFE if multicast_bit
			mac  += "%02X:" % byte
			multicast_bit = false
		end
		return mac.chomp(":")
	end
	
	#
	# Create a new local virtual network interface for pivoting.
	#
	# Parameters:
	#     id   - The ID of the remote network interface to bridge with when creating the virtual interfaces, e.g. 0
	#     opts - A hash of the options to use, e.g. 'msftapd_host', 'msftapd_port', 'msftapd_ssl', 'mac', 'compression'
	#
	def create_pivot( id, opts={} )
		# fail if we dont have the correct params
		raise "Invalid parameters, no interface ID provided." if( not id )
		# if we havent been supplied a MAC generate a random one to use
		if( not opts['mac'] )
			opts['mac'] = self.random_mac
		end
		# parse the given MAC address into a bytestring
		physical_address = ""
		physical_index   = 0
		opts['mac'].split( ":" ).each do | byte |
			raise "Invalid MAC address (#{opts['mac']}). he multicast bit is set." if( byte.to_i(16) & 1 == 1 and physical_index == 0 )
			physical_address += [ byte.to_i(16) ].pack( "C" )
			physical_index   += 1
		end
		# fail if we couldnt parse the given MAC address into a bytestring
		raise "Invalid MAC address (#{opts['mac']}) provided." if physical_address.length != 6
		# get the details about the remote interface we are bridging with
		bridge = get_remote_interface( id )
		# fail if we couldnt get the info
		raise "Invalid parameters." if( not bridge )
		# create remote virtual interface...
		request = Packet.create_request(COMMAND_ID_PIVOT_CREATE_PIVOT)
		# specify which interface on the meterpreter host to bridge with
		request.add_tlv( TLV_TYPE_PIVOT_INTERFACE_ID, bridge['id'] )
		# specify what MAC address to use for the new virtual interface
		request.add_tlv( TLV_TYPE_PIVOT_INTERFACE_PHYSICAL_ADDRESS, physical_address )
		# specify whether of not to use compression for channel IO (for performance testing)
		request.add_tlv( TLV_TYPE_PIVOT_INTERFACE_COMPRESSION, opts['compression'] )
		# send the request
		response = client.send_request( request )
		# and make sure it succeeded...
		if( response.result == 0 )
			# get the new channel ID for the client/server virtual interface IO
			cid = response.get_tlv_value( TLV_TYPE_PIVOT_INTERFACE_CID )
			# override the default MTU option for the new TAP to match its bridged counterparts MTU
			opts['mtu'] = bridge['mtu'] if bridge['mtu']
			# and get a suitable TAP driver for this OS bound to a meterpreter channel 
			tap = nil
			if( opts['msftapd_host'] )
				tap = Tap::RemoteTap.new( client, cid, bridge, opts )
			else
				tap = Tap::LocalTap.new( client, cid, bridge, opts )
			end
			if( tap.open )
				# save this new tap interface to a list of taps on this client.
				@taps << tap
				# pass it pack to the caller (who is responsible for configuring the new TAP as it wants)
				return tap
			end
		end
		# failure!
		return nil
	end
	
	#
	# Destroy an existing local virtual network interface.
	#
	# Parameters:
	#     id  - The ID of the remote network interface that was bridged with when creating the virtual interfaces.
	#
	def destroy_pivot( id )
		# get the tap associated with this ID
		tap = get_tap( id )
		if( tap )
			# bring down remote virtual interface, the local virtual interface and the channel stream...
			if( tap.close )
				@taps.delete( tap )
				return true
			end
		end
		return false
	end
	
	#
	# Set an IPv4 address for a pivoted virtual network.
	#
	def pivot_set_ip( id, ip )
		# get the tap associated with this ID
		tap = get_tap( id )
		if( tap )
			netmask = tap.bridge['ip4_subnetmask'].length > 0 ? tap.bridge['ip4_subnetmask'][0] : nil
			if( netmask )
				return tap.set_ip4_address( ip, netmask )
			end
		end
		return false
	end
	
	#
	# Helper function to get a remote interface on the server side with a specific ID.
	#
	def get_remote_interface( id )
		interfaces = self.list_interfaces
		interfaces.each do | interface |
			return interface if( interface['id'] == id )
		end
		return nil
	end
	
	#
	# Helper function to get a local TAP interface via a remote bridged interface ID.
	#
	def get_tap( id )
		@taps.each do | tap |
			if( tap.bridge['id'] == id )
				return tap
			end
		end
		return nil
	end
	
end

end; end; end; end; end
