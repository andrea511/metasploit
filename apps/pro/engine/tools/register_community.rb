#!/usr/bin/env ruby

msfbase = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'msf3', 'lib'))
$:.unshift(msfbase)

require 'rex/proto/http/client'
require 'rex/compat'
require 'uri'

def usage
	$stderr.puts "#{$0} [email-address]"
	exit(1)
end

email = ARGV.shift() || usage()
unless email =~ /^(.*)\@.*\.[a-z]+$/i
	$stderr.puts "[-] Not a properly formatted email: #{email}"
	exit(1)
end

params = {
	'custparamfirstname'   => email,
	'custparamlastname'    => email,
	'custparamuse'         => 'Personal',
	'custparamcompanyname' => 'Metasploit Community(' + email + ')',
	'custparamcustentityr7annualrevenue' => '1',
	'custparamleadsource'  => '447968',
	'submitted'            => '',
	'custparamproductaxscode' => 'msJGbq8M2T',
	'custparamreturnpath'  => 'https://www.rapid7.com/register/metasploit.jsp?source=cli-tool',
	'custparamproduct_key' => '',
	'custparamthisIP'      => 'null',
	'product'              => 'Metasploit Community',
	'custparamemail'       => email
}

uri = URI.parse('https://forms.netsuite.com/app/site/hosting/scriptlet.nl?script=214&deploy=1&compid=663271&h=f545d011e89bdd812fe1')
$stdout.puts "[*] Sending our registration request for #{email}..."

http = Rex::Proto::Http::Client.new(uri.host, uri.port, {}, true)
req = http.request_cgi(
	'uri'       => uri.path,
	'query'     => uri.query,
	'vars_post' => params,
	'vhost'     => uri.host,
	'method'    => 'POST',
	'headers'   => { 'Referer' => 'https://www.rapid7.com/register/metasploit.jsp?source=cli-tool' }
)

res = http.send_recv(req, 60)
if res and res.body and res.body =~ /NLStickyResponseWrapper/ and res.body !~ /errormsg=/
	$stdout.puts "[*] Registration succeeded, check your mail for a Metasploit Community license key"
else
	$stdout.puts "[-] Failed to register from the CLI, please browse to:"
	$stdout.puts "    - https://www.rapid7.com/register/metasploit.jsp"
end
