#!/usr/bin/ruby

###
# ./ruby c_to_dyn.rb <WinCFunction defined in data/metasm/common.h>
# Produces strings for function definitions and RDL in DynExe
###

msfbase = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

def to_evade(str)
  return "char cb#{str}[] = { CRYPT#{str.length}(#{str.chars.map {|c| "'#{c}'"}.join(',')}),XOR_KEY };"
end

def to_typedef(str, defs = File.expand_path(File.join(File.dirname(__FILE__), '..', '..','data','metasm','common.h')))
  defn = File.read(defs).lines.select {|l| l =~ /^__stdcall.*\s#{str}\s/}[0]
  type = defn.split[1]
  params = defn.scan(/port\)\).*/)[0].scan(/[[:upper:]][[:upper:]]+/)
  params = [ 'VOID' ] if params.nil? or params.empty?
  return "typedef #{type} (__stdcall *#{str}Proto)(#{params.join(', ')});"
end

def to_rdload(str, via = 'hKernel')
  return "RDLLOAD(#{str}RDL, #{str}Proto, #{via}, cb#{str});"
end

def to_obfu(str)
  puts [
    to_typedef(str),
    to_evade(str),
    to_rdload(str)
  ].join("\n")
end

ARGV.each do |func|
  to_obfu(func)
end
