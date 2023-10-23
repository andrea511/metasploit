@echo off
CALL "C:\metasploit\scripts\setenv.bat"
cd "C:\metasploit"
ruby "C:\metasploit\apps\pro\ui\script\diagnostic_logs.rb"
explorer .
pause
