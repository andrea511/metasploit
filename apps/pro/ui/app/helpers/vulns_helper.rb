module VulnsHelper
	# Generate the markup for the Mdm::Vuln's row checkbox.
	#
	# vuln - The Mdm::Vuln to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def vuln_host_checkbox_tag(vuln, opts={})
		markup = ""
		unless opts[:no_host]
			markup += check_box_tag("host_ids[]", vuln.host.id, false, :id => nil, :class => 'hosts')
		end
		class_name = if opts[:no_host] then '' else 'invisible' end
		markup += check_box_tag("vuln_ids[]", vuln.id, false, :id => nil, :class => "#{class_name} vulns")
		markup += "<div class='invisible'>"
		unless opts[:no_host]
			vuln.host.tags.each do |tag|
				markup += tag_html(tag)
			end
		end
		markup += "</div>"
		markup.to_json.html_safe
	end

	# Output the markup to display a ref's name as either a text field or a
	# plaintext, depending upon whether it appears on the new or edit views.
	#
	# ref  - The Mdm::Ref being displayed.
	# form - The FormBuilder instance for the Mdm::Ref's form.
	#
	# Returns the String markup.
	def ref_name_field(ref = nil, form = nil)
		if controller.action_name == 'edit'
			ref.name
		else
			form.text_field :name
		end
	end

	# Generate the markup for the Mdm::Vuln's Mdm::Host's name.
	#
	# vuln - The Mdm::Vuln to fetch the Mdm::Host's attribute from.
	#
	# Returns the String markup html, escaped for json.
	# TODO: Abstract this. It's used in several of the Analysis tab views.
	def vuln_host_name_html(vuln)
		raw_name = vuln.host.name
		# if the hostname was populated from a wildcard cert, we don't want
		#   to see a huge list of e.g. *.metasploit.com
		name_is_safe = raw_name.present? && !raw_name.starts_with?("*")
		name = name_is_safe ? (json_data_scrub(raw_name)) : vuln.host.address
		link_to(name, vuln.host).to_json.html_safe
	end

	# Generate the markup for the Mdm::Vuln name.
	#
	# vuln - The Mdm::Vuln to fetch the attribute from.
	#
	# Returns the String markup html, escaped for json.
	def vuln_name_html(vuln)
		name = h(json_data_scrub(vuln.name))
		link_to(name, workspace_vuln_path(@workspace, vuln)).to_json.html_safe
	end

	# Calculate the status of an Mdm::Vuln
	#
	# TODO: Performance of this is terrible. See MSP-13179
	def vuln_status_html(vuln, params, opts={escape: true})

		latest_match_result = Mdm::ExploitAttempt.where({vuln_id:vuln.id}).last

		status_type =
			case latest_match_result.try(:exploited)
				when nil
					:not_tested
				when true
					:exploited
				when false
					:exploit_attempted
				else
					:not_tested
			end

    last_vuln_attempt = vuln.vuln_attempts.last

    if !last_vuln_attempt.nil? && !last_vuln_attempt.last_fail_reason.nil?
			status_type = :not_exploitable
    end

    if !last_vuln_attempt.nil?  && last_vuln_attempt.last_fail_reason.nil? && last_vuln_attempt.exploited == false
			status_type = :exploit_attempted
		end

		status = vuln_status_html_template(status_type)

    if opts[:escape]
      status.to_json.html_safe
    else
      status
    end
	end

	def vuln_status_html_template(status)
		case status
			when :not_tested
				css_class       = 'not-tested'
				css_data_status = 'not_exploitable'
				status_text     = 'Not Tested'
			when :exploited
				css_class       = 'exploited'
				css_data_status = 'exploited'
				status_text     = 'Exploited'
			when :exploit_attempted
				css_class       = 'exploit-attempted'
				css_data_status = 'not_exploitable'
				status_text     = 'Exploit Attempted'
			when :not_exploitable
				css_class       = 'not-exploitable'
				css_data_status = 'not_exploited'
				status_text     = 'Not Exploitable'
		end
		<<-TEMPLATE
		<div class='pill'>
		  <div class='#{css_class}' data-status='#{css_data_status}'>
				#{status_text}
			</div>
		</div>
    TEMPLATE
	end


	# Generate the markup for the Mdm::Vuln's refs.
	#
	# vuln - The Mdm::Vuln to fetch the relationship from.
	#
	# Returns the String markup html, escaped for json.
	def vuln_refs_html(vuln)
		refs = vuln.refs
		pref = [ "CVE", "OSVDB", "BID", "NEXPOSE" ]

		tbl = ""
		ref = nil
		pref.each do |rt|
			ref = refs.select{|r| r.name.index(rt+"-") == 0 }.first
			break if ref
		end

		ref ||= refs.first

		if ref
			ref_link = link_for_ref(*ref.link_info)

			tbl = "<div class='full-ref-map invisible'>"
			tbl += "<h2>#{h vuln.name}</h2><br/>"
			tbl += ref_map(refs, 3)
			tbl += "</div>"

			tbl << '<table width="100%">'
			tbl << "<tr><td>"
			tbl << ref_link

			if refs.length > 1
				tbl << " ("
				tbl << link_to("#{refs.length} Total", '', :class => 'full-ref-map-view')
				tbl << " )"
			end

			tbl << "</td></tr>"
			tbl << "</table>"
		else
			tbl = '<table width="100%"><tr><td>No references</td></tr></table>'
		end
		return tbl.to_json.html_safe
	end


	# Generate the markup for the Mdm::Vuln's attempt counter
	#
	# vuln - The Mdm::Vuln to fetch the relationship from.
	#
	# Returns the String markup html, escaped for json.
	def vuln_attempts_html(vuln)
		(
			case vuln.vuln_attempt_count
			when 0
				"&nbsp;"
			when 1
				"<img src='/assets/icons/silky/tick.png' title='Tested Once'>"
			else
				"<img src='/assets/icons/silky/tick.png' title='Tested #{vuln.vuln_attempt_count} Times'>"
			end
		).to_json.html_safe
	end

	# Generate the markup for the Mdm::Vuln's exploit counter
	#
	# vuln - The Mdm::Vuln to fetch the relationship from.
	#
	# Returns the String markup html, escaped for json.
	def vuln_exploits_html(vuln)

		res = '&nbsp;'

		if vuln.exploited_at
			res = "<img src='/assets/icons/silky/exclamation.png' title='Exploited at #{vuln.exploited_at.to_s}'>"
		elsif vuln.vuln_attempt_count == 1
			res = "<img src='/assets/icons/silky/tick.png' title='Tested once'>"
		elsif vuln.vuln_attempt_count > 1
			res = "<img src='/assets/icons/silky/tick.png' title='Tested #{vuln.vuln_attempt_count} times'>"
		else
			res = "<img src='/assets/icons/silky/bullet_white.png' title='Untested'>"
		end

		res.to_s.to_json.html_safe
	end


	# Generate the markup for the Mdm::Vuln's exploit counter
	#
	# vuln - The Mdm::Vuln to fetch the relationship from.
	#
	# Returns the String markup html, escaped for json.
	def vuln_service_html(vuln)
		( vuln.service ? "#{vuln.service.port}/#{vuln.service.proto}" : "&nbsp;" ).to_json.html_safe
	end

	# Generate the markup for the Mdm::Vuln's refs count.
	#
	# vuln - The Mdm::Vuln to fetch the relationship from.
	#
	# Returns the String markup html, escaped for json.
	def vuln_host_count_html(vuln)
		link_to(vuln.host_count, workspace_vulns_path(@workspace, :search => vuln.name)).to_json.html_safe
	end
end
