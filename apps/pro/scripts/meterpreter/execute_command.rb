##
# $Id$
##

# Execute a command and return the results
def m_exec(session, cmd)
	r = session.sys.process.execute(cmd, nil, {'Hidden' => true, 'Channelized' => true})
	b = ""
	while(d = r.channel.read)
		b << d
	end
	r.channel.close
	r.close
	b
end

cmd = args.join(" ")

if cmd.strip.empty?
	print_error("Please specify a command line to execute")
	completed
end

base = "cmd.exe /c #{cmd}"
if client.platform !~ /windows/
	base = "/bin/sh -c '#{cmd}'"
end

print_status("Executing #{base}...")

begin
Timeout.timeout(60) do
	res = m_exec(session, base).to_s
	print_line("")
	print_line(res)
	print_line("")
end
rescue ::Timeout::Error
	print_status("Command timed out")
end

