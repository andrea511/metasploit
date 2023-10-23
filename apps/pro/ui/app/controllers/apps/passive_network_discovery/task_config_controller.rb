class Apps::PassiveNetworkDiscovery::TaskConfigController < Apps::BaseController
  private

  def set_report_type
    @report_type = Apps::PassiveNetworkDiscovery::TaskConfig::REPORT_TYPE
  end
end
