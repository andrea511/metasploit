module HostsHelper

  include Presenters::Host

	def link_to_add_service(f)
		link_to_add_field(f, :service, :class => Mdm::Service)
	end

	# Finds exploit modules matching a vuln and host,
  # Returns all matches found linked to the module page.
	def map_exploit(vuln, host)
    found_exploits = vuln.vuln_attempts.map(&:module)

		if found_exploits.empty?
      # Pull in system note (applies to Nexpose imports)
			ret = map_vuln_key(vuln) if @host
		else
      linked_exploits = found_exploits.map { |mod| link_to(h(mod), new_module_run_path(@workspace, mod, :host_ids => [host.id])) }.uniq.join(", ")
			ret = linked_exploits
		end
		ret = "" if ret.nil?
		return ret
	end

	# So far, only nexpose imports populate the vuln key system note, so just
	# deal with that.
	def map_vuln_key(vuln)
		return unless(vuln.name =~ Mdm::Vuln::NEXPOSE_REF_ID_PATTERN)
		vid = vuln.name.gsub(Mdm::Vuln::NEXPOSE_REF_ID_PATTERN,"")
		has_vuln_key = false
		@host.notes.visible.each do |note|
			next unless note.ntype == "host.vuln.nexpose_keys"
			next unless note.data.include? vid
			has_vuln_key = true
			break
		end
		if has_vuln_key
			link_to("See host.vuln.nexpose_keys", "#notes")
		end
	end

  def host_tag_cloud(host)
    return encode("") unless host.tags.size > 0
    hsh = host.tag_frequency
    tag_links = []
    total_hosts = host.workspace.hosts.size.to_f
    hsh.each_pair do |name,freq|
      if freq == total_hosts
        fsize = 3
      elsif (freq <= total_hosts * 0.25) or freq == 1
        fsize = 0
      elsif freq <= total_hosts * 0.5
        fsize = 1
      elsif freq > total_hosts * 0.5
        fsize = 2
      elsif freq >= total_hosts * 0.75
        fsize = 3
      end
      pc = "%.1f" % (freq.to_f/total_hosts * 100)

      tag_link = content_tag(
        :div,
        link_to(
          h(name),
          hosts_path(host.workspace) << ("?search=%23" << name), :title => "#{pc}% of hosts"),
        :class => "tag"
      )

      case fsize
      when 0,1
        tag_links.push(tag_link)
      when 2,3
        tag_links.unshift(tag_link)
      end

    end
    encode(tag_links.join(" "))
  end

	def hosts_page_link(name, args, workspace=@workspace)
		hosts_per_page = ( args[:hosts_per_page] || @hosts_per_page ).to_i
		path_args = { :workspace_id => workspace.id, :page => args[:page], :n => hosts_per_page }
		path_args[:search] = params[:search] if params[:search]
		path_args[:sort_by] = params[:sort_by] if params[:sort_by]
		path_args[:sort_dir] = params[:sort_dir] if params[:sort_dir]
		html_options = args[:html_options] || {}
	 	link_to name, hosts_path(path_args), html_options
  end

	# Generate the markup for the host's row checkbox.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_checkbox_tag(host)
		encode(check_box_tag('host_ids[]', h(host.id), false, :id => nil))
	end

	# Generate the markup for the host IP address.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_address_html(host)
    encode(link_to(h(host.address), h(host_path(host))))
	end

	# Generate the markup for the host name.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_name_html(host)
		encode(json_data_scrub(h(host.name)))
	end

  # Generate the icon markup for the host OS icons.
  #
  # host - The Mdm::Host to fetch the attribute from.
  #
  # Returns html_safe string
	def host_os_icon_html(host, opts = {})
		markup = "<img src='#{os_to_icon(host.os)}' class='os_icon'>"

		if opts.fetch(:json, true)
			encode(json_data_scrub(markup))
		else
			markup
		end
  end

	# Generate the markup for the host OS icons.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_os_html(host)
		os_string = (host.os || "Unknown") + " " + host.os_sp.to_s
		encode("<img src='#{os_to_icon(host.os)}' class='os_icon'>#{h(json_data_scrub(os_string))}")
	end

	# Generate the markup for the host OS version.
	#
	# host - The Mdm::Host to fetch the attribute from.
  # opts - a Hash of additional options
  #   :json - escapes the data for display in JSON. defaults to true.
	#
	# Returns the String markup html, escaped for json.
	def host_os_virtual_html(host, opts={})
		hdata = "&nbsp;"
		if host.is_vm_guest?
			hdata = ActionController::Base.helpers.image_tag("icons/os/vm_logo.png", title: h(host.virtual_host))
		end
    if opts.fetch(:json, true)
      encode(json_data_scrub(hdata))
    else
      hdata
    end
	end

	# Generate the markup for the host purpose.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the markup html, escaped for json.
	def host_purpose_html(host)
		encode(json_data_scrub(truncate(h(host.purpose.to_s))))
	end

	# Generate the markup for the host services.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_services_html(host)
		encode(blank_if_zero(host.service_count.to_i).to_s)
	end

	# Generate the markup for the host vulns.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_vulns_html(host)
		encode(blank_if_zero(host.vuln_count.to_i).to_s)
	end

	# Generate the markup for the host tags or notes, depending upon the license.
	#
	# host       - The Mdm::Host to fetch the attribute from.
	# tag_search - The Boolean indicating whether or not a tag search is being performed.
	#
	# Returns the String markup html, escaped for json.
	def host_tags_or_notes_html(host, tag_search)
		tag_count = tag_search ? host.tags.size : host.tags_count
    if tag_count.to_i > 0
      markup = tag_html(host.tags.first)
      if tag_count.to_i > 1
        markup += icon('list', :class => 'tags-icon')
        tags = ""
        host.tags.each do |tag|
          tags += tag_html(tag)
        end
        markup += content_tag(:div, :class => 'tags-hover') do
          encode(tags) + image_tag('triangle.png', :class => 'tags-hover-triangle')
        end
      end
      markup = content_tag :div, :class => 'tags-wrap' do # wrap in a div
        markup
      end
      encode(markup)
    else
      return encode("")
    end
	end

	# Generate the markup for the host tag, including hidden fields needed
	# for the front-end JavaScript.
	#
	# tag - The Mdm::Tag to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def tag_html(tag, workspace=@workspace)
		content_tag(:div, :class => 'tag') do
			link_to(h(tag.name), hosts_path(workspace) << ("?search=%23" << tag.name)) +
			content_tag(:span, :class => 'tag-id invisible') { tag.id.to_s } +
			content_tag(:span, :class => 'tag-name invisible') { tag.name }
		end
	end

	# Generate the markup for the host's update_at attribute.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_updated_at_html(host)
    encode(content_tag(:span, :class => (host.attributes['flagged_count'].to_i > 0 && host.recently_updated?) ? "badge" : "") do
			host.updated_at ? "#{time_ago_in_words(host.updated_at)} ago" : "never"
		end)
	end

	# Generate the markup for the host's update_at attribute.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_status_html(host)
		text = host_status_text(host)

		# add some links to a few of the status messages
		output = case text
		when "looted"
			link_to text.capitalize, host_path(host)+"#captured_data"
		when "cracked"
			link_to text.capitalize, host_path(host)+"#credentials"
		when "shelled"
			link_to text.capitalize, workspace_sessions_path(host.workspace)
		else
			text.capitalize
		end

    encode(content_tag(:div, output, :class => "host_status_#{text}"))
	end


	# Generate the markup for the host's exploit attempt count attribute.
	#
	# host - The Mdm::Host to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def host_attempts_html(host)
		encode(blank_if_zero(host.exploit_attempt_count.to_i).to_s)
	end

	# Display a properly formatted Mdm::Vuln name.
	#
	# vuln - The Mdm::Vuln to fetch the attribute from.
	#
	# Returns the String markup.
	def vuln_name(vuln)
		if vuln.from_nexpose?
			ref = vuln.name.sub(Mdm::Vuln::NEXPOSE_REF_ID_PATTERN, '')
			link_text = "Nexpose ( #{ref} )"
			"<a href='http://www.rapid7.com/vulndb/lookup/#{ref.downcase}' target='_blank'>#{link_text}</a>"
		elsif vuln.exploit?
			link_to_exploit(vuln.name)
		else
			h vuln.name
		end
	end

	def vuln_port(vuln)
		port = ""
		unless vuln.service.nil?
			port = vuln.service.port.to_s
		end
		return port
	end

	def vuln_service(vuln)
		service = ""
		unless vuln.service.nil?
			service = vuln.service.name
		end
		return service
	end

  def exploit_link(name=nil,host=nil,service=nil)
    	link = new_module_run_path(@workspace, h(name))
     	if host && host.address
      	link << "?target_host=#{host.address}"
     	end
     	if service && service.port
      	link << "&target_port=#{service.port}"
     	end
     	return link
  end

  def link_to_exploit(name=nil,host=nil,service=nil)
 		link_to h(name), exploit_link(name,host,service)
  end

  private

  # Properly encode markup for use in a JSON response.
  #
  # @param markup [String] the HTML markup to be encoded
  #
  # @return [String] html safe markup
  def encode(markup)
    markup.html_safe
  end
end
