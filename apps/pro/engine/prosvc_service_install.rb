#!ruby.exe

require 'rubygems'
require 'win32/service'

unless Win32::Service.exists?('metasploitProSvc')
  Win32::Service.new(
    :service_name      => 'metasploitProSvc',
    :display_name      => 'Metasploit Pro Service',
    :start_type        => Win32::Service::AUTO_START,
    :binary_path_name  => 'C:\metasploit\ruby\bin\ruby.exe -C "C:\metasploit\apps\pro\engine" prosvc_service.rb -E production',
    :service_type      => Win32::Service::WIN32_OWN_PROCESS
  )
end
