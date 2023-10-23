require 'rex/logging'
require 'rex/socket'
require 'rex/post/meterpreter/channel'
require 'rex/post/meterpreter/extensions/pivot/dhcp/client'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap

#
# The basic functions used by both LocalTap and RemoteTap.
#
module BasicTap

	#
	# Mixin to create a channel suitable for communication with this TAP
	#
	module TapChannel
			
		class << self
			def cls
				return CHANNEL_CLASS_STREAM
			end
		end
			
		#
		# write frames from the remote interface to the TAP driver interface...
		#
		def dio_write_handler( packet, data )
			begin
				self.tap.rx_frames( data )
			rescue
				wlog( "TapChannel.dio_write_handler - #{$!}" )
			end
			return true
		end
			
		attr_accessor :tap
	end
	
	#
	#
	#
	def initialize_tap( client, cid, bridge, opts={}, packet, **_ )
		# the default options for this TAP interface
		@opts = {
			'compression'     => true,
			'mtu'             => 1500,
			'mac'             => '00:11:22:33:44:55',
			'ip4_address'     => nil,
			'ip6_address'     => nil,
			'ip4_subnetmask'  => nil,
			'ip4_gateway'     => nil,
			'ip6_gateway'     => nil,
			'ip4_broadcast'   => nil,
			'ip4_dns'         => nil,
			'ip4_domain'      => nil,
			'ip4_dhcp'        => nil,
		}
		# merge in any non default options
		@opts     = @opts.merge( opts )
		# the name of the virtual interface
		@name     = ""
		# a reference to a dictionary of data describing the interface we are bridging with server side
		@bridge   = bridge
		# bring up a TAP channel to bind the local and remote virtual interfaces together...
		@channel  = Rex::Post::Meterpreter::Channel.new( client, cid, 'pivot', @opts['compression'] ? CHANNEL_FLAG_COMPRESS : 0, packet, **_ )
		# extend the channel to work as a TapChannel
		@channel.extend( TapChannel )
		# and add in a reference to this tap
		@channel.tap = self
		# we keep a list of filters attached to this TAP
		@filters  = ::Array.new
		# we keep a dictionary of services available on this interface
		@services = ::Hash.new
		# keep a record of if the tap has been closed
		@closed   = false
	end

	#
	# If this TAP has been closed previously we will return true, else false.
	#
	def is_closed?
		return @closed
	end
	
	#
	# Configures the IPv4 address for this virtual network interface via DHCP.
	#
	def configure_via_dhcp( set_ip=true, set_dns=true, set_gateway=true )
		begin
			raise "No MAC address specified" if( not @opts['mac'] )

			bridge_ip = @bridge['ip4_address'].length > 0 ? @bridge['ip4_address'][0] : nil
			netmask   = @bridge['ip4_subnetmask'].length > 0 ? @bridge['ip4_subnetmask'][0] : nil

			raise "Could not determine the bridged interfaces IP or netmask" if( not bridge_ip or not netmask )

			network = Rex::Socket.addr_itoa( Rex::Socket.addr_atoi( bridge_ip ) & Rex::Socket.addr_atoi( netmask ) )

			@opts['ip4_broadcast'] = Rex::Socket.addr_itoa( Rex::Socket.addr_atoi( network ) | ~Rex::Socket.addr_atoi( netmask ) )

			# acquire an IP address via DHCP (and discover the DNS/Gateway/DHCP servers present)
			@services['dhcp'] = Rex::Post::Meterpreter::Extensions::Pivot::DHCP::Client.new( self ) if( not @services['dhcp'] )
			raise "The DHCP client failed to acquire an IP address" if( not @services['dhcp'].acquire )
			
			# bring up the interface with this IP address
			if( set_ip and @services['dhcp'].acquired['ip4_address'] )
				set_ip4_address( @services['dhcp'].acquired['ip4_address'], netmask )
			end

			# add the DNS server (if available)
			if( set_dns and @services['dhcp'].acquired['ip4_dns'] )
				add_ip4_dns( @services['dhcp'].acquired['ip4_dns'] )
			end
			
			# if there is a gateway we can set it to be the hosts default
			if( set_gateway and @services['dhcp'].acquired['ip4_gateway'] )
				set_ip4_default_gateway( @services['dhcp'].acquired['ip4_gateway'] )
			end
			
			# store whatever extra info we were able to acquire...
			@opts['ip4_domain'] = @services['dhcp'].acquired['ip4_domain']
			@opts['ip4_dhcp']   = @services['dhcp'].acquired['ip4_dhcp']

		rescue
			wlog( "BasicTap.configure_via_dhcp - #{$!}" )
			return false
		end
		return true
	end
	
	#
	# Attach a filter to this TAP which will be called upon every frame transmit/receive
	# See Rex::Post::Meterpreter::Extensions::Pivot::DHCP::Client for an example of using a filter.
	#
	def add_filter( filter )
		@filters << filter
	end
	
	#
	# Remove a previously attached filter from this TAP.
	#
	def remove_filter( filter )
		@filters.delete( filter )
	end

	#
	# Inject a single frame out the wire as if it came from the TAP driver.
	# Note: Injected frames are not subjected to filters.
	#
	def inject( frame )
		raise "TAP has been closed (BasicTap.inject)." if( self.is_closed? )
		data = [ frame.length ].pack( 'N' ) + frame + [ 0 ].pack( 'N' )
		return @channel.write( data ) == data.length ? frame.length : 0
	end
	
	#
	# Write a group of transmited frames out the meterpreter side virtual interface
	#
	def tx_frames( frames )
		raise "TAP has been closed (BasicTap.tx_frames)." if( self.is_closed? )
		@channel.write( filter( true, frames ) )
		return true
	end

	#
	# Run the filters over a group of transmitted/received frames
	#
	def filter( transmit, frames )
		data   = ''
		offset = 0
		# loop through the frames in the group...
		loop do
			# get the length of the current frame of data (or null terminator)
			length = frames[offset..(offset+3)].unpack( 'N' ).first
			break if( length == 0 )
			# pull out the frame
			frame = frames[(offset+4)..(offset+length+3)]
			# let the filters modify/drop the incoming frame...
			@filters.each do | filter |
				break if not frame
				begin
					frame = filter.process( transmit, frame )
				rescue ::Exception => e
					wlog( "Exception caught in BasicTap.filter_frames - filter.process: #{e}" )
				end
			end
			# if the filters have not dropped this frame add it back into the group to send
			if( frame )
				data << [ frame.length ].pack( 'N' ) << frame
			end
			# move on to the next frame
			offset += length + 4
		end
		# append the null terminator to the frame group
		data << [ 0 ].pack( 'N' )
		return data
	end
	
	attr_reader :name, :opts, :bridge, :services

end

end; end; end; end; end; end
