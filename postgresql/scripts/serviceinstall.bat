@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

"C:\metasploit/postgresql\bin\pg_ctl.exe" register -N "metasploitPostgreSQL" -D "C:\metasploit/postgresql/data"

net start metasploitPostgreSQL >NUL
goto end

:remove
rem -- STOP SERVICE BEFORE REMOVING

net stop metasploitPostgreSQL >NUL
"C:\metasploit/postgresql\bin\pg_ctl.exe" unregister -N "metasploitPostgreSQL"


:end
exit
