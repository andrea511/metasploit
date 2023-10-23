#!ruby.exe

require 'rubygems'
require 'win32/service'

unless Win32::Service.exists?('metasploitThin')
  Win32::Service.new(
    :service_name      => 'metasploitThin',
    :display_name      => 'Metasploit Thin Service',
    :start_type        => Win32::Service::AUTO_START,
    :binary_path_name  => 'C:\metasploit\ruby\bin\ruby.exe -C "C:\metasploit\apps\pro\ui" thin_service.rb',
    :service_type      => Win32::Service::WIN32_OWN_PROCESS
  )
end
