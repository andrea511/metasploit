@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

"C:\metasploit/ruby\bin\ruby.exe" "C:\metasploit/apps/pro/ui\worker_service_install.rb"
sc config metasploitWorker start= auto
net start metasploitWorker >NUL
goto end

:remove
rem -- STOP SERVICE BEFORE REMOVING

net stop metasploitWorker >NUL
sc delete metasploitWorker

:end
exit
