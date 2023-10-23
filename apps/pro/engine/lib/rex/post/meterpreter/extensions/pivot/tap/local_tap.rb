require 'rex/logging'
require 'rex/post/meterpreter/extensions/pivot/tap/basic_tap'
require 'rex/post/meterpreter/extensions/pivot/tap/daemon/factory'
require 'rex/post/meterpreter/extensions/pivot/tap/daemon/tap'

module Rex
module Post
module Meterpreter
module Extensions
module Pivot
module Tap

#
# The Framework client side implementation of a virtual interface, backed by a 
# local TAP driver and a Meterpreter server side implementation which bridges 
# with a real interface to a network we want to tunnel to.
#
class LocalTap
	
	MAX_FRAMES_FLUSH = 64
	
	include BasicTap
	
	#
	#
	#
	def initialize( client, cid, bridge, opts={}, packet, **_ )
		initialize_tap( client, cid, bridge, opts, packet, **_ )
		@tap = nil
	end
	
	#
	# Open a TAP driver on the local host to create a new virtual interface.
	#
	def open
	
		begin
			factory = Daemon::Factory.instance
			
			@tap = factory.create( @opts['mac'], @opts['mtu'] )
		rescue
			@tap = nil
			wlog( "LocalTap.create_tap - factory.create - #{$!}" )
		end
		
		if( @tap )
			@name = @tap.name
			self.start_tap_monitor
			return true
		end
		
		self.close
		
		return false
	end

	#
	# Add an ARP entry to the hosts ARP table for this interface.
	#
	def add_ip4_arp_entry( ip, mac )
		return @tap.add_ip4_arp_entry( ip, mac )
	end
	
	#
	# Remove an ARP entry from the hosts ARP table for this interface.
	#
	def remove_ip4_arp_entry( ip )
		return @tap.remove_ip4_arp_entry( ip )
	end
	
	#
	# Add a DNS nameserver to the hosts list of nameservers.
	#
	def add_ip4_dns( nameserver )
		if( @tap.add_ip4_dns( nameserver ) )
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
		return @tap.remove_ip4_dns( nameserver )
	end

	#
	# Set the IPv4 address and netmask for this local virtual network interface to use.
	#
	def set_ip4_address( address, netmask )
		if( @tap.set_ip4_address( address, netmask ) )
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
		return @tap.set_ip6_address( address )
	end
	
	#
	# Set an IPv4 route in the routing table for this local virtual network interface.
	#
	def add_ip4_route( network, netmask )
		return @tap.add_ip4_route( network, netmask )
	end
	
	#
	# Removes an IPv4 route in the routing table for this local virtual network interface.
	#
	def remove_ip4_route( network, netmask )
		return @tap.remove_ip4_route( network, netmask )
	end
	
	#
	# Set the default gateway in the routing table for the host OS
	#
	def set_ip4_default_gateway( gateway )
		if( @tap.set_ip4_default_gateway( gateway ) )
			@opts['ip4_gateway'] = gateway
			return true
		end
		return false
	end
	
	#
	# Set an IPv6 route in the routing table for this local virtual network interface.
	#
	def add_ip6_route( network, gateway )
		return @tap.add_ip6_route( network, gateway )
	end
	
	#
	# Remove an IPv6 route 
	#
	def remove_ip6_route( network, netmask )
		return @tap.remove_ip6_route( network, netmask )
	end

	#
	# Write a group of received frames to the tap interface.
	#
	def rx_frames( frames )
		raise "TAP has been closed (LocalTap.rx_frames)." if( self.is_closed? )
		frames = filter( false, frames )
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
		return true
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
				wlog( "Exception caught in LocalTap.close - @services[#{name}].stop: #{e}" )
			end
		end
		@services.clear
			
		# bring down the local virtual interface...
		begin
			# if a dns entry was set, remove it...
			self.remove_ip4_dns()
			# destroy the virtual interface
			@tap.close if @tap
			self.stop_tap_monitor
		rescue ::Exception => e
			wlog( "Exception caught in LocalTap.close - daemon: #{e}" )
		end
			
		# close the channel which inturn will bring down the meterpreter side virtual interface (and its respective network bridge)...
		begin
			# sf: test if the channels client is alive otherwise we can get a situation where the client is dead and this will hang.
			@channel.close if( @channel.client.alive )
			@channel = nil
		rescue ::Exception => e
			wlog( "Exception caught in LocalTap.close - @channel.close: #{e}" )
		end
			
		@closed = true
			
		return true  
	end

	protected

	#
	#
	#
	def stop_tap_monitor
		@monitor.kill if ( @monitor and @monitor.alive? )
		@monitor = nil
	end
	
	#
	#
	#	
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
						self.tx_frames( frames )
					end
				end
			rescue
				wlog( "[TAP DAEMON] LocalTap.start_tap_monitor - thread - #{$!}" )
				@tap.close
				::Thread.exit
			end
		end
			
		return true
	end
	
end

end; end; end; end; end; end
