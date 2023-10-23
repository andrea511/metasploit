#!/usr/bin/env ruby

def getname
	$cur ||= 0
	$cur += 1
	"var#{$cur}"
end

fd = ::File.open("common.n", "r")
fd.each_line do |line|
	name,args = line.strip.split(",")
	next if not args
	argc = args.to_i
	argx = []
	1.upto(argc) do
		argx << "void * #{getname} "
	end
	argv = argx.join(", ")
	puts "__stdcall void * #{name} __attribute__((dllimport))(#{argv});"
end

