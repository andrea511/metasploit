module Pro

# Basic hash container for managing tasks
  class TaskContainer < Hash
    attr_accessor :monitor

    def initialize(*args)
      super(*args)
      start_monitor
      @tcnt = 0
    end

    # @param record {Mdm::Task} the DB record of the task
    # @param proc {Proc} the block containing the work to be done by the task
    def create(record, proc, args={})
      t = ProTask.new(proc, args)
      t.task_id = record.id.to_s
      t.record  = record
      t.path    = record.path
      self[t.task_id] = t
      t.task_id
    end

    def start(proc, args={})
      tid = create(proc, args)
      self[tid].start
      tid
    end

    def start_monitor
      self.monitor = Rex::ThreadFactory.spawn("ProRPCTaskMonitor", true) do
        while true
          begin
            self.keys.each { |t| self[t].sync }
            self.keys.each { |t| self.delete(t) if t.status == Pro::ProTask::Status::DONE }
          rescue ::Exception => e
          end
          sleep 1
        end
      end
    end

  end

# Wrapper object for the task
  class ProTask
    # Raised when a +metasploit_module+ doesn't satisfy an expected interface
    # e.g. when #pause is called on a task whose module doesn't implement
    # ProTask::METASPLOIT_MODULE_PAUSE_METHOHD_NAME
    class TaskModuleInterfaceError < Exception; end

    # States used for ProTask don't correspond directly to those used in the database,
    # as these are used to represent the work being done by the thread and not the
    # logical task itself, which is represented by an {Mdm::Task} at +record+
    module Status
      DONE    = :done
      NEW     = :new
      RUNNING = :running
    end


    # @!attribute args
    #   Arbitrary argument hash
    #   @return [Hash]
    attr_accessor :args

    # @!attribute created_at
    #   Creation timestamp for this ProTask
    #   @return [DateTime]
    attr_accessor :created_at

    # @!attribute completed_at
    #   Completion timestamp for this ProTask, part of values that get sync'd to corresponding
    #   attribute on the +record+
    #   @return [DateTime]
    attr_accessor :completed_at

    # @!attribute description
    #   Arbitrary description of the work done by the code running in +proc+, part of the values that get sync'd
    #   to the corresponding attribute on the +record+
    #   @return [String]
    attr_accessor :description

    # @!attribute error
    #   Error string from the code running in +proc+, part of values that get sync'd to corresponding
    #   attribute on the +record+
    #   @return [String]
    attr_accessor :error

    # @!attribute info
    #   Arbitrary information string used to describe current state of the work done by the code running in +proc+,
    #   part of the values that get sync'd to the corresponding attribute on +record+
    #   @return [String]
    attr_accessor :info

    # @!attribute metasploit_module
    #   The instantiated Metasploit module that the code in +proc+ is running
    #   @return [Metasploit3]
    attr_accessor :metasploit_module

    # @!attribute on_stop
    #   A callback Proc that gets executed when the RPC bridge stops the task
    #   @return [Proc]
    attr_accessor :on_stop

    # @!attribute path
    #   The path on disk to the task's log file
    #   @return [String]
    attr_accessor :path

    # @!attribute proc
    #   Memoized chunk of work to be done by the ProTask
    #   @return [Proc]
    attr_accessor :proc

    # @!attribute progress
    #   Progress value set/incremented by code running in +proc+, part of values that get sync'd to corresponding
    #   attribute on the +record+
    #   @return [Integer]
    attr_accessor :progress

    # @!attribute record
    #   The DB record of the ProTask
    #   @return [Mdm::Task]
    attr_accessor :record

    # @!attribute requested_task_action
    #   The action that the RPC request asked for
    attr_accessor :requested_task_action

    # @!attribute result
    #   An arbitrary string representing the end state of running the task
    #   @return [String]
    attr_accessor :result

    # @!attribute thread
    #   The Thread object that will do the work in +proc+
    #   @return [Thread]
    attr_accessor :thread

    # @!attribute task_id
    #   The ID of the {Mdm::Task} that is being used to provide database linkage for this ProTask
    #   @return [Integer]
    attr_accessor :task_id

    # @!attribute username
    #   The name of the Pro user who requested this task
    #   @return [username]
    attr_accessor :username

    # @!attribute workspace
    #   The name of the Pro project where this task is scoped
    #   @return [String]
    attr_accessor :workspace

    # Actions that can be requested by the RPC bridge code
    PAUSE  = 'pause'
    RESUME = 'resume'
    START  = 'start'
    STOP   = 'stop'


    # Duration to wait for +metasploit_module+ to finish cleaning up
    METASPLOIT_MODULE_CLEANUP_SLEEP_DURATION = 1


    # Valid actions that can be requested for a ProTask from the RPC bridge
    VALID_REQUESTED_TASK_ACTIONS = [PAUSE, RESUME, START, STOP]

    # Metasploit module datastore key for holding a {VALID_REQUESTED_ACTION}
    REQUESTED_TASK_ACTION_DS_KEY = 'RequestedTaskAction'

    def initialize(proc, args)
      @proc        = proc
      @args        = args
      @progress    = 0
      @created_at  = ::Time.now.utc
      @info        = ""
      @description = ""
      @result      = ""
    end

    # Perform tasks to finish the task up
    # @return [void]
    def cleanup
      create_notification
      metasploit_module.user_output.close if (metasploit_module and metasploit_module.user_output)
      metasploit_module.user_output = nil if (metasploit_module and metasploit_module.user_output)

      self.metasploit_module = nil
      GC.start
    end

    # TODO: find a better design than one which requires straight murdering Threads blindly
    # End the Thread that is running the current task, stored in +thread+,
    # waiting to return until #status is Status::DONE
    # @return [void]
    def end_task_thread
      if thread.present?
        thread.kill
        while status == Status::RUNNING
          sleep 0.10
        end
      end
    end

    # Pauses the task if +metasploit_module+ supports it, raises an exception otherwise
    # @return [void]
    def pause
      if supports_pause_resume?
        metasploit_module.send(::Metasploit::Pro::Engine::Task::PauseResume::PAUSE_METHOD_NAME)
        end_task_thread
        cleanup
        sync
      else
        raise TaskModuleInterfaceError, "Module '#{metasploit_module.fullname}' doesn't support pause/resume"
      end
    end

    def start
      self.thread = Rex::ThreadFactory.spawn("ProRPCTask-#{self.task_id}", false) do
        begin
          case requested_task_action
          when START
            record.start!
          when RESUME
            record.resume!
          end

          Thread.current[:task] = self
          proc.call(self, self.args)
          task_complete if self.error.nil? && requested_task_action != PAUSE
        rescue ::Exception => e
          self.error = "#{e.class} #{e}"
          if metasploit_module && metasploit_module.user_output
            metasploit_module.user_output.print_error("Task Exception: #{e.class} #{e} #{e.backtrace}")
          end
        end

        cleanup
        self.completed_at = ::Time.now.utc
        sync
      end
    end


    # Report status based on the state of the thread being used to perform the task
    # - If there is no value for self.thread, NEW
    # - If the Thread at self.thread is not alive, DONE
    # - Otherwise there is an alive thread, so we assume RUNNING
    def status
      if(not thread)
        return Status::NEW
      end

      if(not thread.alive?)
        return Status::DONE
      end

      return Status::RUNNING
    end

    # Stop the current task
    # @param [void]
    def stop
      # Tell the module to cleanup first
      if metasploit_module
        metasploit_module.stop_task if metasploit_module.respond_to?(:stop_task)
        metasploit_module.cleanup rescue nil
        sleep METASPLOIT_MODULE_CLEANUP_SLEEP_DURATION
      end

      end_task_thread
      cleanup
      sync
    end

    # Returns true if {#metasploit_module} satisfies the interface defined by
    # {Metasploit::Pro::Engine::Task::PauseResume::REQUIRED_INTERFACE_METHOD_NAMES}
    # @return [Boolean]
    def supports_pause_resume?
      Metasploit::Pro::Engine::Task::PauseResume::REQUIRED_INTERFACE_METHOD_NAMES.
        select{|mname| metasploit_module.respond_to?(mname) == false}.size == 0
    end

    # Sync the database object to the current task info
    # self.record is an Mdm::Task and therefore conforms to the state machine in
    # {Mdm::Task::States}
    def sync
      ::ApplicationRecord.connection_pool.with_connection {
        # Thread is done and DB record needs to be updated
        done = (record.running? && status == Status::DONE)

        if done ||
          (record.info != info) ||
          (record.description != description) ||
          (record.progress != progress) ||
          (record.error != error) ||
          (record.result != result)

          # Update just the attributes this code monitors
          update_info = {
            :info        => info,
            :description => description,
            :progress    => progress,
            :error       => error,
            :result      => result
          }

          if done
            if error.present?
              record.fail!
            else
              case requested_task_action
              when START
                record.complete!
              when RESUME
                record.complete!
              when STOP
                record.stop!
              when PAUSE
                record.pause!
              end
            end
          end


          # Update just the modified fields (dont conflict with UI DB fields like :settings)
          # Mdm::Task.update(record[:id], update_info)
          record.update(update_info)

          # Update the record with the new data
          record.reload
        end
      }
    end

    # Return true if self meets all validation criteria
    # @return [Boolean]
    def valid?
      return false unless Pro::ProTask::VALID_REQUESTED_TASK_ACTIONS.include? requested_task_action
      return true
    end

    private

    # Creates the path that the user goes to when they click the notification message
    # or returning a module specific url if the module defines this method
    # Special-cases Discover and Report to go to a specific place
    # TODO: When we add rails replace these with url helpers
    def built_notification_url
      module_path = record.module
      case module_path
      when "pro/report"
        "/workspaces/#{record.workspace.id}/reports"
      when "pro/discover"
        "/workspaces/#{record.workspace.id}/hosts"
      else
        "/workspaces/#{record.workspace.id}/tasks/#{record.id}"
      end
    end

    # @return[Notifications::Message] a generic notification used for all Mdm::Task runs that have no associated
    # AppRun object
    def create_generic_notification
      Notifications::Message.create(:workspace => record.workspace,
                                    :title => description,
                                    :url => built_notification_url,
                                    :content => info,
                                    :kind => :task_notification)

    end

    # Create a {Notifications::Message} object, saving the one provided by the module if it exists
    # otherwise creating a generic one for the task
    # @return [void]
    def create_notification
      if defined? metasploit_module.app_run
        run_state = metasploit_module.app_run.state
        metasploit_module.send("#{run_state}_notification").save
      else
        create_generic_notification
      end
    end

    def task_complete
      self.progress = 100
      time = "[#{Time.now.strftime("%Y.%m.%d-%H:%M:%S")}] "
      metasploit_module.user_output.print_good("#{time}Workspace:#{self.workspace} Task Completed - Progress: #{self.progress}%")
    end

  end
end
