@echo off
rem start or stop thin service
rem --------------------------------------------------------
rem check if argument is stop or start

if not ""%1"" == ""START"" goto stop

net start metasploitThin
goto end

:stop

net stop metasploitThin

:end
exit
