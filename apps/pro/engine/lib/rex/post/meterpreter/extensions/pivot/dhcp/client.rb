require 'timeout'
require 'packetfu'
require 'rex/logging'
require 'rex/post/meterpreter/extensions/pivot/dhcp/packet'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module DHCP

#
# A DHCP Client.
#
# RFC2131 - Dynamic Host Configuration Protocol - http://tools.ietf.org/html/rfc2131
# RFC1533 - DHCP Options and BOOTP Vendor Extensions - http://tools.ietf.org/html/rfc1533
#
class Client

	SERVER_PORT	= 67
	CLIENT_PORT	= 68
		
	FRAME_IP	= 0x0800
	PROTO_UDP	= 17
		
	def initialize( tap )
	
		@tap       = tap
		@broadcast = '255.255.255.255'

		@acquired = {
			'ip4_address' => nil,
			'ip4_dns'     => nil,
			'ip4_domain'  => nil,
			'ip4_dhcp'    => nil,
			'ip4_gateway' => nil,
		}
		
		@queue = ::Queue.new
	end
	
	#
	# A TAP filter for the DHCP client.
	#
	class Filter

		def initialize( queue )
			@queue = queue
		end

		#
		# Process any frames being received and add DHCP responses to the clients incoming packet queue.
		#
		def process( transmit, frame )
			# process a frame being received...
			if( not transmit )
				type = frame[12..13].unpack( 'n' ).first
				# if its an IPv4 packet...
				if( type == FRAME_IP )
					protocol = frame[23..23].unpack( 'C' ).first
					# and if its UDP datagram...
					if( protocol == PROTO_UDP )
						# pull out the source/dest ports...
						ihl      = ( frame[14..14].unpack( 'C' ).first & 0x0F ) * 4
						src_port = frame[(14+ihl)..(15+ihl)].unpack( 'n' ).first
						dst_port = frame[(16+ihl)..(17+ihl)].unpack( 'n' ).first
						# if we have a DHCP response...
						if( src_port == SERVER_PORT and dst_port == CLIENT_PORT )
							# add it to the queue for processing
							@queue << frame[(22+ihl)..frame.length]
							# drop the frame as we will handle it ourselves
							return nil
						end
					end
				end

			end
			# return the frame to the next filter...
			return frame
		end
		
	end
	
	#
	# Send a UDP packet out the TAP interface.
	#
	def sendto( data, src_ip, src_port, dst_ip, dst_port, src_mac=nil, dst_mac=nil )
	
		frame = PacketFu::UDPPacket.new
		frame.eth_saddr = src_mac ? src_mac : @tap.opts['mac']
		frame.eth_daddr = dst_mac ? dst_mac : "ff:ff:ff:ff:ff:ff"
		frame.ip_ttl = 128
		frame.ip_saddr = src_ip
		frame.ip_daddr = dst_ip
		frame.udp_sport = src_port
		frame.udp_dport = dst_port
		frame.payload = data
		frame.recalc
		return @tap.inject( frame.to_s )
	end

	#
	# Acquire an IP address from a DHCP server.
	#
	def acquire( timeout=60 )
		tries    = 5
		filter   = nil
		result   = false
		accepted = false
		timeout  = timeout/tries
		
		begin
			# add a filter to the underlying TAP device so we can capture DHCP responses
			filter = Filter.new( @queue )
			@tap.add_filter( filter )

			worker =  Rex::ThreadFactory.spawn("TapDHCPWorker", false) do 
			
				begin
					# create the DHCP packet whch keeps state, for processing requests/responses
					packet = Packet.new( @tap.opts['mac'] )

					loop do
						
						# if we have not been offered an IP address, we issue a DHCP Discover request (at most 5 times)
						if( not accepted )
							self.sendto( packet.dhcp_discover, '0.0.0.0', CLIENT_PORT, @broadcast, SERVER_PORT )
							tries -= 1
						end
						
						# wait for some packets to arrive
						pkt = ''
						begin
							::Timeout.timeout( timeout ) do
								pkt = @queue.pop
							end
						rescue
							# if we have tried enough times we just have to concead we couldnt get a good offer
							break if( tries == 0 )
							# if we havent gotten an offer yet keep trying to solicit one
							next if( not accepted )
							# if we already sent a request but timed out trying to receive a response, send the request again
							if( packet.is_dhcp_request? )
								self.sendto( packet.dhcp_request, '0.0.0.0', CLIENT_PORT, @broadcast, SERVER_PORT )
								tries -= 1
								next
							end
							# if we end up here we cant go any further
							break
						end
						
						# the XID of the incoming packets must match that of our origional dhcp_discover packets if we are to process them
						next if( not packet.check_xid( pkt ) )
						
						# if parsing the new packet failed we finish with failure
						break if( not packet.from_pkt( pkt ) )
						
						# if we somehow got a packet that is not a response continue the loop
						next if( not packet.is_response? )
						
						# if we have received a DHCP offer and have not allready accepted a previous offer, accept this one
						if( packet.is_dhcp_offer? and not accepted )
							self.sendto( packet.dhcp_request, '0.0.0.0', CLIENT_PORT, @broadcast, SERVER_PORT )
							# reset the tries conter as we may need to send more than one ACK response
							tries    = 5
							accepted = true
							next
						# if we have received a DHCP Acknowledgment we have now acquired an IP address and can finish with success
						elsif( packet.is_dhcp_ack? )
							# record our newly acquired IP address...
							@acquired['ip4_address'] = Rex::Socket.addr_itoa( packet.header['yiaddr'] )
							# as well as any other useful info that came back...
							@acquired['ip4_dhcp']    = Rex::Socket.addr_itoa( packet.option( Packet::SERVER_IDENTIFIER ) ) if packet.option( Packet::SERVER_IDENTIFIER )
							@acquired['ip4_gateway'] = Rex::Socket.addr_itoa( packet.option( Packet::ROUTER ) ) if packet.option( Packet::ROUTER )
							@acquired['ip4_dns']     = Rex::Socket.addr_itoa( packet.option( Packet::DNS_SERVER ) ) if packet.option( Packet::DNS_SERVER )
							@acquired['ip4_domain']  = packet.option( Packet::DOMAIN_NAME ) if packet.option( Packet::DOMAIN_NAME )
							result = true
							break
						# server sent back a NAK, log the error message and finish...
						elsif( packet.is_dhcp_nak? )
							message = packet.option( Packet::MESSAGE ) ? packet.option( Packet::MESSAGE ) : "<unspecified>"
							wlog( "DHCP server responded with a NAK: #{message}" )
							result = false
							break
						end
						
					end
					
				rescue ::Exception => e
					wlog( "Exception caught in DHCP::Client worker thread: #{e}" )
					::Thread.exit
				end
				
			end
			
			# wait for the worker thread to finish...
			worker.join
			
		rescue ::Exception => e
			wlog( "Exception caught in DHCP::Client.acquire: #{e}" )
			result = false
		ensure
			@tap.remove_filter( filter ) if filter
		end
		
		return result
	end
	
	attr_reader :acquired
	
end

end; end; end; end; end; end
