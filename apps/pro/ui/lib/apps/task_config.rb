# Adds some helper methods to the TaskConfigs for Apps.

class Apps::TaskConfig < ::TaskConfig
  # @api meta_modules

  # To coerce strings from form request -> ruby data types
  include Metasploit::Pro::AttrAccessor::Boolean

  include Metasploit::Credential::Creation

  # Include address range validation methods
  include Metasploit::Pro::IpRangeValidation

  # TODO: rails 4: change this to include ActiveModel::Model
  include ActiveModel::Validations

  # @attr [Boolean] form request contains file uploads (not sent on validation req's)
  attr_accessor :no_files

  # @attr [Mdm::User] adding the current user to app task configs
  attr_accessor :current_user


  # make app_symbol a reader + protected writer
  def self.app_symbol; @app_symbol; end

  # don't let other classes modify the app's symbol associated with the TaskConfig.
  # the app symbol is set by the TaskConfig subclass.
  def self.app_symbol=(symbol)
    if instance_variable_defined? :@app_symbol
      raise "Can't override app_symbol outside of TaskConfig subclass."
    end
    @app_symbol = symbol
  end

  # @return [Boolean] Whether this App uses the new Task Presenter pattern for its Findings UI
  def self.use_task_presenter; @use_task_presenter; end

  # Set whether this App uses the new Task Presenter pattern for its Findings UI
  # @param [Boolean] bool
  def self.use_task_presenter=(bool)
    @use_task_presenter = bool
  end

  # Includes ActiveModel's nice initialize() method for auto assignment.
  def initialize(params={}, report_args={})
    if params
      params.each do |attr, value|
        method = "#{attr}="
        if self.respond_to?(method)
          self.public_send(method, value)
        end
      end
    end

    super(params || {})

    @no_files = set_default_boolean(@no_files, false)
  end

  # joe! are you copying and pasting things from rails source again!? JOE?!! JJOOOOOOOEEEEEE
  def valid?(context = nil)
    current_context, self.validation_context = validation_context, context
    errors.clear
    run_validations!
  ensure
    self.validation_context = current_context
  end

  # finds or creates an app run for this module
  # @return [Apps::AppRun]
  def app_run
    unless instance_variable_defined? :@app_run
      app = Apps::App.find_by_symbol self.class.app_symbol
      @app_run = Apps::AppRun.new()
      @app_run.app = app
      @app_run.workspace_id = @workspace.id
    end
    @app_run
  end

  # @return [Hash] for passing opts to the RPC call
  def config_to_hash
    app_id = if app_run.present? then app_run.id else nil end
    {
      'DS_APP_RUN_ID' => app_id,
      'workspace'     => workspace.name,
      'username'      => @username,
      'DS_PROUSER'    => @username,
      'report_id'     => report_id
    }
  end

  # Make the RPC call, save the AppRun object, update the newly created Mdm::Task with the AppRun#id
  def launch!
    begin
      app_run.config = app_run_config.merge(config_to_hash)
      app_run.save!
      rpc_result = rpc_call(Pro::Client.get)

      task = Mdm::Task.find(rpc_result['task_id'])
      app_run.start!

      new_attrs = { :app_run_id => app_run.id }

      if self.class.use_task_presenter
        new_attrs[:presenter] = self.class.app_symbol
      end

      task.update(new_attrs)
      task
    rescue ActiveRecord::RecordInvalid
      raise AppRunConfigurationError, "the requested app run can't fire"
    end
  end

  # sets default attr values
  # @return self
  def set_defaults!
    self
  end

  # Set report params not configurable by user
  #
  # @return [Hash] the params for the new Report
  def finalized_report_params(report_params = {})
    additional_params = {
      'usernames_reported' => @username,
      'created_by'         => @username,
      'workspace_id'       => @workspace.id
    }

    report_params.merge(additional_params)
  end

  private

  def cred_type_user_supplied?
    cred_type.to_s == 'user_supplied'
  end

  # Configuration options stored in the AppRun itself
  def app_run_config
    {} # override me!
  end


end
