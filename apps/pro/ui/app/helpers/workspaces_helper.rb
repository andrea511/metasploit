module WorkspacesHelper
	# Determines if the overview section of the dashboard should be collapsed.
	#
	# Returns true if the section should be collapsed, false otherwise.
	def show_dashboard?
		@workspace.hosts.count > 0 && @workspace.services.count > 0
	end

	def global_search_vuln_refs_html(vuln)
		refs = vuln.refs
		ref_links = refs[0..2].map {|r| link_for_ref(*r.link_info)}
		ref_table = []
		ref_table = 0.upto(refs.size-1).collect {|i| ref_links[i,3] if i % 3 == 0}.compact
		tbl = "<div class='full-ref-map invisible'>"
		tbl += ref_map(refs, 3)
		tbl += "</div>"
		tbl << '<table width="100%">'
		tr = ref_table.first
		tbl << "<tr>"
		td_count = 0

		unless tr.nil?
			if refs.size < 3
				0.upto(3 - refs.size).each do
					tr << "&nbsp;"
				end
			elsif refs.size > 3
				tr << link_to("View all", '', :class => 'full-ref-map-view')
			else
				tr << "&nbsp;"
			end
			tr.each {|td|
				tbl << "<td style=\"white-space: nowrap;\" width=\"25%\">" << td << "</td>"
				td_count += 1
			}
		end
		tbl << "</tr>"
		tbl << "</table>"
		return tbl.html_safe
	end

end

