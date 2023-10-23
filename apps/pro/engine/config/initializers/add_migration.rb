Rails.application.reloader.to_prepare do
  Msf::DBManager::Migration.send(:prepend,  Metasploit::Database::Migration)
end
