#!/usr/bin/env ruby
fd = ::File.open("common.h", "r")
fd.each_line do |line|
	line.strip!
	next if not line =~ /__stdcall\s+([^\s]+)\s+([^\s]+)\s+.*dllimport(.*)/m
	nam = $2
	cnt = $3.scan(",").length
	cnt += 1
	puts "#{nam},#{cnt}"
end

