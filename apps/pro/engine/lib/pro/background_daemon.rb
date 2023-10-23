#
# Standard Libraries
#

require 'timeout'

#
# Gems
#

require 'msf/core'
require 'nexpose'

module Pro
class BackgroundDaemon

  attr_accessor :framework, :monitor, :state, :profile, :update_last_checked
  attr_accessor :sonar_last_checked

  def initialize(framework)
    self.state = {}
    self.framework = framework

    #
    # Spawn thread to kickoff sanity/maintenance loop
    #
    self.monitor = framework.threads.spawn("BackgroundDaemon", false) do
      #
      # This is a sanity loop that will launch and re-launch
      # the maintenance loop if it dies for any reason
      #
      loop do
        maintenance_tasks rescue nil
        ::IO.select(nil, nil, nil, 30.0)
      end
    end
  end # initialize

  #
  # Execute sub-tasks defined below
  #
  def maintenance_tasks
    loop do
      #
      # Execute nexpose console state update logic
      #
      begin
        update_nexpose_console_states
      rescue ::Exception => e
      end

      #
      # Execute product update alerting logic
      #
      begin
        check_for_updates
      rescue ::Exception => e
        elog("[BG Daemon] Product Updates: #{e.class} #{e}:\n#{e.backtrace.join("\n")}")
      end

      #
      # Check for valid Sonar License
      #
      begin
        check_sonar_license
      rescue ::Exception => e
        elog("[BG Daemon] Sonar License: #{e.class} #{e}:\n#{e.backtrace.join("\n")}")
      end

      #
      # Execute scheduled task chain logic
      #
      begin
        exec_scheduled_chains
      rescue ::Exception => e
        elog("[BG Daemon] Scheduled Chains: #{e.class} #{e}:\n#{e.backtrace.join("\n")}")
      end

      ::IO.select(nil, nil, nil, 10.0)
    end
  end # maintenance_tasks

  def update_nexpose_console_states
    ::ApplicationRecord.connection_pool.with_connection {
      Mdm::NexposeConsole.all.each do |con|
        self.state[con.id] ||= 0
        next if not con.enabled

        # Look for recently modified consoles
        if con.updated_at.utc.to_i > self.state[con.id] or self.state[con.id] + (60 * 10) < ::Time.now.utc.to_i
          update_nexpose_console_state(con)
        end
      end
    }
  end

  def check_for_updates
    ::ApplicationRecord.connection_pool.with_connection {
      profile = Mdm::Profile.find_by_active(true)
      return if not profile

      #
      # Run through the software update check if:
      #	1. Global options are set to automatically check for updates
      #	and
      #	2. The check has not been run before
      #	or
      #	3. The check has not happened in 6 hours
      #
      if profile.settings["automatically_check_updates"] &&
        (@update_last_checked.nil? ||
         @update_last_checked < 6.hours.ago.utc)

        #
        # Redmine: #6898
        # Update last checked time here to ensure any errors below will
        # not cause this logic to be executed every 10 seconds.
        #
        @update_last_checked = Time.now.utc

        #
        # Use an HTTP proxy for the update request if one is configured
        #
        if profile.settings["use_http_proxy"]
          proxy_settings =  {
            :proxy_host => profile.settings["http_proxy_host"],
            :proxy_port => profile.settings["http_proxy_port"],
            :proxy_user => profile.settings["http_proxy_user"],
            :proxy_pass => profile.settings["http_proxy_pass"],
          }
        end

        #
        # Make actual call to check for available update package
        #
        update = ::UpdateCheck.new(proxy_settings || {})
        #
        # Update profile record based on status of update check
        #
        if update.error.nil?
          profile.settings["update_proxy_error"] = nil
          profile.settings["update_available"]   = !update.up_to_date?
        else
          # Don't treat a missing license as a proxy error
          if update.error =~ /no product key/i
            profile.settings["update_proxy_error"] = nil
          else
            profile.settings["update_proxy_error"] = true
          end
          profile.settings["update_available"]   = nil
        end

        #
        # If the update check takes five minutes to time out, then we don't want
        # to save the profile object we loaded five minutes ago. Reload it, overwrite
        # the settings we changed, and save it again to avoid ActiveRecord::StaleObjectError.
        #
        fresh_profile = Mdm::Profile.find(profile[:id])
        ["update_proxy_error","update_available"].each do |field|
          fresh_profile.settings[field] = profile.settings[field]
        end

        replace_and_create_update_notification(update)
        fresh_profile.save

        if update.metrics
          metric_processor = Rex::ThreadFactory.spawn("Background Usage Metrics Processor", false) do
            error = UsageMetrics.update(proxy_settings || {})
            unless error.nil?
              elog("Error: #{error}")
            end
          end
          metric_processor.priority = -10
        end
      end
    }
  end

  # Checks the Sonar license every 6 hours to attempt to enroll in Sonar
  # and ensure that the {SonarAccount} is still valid.
  def check_sonar_license
    if @sonar_last_checked.nil? || @sonar_last_checked <  6.hours.ago.utc
      @sonar_last_checked = Time.now.utc
      license_info = self.framework.esnecil_information
      product_key = license_info['product_key']
      enroller = Metasploit::Pro::Engine::Sonar::Enroller.new(product_key)
      enroller.enroll
    end
  end

  #
  # Only create an Update Notification if we are not up to date or replace it
  #
  def replace_and_create_update_notification(update)
    latest_version = update.latest_version
    unless update.up_to_date?
      notification_messages = Notifications::Message.arel_table
      update_query = Notifications::Message.where(notification_messages[:content].matches("Update % Available"))

      create_notification = update_query.exists? ? update_query.first.content != "Update #{latest_version} Available" : true

      if create_notification
        Notifications::Message.transaction do
          update_query.destroy_all
          create_update_notification(latest_version)
        end
      end

    end
  end

  #
  # Create Update Notification
  #
  def create_update_notification(latest_version)
    update_message ="Update #{latest_version} Available"
    Notifications::Message.create(:title => "Update Available",:url => '/updates', :content => update_message ,
                                  :kind => :update_notification)
  end

  #
  # Handle execution of scheduled task chains
  #
  def exec_scheduled_chains
    ::ApplicationRecord.connection_pool.with_connection {
      #
      # Query scheduled task chains and extract records
      # whose next_run_at value is <= the current time
      #
      task_chains = TaskChain.where(state: 'ready').
                              where(TaskChain.arel_table[:next_run_at].lteq(Time.now.utc)).
                              select {|tc| tc.valid? }

      #
      # Iterate over any chains returned above and execute task list
      #
      task_chains.each_with_index do |chain, index|
        chain_cnt = index + 1

        chain.start! # state: 'running'

        # Skip over any chain that fails validation
        next unless chain.save

        #
        # Spawn a thread on a per-chain basis so we do not block
        # the overall event loop querying for scheduled chains
        #
        framework.threads.spawn("TaskChain#{chain_cnt}", false, chain) do |xchain|
          begin
            #
            # Execute all tasks associated with each chain
            #
            exec_scheduled_tasks(xchain)
          rescue ::Exception => e

            elog("Error processing Chain #{xchain.id}: #{e.class} #{e} #{e.backtrace}")

          end

          #
          # Update the chain's state to 'ready' and save
          #
          xchain.finish!

        end # thread spawn

      end # task chain iterator
    }
  end # exec_scheduled_chains

  def exec_scheduled_tasks(chain)
    ::ApplicationRecord.connection_pool.with_connection {
      #
      # Grab associated tasks for this chain
      #
      task_list = chain.scheduled_tasks

      #
      # Stop all sessions and delete all hosts associated with the project
      # for which this chain was scheduled.
      #
      if chain.clear_workspace_before_run
        chain.workspace.sessions.each { |s| s.stop rescue nil }
        chain.workspace.hosts.destroy_all
      end

      #
      # Instantiate RPC client object
      #
      rpc = ::Pro::Client.get

      #
      # Iterate over task list and execute
      #
      task_list.each do |task|
        #
        # Update last_run_at value to be the start time of task
        #
        task.last_run_at = Time.now.utc
        task.save!

        #
        # Pass task's config_hash off to rpc method based on task type
        #
        case task.kind
          when /^scan$/i # avoid clash w/ webscan
            tid = rpc.call("pro.start_discover", task.config_hash)['task_id']
          when /exploit/i
            tid = rpc.call("pro.start_exploit", task.config_hash)['task_id']
          when /bruteforce/i
            tid = launch_bruteforce(task,chain)
          when /report/i
            rid = launch_report(task,chain)
          when /^import$/i
             tid = launch_import(task,rpc)
          when /webscan/i
            tid = rpc.call("pro.start_webscan", task.config_hash)['task_id']
          when /^scan_and_import$/i
            sites = task.form_hash[:sites]
            import_run_id = task.config_hash["DS_IMPORT_RUN_ID"]
            ::Nexpose::Data::ImportRun.find(import_run_id).choose_sites(sites)

            tid = rpc.call("pro.start_scan_and_import", task.config_hash)['task_id']
          when /collect/i
            # Collect on all sessions opened during the chain's run
            session_list = Mdm::Session.alive.joins(:workspace).where(workspaces: {id: chain.workspace_id})
            session_ids = ''

            if session_list.present?
              session_ids = session_list.map { |session| session.local_id.to_s }.join(" ")
            end

            task.config_hash.merge!({'DS_SESSIONS' => session_ids})

            tid = rpc.call("pro.start_collect", task.config_hash)['task_id']
          when /cleanup/i
            tid = rpc.call("pro.start_cleanup", task.config_hash)['task_id']
          when /module_run/i
            tid = rpc.call("pro.start_single", task.config_hash)['task_id']
          when /rc_script/i
            tid = rpc.call("pro.start_rc_launch", task.config_hash)['task_id']
          when /nexpose_push/i
            tid = rpc.call("pro.start_nexpose_exception_and_validation_push_v2", task.config_hash)['task_id']
          when /metamodule/i
            tid = launch_metamodule(task)
          else
            # we need to Raise an error when we dont get a task_id
        end

        #
        # Block on task execution waiting until complete (or error)
        #
        if tid || rid
          chain.active_scheduled_task_id = task.id
          #If a Task
          if tid
            chain.active_task_id = tid
            chain.last_run_report_id = nil
            chain.last_run_task_id = tid
            chain.save
            while poll_scheduled_task(rpc, chain, task)
              sleep(10)
            end
          end

          #If a Report
          if rid
            chain.active_report_id = rid
            chain.last_run_task_id = nil
            chain.last_run_report_id = rid
            chain.save
            while poll_report_job(rid,task)
              sleep(10)
            end
            chain.active_report_id = nil
          end
        else
          task.state  = 'Error: RPC call did not return task id'
          scheduled_task_failure(task)
        end

        #
        # Stop task chain execution if any task fails
        #
        break if task.last_run_status == 'failure'
      end # task_list iterator

    }
  end # exec_scheduled_tasks


  def poll_scheduled_task(rpc, task_chain, scheduled_task)
    active_task_id = task_chain.active_task_id.to_s
    response = rpc.call("pro.task_status", task_chain.active_task_id)
    task_chain.reload
    #
    # If error condition detected, set status to false and break
    #

    if response['error'] and response[active_task_id]['error'].present?
      scheduled_task.state  = "Error: #{response['error'] || response[active_task_id]['error']}"
      scheduled_task_failure(scheduled_task)
      return false
    end
    if (task_chain.suspended? || task_chain.ready?)
      scheduled_task.state  = "Scheduled Task Has been suspended or stopped."
      rpc.task_stop(active_task_id)
      scheduled_task_failure(scheduled_task)
      return false
    end

    #
    # Update the current state of running task
    #
    unless scheduled_task.state == response[active_task_id]['info']
      scheduled_task.state = response[active_task_id]['info']
      scheduled_task.save!
    end
    response[active_task_id]['status'] == 'running'
  end # poll_scheduled_task

  def poll_report_job(rid,scheduled_task)
    report = Report.find(rid)
    if report.state == 'failed'
      scheduled_task.last_run_status = 'failure'
      scheduled_task.save
      elog("Error processing Generating Report (#{report.id}) - Please see reports/log")
      return false
    else
      scheduled_task.state = report.state
    end

    if report.state == 'complete'
      return false
    end

    return true
  end


  def scheduled_task_failure(scheduled_task)
    scheduled_task.last_run_status = 'failure'
    unless scheduled_task.save
      elog("Error processing Task #{task.id}: failed to save updated status")
    end
  end

  def update_nexpose_console_state(con)
    ::ApplicationRecord.connection_pool.with_connection {
      status = "Unknown"
      sites  = []
      vers   = ''
      nsc    = nil

      begin
        ::Timeout.timeout(10) do
          nsc = Nexpose::Connection.new( con.address, con.username, con.password, con.port )
          nsc.login
          status = "Available"
        end

        ::Timeout.timeout(10) do
          if nsc
            res = nsc.console_command("ver") rescue nil
            if res and res =~ /^(NSC|Console) Version ID:\s*(\d+)\s*$/m
              vers = $2
            else
              vers = "Unknown"
            end
          end
        end

        ::Timeout.timeout(10) do
          if nsc
            sites = nsc.list_sites.collect { |site| site.name }
          end
        end

        ::Timeout.timeout(10) do
          users = nsc.users
          users.each do |user|
            if user.name == con.username
              status = "User #{con.username} has limited privilege" unless user.is_admin
            end
          end
        end

      rescue ::Timeout::Error => e
        elog("Nexpose console timeout: #{e}")
        status = "Timeout"
      rescue Nexpose::AuthenticationFailed => e
        elog("Nexpose console authentication failed: #{e}")
        status = "No Access"
      rescue Nexpose::APIError => e
        elog("Nexpose console API error: #{e}")
        if e.req.error.include?('GLOBAL_ALL_PRIVILEGE')
          status = "User #{con.username} has limited privilege"
        else
          status = "Error: #{e.req.error}"
        end
      rescue ::SocketError => e
        elog("Nexpose console socket error: #{e}")
        status = "Unreachable"
      rescue ::Exception => e
        elog("Nexpose console error: #{e}:\n#{e.backtrace.join("\n")}")
        status = "Error(#{e.class})"
      ensure
        if nsc
          nsc.logout rescue nil
        end
      end

      update_info = { :status => status, :updated_at => ::Time.now.utc }
      update_info[:cached_sites] = sites if (sites.length > 0)
      update_info[:version]      = vers  if (vers and not vers.empty?)

      Mdm::NexposeConsole.update(con.id, update_info)
      self.state[con.id] = ::Time.now.utc.to_i
    }
  end

  private


  def launch_bruteforce(task,chain)
    run = ::BruteForce::Quick::Launch.run(task.form_hash.to_hash.merge({
                                                 workspace: chain.workspace,
                                                 current_user: chain.user
                                               }))
    if run.valid?(:stand_alone)
      run.task_data['task_id']
    end
  end

  def launch_report(task,chain)
    report_params = task.form_hash.merge({workspace_id: chain.workspace_id})
    report = build_sanitized_report(report_params,chain)
    report.save
    report.generate_delayed
    report.id
  end

  # TODO DRY, this is almost identical to method in
  # ReportsSharedControllerMethods Mixin
  def build_sanitized_report(report_params,chain)
    # Without this conversion to HWIA,
    # ActiveModel::ForbiddenAttributesError is thrown:
    params = ActiveSupport::HashWithIndifferentAccess.new(report_params)
    report = Report.new(params)
    report.created_by = chain.user.username
    # TODO Should include users that performed related actions
    report.usernames_reported = chain.user.username
    # TODO Serialized field issues, remove empty
    # items so validation works:
    report.options.delete('') if report.options
    report.file_formats.delete('') if report.file_formats
    report.sections.delete('') if report.sections
    report
  end

  def launch_import(task,rpc)
    unless task.file_upload.nil?
      task.config_hash['DS_PATH'] = task.file_upload.current_path
    end
    this_config = task.config_hash.dup
    this_config['DS_REMOVE_FILE'] = false
    rpc.call("pro.start_import", this_config)['task_id']
  end

  def launch_metamodule(task)
    app = Apps::App.select([:symbol]).where(symbol: task.form_hash[:mm_symbol]).first
    task.form_hash[:cred_type] = "stored"
    #Because we wrap all the input parameters in the input_for_hash[index] hash
    task.form_hash.delete(:report)

    begin
      #TODO: Refactor MM Symbol to Passive Network Discovery
      if app[:symbol] == "passive_network"
        task_config = Apps::PassiveNetworkDiscovery::TaskConfig.new(task.form_hash)
      else
        task_config = Apps.const_get(app[:symbol].camelize)::TaskConfig.new(task.form_hash)
      end

    rescue NameError => e
      task_config = Object.const_get(app[:symbol].camelize)::TaskConfig.new(task.form_hash)
    end

    report = Report.new(task.report_hash)
    report.save
    task_config.report = report
    task = task_config.launch!
    task.id
  end

end
end

