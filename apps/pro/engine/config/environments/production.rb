if defined? Metasploit::Pro::Engine::Application
  Metasploit::Pro::Engine::Application.configure do
    config.log_level = :info
    config.active_record.dump_schema_after_migration = false
    config.paths['db/migrate'] << '../ui/db/migrate'
  end
end

