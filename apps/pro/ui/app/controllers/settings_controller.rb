class SettingsController < ApplicationController

  before_action :require_admin

  @@submitted_profile = nil

  def index
    @macros    = Mdm::Macro.all
    @api_keys  = Mdm::ApiKey.all
    @listeners = Mdm::Listener.all
    @consoles  = Mdm::NexposeConsole.all
    @backups   = Backup.all.sort_by(&:date)
    @profile   = @@submitted_profile.nil? ? current_profile : @@submitted_profile
    @@submitted_profile = nil
  end


  def update_profile
    pid = params[:profile_id]
    params[:smtp_ssl] = true if params[:smtp_ssl] == "true"

    @profile = Mdm::Profile.find(pid)
    current = @profile.settings.dup

    if @profile.blank?
      flash[:error] = "Invalid Mdm::Profile ID"
      redirect_to :action => 'index'
    end

    @profile.settings_list.each do |s|
      key = s[:name].intern
      val = params[key]

      next if val.nil?

      if s[:type] == :boolean
        val = (val.to_s =~ /(true|1|yes)/) ? true : false
      end
      @profile.settings[s[:name]] = val
    end

    if smtp_settings_present?
      update_smtp_settings
      unless smtp_settings_valid?
        @@submitted_profile = @profile
        # this relies on that smtp setting are on a unique page
        # allowing error set by side-effect to be returned
        return redirect_to :action => 'index', :anchor => params[:anchor]
      end
    end
    update_ui_settings if ui_settings_present?
    update_proxy_settings
    @profile.save!
    UsageMetrics.update_config
    updated = @profile.settings

    Mdm::Profile.record_timestamps = false
    @profile.update :updated_at => Time.now.utc
    Mdm::Profile.record_timestamps = true

    @profile.load_smtp_configuration

    flash[:notice] = "Settings successfully updated."
    AuditLogger.settings "#{ip_user} - Settings updated. #{audit_view(current, updated)}"

    redirect_to :action => 'index', :anchor => params[:anchor]
  end

  private

  # Ensure that SMTP information is complete if provided.
  # @return [Boolean]
  def smtp_settings_valid?
    status, error_msg = check_smtp_settings

    if status == :error
      flash[:error] = "SMTP Settings Error: #{error_msg}"
      false
    else
      true
    end
  end

  # Assume the user wants to use an SMTP server if they have anything in the address field
  # @return [Boolean]
  def smtp_settings_present?
    params[:smtp_address].present?
  end

  # Assume the user is updating server settings if `logged_in_timeout` is present
  # @return [Boolean]
  def ui_settings_present?
    params[:ui_server_logged_in_timeout].present?
  end

  def update_ui_settings
    ui_server_params = ui_server_allowed_params
    UIServerSettings.new(ui_server_params).apply_to(@profile.settings)
  end

  def update_proxy_settings
    if params['use_http_proxy'].present?
      Mdm::Profile::HTTP_PROXY_SETTINGS.each do |setting|
        @profile.settings[setting.to_s] = params[setting]
      end
    end
  end

  def update_smtp_settings
    smtp_params = smtp_allowed_params
    SmtpSettings.new(smtp_params).apply_to(@profile.settings)
  end

  # Perform a check of the provided SMTP information to ensure that the server
  # is up and responds to the settings.
  def check_smtp_settings
    smtp_params = smtp_allowed_params
    use_ssl = smtp_params[:smtp_ssl]
    server = smtp_params[:smtp_address]
    port = smtp_params[:smtp_port].to_i
    username = smtp_params[:smtp_username]
    password = smtp_params[:smtp_password]
    domain = smtp_params[:smtp_domain]
    auth = smtp_params[:smtp_authentication]
    if password == SmtpSettings::PASSWORD_UNCHANGED
      password = @profile.settings['smtp_password']
    end
    settings_validator = SmtpSettingsValidator.new(
        :server => server,
        :port => port,
        :ssl => use_ssl,
        :domain => domain,
        :username => username,
        :password => password,
        :auth => auth)
    valid = settings_validator.valid?
    error_msg = settings_validator.errors.join(', ')
    status = valid ? :ok : :error
    [status, error_msg]
  end

  def audit_view(current, updated)
    AuditHelper.compare(current, updated, filter: Mdm::Profile::PASSWORD_SETTINGS, same: false)
  end

  def ui_server_allowed_params
    params.slice(:ui_server_logged_in_timeout, :ui_server_consecutive_failed_logins_limit).permit!
  end

  def smtp_allowed_params
    params.slice(:smtp_ssl, :smtp_address, :smtp_port, :smtp_username, :smtp_password, :smtp_domain, :smtp_authentication).permit!
  end
end

