module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module DHCP

class Packet

	TYPE_ETHERNET			= 1
	
	# Options
	PAD_OPTION				= 0
	SUBNET_MASK				= 1
	TIME_OFFSET				= 2
	ROUTER					= 3
	TIME_SERVER				= 4
	NAME_SERVER				= 5
	DNS_SERVER				= 6
	LOG_NAME_SERVER			= 7
	COOKIE_NAME_SERVER		= 8
	LPR_NAME_SERVER			= 9
	IMPRESS_NAME_SERVER		= 10
	RESOURCE_NAME_SERVER	= 11
	HOST_NAME				= 12
	BOOT_FILE_SIZE			= 13
	MERIT_DUMP_FILE			= 14
	DOMAIN_NAME				= 15
	SWAP_SERVER				= 16
	ROOT_PATH				= 17
	EXTENSIONS_PATH			= 18
	IP_FORWARDING			= 19
	NONLOCAL_SOURCE_ROUTING	= 20
	POLICY_FILTER			= 21
	MAX_DATAGRAM_REASSEMBLY	= 22
	IP_TTL					= 23
	PATH_MTU_TIMEOUT		= 24
	PATH_MTU_PLATEAU		= 25
	INTERFACE_MTU			= 26
	ALL_SUBNETS_ARE_LOCAL	= 27
	BROADCAST_ADDRESS		= 28
	REQUESTED_IP_ADDRESS	= 50
	IP_ADDRESS_LEASE_TIME	= 51
	DHCP_MESSAGE_TYPE		= 53
	SERVER_IDENTIFIER		= 54
	PARAMETER_REQUEST_LIST	= 55
	MESSAGE					= 56
	CLIENT_IDENTIFIER		= 61
	END_OPTION				= 255
	
	DHCP_MAGIC				= 0x63825363

	BOOTREQUEST				= 1
	BOOTREPLY				= 2

	DHCPDISCOVER			= 1
	DHCPOFFER				= 2
	DHCPREQUEST				= 3
	DHCPDECLINE				= 4
	DHCPACK					= 5
	DHCPNAK					= 6
	DHCPRELEASE				= 7
	DHCPINFORM				= 8
	
	#
	#
	#
	def initialize( mac, broadcast=true )
		@mac       = mac
		@broadcast = broadcast
		@xid       = rand( 0xFFFFFFFF )
		@physical_address = ""
		@mac.split( ":" ).each do | byte |
			@physical_address += [ byte.to_i(16) ].pack( "C" )
		end
		@header    = {}
		@options   = {}
		self.reset
	end
	
	#
	#
	#
	def reset
	
		@header['op']     = BOOTREQUEST
		@header['htype']  = TYPE_ETHERNET
		@header['hlen']   = @physical_address.length
		@header['hops']   = 0
		@header['xid']    = @xid
		@header['secs']   = 0
		@header['flags']  = @broadcast ? 0x8000 : 0x0000
		@header['ciaddr'] = 0
		# dont reset our yiaddr if we have been given one
		@header['yiaddr'] = @header['yiaddr'] ? @header['yiaddr'] : 0
		@header['siaddr'] = 0
		@header['giaddr'] = 0
		@header['chaddr'] = @physical_address
		@header['sname']  = ""
		@header['file']   = ""
		
		@options.clear

	end
	
	#
	#
	#
	def dhcp_discover( parameters=[ ROUTER, SUBNET_MASK, DOMAIN_NAME, DNS_SERVER, SERVER_IDENTIFIER ] )
		
		self.reset
		
		cid    = [ TYPE_ETHERNET ].pack( 'C' ) + @physical_address
		params = parameters.pack( 'C*' )
		
		@options[ DHCP_MESSAGE_TYPE ]      = [ 1, DHCPDISCOVER ]
		@options[ CLIENT_IDENTIFIER ]      = [ cid.length, cid ]
		@options[ PARAMETER_REQUEST_LIST ] = [ params.length, params ]
		 
		return self.to_pkt
	end
	
	#
	#
	#
	def dhcp_request
	
		requested_ip = @header['yiaddr']
		
		self.reset
		
		cid = [ TYPE_ETHERNET ].pack( 'C' ) + @physical_address
		
		@options[ DHCP_MESSAGE_TYPE ]    = [ 1, DHCPREQUEST ]
		@options[ CLIENT_IDENTIFIER ]    = [ cid.length, cid ]
		@options[ REQUESTED_IP_ADDRESS ] = [ 4, requested_ip ]

		return self.to_pkt
	end
	
	#
	#
	#
	def check_xid( data )
	
		return false if not data

		return false if data.length < 240
		
		return false if data[4..7].unpack( "N" ).first != @header['xid']
		
		return true
	end
	
	#
	#
	#
	def from_pkt( data )
	
		return false if not data

		return false if data.length < 240
		
		return false if data[236..239].unpack( "N" ).first != DHCP_MAGIC
		
		self.reset
		
		@header['op']     = data[0..0].unpack( "C" ).first
		@header['htype']  = data[1..1].unpack( "C" ).first
		@header['hlen']   = data[2..2].unpack( "C" ).first
		@header['hops']   = data[3..3].unpack( "C" ).first
		@header['xid']    = data[4..7].unpack( "N" ).first
		@header['secs']   = data[8..9].unpack( "n" ).first
		@header['flags']  = data[10..11].unpack( "n" ).first
		@header['ciaddr'] = data[12..15].unpack( "N" ).first
		@header['yiaddr'] = data[16..19].unpack( "N" ).first
		@header['siaddr'] = data[20..23].unpack( "N" ).first
		@header['giaddr'] = data[24..27].unpack( "N" ).first
		@header['chaddr'] = data[28..(28+@header['hlen'])]
		@header['sname']  = data[44..107].gsub( "\x00", "" )
		@header['file']   = data[108..235].gsub( "\x00", "" )

		data = data[240..data.length]

		loop do
			type = data[0..0].unpack( "C" ).first

			break if type == END_OPTION
	
			if( type == PAD_OPTION )
				data = data[1..data.length]
				next
			end
			
			length = data[1..1].unpack( "C" ).first

			value = data[2..1+length]

			case length
				when 1
					value = value.unpack( "C" ).first
				when 2
					value = value.unpack( "n" ).first
				when 4
					value = value.unpack( "N" ).first
			end
			
			@options[ type ] = [ length, value ]

			data = data[(2+length)..data.length]
		end
		
		return true
	end
	
	#
	#
	#
	def to_pkt
		data  = [ @header['op'] ].pack( "C" )
		data += [ @header['htype'] ].pack( "C" )
		data += [ @header['hlen'] ].pack( "C" )
		data += [ @header['hops'] ].pack( "C" )
		data += [ @header['xid'] ].pack( "N" )
		data += [ @header['secs'] ].pack( "n" )
		data += [ @header['flags'] ].pack( "n" )
		data += [ @header['ciaddr'] ].pack( "N" )
		data += [ @header['yiaddr'] ].pack( "N" )
		data += [ @header['siaddr'] ].pack( "N" )
		data += [ @header['giaddr'] ].pack( "N" )
		data += @header['chaddr'] + "\x00" * ( 16 - @header['chaddr'].length )
		data += @header['sname'] + "\x00" * ( 64 - @header['sname'].length )
		data += @header['file'] + "\x00" * ( 128 - @header['file'].length )
		data += [ DHCP_MAGIC ].pack( "N" )
		@options.each_pair do | type, lenval |
			length, value = lenval
			next if( length > 255 )
			if( value.class == ::Integer or value.class == ::Bignum )
				if( length == 1 )
					data += [ type ].pack( "C" ) + [ length ].pack( "C" ) + [ value ].pack( "C" )
				elsif( length == 2 )
					data += [ type ].pack( "C" ) + [ length ].pack( "C" ) + [ value ].pack( "n" )
				elsif( length == 4 )
					data += [ type ].pack( "C" ) + [ length ].pack( "C" ) + [ value ].pack( "N" )
				end
			else
				data += [ type ].pack( "C" ) + [ length ].pack( "C" ) + value.to_s
			end
		end
		data += [ 0xFF ].pack( "C" )
		data += "\x00" * ( 548 - data.length ) if( data.length < 548 )
		while( data.length % 4 != 0 )
			data += "\x00"
		end
		return data
	end
	
	def is_request?
		@header['op'] == BOOTREQUEST ? true : false
	end
	
	def is_response?
		@header['op'] == BOOTREPLY ? true : false
	end
	
	def option( type )
		@options.has_key?( type ) ? @options[ type ][1] : nil
	end
	
	def is_dhcp_discover?
		option( DHCP_MESSAGE_TYPE ) == DHCPDISCOVER ? true : false
	end
	
	def is_dhcp_offer?
		option( DHCP_MESSAGE_TYPE ) == DHCPOFFER ? true : false
	end
	
	def is_dhcp_request?
		option( DHCP_MESSAGE_TYPE ) == DHCPREQUEST ? true : false
	end
	
	def is_dhcp_decline?
		option( DHCP_MESSAGE_TYPE ) == DHCPDECLINE ? true : false
	end
	
	def is_dhcp_ack?
		option( DHCP_MESSAGE_TYPE ) == DHCPACK ? true : false
	end
	
	def is_dhcp_nak?
		option( DHCP_MESSAGE_TYPE ) == DHCPNAK ? true : false
	end
	
	def is_dhcp_release?
		option( DHCP_MESSAGE_TYPE ) == DHCPRELEASE ? true : false
	end
	
	attr_reader :header
end

end; end; end; end; end; end
