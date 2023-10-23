require 'ipaddr'
require 'thread'
require 'rex/logging'
require 'rex/socket'
require 'rex/post/meterpreter/extensions/pivot/tap/daemon/factory'
require 'rex/post/meterpreter/extensions/pivot/tap/daemon/tap'
require 'rex/post/meterpreter/extensions/pivot/tap/proto'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap
module Daemon

#
# The TapDaemons class to handle a TapClient connection 
#
class TapClient < Rex::Post::Meterpreter::Extensions::Pivot::Tap::Proto
	
	MAX_FRAMES_FLUSH = 64
	
	def initialize( sock )
		super( sock )
		@tap     = nil
		@monitor = nil
	end
		
	def stop
		super()
		self.stop_tap_monitor
		@tap.close if @tap
	end
		
	#
	# handler for incoming requests from the msftapd client
	#
	def request_handler( client, packet )
		handled = true

		case packet.method
			when 'create_tap'
				create_tap( packet )
			when 'destroy_tap'
				destroy_tap( packet )
			when 'set_ip4_address'
				set_ip4_address( packet )
			when 'add_ip4_arp_entry'
				add_ip4_arp_entry( packet )
			when 'remove_ip4_arp_entry'
				remove_ip4_arp_entry( packet )
			when 'remove_ip4_dns'
				remove_ip4_dns( packet )
			when 'add_ip4_dns'
				add_ip4_dns( packet )
			when 'add_ip4_route'
				add_ip4_route( packet )
			when 'remove_ip4_route'
				remove_ip4_route( packet )
			when 'set_ip4_default_gateway'
				set_ip4_default_gateway( packet )
			when 'set_ip6_address'
				set_ip6_address( packet )
			when 'add_ip6_route'
				add_ip6_route( packet )
			when 'remove_ip6_route'
				remove_ip6_route( packet )
			when 'rx_frames'
				begin
					frames = packet.get_tlv_value( TLV_TYPE_FRAMES )
					offset = 0
					# loop through the frames in the group...
					loop do
						# get the length of the current frame of data (or null terminator)
						length = frames[offset..(offset+3)].unpack( 'N' ).first
						break if( length == 0 )
						# pull out the frame and write it to the TAP
						@tap.write_frame( frames[(offset+4)..(offset+length+3)] ) if @tap
						# move on to the next frame
						offset += length + 4
					end
				rescue
					wlog( "[TAP DAEMON] TapClient.request_handler - write_frames - #{$!}" )
				end
			else
				handled = false
		end
			
		return handled
	end
	
	private
	
	def create_tap( request )
		begin
			@tap.close if @tap
				
			mac = request.get_tlv_value( TLV_TYPE_MAC )	
			if !Rex::Socket.is_mac_addr?(mac)
				raise "Invalid MAC address #{mac}"				
			end

			mtu = request.get_tlv_value( TLV_TYPE_MTU )
			if !is_integer?(mtu)
				raise "MTU not an integer #{mtu}"				
			end
				
			response = create_response( request )
			
			begin
				factory = Factory.instance
					
				@tap = factory.create( mac, mtu )
			rescue
				@tap = nil
				wlog( "[TAP DAEMON] TapClient.create_tap - factory.create - #{$!}" )
			end
				
			if( @tap )
				self.start_tap_monitor
				response.add_tlv( TLV_TYPE_NAME, @tap.name )
				response.result = RESULT_SUCCESS
			end
				
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.create_tap - #{$!}" )
			return false
		end
		return true
	end
	
	def destroy_tap( request )
		begin
			response = create_response( request )
			begin
				@tap.close if @tap
				self.stop_tap_monitor
				response.result = RESULT_SUCCESS
			rescue
				wlog( "[TAP DAEMON] TapClient.destroy_tap - closing - #{$!}" )
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.destroy_tap - #{$!}" )
			return false
		end
		return true
	end
	
	def set_ip4_address( request )
		begin
			address  = request.get_tlv_value( TLV_TYPE_ADDRESS )
			if !is_ip_addr?(address)
				raise "Invalid IP address #{address}"
			end
			netmask  = request.get_tlv_value( TLV_TYPE_NETMASK )
			if !is_ip_addr?(netmask)
				raise "Invalid netmask #{netmask}"
			end
			response = create_response( request )
			if( @tap and @tap.set_ip4_address( address, netmask ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.set_ip4_address - #{$!}" )
			return false
		end
		return true
	end
	
	def add_ip4_arp_entry( request )
		begin
			ip       = request.get_tlv_value( TLV_TYPE_ADDRESS )
			if !is_ip_addr?(ip)
				raise "Invalid IP address #{ip}"
			end
			mac      = request.get_tlv_value( TLV_TYPE_MAC )
			if !Rex::Socket.is_mac_addr?(mac)
				raise "Invalid MAC address #{mac}"				
			end
			response = create_response( request )
			if( @tap and @tap.add_ip4_arp_entry( ip, mac ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.add_ip4_arp_entry - #{$!}" )
			return false
		end
		return true
	end
	
	def remove_ip4_arp_entry( request )
		begin
			ip       = request.get_tlv_value( TLV_TYPE_ADDRESS )
			if !is_ip_addr?(ip)
				raise "Invalid IP address #{ip}"
				return false
			end
			response = create_response( request )
			if( @tap and @tap.remove_ip4_arp_entry( ip ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.remove_ip4_arp_entry - #{$!}" )
			return false
		end
		return true
	end
	
	def remove_ip4_dns( request )
		begin
			nameserver = request.get_tlv_value( TLV_TYPE_NAMESERVER )
			response   = create_response( request )
			if( @tap and @tap.remove_ip4_dns( nameserver ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.remove_ip4_dns - #{$!}" )
			return false
		end
		return true
	end
	
	def add_ip4_dns( request )
		begin
			nameserver = request.get_tlv_value( TLV_TYPE_NAMESERVER )
			response   = create_response( request )
			if( @tap and @tap.add_ip4_dns( nameserver ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.add_ip4_dns - #{$!}" )
			return false
		end
		return true
	end
	
	def add_ip4_route( request )
		begin
			network  = request.get_tlv_value( TLV_TYPE_NETWORK )
			if !is_ip_addr?(network)
				raise "Invalid network address #{network}"
			end			
			netmask  = request.get_tlv_value( TLV_TYPE_NETMASK )
			if !is_ip_addr?(netmask)
				raise "Invalid netmask #{netmask}"
			end		
			response = create_response( request )
			if( @tap and @tap.add_ip4_route( network, netmask ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.add_ip4_route - #{$!}" )
			return false
		end
		return true
	end
	
	def remove_ip4_route( request )
		begin
			network  = request.get_tlv_value( TLV_TYPE_NETWORK )
			if !is_ip_addr?(network)
				raise "Invalid network address #{network}"
			end	
			netmask  = request.get_tlv_value( TLV_TYPE_NETMASK )
			if !is_ip_addr?(netmask)
				raise "Invalid netmask #{netmask}"
			end
			response = create_response( request )
			if( @tap and @tap.remove_ip4_route( network, netmask ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.remove_ip4_route - #{$!}" )
			return false
		end
		return true
	end
	
	def set_ip4_default_gateway( request )
		begin
			gateway  = request.get_tlv_value( TLV_TYPE_GATEWAY )
			if !is_ip_addr?(gateway)
				raise "Invalid gateway #{gateway}"
			end	
			response = create_response( request )
			if( @tap and @tap.set_ip4_default_gateway( gateway ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.set_ip4_default_gateway - #{$!}" )
			return false
		end
		return true
	end
	
	def set_ip6_address( request )
		begin
			address  = request.get_tlv_value( TLV_TYPE_ADDRESS )
			if !is_ip_addr?(address)
				raise "Invalid IP address #{address}"
			end
			response = create_response( request )
			if( @tap and @tap.set_ip6_address( address ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.set_ip6_address - #{$!}" )
			return false
		end
		return true
	end
	
	def add_ip6_route( request )
		begin
			network  = request.get_tlv_value( TLV_TYPE_NETWORK )
			if !is_ip_addr?(network)
				raise "Invalid network address #{network}"
			end
			gateway  = request.get_tlv_value( TLV_TYPE_GATEWAY )
			if !is_ip_addr?(gateway)
				raise "Invalid gateway #{gateway}"
			end
			response = create_response( request )
			if( @tap and @tap.add_ip6_route( network, gateway ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.add_ip6_route - #{$!}" )
			return false
		end
		return true
	end
	
	def remove_ip6_route( request )
		begin
			network  = request.get_tlv_value( TLV_TYPE_NETWORK )
			if !is_ip_addr?(network)
				raise "Invalid network address #{network}"
			end
			netmask  = request.get_tlv_value( TLV_TYPE_NETMASK )
			if !is_ip_addr?(netmask)
				raise "Invalid netmask #{netmask}"
			end
			response = create_response( request )
			if( @tap and @tap.remove_ip6_route( network, netmask ) )
				response.result = RESULT_SUCCESS
			end
			send_packet( response )
		rescue
			wlog( "[TAP DAEMON] TapClient.remove_ip6_route - #{$!}" )
			return false
		end
		return true
	end

	def is_ip_addr?( address )
		begin
			IPAddr.new address
		rescue IPAddr::InvalidAddressError
			return false
		end
		return true
	end

	def is_integer?( mtu )
		!(mtu =~ /\A\d+\z/).nil?
	end
	
protected

	def stop_tap_monitor
		@monitor.kill if ( @monitor and @monitor.alive? )
		@monitor = nil
	end
		
	def start_tap_monitor
		# monitor the local TAP interface to see if there are any frames pending
		@monitor = Rex::ThreadFactory.spawn("TapMonitor", false) do 
			begin
				loop do
					next if not @tap.select( 0.5 )
					frames = ''
					# try to read up to 64 frames from the TAP's tx queue...
					1.upto( MAX_FRAMES_FLUSH ) do
						begin
							frame = @tap.read_frame
							break if( frame == nil )
						rescue ::EOFError => e
							raise e
						rescue ::Errno::EAGAIN
							break
						end
						frames << [ frame.length ].pack( 'N' ) << frame
					end
					if( frames.length != 0 )
						# write the frames out the wire (and append 0 to indicate the end of the frame list).
						frames << [ 0 ].pack( 'N' )
						request = Packet.create_request( 'tx_frames' )
						request.add_tlv( TLV_TYPE_FRAMES, frames )
						send_packet( request )
					end
				end
			rescue
				wlog( "[TAP DAEMON] TapClient.start_tap_monitor - thread - #{$!}" )
				@tap.close
				::Thread.exit
			end
		end
			
		return true
	end
	
end
	
end; end; end; end; end; end; end
