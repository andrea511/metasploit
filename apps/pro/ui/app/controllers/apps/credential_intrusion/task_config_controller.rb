class Apps::CredentialIntrusion::TaskConfigController < Apps::BaseController
  private

  def set_report_type
    @report_type = Apps::CredentialIntrusion::TaskConfig::REPORT_TYPE
  end
end
