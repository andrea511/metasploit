@echo off
rem start or stop worker service
rem --------------------------------------------------------
rem check if argument is stop or start

if not ""%1"" == ""START"" goto stop

net start metasploitWorker
goto end

:stop

net stop metasploitWorker

:end
exit
