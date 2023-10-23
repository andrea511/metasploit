class TaskChainsController < ApplicationController
  include TasksSharedControllerMethods
  attr_reader :task_chain_data, :ice_cube_schedule

  before_action :load_workspace
  before_action :load_metamodules, only: [:new, :edit]
  before_action :load_task_chains_for_workspace, only: [:destroy_multiple, :stop_multiple, :suspend_multiple, :resume_multiple, :start_multiple]
  before_action :load_consoles, only: [:new, :edit]
  before_action :set_js_routes, only: [:new, :edit]

  def index
    load_all_task_chains_for_workspace
    present_task_chains
    set_javascript_vars_for_index
  end

  def new
    @task_chain = TaskChain.new
    gon.watch.taskChainRunning = @task_chain.running?
    gon.workspace_cred_count = Metasploit::Credential::Core.where(workspace_id: @workspace).count
  end

  def show
    @task_chain = TaskChain.includes(:scheduled_tasks).find(params[:id])
  end

  def edit
    #TODO: Optimize Query to only include ID and Kind on ScheduledTasks
    @task_chain = TaskChain.includes(:scheduled_tasks).find(params[:id])

    if @task_chain.running?
      flash.keep[:error] = 'Unable to edit a running task chain'
      redirect_to workspace_task_chains_path(@workspace)
    else
      if @task_chain.schedule.nil? and !@task_chain.next_run_at.nil?
        @task_chain.schedule_info = @task_chain.next_run_at.strftime("%B %d, %Y at %I:%M %P %z")
      else
        @task_chain.schedule_info = @task_chain.schedule.to_s
      end
      @task_chain
      gon.watch.taskChainRunning = @task_chain.running?
      gon.workspace_cred_count = Metasploit::Credential::Core.where(workspace_id: @workspace).count
      gon.legacy_tasks = ScheduledTask.select(:id).where(task_chain_id:@task_chain,legacy:true)
    end
  end

  def create
    @task_chain = TaskChain.new
    init_task_chain
    schedule_for_run
    build_task_chain

    save_chain(create: true)
  end

  def update
    @task_chain = TaskChain.find(params[:id])

    if @task_chain.running?
      flash.keep[:error] = 'Unable to edit a running task chain'
      redirect_to workspace_task_chains_path(@workspace)
    else
      init_task_chain
      schedule_for_run
      @task_chain.scheduled_tasks.destroy_all
      build_task_chain

      save_chain
    end
  end

  def clone
    @task_chain = TaskChain.find(params[:id])
    @duped_chain = @task_chain.copy
    @duped_chain.user = current_user

    if @duped_chain.valid?
      @duped_chain.save
      redirect_to edit_workspace_task_chain_path(@workspace, @duped_chain)
    else
      flash[:error] = 'Unable to clone task chain.'
      redirect_to workspace_task_chains_path(@workspace)
    end
  end

  def validate
    @task_chain                            = params[:id].blank? ? TaskChain.new : TaskChain.find(params[:id])

    @task_chain.user                       = current_user
    @task_chain.workspace                  = @workspace
    @task_chain.name                       = task_chain_params[:name]

    if @task_chain.valid?
      render :json => {success: :ok}
    else
      render :json => {success: false, errors: @task_chain.errors}, :status => :bad_request
    end
  end


  def destroy_multiple
    TaskChain.where(id: @task_chains.collect(&:id),
                          workspace_id: @workspace.id).destroy_all

    render json: {}, status: :ok
  end

  def stop_multiple
    transition_multiple_task_chains_to :finish!

    render_task_chains_json
  end

  def suspend_multiple
    transition_multiple_task_chains_to :suspend!

    render_task_chains_json
  end

  def resume_multiple
    transition_multiple_task_chains_to :ready!

    render_task_chains_json
  end

  def start_multiple
    start_time = Time.now

    @task_chains.each do |task_chain|
      task_chain.schedule_to_run_at(Time.now)
      task_chain.save
    end

    render_task_chains_json
  end

  def validate_schedule
    begin
      raise ArgumentError.new, "Frequency is required" unless params[:schedule_recurrence] && params[:schedule_recurrence][:frequency].present?
      #If one time schedule
      if params[:schedule_recurrence][:frequency] == 'once'
        once_schedule = TaskChains::OnceSchedule.new(params[:schedule_recurrence][:once])

        if once_schedule.valid?
          start_hour = params[:schedule_recurrence][:once][:start_time]
          date_time = "#{params[:schedule_recurrence][:once][:start_date]} #{start_hour}"
          start_time = Time.strptime(date_time,'%m/%d/%Y %I:%M %P %z')
          start_time_utc = start_time.dup.utc

          start_time = start_time.strftime("%B %d, %Y at")
          start_time = "#{start_time} #{start_hour}"


          if start_time_utc.past?
            once_schedule.errors.add(:schedule, 'Start Time must be in the future')
            render json: once_schedule.errors, status: :error
          else
            render :json => {schedule: start_time}, :status => :ok
          end
        else
          render json: once_schedule.errors, status: :error
        end
      else

        case params[:schedule_recurrence][:frequency]
          when 'hourly'
            schedule = TaskChains::HourlySchedule.new(params[:schedule_recurrence][:hourly])
          when 'daily'
            schedule = TaskChains::DailySchedule.new(params[:schedule_recurrence][:daily])
          when 'weekly'
            schedule = TaskChains::WeeklySchedule.new(params[:schedule_recurrence][:weekly])
          when 'monthly'
            schedule = TaskChains::MonthlySchedule.new(params[:schedule_recurrence][:monthly])
        end

        if schedule.valid?
          #If recurring schedule
          if params[:schedule_recurrence][:frequency] == 'weekly' and params[:schedule_recurrence][:weekly][:days].nil?
            render :json => {schedule: "Invalid Schedule"},:status => :bad_request
          end

          if ice_cube_schedule.start_time.past?
            render :json => {schedule: "Start Time must be in the future"},:status => :bad_request
          else
            if ice_cube_schedule.next_occurrence.nil?
              render :json => {schedule: "Invalid Schedule: #{ice_cube_schedule.to_s}"},:status => :bad_request
            else
              render :json => {schedule: ice_cube_schedule.to_s}, :status => :ok
            end
          end
        else
          render json: schedule.errors, status: :bad_request
        end
      end

    rescue ArgumentError
      render :json => {schedule: "Invalid Schedule"},:status => :bad_request
    end
  end


  private


  def restore_file(task,use_last_uploaded)
    unless use_last_uploaded.nil?
      path = use_last_uploaded.split('/').try(:last) || use_last_uploaded
      task.file_upload.retrieve_from_store!(path)
      path = task.file_upload.current_path
      file = File.open(path)
      task.file_upload = file
      file.close
    end
  end

  def save_chain(opts={})
    str = opts[:create] ? 'created' : 'edited'

    if params[:run_now] == "true"
      @task_chain.schedule_to_run_at(Time.now.utc)
    end

    if params[:schedule_suspend] == 'manual' and not @task_chain.suspended? and params[:scheduled].nil?
      @task_chain.suspend!
    end

    if params[:schedule_suspend] == 'future' and @task_chain.suspended?
      @task_chain.ready!
    end

    # No task should be active during a save so this clears an error state
    # that currently is only produced by defunct tasks cleanup at service start.
    if @task_chain.active_task_id
      @task_chain.active_task_id = nil
      @task_chain.active_scheduled_task_id = nil
    end

    #TODO: Remove this after we get rid of legacy chains all together
    @task_chain.legacy = false

    if @task_chain.save
      if params[:run_now] == "false"
        flash.keep[:notice] = "Chain '#{@task_chain.name}' has been #{str}"
        redirect_to :action => "index"
      else
        flash.keep[:notice] = "Chain '#{@task_chain.name}' has been #{str} and has been scheduled to start in less than a minute."
        redirect_to :action => "index"
      end
    else
      render :action => :new
    end
  end


  def init_task_chain
    @task_chain.user                       = current_user
    @task_chain.name                       = task_chain_params[:name]
    @task_chain.workspace                  = @workspace
    @task_chain.schedule                   = ice_cube_schedule
    @task_chain.schedule_hash = params[:schedule_recurrence]
    @task_chain.clear_workspace_before_run = task_chain_params[:clear_workspace_before_run]
  end



  def build_task_chain
    config_hash_array.each_with_index do |config, index|
      position = index + 1

      new_task = @task_chain.scheduled_tasks.build
      new_task.kind        = config[0]

      #If Metamodule
      if config[1].is_a?(Hash)
        new_task.config_hash = config[1][:task_config].config_to_hash

        #config[3] is the options hash without the file reference removed
        if !config[3][:key_file].nil? and config[3][:cred_type] != "stored"
          new_task.file_upload = config[3][:key_file]
        else
          restore_file(new_task,config[3][:use_last_uploaded])
        end

        config[2][:key_file_content] = new_task.file_upload.try(:read)
        config[2].delete('key_file')
        new_task.report_hash = config[1][:report].merge({
          'usernames_reported' => current_user.username,
          'created_by'         => current_user.username,
          'workspace_id'       => @workspace.id
        })

      else
        config[1].class == Report ? new_task.config_hash = config[2] : new_task.config_hash = config[1].config_to_hash
        # Clean up config, create Report:
        if new_task.kind == 'report'
          #Scheduled Task Expects a config_hash :-/
          @task_chain.scheduled_tasks[index]['config_hash'] = {report: true}
        else


          if new_task.kind == 'bruteforce'
            #Scheduled Task Expects a config_hash :-/
            @task_chain.scheduled_tasks[index]['config_hash'] = {stubbed:true}
            new_task.config_hash = {stubbed:true}
          else
            new_task.config_hash = config[1].config_to_hash
          end


          unless config[3][:file].nil?
            new_task.file_upload = config[3][:file]
          else
            restore_file(new_task,config[3][:use_last_uploaded])
          end
        end

      end

      if !config[3][:file].nil? and config[3][:key_file].nil?
        new_task.file_upload = config[3][:file]
      end

      new_task.form_hash   = config[2]

      new_task.position    = position
      #If you re-save the chain you are replacing legacy tasks in the chain
      new_task.legacy = false
    end
  end

  # NB: the order created in task_chain_data needs to be preserved for all of this to
  # work as designed.  Ordered hashes -- yet another reason to run Ruby 1.9.2+!

  # Create a nice fat hash that can be used to instantiate TaskConfig descendant models
  # and therefore create a bunch of ScheduledTasks
  def task_chain_data
    @task_chain_data ||= task_params[:scheduled_task_order].split(',').inject({}) do |hash, task_order_key|
      hash[task_order_key] = {}
      potential_type = params[:scheduled_task_types][task_order_key]
      if potential_type.include?("collect")
        potential_type = "collect_evidence"
      end
      hash[task_order_key][:type] = potential_type
      hash[task_order_key][:inputs_for_task] = task_params[:inputs_for_task][task_order_key]

      hash
    end
  end

  # The hash we use to build the ScheduledTask objects in the TaskChain.
  def config_hash_array
    array = []
    task_chain_data.each_value do |input_hash|


      type = ""
      if input_hash.include? "collect" # just had to be different, didn't you?
        type = "collect_evidence"
      else
        type = input_hash[:type]
      end

      if type == "nexpose"
        type = "scan_and_import"
      end


      unless type=="report"
        input_hash[:inputs_for_task][:workspace] = @workspace
        input_hash[:inputs_for_task][:username] = current_user.username
        input_hash[:inputs_for_task][:current_user_id] = current_user.id
      end


      file_input = input_hash[:inputs_for_task].dup

      #We don't want to save the file in our form_hash
      uncoerced_inputs = input_hash[:inputs_for_task].dup
      uncoerced_inputs[:options] = input_hash[:inputs_for_task][:options]
      uncoerced_inputs.delete(:file)
      uncoerced_inputs.delete(:key_file)

      processed_task_config = process_task_config(type, input_hash[:inputs_for_task])

      #Because the core id is not set until config has is called. background daemon uses the form hash
      if processed_task_config.is_a?(Hash) and processed_task_config[:task_config].respond_to?(:core)
        uncoerced_inputs[:core_id] = processed_task_config[:task_config].core.id
        uncoerced_inputs[:realm] = processed_task_config[:task_config].realm.try(:value) if processed_task_config[:task_config].respond_to?(:realm)
      end

      array << [type, processed_task_config, uncoerced_inputs, file_input]
    end
    array
  end

  # Sets up the IceCube::Schedule object that's used to hold a recurrence schedule
  def ice_cube_schedule
    @ice_cube_schedule ||= make_schedule
  end


  def days_until_expiration(config)
    case config[:max_duration]
      when 'week'
        days = 6
      when 'month'
        days = 30
      when 'year'
        days = 365
    end
    days
  end

  def init_hourly_schedule(config)
    minute_of_hour = config[:minute].to_i
    t = Time.now.utc

    #
    # If current time is past scheduled minutes
    # start in next hour else start this hour
    #
    start_hour = minute_of_hour < t.min ? t.hour + 1 : t.hour

    #Wrap Hours
    if start_hour >=24
      start_hour = start_hour-24
      t.mday = t.mday+1
    end

    start_time = Time.utc(t.year, t.month, t.mday, start_hour, minute_of_hour, 0)
    #
    # Create schedule object given start time and
    # add hourly recurrence rule
    #
    IceCube::Schedule.new(start_time)
  end

  def schedule_hourly(config, schedule)
    ice_cube_rule = IceCube::Rule.hourly

    if config[:max_duration] != 'never_expire'
      ice_cube_rule.until(Date.today + days_until_expiration(config))
    end

    schedule.add_recurrence_rule ice_cube_rule
    schedule
  end

  def schedule_daily(config,schedule)
    interval    = interval(config)
    if config[:max_duration] == 'never_expire'
      schedule.add_recurrence_rule IceCube::Rule.daily(interval)
    else
      schedule.add_recurrence_rule IceCube::Rule.daily(interval).until(Date.strptime(config[:start_date], "%m/%d/%Y") + days_until_expiration(config))
    end
    schedule
  end

  def schedule_weekly(config,schedule)
    active_days = config[:days].map{|d| d.to_i }.flatten
    interval    = interval(config)
    if config[:max_duration] == 'never_expire'
      schedule.add_recurrence_rule IceCube::Rule.weekly(interval).day(*active_days)
    else
      schedule.add_recurrence_rule IceCube::Rule.weekly(interval).day(*active_days).until(Date.strptime(config[:start_date], "%m/%d/%Y") + days_until_expiration(config))
    end
    schedule
  end

  def interval(config)
    if config[:interval].blank?
      1
    else
      if config[:interval].to_i < 1
        1
      else
        config[:interval].to_i
      end
    end
  end

  def monthly_ice_cube_rule(config)
    interval = config[:interval].to_i
    ice_cube_rule = IceCube::Rule
    case config[:type]
      when 'day'
        day = config[:day_index].to_i
        ice_cube_rule = ice_cube_rule.monthly(interval).day_of_month(day)
      when 'last'
        days= {
            config[:day_interval].to_sym => [-1]
        }
        ice_cube_rule = ice_cube_rule.monthly(interval).day_of_week(days)
      else
        days= {
            config[:day_interval].to_sym => [config[:type].to_i]
        }
        ice_cube_rule = ice_cube_rule.monthly(interval).day_of_week(days)
    end
    ice_cube_rule
  end

  def schedule_monthly(config,schedule)
    ice_cube_rule = monthly_ice_cube_rule(config)

    if config[:max_duration] != 'never_expire'
      ice_cube_rule = ice_cube_rule.until(Date.strptime(config[:start_date], "%m/%d/%Y") + days_until_expiration(config))
    end

    schedule.add_recurrence_rule ice_cube_rule
    schedule
  end

  def make_schedule
    # Just let #create manipulate next_run_at instead of setting up a Schedule
    return nil if (params[:schedule_suspend] == "now" || params[:schedule_suspend] == 'manual')

    type     = params[:schedule_recurrence][:frequency]
    config   = params[:schedule_recurrence][type]

    if type == "once"
      return nil
    elsif type == "hourly"
      schedule_hourly(config,init_hourly_schedule(config))
    else
      schedule = init_common_schedule(config)
      case type
        when "daily"
          schedule_daily(config, schedule)
        when "weekly"
          schedule_weekly(config, schedule)
        when "monthly"
          schedule_monthly(config, schedule)
      end
    end
  end

  def init_common_schedule(config)
    # Common to any non-hourly recurrence schedule
    date_time = "#{config[:start_date]} #{config[:start_time]}"
    start_time = Time.strptime(date_time,'%m/%d/%Y %I:%M %P %z')
    IceCube::Schedule.new(start_time)
  end

  def schedule_for_run
    if should_schedule?
      run_time = determine_time_to_run
      schedule_for(run_time)
    end
  end

  def should_schedule?
    not (params[:schedule_suspend] == 'manual')
  end

  def determine_time_to_run
    if params[:schedule_suspend] == 'now'
      Time.now.utc
    elsif params[:schedule_suspend] == 'future'
      if params[:schedule_recurrence]['frequency'] == 'once'
        if params[:schedule_recurrence]['once_datetime'].nil?
          request_time = "#{params[:schedule_recurrence][:once][:start_date]} #{params[:schedule_recurrence][:once][:start_time]}"
          Time.strptime(request_time, "%m/%d/%Y %I:%M %P %z").utc
        else
          request_time = params[:schedule_recurrence]['once_datetime']
          Time.strptime(request_time, "%m/%d/%Y %I:%M %P").utc
        end
      else
        @task_chain.schedule.next_occurrence
      end
    end
  end

  def schedule_for(time)
    @task_chain.schedule_to_run_at(time)
  end

  def load_metamodules
    gon.metamodules = Apps::App.select([:symbol,:name]).where(hidden:false).order('name ASC')
  end

  # Provide access to some data from JavaScript.
  def set_javascript_vars_for_index
    gon.task_chains = gon.jbuilder
    gon.workspace_task_chains_path = workspace_task_chains_path(@workspace, format: 'json')
    gon.new_workspace_task_chains_path = new_workspace_task_chain_path(@workspace)
    gon.destroy_multiple_workspace_task_chains_path = destroy_multiple_workspace_task_chains_path(@workspace, format: 'json')
    gon.resume_multiple_workspace_task_chains_path = resume_multiple_workspace_task_chains_path(@workspace, format: 'json')
    gon.stop_multiple_workspace_task_chains_path = stop_multiple_workspace_task_chains_path(@workspace, format: 'json')
    gon.suspend_multiple_workspace_task_chains_path = suspend_multiple_workspace_task_chains_path(@workspace, format: 'json')
    gon.start_multiple_workspace_task_chains_path = start_multiple_workspace_task_chains_path(@workspace, format: 'json')
    gon.legacy_chains = TaskChain.select([
                                           TaskChain[:id],
                                           TaskChain[:name]
                                         ]).distinct.joins(
      TaskChain.join_association(:scheduled_tasks)
    ).where(
      workspace_id: @workspace.id,
      scheduled_tasks:{legacy:true}
    )
  end

  # Fetch all of the task chains for this workspace.
  def load_all_task_chains_for_workspace
    @task_chains = TaskChain.includes(:user, :scheduled_tasks, :last_run_report, :last_run_task).for_workspace(@workspace).where(legacy:false)
  end

  # Fetch the task chains within this workspace with the requested ids.
  def load_task_chains_for_workspace
    @task_chains = TaskChain.where(workspace_id: @workspace.id, id: params[:task_chain_ids])
  end

  # Run all of the task chain objects through their presenter.
  def present_task_chains
    @task_chains = @task_chains.collect { |task_chain| present(task_chain) }
  end

  # Transition the task chains to the specified state.
  #
  # @param state [Symbol] the state to transition to
  def transition_multiple_task_chains_to(state)
    @task_chains.each do |task_chain|
      begin
        task_chain.send(state)
      # Ignore any that can't be transitioned.
      rescue StateMachine::InvalidTransition
        nil
      end
    end
  end

  def render_task_chains_json
    load_all_task_chains_for_workspace
    present_task_chains

    render 'index.json.jbuilder'
  end

  # @return [Hash<String, Integer>] map of Nexpose Console name -> Console ID
  # for rendering as an HTML <select> collection
  def load_consoles
    gon.consoles = Mdm::NexposeConsole.order('created_at DESC')
                     .each_with_object({}) { |c, obj| obj[c.name] = c.id }
    gon.addresses = @workspace.addresses
  end

  def search_operator_class
    Mdm::Host
  end

  def set_js_routes
    gon.filter_values_apps_domino_task_config_index_path =
        filter_values_apps_domino_task_config_index_path(@workspace)
    gon.search_operators_apps_domino_task_config_index_path =
        search_operators_apps_domino_task_config_index_path(@workspace)
  end

  def task_chain_params
    params.fetch(:task_chain, {}).permit!
  end

  def task_params
    params.permit!
  end
end
