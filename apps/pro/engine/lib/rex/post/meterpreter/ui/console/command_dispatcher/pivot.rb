require 'rex/post/meterpreter'

module Rex
module Post
module Meterpreter
module Ui

###
#
# Pivot - Manage virtual network interfaces for use in network pivoting
#
###
class Console::CommandDispatcher::Pivot

	Klass = Console::CommandDispatcher::Pivot
	
	include Console::CommandDispatcher
	
	#
	# Initializes an instance of the Pivot command interaction.
	#
	def initialize( shell )
		super
	end
	
	#
	# List of supported commands.
	#
	def commands
		{
			'list_interfaces' => 'List the available remote network interfaces that can be used for pivoting.',
			'create_pivot'    => 'Create a new local virtual network interface for pivoting.',
			'destroy_pivot'   => 'Destroy an existing local virtual network interface.',
			'pivot_set_ip'    => 'Manually set an IPv4 address for a pivoted virtual network.'
		}
	end
	
	#
	# Manually set an IPv4 address for a pivoted virtual network.
	# (Will use the subnet mask as found on the respective bridged interface)
	#
	def cmd_pivot_set_ip(*args)
		
		id = nil
		ip = nil
		
		opts = Rex::Parser::Arguments.new(
			"-h" => [ false, "Help Banner." ],
			"-i" => [ true,  "The ID of the network interface which has been bridged." ],
			"-a" => [ true,  "The IP address to set." ]
		)
		
		opts.parse(args) { | opt, idx, val |
			case opt
				when "-h"
					print_line( "Usage: pivot_set_ip" )
					print_line( "Manually set an IPv4 address for a pivoted virtual network." )
					print_line( opts.usage )
					return
				when "-i"
					id = val.to_i
				when "-a"
					ip = val
			end
		}
		
		if( id == nil )
			print_error( "You must specify an ID of the network interface, e.g. >pivot_set_ip -i 1 -a 192.168.0.1" )
			return
		end
		
		if( ip == nil )
			print_error( "You must specify an IP address, e.g. >pivot_set_ip -i 1 -a 192.168.0.1" )
			return
		end
		
		if( client.pivot.pivot_set_ip( id, ip ) )
			print_line( "Set the virtual interface IPv4 address." )
		else
			print_error( "Failed to set the virtual interface IPv4 address." )
		end
		
	end
	
	#
	# Destroy an existing local virtual network interface.
	#
	def cmd_destroy_pivot(*args)
		
		id = 0
		
		opts = Rex::Parser::Arguments.new(
			"-h" => [ false, "Help Banner." ],
			"-i" => [ true,  "The ID of the network interface which has been bridged. (Default: #{id})" ]
		)
		
		opts.parse(args) { | opt, idx, val |
			case opt
				when "-h"
					print_line( "Usage: destroy_pivot" )
					print_line( "Destroy an existing local virtual network interface." )
					print_line( opts.usage )
					return
				when "-i"
					id = val.to_i
			end
		}
		
		if( client.pivot.destroy_pivot( id ) )
			print_line( "Destroyed the virtual interface." )
		else
			print_error( "Failed to destroy the virtual interface." )
		end
		
	end
	
	#
	# Create a new local virtual network interface for pivoting.
	#
	def cmd_create_pivot(*args)

		id             = 0
		auto_configure = false
		
		opts = {
			'msftapd_host' => nil, # we don't set an msftapd host by default so as to use the LocalTap
			'msftapd_port' => 55552,
			'msftapd_ssl'  => false,
			'mac'          => client.pivot.random_mac,
			'compression'  => true,
		}
		
		options = Rex::Parser::Arguments.new(
			"-h" => [ false, "Help Banner." ],
			"-i" => [ true, "The ID of the network interface to pivot through. (Default: #{id})" ],
			"-m" => [ true, "The MAC address of the new virtual interface (Note: Don't set the multicast bit!). (Default: #{opts['mac']})" ],
			"-c" => [ true, "Configure the new virtual interface via DHCP if possible. (Default: #{auto_configure})" ],
			"-a" => [ true, "The MSF TAP Daemon host IP address to use." ],
			"-p" => [ true, "The MSF TAP Daemon port number to use. (Default: #{opts['msftapd_port']})" ],
			"-s" => [ true, "Use SSL for MSF TAP Daemon communication. (Default: #{opts['msftapd_ssl']})" ]
		)
		
		options.parse(args) { | opt, idx, val |
			case opt
				when "-h"
					print_line( "Usage: create_pivot" )
					print_line( "Create a new local virtual network interface for pivoting." )
					print_line( options.usage )
					return
				when "-i"
					id = val.to_i
				when "-m"
					mac = val
					# Some people like to enter MAC addresses using different
					# notation, so we account for that and normalize the input.
					mac = mac.gsub( "-", ":" )
					mac = mac.gsub( "::", ":" )
					opts['mac'] = mac
				when "-c"
					auto_configure = true if( val =~ /^(t|y|1)/i )
				when "-a"
					opts['msftapd_host'] = val
				when "-p"
					opts['msftapd_port'] = val.to_i
				when "-s"
					opts['msftapd_ssl'] = true if( val =~ /^(t|y|1)/i )
			end
		}
		
		tap = client.pivot.create_pivot( id, opts )
		
		if( tap )
			print_line( "Created local network interface '#{tap.name}'" )
			
			# if specified, try to use DHCP to configure the new virtual interface...
			tap.configure_via_dhcp if( auto_configure )
			
			# depending on how much configuration has been done we can print out some available info about the new local virtual network interface
			print( "\tMAC Address: #{tap.opts['mac']}\n" ) if tap.opts['mac']
			print( "\tIP Address:  #{tap.opts['ip4_address']}\n" ) if tap.opts['ip4_address']
			print( "\tSubnet Mask: #{tap.opts['ip4_subnetmask']}\n" ) if tap.opts['ip4_subnetmask']
			print( "\tGateway:     #{tap.opts['ip4_gateway']}\n" ) if tap.opts['ip4_gateway']
			print( "\tDNS Server:  #{tap.opts['ip4_dns']}\n" ) if tap.opts['ip4_dns']
			print( "\tDomain Name: #{tap.opts['ip4_domain']}\n" ) if tap.opts['ip4_domain']
			print( "\tDHCP Server: #{tap.opts['ip4_dhcp']}\n" ) if tap.opts['ip4_dhcp']
		else
			print_error( "Failed to create an interface." )
		end

	end
	
	#
	# List the available remote network interfaces that can be used for pivoting.
	#
	def cmd_list_interfaces(*args)
	
		opts = Rex::Parser::Arguments.new(
			"-h" => [ false, "Help Banner." ]
		)
		
		opts.parse(args) { | opt, idx, val |
			case opt
				when "-h"
					print_line( "Usage: list_interfaces" )
					print_line( "List the available remote network interfaces that can be used for pivoting." )
					print_line( opts.usage )
					return
			end
		}
	
		interfaces = client.pivot.list_interfaces
		
		if( interfaces != nil )
			
			if( interfaces.length == 0 )
				print_line( "No available interfaces were found." )
			else
				interfaces.each do | interface |
					tap = nil
					
					type = client.pivot.iface_type_to_s(interface['type'])
					
					mac = ""
					interface['physical_address'].each_byte do | b | 
						mac += "%02X:" % b 
					end
					mac = mac.chomp(":")

					print( "\n" )
					print( "\tID:          #{ interface['id'] }\n" )
					print( "\tType:        #{ type }\n" )
					print( "\tName:        #{ interface['name'] }\n" )
					print( "\tDescription: #{ interface['description'] }\n" )
					print( "\tMAC Address: #{ mac }\n" )
					print( "\tIP Address:  #{ interface['ip4_address'].to_line }\n" ) if interface['ip4_address'].length > 0
					print( "\tSubnet Mask: #{ interface['ip4_subnetmask'].to_line }\n" ) if interface['ip4_subnetmask'].length > 0
					print( "\tGateway:     #{ interface['ip4_gateway'].to_line }\n" ) if interface['ip4_gateway'].length > 0
					print( "\tDNS Server:  #{ interface['ip4_dns'].to_line }\n" ) if interface['ip4_dns'].length > 0
					print( "\tDHCP Server: #{ interface['ip4_dhcp'].to_line }\n" ) if interface['ip4_dhcp'].length > 0
					print( "\tBridged:     #{ interface['bridged'] ? "Yes" : "No" }\n" )
				
					# if we have already bridged to this interface we can pull out some
					# info on the local virtual interface we have previously created.
					if( interface['bridged'] )
						tap = client.pivot.get_tap( interface['id'] )
						if( tap )
							print( "\t\tName:        #{tap.name}\n" )
							print( "\t\tDescription: A local virtual network interface.\n" )
							print( "\t\tMAC Address: #{tap.opts['mac']}\n" ) if tap.opts['mac']
							print( "\t\tIP Address:  #{tap.opts['ip4_address']}\n" ) if tap.opts['ip4_address']
							print( "\t\tSubnet Mask: #{tap.opts['ip4_subnetmask']}\n" ) if tap.opts['ip4_subnetmask']
							print( "\t\tGateway:     #{tap.opts['ip4_gateway']}\n" ) if tap.opts['ip4_gateway']
							print( "\t\tDNS Server:  #{tap.opts['ip4_dns']}\n" ) if tap.opts['ip4_dns']
							print( "\t\tDomain Name: #{tap.opts['ip4_domain']}\n" ) if tap.opts['ip4_domain']
							print( "\t\tDHCP Server: #{tap.opts['ip4_dhcp']}\n" ) if tap.opts['ip4_dhcp']
						end
					end
					print( "\n" )
				
				end	
			end
		else
			print_error( "Failed to list the available interfaces." )
		end
	end

	#
	# Name for this dispatcher
	#
	def name
		"Pivot"
	end

end

end; end; end; end

