@echo off
rem START or STOP prosvc
rem --------------------------------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop

set /p swap=<C:\metasploit\apps\pro\engine\tmp\swap_config
if "%swap%" == "1" "C:\metasploit\ruby\bin\ruby" "C:\metasploit\apps\pro\ui\script\swap.rb"

net start metasploitProSvc
goto end

:stop
net stop metasploitProSvc

:end
exit

