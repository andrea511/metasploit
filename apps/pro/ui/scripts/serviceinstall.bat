@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

"C:\metasploit/ruby\bin\ruby.exe" "C:\metasploit/apps/pro/ui\thin_service_install.rb"
sc config metasploitThin start= auto
net start metasploitThin >NUL
goto end

:remove
rem -- STOP SERVICE BEFORE REMOVING

net stop metasploitThin >NUL
sc delete metasploitThin

:end
exit
