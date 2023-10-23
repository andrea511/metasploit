# This should be mixed in to any class providing the overseer/commander role in a "module spawning other modules"
# pattern.  It provides job management functionality for the class, enabling it to spawn new modules, shut down
# submodules when finished, etc.
#
# The module expects to operate on a #command_object which implements a finite state machine via the State Machine
# gem.  Using the #command_object enables us to generalize the state management aspects of the "commander" behavior
# here.  In the base class, the object is retrieved from the database and set.

# The command module can run in one of two command modes -- single-threaded and multi-threaded.
#
# single-threaded mode runs modules one after another, passing responsibility for transition logic to the
# command object itself.
#
# multi-threaded mode run each module on its own thread, managed in framework.jobs as Rex::Job objects.

module MsfModuleCommander

  # General configuration errors
  class ConfigError < Exception; end

  # Specific error for a bad config mode
  class InvalidCommandModeError < Exception; end

  # IDs of module jobs being run by MSF
  attr_accessor :job_ids

  # An instance of a class that uses the State Machine (gem) behavior.
  # The command object is basically the DB representation of the thing
  # that the ModuleCommander is "running".
  attr_reader :command_object

  # Holds the setting for whether the modules are to be run in a blocking
  # (single threaded) fashion, or if they are being run as MSF "jobs", which
  # means each gets its own thread.
  VALID_COMMAND_MODES = [:single_threaded, :multi_threaded]
  attr_reader :command_mode

  # Holds the name of state machine method that will be called to mark
  # the command object as "started"
  attr_reader :start_state_event_name

  # Holds the name of state machine method that will be called to mark
  # the command object as "finished"
  attr_reader :finish_state_event_name

  # initialize the job_ids array
  def initialize(opts={})
    @job_ids ||= []
    super
  end

  # Start the commander module's run.  Handles the differences
  # between single and multi-threaded and validates the minimum information
  # necessary to operate the module.
  def validate_and_kickoff!
    raise InvalidCommandModeError unless VALID_COMMAND_MODES.include? command_mode
    raise ConfigError, "no command object specified" unless command_object.present?

    case command_mode
      when :multi_threaded
        if start_state_event_name.present? && finish_state_event_name.present?
          start_and_wait_for_done_state
        else
          raise ConfigError, "both start and end state event method names required when running in multi-threaded mode"
        end
      when :single_threaded
        command_object.execute_with_commander(self)
    end
  end

  # Sets blocking options for a module run
  # If an explicit argument is passed used that
  # If not use the module threading mode
  # @param [Hash] opts the module options hash
  # @return [Hash] the module options hash with blocking mode definitively set
  def blocking_opts(opts)
    if opts['RunAsJob'].nil?
      opts['RunAsJob'] = multi_threaded?
    end
    opts
  end

  # Make sure a valid LHOST is provided
  # Use an optional default value if needbe
  # Otherwise use our local IP determined from Rex::Socket
  # @param [String] lhost The current value for LHOST
  # @param [String] optional_default An optional default to use for certain cases
  # @return [String] The final LHOST value to use
  def set_default_lhost(lhost, optional_default = nil)
    if lhost.blank? and optional_default.blank?
      lhost = Rex::Socket.source_address('50.50.50.50')
    elsif lhost.blank?
      lhost = optional_default
    end
    lhost
  end

  # Runs a single module.
  # Adds a job ID to the commander's jobs array if the module has a job_id
  # after calling exploit_simple
  # @param [String] name path/name for a Metasploit module
  # @param [Hash] opts a Metasploit3 datastore hash
  # @return [Metasploit3]
  def run_module(name, opts=self.datastore)
    mod = configured_sub_module(name, opts)
    opts = blocking_opts(opts)
    mod.run_simple('RunAsJob' => opts['RunAsJob'])
    track_sub_module_run_as_job_if_multithreaded(mod)
    mod
  rescue => e
    print_error "Error running module #{name}: #{e}"
    elog("Error running #{name}", error: e)
    nil
  end

  # Runs a single exploit module, including configuring the payload.
  # Adds a job ID to the local jobs array if the module has a job_id
  # after calling exploit_simple
  # @param [String] name path/name for a Metasploit module
  # @param [Hash] opts a Metasploit3 datastore hash
  # @return [Metasploit3]
  def run_exploit(name, opts=self.datastore)
    mod = configured_sub_module(name, opts)
    unless name == "exploit/multi/handler"
      configure_payload(mod, Rex::Socket.source_address('50.50.50.50'), opts)
    end

    mod.datastore['LHOST'] = set_default_lhost(mod.datastore['LHOST'])

    opts = blocking_opts(opts)

    mod.exploit_simple(
        'Payload'        => mod.datastore['PAYLOAD'],
        'Target'         => mod.datastore['TARGET'],
        'RunAsJob'       => opts['RunAsJob']
    )
    track_sub_module_run_as_job_if_multithreaded(mod)
    mod
  rescue => e
    print_error "Error running exploit #{name}: #{e}"
    elog("Error running #{name}", error: e)
    nil
  end

  # Create an instance of a Metasploit3 module class, setting it to run as
  # a "job" - meaning it will be on its own thread and managed as part of
  # the MSF jobs array.
  # @param [String] name name/path of the module
  # @param [Hash] opts datastore options for the module
  # @option opts [Bool] ExitOnSession
  # @return [Metasploit3]
  def configured_sub_module(name, opts)
    mod                        = framework.modules.create(name)
    mod[:task]                 = self[:task]
    configure_module(mod)
    sanitized_options = opts.clone          # we don't want to overwrite DS_USERNAME
    sanitized_options.delete('username')
    mod.datastore.merge!(sanitized_options) # Prefer the options passed in
    mod.datastore.merge! normalized_extra_config(opts)
    mod.datastore['COMMANDER'] = self
    mod.datastore['WORKSPACE'] = self.workspace
    mod.options.validate(mod.datastore)
    mod
  end

  # If #command mode is :multi_threaded, add the framework job ID
  # to the array being maintained internally by this commanding module.
  # If #command_mode is :blocking, nop.
  # @param [Metasploit3] mod the Metasploit module whose run will be tracked as a job
  def track_sub_module_run_as_job_if_multithreaded(mod)
    if multi_threaded?
      job_ids << mod.job_id.to_s if mod.job_id
    end
  end

  # Copy of the config option smoothing/rearrangement that happens for some reason in the
  # Pro::RPC::Stubs::Tasks module.
  # TODO: this is a DRY violation -- this code also exists in the above-ref'd module
  def normalized_extra_config(conf)
    datastore_extras = {}
    datastore_extras['TimestampOutput'] = true
    datastore_extras['WORKSPACE'] = conf['workspace']
    datastore_extras['PROUSER']   = conf['username']
    conf.each_key do |k|
      if(k =~ /^DS_/)
        datastore_extras[k.sub(/^DS_/, '')] = conf[k]
      end
    end
    datastore_extras
  end

  def multi_threaded?
    command_mode == :multi_threaded
  end

  def single_threaded?
    command_mode == :single_threaded
  end


  # Loop, waiting for the component jobs to all finish.
  #
  # Watch the framework's jobs array, removing job IDs from
  # the local managed list of submodules until the framework
  # has an empty job's list, at which point we set finish state and return.
  #
  # We assume that we want to persist changes to some
  # database object to mark start state and done state.
  #
  # We also assume that state changes happen as the result
  # of a single method call, going on behavior provided by
  # the StateMachine gem.
  def start_and_wait_for_done_state
    self.task_progress = -1

    # Event that persists the state machine state change
    command_object.send(start_state_event_name)

    loop do
      select(nil, nil, nil, 0.5)
      job_ids.delete_if { |jid| framework.jobs[jid.to_s].blank? }

      # All submodules have finished work if the job_ids array is empty,
      # so the object the ModuleCommander is managing is in the finish state
      if job_ids.blank?
        command_object.send(finish_state_event_name)
        return
      end
    end
  end

  # Gets called for each Rex::Job callback when iterating over job_ids
  # in #_cleanup
  def stop_task
    _cleanup("Stopping all jobs")
  end

  private

  # Tear down submodule jobs and cleanup any other tasks
  # @param [String] message a message to print as a status at the end of cleaning up
  def _cleanup(cleanup_message)
    job_ids.each { |jid|
      if framework.jobs[jid.to_s]
        print_status("Stopping job...")

        begin
          job = framework.jobs[jid.to_s]
          job.ctx[0].stop_task if job.ctx[0].respond_to?('stop_task')
        rescue ::Exception => e
          print_error "Error shutting down Job #{jid} (#{framework.jobs[jid.to_s].ctx[0].refname}):"
          print_error e.message
          e.backtrace.each do |line|
            print_error "#{line}"
          end
          elog("Error shutting down Job #{jid} (#{framework.jobs[jid.to_s].ctx[0].refname}): \n #{e.message} \n #{e.backtrace.join("\n")} ")
        end

        begin
          framework.jobs.stop_job(jid)
        rescue ::Exception => e
          print_error "Error shutting down Job #{jid} (#{framework.jobs[jid.to_s].ctx[0].refname}):"
          print_error e.message
          e.backtrace.each do |line|
            print_error "#{line}"
          end
          elog("Error shutting down Job #{jid} (#{framework.jobs[jid.to_s].ctx[0].refname}): \n #{e.message} \n #{e.backtrace.join("\n")} ")
          framework.jobs.remove_job(framework.jobs[jid.to_s])
        end
      end
    }

    # Call the parent method to make sure our own service gets cleaned up.
    print_status(cleanup_message)
  end
end
