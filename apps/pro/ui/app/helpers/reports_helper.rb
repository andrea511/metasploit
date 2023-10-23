module ReportsHelper

	def ref_map(refs,width=3)
		ref_links = refs.map {|r| link_for_ref(*r.link_info)}
		ref_table = []
		td_width = ((1 / width.to_f) * 100).to_i
		ref_table = 0.upto(refs.size-1).collect {|i| ref_links[i,width] if i % width == 0}.compact
		# Allow sorting by number of refs on the client side.
		tbl = "<span title='#{refs.size}'></span>"
		tbl << '<table width="100%">'
		ref_table.each {|tr|
			tbl << "<tr>"
			td_count = 0
			tr.each {|td|
				tbl << "<td style=\"white-space: nowrap;\" width=\"#{td_width}%\">" << td << "</td>"
				td_count += 1
			}
			if tr.size == width 
				tbl << "</tr>"
			else
				(width - (tr.size % width)).times { tbl << "<td width=\"#{td_width}%\"></td>"}
				tbl << "</tr>"
			end
		}
		tbl << "</table>"
		return tbl
  end

  def ref_link(refs)
    show_more = refs.length >1 ? " (<a href='javascript:void(0)' class='details'>+#{refs.length-1} more</a>)" : ""
    refs.length>0 ? "#{link_for_ref(*refs[0].link_info)}#{show_more}"  : ""
  end

  def short_datetime(time=Time.now)
    time.strftime("%Y%m%d-%H%M")
  end

  # @param report [Report]
  # @return [Array] of child artifacts of report, file extension linked
  # to artifact view page.
  def linked_artifact_list(report)
    # TODO These should be sorted by the extension alphabetically
    report.report_artifacts.collect { |f|
      format = f.format.try(:upcase)
      if format
        view_context.link_to(format,
                view_workspace_report_report_artifact_path(report.workspace_id, report.id, f.id)
        )
      else
        'Report File Missing'
      end
    }
  end

  # @param artifacts [Array]
  # @return [String] of artifacts or status message if none
  def wrapped_artifact_list(artifacts)
    if artifacts.blank?
      'None'
    else
      artifacts.join(', ')
    end
  end

end

