

set PATH=C:\metasploit\ruby\bin;C:\metasploit\postgresql\bin;C:\metasploit\java\bin;%PATH%

rem #### Force 'West European Latin' locale on Windows #####
chcp 1252 >NUL

rem #### RUBY ENV ####
set RUBYOPT=-rbundler/setup -rrubygems

set NMAPDIR="C:\metasploit\common\share\nmap\"
set RAILS_ENV=production
