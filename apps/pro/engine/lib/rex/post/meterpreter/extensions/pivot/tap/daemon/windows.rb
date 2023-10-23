
#
# Allow this to be loaded even on Linux
#

require 'thread'
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
# A subclass for Windows TAP interfaces and not to be instanciated directly, use the TAP Factory instead.
# As the Windows TAP driver implementation is very Windows specific we wrap all the Windows specific 
# elements in WindowsTapDevice.
#
class WindowsTap < Tap

	#
	# A simple wrapper class for Windows TAP device driver IO. We must use this as 
	# the Ruby interpeter cannot handle opening a device without segfaulting. We also
	# wrap all the device instance configuration stuff (MAC/MTU/device reloading) in
	# this class.
	#
	class WindowsTapDevice

		IOCTL_MSFTAP_GET_MAC              = 0x00170000
		IOCTL_MSFTAP_GET_MTU              = 0x00170004
		IOCTL_MSFTAP_GET_CONNECTION_STATE = 0x00170008
		IOCTL_MSFTAP_GET_FRIENDLY_NAME    = 0x0017000C
		IOCTL_MSFTAP_GET_NAME             = 0x00170010
		IOCTL_MSFTAP_GET_GUID             = 0x00170014
		IOCTL_MSFTAP_SET_CONNECTION_STATE = 0x00170018
		IOCTL_MSFTAP_SELECT_READ          = 0x0017001C
		IOCTL_MSFTAP_SET_BLOCKING         = 0x00170020

		MSFTAP_DEV        = "\\\\.\\msftap"
		
		GENERIC_READ      = 0x80000000
		GENERIC_WRITE     = 0x40000000
		FILE_SHARE_READ   = 0x00000001  
		FILE_SHARE_WRITE  = 0x00000002 
		OPEN_EXISTING     = 0x00000003
		NULL              = 0x00000000

begin
		original_verbose, $VERBOSE = $VERBOSE, nil
		require 'Win32API'
		require 'win32/registry'
		$VERBOSE = original_verbose
		
		@@CreateFile      = ::Win32API.new( 'kernel32', 'CreateFile',      'PLLLLLL',  'L' )
		@@CloseHandle     = ::Win32API.new( 'kernel32', 'CloseHandle',     'L',        'N' )
		@@ReadFile        = ::Win32API.new( 'kernel32', 'ReadFile',        'LPLPP',    'I' )
		@@WriteFile       = ::Win32API.new( 'kernel32', 'WriteFile',       'LPLPP',    'I' )
		@@DeviceIoControl = ::Win32API.new( 'kernel32', 'DeviceIoControl', 'LLPLPLPP', 'I' )
		@@GetLastError    = ::Win32API.new( 'kernel32', 'GetLastError',    '',         'I' )
		
rescue ::Exception
end

		# we maintain a pool of adapters as defined in the drivers INF file.
		@@pool = {
			0 => nil,
			1 => nil,
			2 => nil,
			3 => nil,
		}
		
		# we sync pool access with this mutex
		@@pool_mutex = ::Mutex.new
		
		
		#
		# Detect whether or not the drivers are loaded
		#
		def self.drivers_loaded?
			begin
				handle = @@CreateFile.Call( "#{MSFTAP_DEV}0", GENERIC_READ|GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL )
				if handle >= 0
					@@CloseHandle.Call( handle )
					return true
				end
			rescue ::Exception
				wlog( "[TAP DAEMON] WindowsTapDevice.drivers_loaded? - #{$!} #{$!.backtrace}" )
			end
			return false
		end

		#
		# Reset all interfaces
		#
		def self.reset_interfaces
			@@pool.each_key do |idx|
				if @@pool[idx]
					@@pool[idx].close rescue nil
				end
				self.device_update(idx)
			end
		end


		#
		# Install drivers
		#
		def self.install_drivers
			arch = is_wow64 ? "amd64" : "i386"				
			msftap_bat = ::File.expand_path(::File.join(Rails.application.root.parent, "data", "drivers", arch, "msftap_install.bat" ))
			msftap_bat.gsub!("/", "\\")
			wlog("Executing cmd.exe /c #{msftap_bat}")
			system("cmd.exe /c #{msftap_bat} > NUL")
		end

		#
		# Uninstall drivers
		#
		def self.uninstall_drivers
			arch = is_wow64 ? "amd64" : "i386"	
			msftap_bat = ::File.expand_path(::File.join(Rails.application.root.parent, "data", "drivers", arch, "msftap_uninstall.bat" ))
			msftap_bat.gsub!("/", "\\")
			system("cmd.exe /c #{msftap_bat} > NUL")
		end
		
		#
		# Check for drivers, install if needed, reset interfaces otherwise
		#
		def self.configure
			if drivers_loaded?
				reset_interfaces
			else
				install_drivers
			end
		end
								
		#
		# Initialize a new TAP from the pool of available adapters.
		#
		def initialize( mac, mtu )
			@mac       = mac
			@mtu       = mtu
			@handle    = nil
			@index     = nil
			@guid      = nil
			@conn_name = nil
		end
		
		#
		# Open a handle to a TAP device.
		#
		def open
			@@pool_mutex.synchronize do
				# find an unused device entry in the pool
				@@pool.each_pair do | key, value |
					# if we found an unused entry, we consume it with this device instance
					if( not value )
						@index = key
						@@pool[@index] = self
						break
					end
				end
			end
			# fail if we cant get an adapter instance
			if( not @index )
				wlog( "[TAP DAEMON] WindowsTapDevice.open - No more devices available in the pool." )
				return false
			end
			# open a temporary handle to this adapter instance
			@handle = @@CreateFile.Call( "#{MSFTAP_DEV}#{@index}", GENERIC_READ|GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL )
			if( @handle < 0 )
				wlog( "[TAP DAEMON] WindowsTapDevice.open - Unable to open temporary handle to #{MSFTAP_DEV}#{@index}" )
				@handle = nil
				return false
			end
			# get the GUID for this adapter so we can configure it
			if( not self.get_guid )
				wlog( "[TAP DAEMON] WindowsTapDevice.open - Unable to get the GUID for #{MSFTAP_DEV}#{@index}" )
				return false
			end
			# bring the adapters network connection down in case somehow it was left up (e.g. a previous ruby interpreter crash)
			self.connected( false )
			# close the temporary handle
			@@CloseHandle.Call( @handle )
			@handle = nil
			# update the adapter instances desired MAC and MTU values in the registry
			if( not self.registry_update )
				wlog( "[TAP DAEMON] WindowsTapDevice.open - Unable to update the adapters registry settings." )
				return false
			end
			# update the virtual adapter instance settings (MTU/MAC) by reloading this adapter instance
			if( not self.device_update )
				wlog( "[TAP DAEMON] WindowsTapDevice.open - Unable to update the adapter instance." )
				return false
			end
			# open a handle to the new device instance for IO
			@handle = @@CreateFile.Call( "#{MSFTAP_DEV}#{@index}", GENERIC_READ|GENERIC_WRITE, FILE_SHARE_READ|FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL )
			if( @handle < 0 )
				wlog( "[TAP DAEMON] WindowsTapDevice.open - Unable to open the handle to #{MSFTAP_DEV}#{@index}" )
				@handle = nil
				return false
			end
			# disable the native Windows autoconf 
			self.windows_autoconf( false )
			# we want non-blocking reads
			self.blocking( false )
			# bring the adapters network connection up and if successful we are good to now begin reading/writing frames
			return self.connected( true )
		end
		
		#
		# Close and destroy this TAP device.
		#
		def close
			if( @handle )
				# bring the adapters network connection down
				self.connected( false )
				# close the file handle if it was opened
				@@CloseHandle.Call( @handle )
				@handle = nil
				@guid   = nil
			end
			# mark this instance in the pool as available
			@@pool_mutex.synchronize do
				@@pool[@index] = nil
				@index         = nil
			end
		end
		
		#
		# Discover how many tx frames are pending.
		#
		def select_read
			output = [0].pack( 'V' )
			if( ioctl( IOCTL_MSFTAP_SELECT_READ, nil, output ) )
				return output.unpack( 'V' ).first
			end
			return 0
		end
		
		#
		# Perform a read on the TAP device.
		#
		def sysread( length )
			ammount = [0].pack( 'V' )
			data    = "\x00" * length
			if( @@ReadFile.Call( @handle, data, data.length, ammount, NULL ) == 1 )
				ammount = ammount.unpack( 'V' ).first
				if( ammount > 0 and ammount <= length )
					return data[0..ammount-1]
				end
			end
			return nil
		end
		
		#
		# Perform a write to the TAP device.
		#
		def syswrite( data )
			ammount = [0].pack( 'V' )
			if( @@WriteFile.Call( @handle, data, data.length, ammount, NULL ) == 1 )
				return ammount.unpack( 'V' ).first
			end
			return 0
		end
		
		#
		# Get the MTU (e.g. 1500) as used by the TAP device.
		#
		def get_mtu
			output = [0].pack( 'V' )
			if( ioctl( IOCTL_MSFTAP_GET_MTU, nil, output ) )
				return output.unpack( 'V' ).first
			end
			return nil
		end
		
		#
		# Get the MAC (e.g. '00:11:22:33:44:55') as used by the TAP device.
		#
		def get_mac
			output = "\x00" * 6
			if( ioctl( IOCTL_MSFTAP_GET_MAC, nil, output ) )
				mac = ''
				output[0..5].each_byte do | b |
					mac << "%02X:" % b 
				end
				return mac.chomp( ":" )
			end
			return nil
		end
		
		#
		# Get the devices 'friendly name' as found by the TAP device.
		#
		def get_friendly_name
			output = "\x00" * 512
			if( ioctl( IOCTL_MSFTAP_GET_FRIENDLY_NAME, nil, output ) )
				return output.unpack( 'A*' ).first
			end
			return nil
		end
		
		#
		# Get the devices name (e.g. 'msftap0') as found by the TAP device.
		#
		def get_name
			output = "\x00" * 512
			if( ioctl( IOCTL_MSFTAP_GET_NAME, nil, output ) )
				return output.unpack( 'A*' ).first
			end
			return nil
		end
		
		#
		# Get the devices GUID (e.g. '{0108A4FA-D861-11DF-8FE9-B88EDFD72085}') as found by the TAP device.
		#
		def get_guid
			if( not @guid )
				output = "\x00" * 512
				if( ioctl( IOCTL_MSFTAP_GET_GUID, nil, output ) )
					@guid = output.unpack( 'A*' ).first
				end
			end
			return @guid
		end
		
		#
		# Get the adapters connection name (e.g. 'Local Area Connection 1') via its GUID for netsh commands.
		#
		def get_connection_name
			if( not @conn_name )
				begin
					# 4D36E972-E325-11CE-BFC1-08002bE10318 is the Net class GUID
					path = "SYSTEM\\CurrentControlSet\\Control\\Network\\{4D36E972-E325-11CE-BFC1-08002BE10318}\\#{self.get_guid}\\Connection"
					::Win32::Registry::HKEY_LOCAL_MACHINE.open( path, ::Win32::Registry::KEY_READ ) do | r |
						@conn_name = r.read_s( 'Name' )
					end
				rescue
				end
			end
			return @conn_name
		end
		
		#
		# Determine if we are 64-bit or not
		#
		def self.is_wow64
			Rex::Compat.is_wow64
		end
		
		def is_wow64
			self.class.is_wow64
		end

		#
		# Set whether read operations are blocking or not
		#
		def blocking( state )
			return ioctl( IOCTL_MSFTAP_SET_BLOCKING, [ state ? 1 : 0 ].pack( 'C' ) )
		end
		
		#
		# Set the adapters network connection state to either connected or unconnected.
		#
		def connected( state )
			return ioctl( IOCTL_MSFTAP_SET_CONNECTION_STATE, [ state ? 1 : 0 ].pack( 'C' ) )
		end
		
		#
		# Perform an IOCTL on the device.
		#
		def ioctl( code, input=nil, output=nil )
			ammount = [0].pack( 'V' )
			if( @@DeviceIoControl.Call( @handle, code, input ? input : NULL, input ? input.length : 0, output ? output : NULL, output ? output.length : 0, ammount, NULL ) == 1 )
				return true
			end
			return false
		end
		
		#
		# Update this virtual adapter instance.
		#
		def self.device_update(idx)
			begin
			
				arch = is_wow64 ? "amd64" : "i386"
				
				msftap_inf = ::File.join(Rails.application.root.parent, "data", "drivers", arch, "msftap.inf" )
				update_exe = ::File.join(Rails.application.root.parent, "data", "drivers", arch, "update.exe" )
				if( Rex::Compat.is_cygwin )
					msftap_inf = Rex::Compat.cygwin_to_win32( msftap_inf )
					update_exe = Rex::Compat.cygwin_to_win32( update_exe )
				else
					msftap_inf = msftap_inf.gsub( "/", "\\" )
					update_exe = update_exe.gsub( "/", "\\" )
				end
				
				return system( "#{update_exe} \"#{msftap_inf}\" msftap#{idx}" )
			rescue ::Exception
				wlog( "[TAP DAEMON] WindowsTapDevice.device_update - #{$!} #{$!.backtrace}" )
				return false
			end
			
			return true
		end
		
		def device_update
			self.class.device_update(@index)
		end
		
		#
		# Write to the registry to disable the native Windows adapter auto conf stuff
		#
		def windows_autoconf( enable )
			begin
				path = "SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters\\Interfaces"
				::Win32::Registry::HKEY_LOCAL_MACHINE.open( "#{path}\\#{self.get_guid}", ::Win32::Registry::KEY_READ | ::Win32::Registry::KEY_WRITE ) do | r |
					r.write_i( 'EnableDHCP', enable ? 1 : 0 )
				end
			rescue ::Exception
				wlog( "[TAP DAEMON] WindowsTapDevice.windows_autoconf - #{$!} #{$!.backtrace}" )
				return false
			end
			return true
		end
		
		#
		# Update this adapters MAC/MTU settings in the registry.
		#
		def registry_update
			begin
				# 4D36E972-E325-11CE-BFC1-08002bE10318 is the Net class GUID
				path = "SYSTEM\\CurrentControlSet\\Control\\Class\\{4D36E972-E325-11CE-BFC1-08002bE10318}"
				# enum all entries in 'path' and compare NetCfgInstanceId to the GUID of the adapter we are looking for
				::Win32::Registry::HKEY_LOCAL_MACHINE.open( path, ::Win32::Registry::KEY_READ ) do | reg1 |
					reg1.each_key do | key |
						::Win32::Registry::HKEY_LOCAL_MACHINE.open( "#{path}\\#{key}", ::Win32::Registry::KEY_READ | ::Win32::Registry::KEY_WRITE ) do | reg2 |
							# Some interfaces return access denied even with privileged access
							begin
								reg2.each_value do | name, type, value |
									# once found, set the MTU and NetworkAddress accordingly
									if( name == 'NetCfgInstanceId' and value == self.get_guid )
										reg2.write_i( 'MTU', @mtu )
										reg2.write_s( 'NetworkAddress', @mac.gsub( ":", "" ) )
										return true
									end
								end
							rescue ::Exception
								wlog( "[TAP DAEMON] WindowsTap.registry_update - reading #{path}\\#{key} - #{$!} #{$!.backtrace}" )
							end
						end
					end
				end
			rescue ::Exception
				wlog( "[TAP DAEMON] WindowsTap.registry_update - #{$!} #{$!.backtrace}" )
			end
			return false
		end
		
	end
	
	#
	# Initialize a new WindowsTap
	#
	def initialize( mac, mtu )
		super
		@handle          = nil
		@name            = nil
		@connection_name = nil
	end
	
	#
	# Open a new TAP virtual network adapter (with the specified MAC/MTU).
	#
	def open
	
		begin
			@handle = WindowsTapDevice.new( @mac, @mtu )
		rescue
			wlog( "[TAP DAEMON] WindowsTap.open - WindowsTapDevice.new failed" )
			return false
		end
		
		if( not @handle.open )
			@handle.close
			@handle = nil
			@name   = nil
			wlog( "[TAP DAEMON] WindowsTap.open - @handle.open failed" )
			return false
		end
		
		# perform some sanity checking to ensure the adapter has been created as intended
		if( @mtu != @handle.get_mtu )
			wlog( "[TAP DAEMON] WindowsTap.open - MTU #{@mtu} != #{@handle.get_mtu}" )
			return false
		end
		
		if( @mac.downcase != @handle.get_mac.downcase )
			wlog( "[TAP DAEMON] WindowsTap.open - MAC #{@mac} != #{@handle.get_mac}" )
			return false
		end
		
		# get this adapters display name (e.g. 'msftap0')
		@name = @handle.get_name
		
		# get this adapters connection name (e.g. 'Local Area Connection 1') for the netsh commands
		@connection_name = @handle.get_connection_name

		return true
	end

	#
	# Wrapper for Windows specific select operations on the TAP handle. Unfortunatly a
	# crude implementation due to some ruby issues. We effectively poll via read_frame but
	# we must let the ruby vm do background work to avoid deadlock, hence the select
	# call here with no fd's specified.
	#
	# If we try to perform a blocking read (to avoid using select) we deadlock the ruby vm
	# as at a native level it is effectivly single threaded.
	#
	def select( timeout=0.5, step=0.05 )
		# Perform an IO.select to let the Ruby vm do some background work.
		::IO.select( nil, nil, nil, 0.001 )
		return true
	end
	
	#
	# Read a frame of data from the TAP driver.
	#
	def read_frame
		return @handle.sysread( @mtu )
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
			system( "arp -s #{ip} #{mac.gsub( ":", "-" )}" )
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
			system( "arp -d #{ip}" )
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
			system( "netsh interface ip set dns name=\"#{@connection_name}\" source=static #{nameserver} primary" )
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
			system( "netsh interface ip delete dns name=\"#{@connection_name}\" #{nameserver}" )
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
			system( "netsh interface ip set address name=\"#{@connection_name}\" source=static #{address} #{netmask}" )
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
			system( "netsh interface ipv6 set address interface=\"#{@connection_name}\" address=#{address}" )
		rescue
			return false
		end
		return true
	end
	
	#
	# Set an IPv4 route in the routing table for this local virtual network interface.
	#
	def add_ip4_route( network, netmask )
		begin
			system( "route add #{network} #{netmask}" )
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
			system( "route delete #{network}" )
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
			system( "netsh interface ip set address name=\"#{@connection_name}\" gateway=#{gateway} gwmetric=1" )
		rescue
			return false
		end
		return true
	end
	
	#
	# Set an IPv6 route in the routing table for this local virtual network interface.
	#
	def add_ip6_route( network, gateway )
		false
	end
	
	#
	# 
	#
	def remove_ip6_route( network, netmask )
		false
	end
	
end

end; end; end; end; end; end; end
