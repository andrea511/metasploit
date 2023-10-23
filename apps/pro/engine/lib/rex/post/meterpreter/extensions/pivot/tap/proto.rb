require 'thread'
require 'rex/post/meterpreter/packet'
require 'rex/post/meterpreter/packet_parser'
require 'rex/post/meterpreter/inbound_packet_handler'
require 'rex/post/meterpreter/packet_dispatcher'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap

#
# A superclass for the client and server side of the TAP Daemon to inherit 
# from for packet exchange by reusing the Meterpreter packet comm routines.
#
class Proto

	RESULT_SUCCESS         = 1
	RESULT_FAILURE         = 0
		
	TLV_TYPE_FRAMES        = TLV_META_TYPE_RAW    | 1000
	TLV_TYPE_ADDRESS       = TLV_META_TYPE_STRING | 1001
	TLV_TYPE_NETWORK       = TLV_META_TYPE_STRING | 1002
	TLV_TYPE_NETMASK       = TLV_META_TYPE_STRING | 1003
	TLV_TYPE_NAMESERVER    = TLV_META_TYPE_STRING | 1004
	TLV_TYPE_GATEWAY       = TLV_META_TYPE_STRING | 1005
	TLV_TYPE_MAC           = TLV_META_TYPE_STRING | 1006
	TLV_TYPE_NAME          = TLV_META_TYPE_STRING | 1007
	TLV_TYPE_MTU           = TLV_META_TYPE_UINT   | 1008
	
	include Rex::Post::Meterpreter::InboundPacketHandler
	include Rex::Post::Meterpreter::PacketDispatcher
	
	def initialize( sock )
		@sock             = sock
		@send_keepalives  = false
		@alive            = true
		@parser           = PacketParser.new
		@response_timeout = 60
	end

	#
	# Start the handlers so we can receive incoming packets
	#
	def start
		begin
			self.initialize_inbound_handlers
			self.register_inbound_handler( self )
			self.monitor_socket
		rescue
			return false
		end
		return true
	end
	
	#
	# Stop the incoming packet handlers and close the socket.
	#
	def stop
		begin
			self.deregister_inbound_handler( self )
			self.monitor_stop
			@sock.close if @sock
			@sock = nil
		rescue
			return false
		end
		return true
	end
	
protected

	#
	# Modified send_request() to override PacketDispatcher.send_request() so
	# we dont throw and exception if the response.result != 0
	#
	def send_request(packet, t = self.response_timeout)
		response = send_packet_wait_response(packet, t)
		if (response == nil)
			raise Timeout::Error.new("Send timed out")
		end
		return response
	end
		
	#
	# Helper function to create a new response based off a previous request.
	#
	def create_response( request )
		response = Packet.create_response( request )
		response.add_tlv( TLV_TYPE_REQUEST_ID, request.rid )
		response.result = RESULT_FAILURE
		return response
	end
	
	attr_accessor :sock, :send_keepalives, :alive, :parser, :response_timeout

end


end; end; end; end; end; end
