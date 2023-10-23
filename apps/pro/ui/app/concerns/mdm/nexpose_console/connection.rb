module Mdm::NexposeConsole::Connection
  extend ActiveSupport::Concern

  DEFAULT_STATUS_TIMEOUT = 5

  # Attempts to connect to the console and returns a result
  # @param [Hash] opts the options hash
  # @option opts [Integer] :timeout returns after the specified interval. @see DEFAULT_STATUS_TIMEOUT.
  # @return [Hash] with connection_success: Boolean and optional connection_error: String
  def check_status
    begin
      ::Timeout.timeout(DEFAULT_STATUS_TIMEOUT) do
        conn = ::Nexpose::Connection.new(
          self.address, self.username, self.password, self.port
        )
        conn.login
      end
    rescue ::Timeout::Error => e
      { connection_success: false, message: "Connection to #{self.address}:#{self.port} timed out" }
    rescue ::SocketError => e
      { connection_success: false, message: "Connection to #{self.address}:#{self.port} failed" }
    rescue ::Nexpose::AuthenticationFailed => e
      { connection_success: false, message: "Incorrect username or password" }
    rescue ::Nexpose::APIError => e
      { connection_success: false, message: "API error occurred" }
    else
      { connection_success: true }
    end
  end
end
