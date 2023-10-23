Rails.application.reloader.to_prepare do
  [Metasploit::Pro::DbManagerOverride, Metasploit::Pro::ImportMsfXml, Web::VulnCategory::Mixin].each do |ancestor|
    Msf::DBManager.send(:prepend, ancestor)
  end
end
