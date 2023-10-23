module  Metasploit::Pro::DbManagerOverride
  def init_db(opts)
    if ApplicationRecord.respond_to?(:connection_db_config) # supported in Rails 6
      connect(ApplicationRecord.connection_db_config.configuration_hash)
    else
      connect(ApplicationRecord.connection_config)
    end

    if !! error
      # +error+ is not an instance of +Exception+, it is, in fact, a +String+
      elog("Failed to connect to the database: #{error}")
    end
  end
end
