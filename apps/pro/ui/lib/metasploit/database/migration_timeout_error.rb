# Error raised by {Metasploit::Database#wait_until_migrated} if timeout expires.
class Metasploit::Database::MigrationTimeoutError < Timeout::Error
end