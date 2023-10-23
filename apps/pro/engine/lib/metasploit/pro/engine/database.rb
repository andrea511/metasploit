module Metasploit::Pro::Engine::Database
  #
  # CONSTANTS
  #

  # Default timeout to wait for a database connection.
  DEFAULT_WAIT_TIMEOUT = 5.minutes
  # Max value for `'pool'` based on supported values for PostgreSQL.
  MAX_POOL = 75
end
