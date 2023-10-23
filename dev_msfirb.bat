@echo off
set BASE=%~dp0
cd "%BASE%"

rem #### Force 'West European Latin' locale on Windows #####
chcp 1252 >NUL
set PATH=%BASE%ruby\bin;%BASE%java\bin;%BASE%tools;%BASE%nmap;%BASE%postgresql\bin;%PATH%

IF NOT EXIST "%BASE%java" GOTO NO_JAVA
set JAVA_HOME="%BASE%java"
:NO_JAVA

set MSF_DATABASE_CONFIG="%BASE%apps\pro\ui\config\database.yml"

set FRAMEWORK_FLAG=true
set RUBYOPT=-rbundler/setup -rrubygems
set DEV_MSFCONSOLE_OPTS=/e production /y "%BASE%apps\pro\ui\config\database.yml"
set MSFCONSOLE_OPTS=/e production /y "%BASE%apps\pro\ui\config\database.yml"
set BUNDLE_GEMFILE=%BASE%apps\pro\Gemfile



cd %BASE%\apps\pro\vendor\bundle\ruby\3.0.0\bin
CALL C:\metasploit\ruby\bin\irb.bat
