module SocialEngineering
class EmailServerConfigController < ServerConfigController
  def update
    params.require(:social_engineering_campaign)
    @campaign.smtp_host     = params[:social_engineering_campaign][:smtp_host]
    @campaign.smtp_port     = params[:social_engineering_campaign][:smtp_port]
    @campaign.smtp_username = params[:social_engineering_campaign][:smtp_username]
    @campaign.smtp_ssl      = (params[:social_engineering_campaign][:smtp_ssl].to_i > 0)
    @campaign.smtp_auth     = params[:social_engineering_campaign][:smtp_auth]
    @campaign.smtp_domain   = params[:social_engineering_campaign][:smtp_domain]
    @campaign.smtp_batch_size    = params[:social_engineering_campaign][:smtp_batch_size]
    @campaign.smtp_batch_delay   = params[:social_engineering_campaign][:smtp_batch_delay]
    @campaign.smtp_config_saved  = true

    password = params[:social_engineering_campaign][:smtp_password]
    unless password == SmtpSettings::PASSWORD_UNCHANGED
      @campaign.smtp_password = password
    end

    @campaign.errors.clear
    if @campaign.save
      render :json => SocialEngineering::CampaignSummary.new(@campaign).to_json
    else
      render :edit, :status => :bad_request
    end
  end

  # Accepts server, port, username, use_ssl, and password
  def check_smtp
    params.require(:social_engineering_campaign)
    params[:social_engineering_campaign] ||= {}
    use_ssl     = params[:social_engineering_campaign][:smtp_ssl].to_i > 0
    server      = params[:social_engineering_campaign][:smtp_host]
    port        = params[:social_engineering_campaign][:smtp_port].to_i
    username    = params[:social_engineering_campaign][:smtp_username]
    password    = params[:social_engineering_campaign][:smtp_password]
    auth        = params[:social_engineering_campaign][:smtp_auth]
    domain      = params[:social_engineering_campaign][:smtp_domain]

    if password == SmtpSettings::PASSWORD_UNCHANGED
      password = @campaign.smtp_password
    end
    
    settings_validator = SmtpSettingsValidator.new(
      :server      => server,
      :port        => port,
      :ssl         => use_ssl,
      :domain      => domain,
      :username    => username,
      :password    => password,
      :auth        => auth,
    )

    valid = settings_validator.valid?
    error_msg = settings_validator.errors.join(', ')
    status = valid ? :ok : :bad_request
    render :json => { :valid => valid, :error_msg => error_msg }, :status => status
  end

end
end
