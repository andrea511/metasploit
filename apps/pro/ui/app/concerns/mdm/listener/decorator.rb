require 'mdm/listener/task'
module Mdm::Listener::Decorator
  extend ActiveSupport::Concern

   include Mdm::Listener::Task

  module ClassMethods
    def supported_payloads
      [
          [ "IPv4: Windows Meterpreter (TCP)", "windows/meterpreter/reverse_tcp"],
          [ "IPv4: Windows Meterpreter (HTTPS)", "windows/meterpreter/reverse_https"],
          [ "IPv4: Windows Meterpreter (HTTP)", "windows/meterpreter/reverse_http"],
          [ "IPv4: Windows x64 Meterpreter (TCP)", "windows/x64/meterpreter/reverse_tcp"],
          [ "IPv4: Linux x64 Meterpreter (TCP)", "linux/x64/meterpreter/reverse_tcp"],
          [ "IPv4: Linux Meterpreter (TCP)", "linux/x86/meterpreter/reverse_tcp"],
          [ "IPv4: Linux armle Meterpreter (TCP)", "linux/armle/meterpreter/reverse_tcp"],
          [ "IPv4: Linux aarch64 Meterpreter (TCP)", "linux/aarch64/meterpreter/reverse_tcp"],
          [ "IPv4: Linux mipsbe Meterpreter (TCP)", "linux/mipsbe/meterpreter/reverse_tcp"],
          [ "IPv4: Linux mipsle Meterpreter (TCP)", "linux/mipsle/meterpreter/reverse_tcp"],
          [ "IPv4: Multi Meterpreter (HTTPS)", "multi/meterpreter/reverse_https"],
          [ "IPv4: Multi Meterpreter (HTTP)", "multi/meterpreter/reverse_http"],
          [ "IPv4: Java Meterpreter (TCP)", "java/meterpreter/reverse_tcp"],
          [ "IPv4: PHP Meterpreter (TCP)", "php/meterpreter/reverse_tcp"],
          [ "IPv4: Command Shell (TCP)", "generic/shell_reverse_tcp"],
          [ "IPv6: Windows Meterpreter (TCP)", "windows/meterpreter/reverse_ipv6_tcp"],
          [ "IPv6: Windows Meterpreter (HTTPS)", "windows/meterpreter/reverse_ipv6_https"],
          [ "IPv6: Windows Meterpreter (HTTP)", "windows/meterpreter/reverse_ipv6_http"],
          [ "IPv6: Linux Meterpreter (TCP)", "linux/x86/meterpreter/reverse_ipv6_tcp"]
      ]
    end
  end

	def status
		active? ? "Active" : "Inactive"
  end

  def name
		"#{self.address}:#{self.port}"
  end
end

