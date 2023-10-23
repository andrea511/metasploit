@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

cd "C:\metasploit/apps/pro/engine"
"C:\metasploit/ruby\bin\ruby.exe" "C:\metasploit/apps/pro/engine\prosvc_service_install.rb"
sc config metasploitProSvc start= auto
net start metasploitProSvc >NUL
goto end

:remove
rem -- STOP SERVICES BEFORE REMOVING

net stop metasploitProSvc >NUL
sc delete metasploitProSvc

:end
exit
