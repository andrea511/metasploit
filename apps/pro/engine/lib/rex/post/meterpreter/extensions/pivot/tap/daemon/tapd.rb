require 'rex/logging'
require 'rex/socket'
require 'rex/post/meterpreter/extensions/pivot/tap/daemon/tapc'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap
module Daemon

#
# A TAP daemon which lets its clients create and manage TAP interfaces for network pivoting.
#
class TapDaemon
	
	def initialize( opts )
		@opts    = opts
		@clients = ::Array.new
		@running = true
		@server  = nil
	end
	
	def stop
		@running = false
		@clients.each do | client |
			client.stop
		end
		@clients.clear
		@server.close if @server
	end
	
	def start
		begin
		
			@server = Rex::Socket::TcpServer.create(
				'LocalHost' => @opts['ServerHost'],
				'LocalPort' => @opts['ServerPort'],
				'SSL'       => @opts['SSL']
			)
			
			# disable the nagle algorithm on this socket to help reduce latency
			begin
				@server.setsockopt( ::Socket::SOL_TCP, ::Socket::TCP_NODELAY, true )
			rescue
			end
			
			while( @running ) do
				
				sock = @server.accept
				
				client = TapClient.new( sock )
				
				@clients << client
					
				begin
					client.start
				rescue
					client.stop
					@clients.delete( client )
				end
	
			end
			
		rescue
			$stderr.puts "TapDaemon Exception - #{$!}\n\n#{$@.join("\n")}"
			self.stop
		end
	end
	
end


end; end; end; end; end; end; end
