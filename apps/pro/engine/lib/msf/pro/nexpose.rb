require 'msf/core'
require 'nexpose'

module Msf
module Pro
module Nexpose
end
end
end

# Provides methods to connect and disconnect to a Nexpose instance, as well as various
# other nexpose-specific functions.
module Msf::Pro::Nexpose

	# The Nexpose connection
	attr_accessor :nsc
	# The hostname or IP address of a remote nexpose console
	attr_accessor :nexpose_host
	# The Nexpose username
	attr_accessor :nexpose_user
	# The Nexpose password. XXX Avoid logging this
	attr_accessor :nexpose_pass
	# The port number of the remote nexpose console.
	attr_accessor :nexpose_port
	# Compatibility verified
	attr_accessor :verified

	# A simplified vulnerability struct, tied rather closely to the
	# Nexpose::VulnerabilityListing class, but without the associated connection info.
	# Note that :references will be populated as an array of [source,url] elements, and
	# usually numeric values such as :severity will be Strings.
	class VulnStruct < Struct.new(:id, :references, :title, :severity, :pciSeverity,
		:cvssScore, :cvssVector, :published, :added, :modified, :description, :solution)

		def initialize
			super
			self.references = []
			self
		end

		def add_ref(source, url)
			self.references << [source, url]
		end

	end


	# Boolean check to see if a connection exists.
	def nexpose_verify
		!!(@nsc && @nsc.respond_to?(:logout))
	end

	# Connects to a Nexpose instance via Metasploit's NexposeAPI.
	def nexpose_connect
		nexpose_disconnect rescue nil
		begin
			::Timeout.timeout(10) do
				nsc = Nexpose::Connection.new(
					@nexpose_host, @nexpose_user, @nexpose_pass, @nexpose_port
				)
				nsc.login
				@nsc = nsc
			end
		rescue ::Timeout::Error => e
			if self.respond_to? :task_error
				self.task_error = "NexposeAPI: Connection to #{@nexpose_host}:#{@nexpose_port} timed out"
			end
			raise e
		rescue ::SocketError => e
			if self.respond_to? :task_error
				self.task_error = "NexposeAPI: Connection to #{@nexpose_host}:#{@nexpose_port} failed"
			end
			raise e
		rescue Nexpose::AuthenticationFailed => e
			print_error "#{e}"
		rescue Nexpose::APIError => e
			if self.respond_to?(:task_error)
				self.task_error = "#{e}.class #{e}"
			end
			raise e
		end

		nexpose_compatibility_check
	end

	# Make sure the engine is compatible
	def nexpose_compatibility_check
		return if not @nsc
		return if self.verified
		self.verified = true
	end

	# Extracts vulnerability details from the connected scan engine in
	# a format consumable by pretty much anything.
	#
	# This method will return either nil (if there is no Nexpose
	# connection, an emtpy VulnStruct (in the event of a NexposeAPI
	# error, which happens with an invalid vuln id), or a populated
	# VulnStruct.
	#
	# Example:
	#   vstruct = nexpose_vuln_detail("windows-hotfix-ms07-054")
	#
	#
	def nexpose_vuln_detail(vid)
		vuln_struct = VulnStruct.new
		begin
			if nexpose_verify
				vuln_detail = Nexpose::VulnerabilityDetail.new(@nsc, vid, nil)
			else
				return nil
			end
		rescue Nexpose::APIError
			return vuln_struct
		end
		ret = []
		vuln_detail.instance_variables.each { |var|
			case var
			when :@error, :@connection, :@url
				next
			when :@references
				vuln_detail.instance_variable_get(var).each do |ref|
					vuln_struct.add_ref(ref.source, ref.reference)
				end
			else
				method = (var.to_s.gsub("@","") + "=").intern
				if vuln_struct.respond_to?(method)
					value  = vuln_detail.instance_variable_get(var)
					vuln_struct.send(method,value)
				end
			end
		}
		vuln_struct
	end

	def nexpose_vuln_list
		vlist = nil
		begin
			if nexpose_verify
				vlist = @nsc.list_vulns
			else
				return nil
			end
		rescue Nexpose::APIError
			return nil
		end
		return vlist
	end

	# Disconnects and destroys a Nexpose session. Always returns nil, even
	# in success.
	def nexpose_disconnect(*args)
		if nexpose_verify
			@nsc.logout() rescue nil
			@nsc = nil
		end
	end

end

