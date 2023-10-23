class MsfModule
	attr :title
	attr :fullname
	attr :description
	attr :authors
	attr :references
	attr :targets
	attr :actions
	attr :default_target
	attr :default_action
	attr :arch
	attr :platform
	attr :stance
	attr :fileformat
	attr :license
	attr :rank
	attr :privileged
	attr :disclosure_date
	attr :notes

	def self.all
		auxiliary + exploits + post
	end

	# Returns the modules as a tree
	#
	# @return [Hash{String => Hash, MsfModule}] Maps directory to either another tree or an MsfModule leaf
	def self.tree(depth=0, modules=all())
		hash = modules.group_by {|m| m.path[depth] }
		hash.inject({}) do |h, element|
			path_element, modules = element
			if modules.size == 1 and modules.first.path.size == depth + 1
				h[path_element] = modules.first
			else
				modules.sort! { |a,b| a.path[depth+1] <=> b.path[depth+1] }
				h[path_element] = self.tree(depth + 1, modules)
			end
			h
		end
	end

	def self.find_by_fullname(fullname)
		self.exploits.find{ |m| m.fullname == fullname } || self.auxiliary.find{ |m| m.fullname == fullname } || self.post.find { |m| m.fullname == fullname }
	end

	def self.reload_modules
		# no-op the "caching" is now done by the engine code
	end

	def self.exploits
		hash = begin
			all = Pro::Client.get.module_details("exploit")["modules"]
			all.delete("exploit/windows/fileformat/adobe_pdf_embedded_exe") # INFILENAME not supported
			all
		end
		hash.map { |fullname, info| MsfModule.new(fullname, info) }
	end

	def self.auxiliary
		hash =
			Pro::Client.get.module_details("auxiliary")["modules"]
		hash.map { |fullname, info| MsfModule.new(fullname, info) }
	end

	def self.post
		hash =
			Pro::Client.get.module_details("post")["modules"]
		hash.map { |fullname, info| MsfModule.new(fullname, info) }
	end

	def initialize(fullname, info)
		@fullname        = fullname
		@title           = info["name"]
		@description     = info["description"]
		@rank            = info["rank"]
		@type            = info["type"]
		@license         = info["license"]
		@authors         = info["authors"] || []
		@references      = info["references"] || []
		@targets         = info["targets"] || []
		@actions         = info["actions"] || []
		@default_target  = info["default_target"]
		@default_action  = info["default_action"]
		@arch            = info["arch"] || []
		@platform        = info["platform"] || []
		@stance          = info["stance"] || "unknown"
		@fileformat      = info["fileformat"] || false
		@privileged      = info["privileged"]
		@disclosure_date = info["disclosure_date"] # a timestamp
		@disclosure_date = ::Time.at(@disclosure_date) if @disclosure_date
		@notes           = info["notes"]
	end

	def options
		@options ||= begin
			# lazy-load the options
			a = Pro::Client.get.module_options(@type, fullname)
			a.map do |opt_name, hash|
				Option.new(:name => opt_name,
					:type => hash["type"],
					:required => hash["required"],
					:advanced => hash["advanced"],
					:evasion  => hash["evasion"],
					:default  => hash["default"],
					:desc     => hash["desc"],
					:enums    => hash["enums"]
					)
			end.sort_by(&:name)
		end
	end

	def evasion_options
		options.select {|o| o.evasion? }
	end

	def advanced_options
		# user doesn't set WORKSPACE or PROUSER directly
		options.select {|o| o.advanced? }.reject {|o| %w{WORKSPACE PROUSER}.include? o.name}
	end

	def basic_options
		case @type
		when "exploit", "auxiliary"
			# user doesn't set RHOST or HOST directly
			options.reject {|o| o.advanced? || o.evasion? }.reject {|o| %{RHOST HOST RHOSTS}.include? o.name }
		else
			# post and other modules sometimes have RHOST/HOST/RHOSTS and thats just fine
			options.reject {|o| o.advanced? || o.evasion? }
		end
	end

	# options to display when configuring this exploit module for use in a web template
	def web_template_options
		basic_options.reject {|o| %w{SRVHOST SRVPORT SSL SSLVersion}.include? o.name }
	end

	def type
		return "File Format Exploit" if file_format_exploit?
		return "Server Exploit" if server_exploit?
		return "Client Exploit" if client_exploit?
		return "Auxiliary" if auxiliary?
		return "Post-Exploitation" if post?
		"Unknown"
	end

	def path
		fullname.split("/")
	end

	def exploit?
		@type == "exploit"
	end

	def auxiliary?
		@type == "auxiliary"
	end

	def post?
		@type == "post"
	end

	def file_format_exploit?
		exploit? and @fileformat
	end

	def server_exploit?
		exploit? and @stance == "aggressive"
	end

	def client_exploit?
		exploit? and @stance != "aggressive"
	end

	def local_exploit?
		exploit? and @fullname =~ /^exploit\/[^\/]+\/local\//
	end

	# For post modules, this returns the local_ids for all compatible sessions, across all workspaces
	def compatible_sessions
		# Can't cache this since sessions are volatile
		Pro::Client.get.module_compatible_sessions(self.fullname)["sessions"] || []
	end

	def references_by_type(type)
		references.select { |t, ref| t == type }
	end

	def self.find_by_ref(ctx_id,ctx_val)
    # Per exploit and aux module,
		res = (self.exploits + self.auxiliary).select do |m|
      # Compare the vuln identifier passed to all refs per module
			match_refs = m.references.select do |r|
				r[0] == ctx_id && r[1] == ctx_val.to_s
			end
			!match_refs.empty?
		end
    # If no refs, don't return module
		res.empty? ? nil : res
	end

	def filter(k)

		[0,1].each do |mode|
			match = false
			k.keys.each do |t|
				next if k[t][mode].length == 0

				refs = references.map { |x| x.join("-") }

				k[t][mode].each do |w|
					# Reset the match flag for each keyword for inclusive search
					match = false if mode == 0

					# Convert into a case-insensitive regex
					r = Regexp.new(Regexp.escape(w), true)

					case t
						when 'text'
							terms = [title, fullname, description] + refs + authors + targets.map { |_, t| t }
							match = [t,w] if terms.any? { |x| x =~ r }
						when 'name'
							match = [t,w] if title =~ r
						when 'path'
							match = [t,w] if fullname =~ r
						when 'author'
							match = [t,w] if authors.any? { |a| a =~ r }
						when 'os', 'platform'
							match = [t,w] if targets.any? { |_, t| t =~ r } or platform.any? { |p| p =~ r } or arch.any? { |a| a =~ r }
						when 'type'
							match = [t,w] if (w == "exploit" and exploit?)
							match = [t,w] if (w == "auxiliary" and auxiliary?)
							match = [t,w] if (w == "post" and post?)
						when 'app'
							match = [t,w] if (w == "server" and server_exploit?)
							match = [t,w] if (w == "client" and client_exploit?)
						when 'cve'
							match = [t,w] if refs.any? { |ref| ref =~ /^cve\-/i and ref =~ r }
						when 'bid'
							match = [t,w] if refs.any? { |ref| ref =~ /^bid\-/i and ref =~ r }
						when 'osvdb'
							match = [t,w] if refs.any? { |ref| ref =~ /^osvdb\-/i and ref =~ r }
						when 'edb'
							match = [t,w] if refs.any? { |ref| ref =~ /^edb\-/i and ref =~ r }
					end
					break if match
				end
				# Filter this module if no matches for a given keyword type
				if mode == 0 and not match
					return true
				end
			end
			# Filter this module if we matched an exlusion keyword (-value)
			if mode == 1 and match
				return true
			end
		end

		false
	end
end

