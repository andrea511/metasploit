module SocialEngineering
class WebServerConfigController < ServerConfigController
  CUSTOM_HOST_VALUE_PLACEHOLDER = 'custom_value'

  def edit
    compute_hosts
  end

  def update
    params.require(:social_engineering_campaign)
    @campaign.web_host     = params[:social_engineering_campaign][:web_host]
    @campaign.web_port     = params[:social_engineering_campaign][:web_port]
    @campaign.web_bap_port = params[:social_engineering_campaign][:web_bap_port]
    @campaign.web_ssl      = (params[:social_engineering_campaign][:web_ssl].to_i == 1)
    @campaign.ssl_cipher   = params[:social_engineering_campaign][:ssl_cipher]

    @campaign.errors.clear

    file = params[:social_engineering_campaign][:file]
    ssl_error = nil

    if file.present?
      begin
        cert_name = "SE-#{@campaign.name}-#{@campaign.id}"
        ssl_cert = SSLCert.create!(workspace_id: @campaign.workspace_id, file: file, name: cert_name)
        @campaign.ssl_cert = ssl_cert
      rescue ActiveRecord::RecordInvalid, OpenSSL::X509::CertificateError => e
        ssl_error = e.message
      end
    end

    if @campaign.save && ssl_error.nil?
      render :partial => 'shared/iframe_transport_response', :locals => {
        :data => {
          success: true,
          json: SocialEngineering::CampaignSummary.new(@campaign).to_json
        }
      }
    else
      unless ssl_error.nil?
        @campaign.errors.add(:file, "is not valid or incomplete. Please verify that it is in PEM format, includes both the Certificate and Key in one file, and does not have a password set. \"#{ssl_error}\"")
      end
      compute_hosts
      errors = render_to_string 'social_engineering/web_server_config/edit', layout: false
      render :partial => 'shared/iframe_transport_response', :locals => { :data => { :success => false, :error => errors } }
    end
  end

  private

  def compute_hosts
    @default_ip = Rex::Socket.source_address()
    @default_host = Socket.gethostname
    if [@default_ip, @default_host].include? @campaign.web_host
      @other_value = ''
    else
      @other_value = @campaign.web_host
      # in order for formtastic to select the correct radio button
      @campaign.web_host = CUSTOM_HOST_VALUE_PLACEHOLDER
    end
  end

end
end
