module TasksHelper

  include Msf::Pro::Locations
  def locations
    @_locations ||= Object.new.extend(Msf::Pro::Locations)
  end

	def autotag_checkbox(host_tag)
		if host_tag.kind_of? Mdm::Tag
			check_box_tag controller.action_name.split("_",2).last + "_task[autotag_tags][]", host_tag.id, false, :id => "tag_#{host_tag.id}"
		else
			check_box_tag controller.action_name.split("_",2).last + "_task[autotag_tags][]", -1, false, :id => nil
		end
	end

	def next_task
		if Mdm::Task.count > 0
			next_id = Mdm::Task.last.id + 1
		else
			next_id = 1
		end
		this_action = case controller.action_name
			when "new_scan"
				"discover"
			when "new_collect_evidence"
				"collect"
			when /^new_(.*)/
				$1.gsub(/[^A-Za-z0-9]/,"_")
			when /^(new|edit)$/
				unless params[:kind].empty?
          case params[:kind]
            when 'scan'
              "discover"
            else
              params[:kind]
          end
        else
          if controller.class.to_s =~ /^Campaign/
            "campaign"
          else
            controller.class.to_s
          end
        end
			else
				controller.action_name
			end
		[this_action,next_id].join("_")
	end

  def prettified_tasklog(task, from_line: 0)
    tasks_directory_path = locations.pro_tasks_directory
    basename = File.basename(task.path)

    path = File.join(tasks_directory_path, basename)

    if path and File.exist?(path)
      log = ''
      File.open(path, 'rb') do |file|
        file.each_line("\n") do |line|
          if from_line > 0
            # Doing the check here still results in a lot of string allocations
            # for large files, but it may help?
            from_line -= 1
          else
            log << tasklog_prettify(line)
          end
        end
      end
    else
      log = tasklog_prettify '(Task log is not available)'
    end

    log << tasklog_cap(task)
  end

	# add an invisible element that responds to the ".end" selector at the
	# end of a tasklog to mark the task as completed on the client (js) side
	def tasklog_cap(task)
		unless task.running? || task.paused?
			'<span class="end" style="display:none;"></span>'.html_safe
		else
			''
		end
	end

	def tasklog_prettify(line)
		new_line = line.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    wsindex = new_line.index('Workspace:')
    pindex = new_line.index('Progress:', wsindex + 11) if wsindex
    ltype = if wsindex && pindex
      'status'
    elsif new_line.start_with?('[-]')
      'error'
    elsif new_line.start_with?('[+]')
      'good'
    else
      'normal'
    end

		content_tag :div, h(new_line), :class => "logline_#{ltype}"
	end

	# Generate the options hash for the Nexpose console +input+ call.
	#
	# consoles - The Array of available consoles for selection.
	#
	# Returns the Hash options.
	def nexpose_console_select_options(consoles)
		options = { collection: options_for_select(consoles) }
		if consoles.size > 1
			options.merge! prompt: "Select a Nexpose console below"
		else
			options.merge! include_blank: false
		end
	end

end
