Rails.application.reloader.to_prepare do
  Msf::Exploit::Remote::HttpServer.send(:prepend, Custom::CampaignAdditions)
end
