# Explicit requires for engine/prosvc.rb
require 'authlogic'

class UserSession < Authlogic::Session::Base
  ABSOLUTE_TIMEOUT = 72.hours

  ui_failed_logins = UIServerSettings.new().consecutive_failed_logins_limit
  if ApplicationRecord.connected?
    begin
      unless ApplicationRecord.connection.migration_context.needs_migration?
        current_profile = Mdm::Profile.find_by_active(true).ui_server_settings
        ui_failed_logins = current_profile.consecutive_failed_logins_limit
      end
    rescue => _e
      # return the default when a value cannot be found in the database.
    end
  end

  logout_on_timeout(Rails.env.production? || Rails.env.test?)
  consecutive_failed_logins_limit ui_failed_logins
  failed_login_ban_for 10.minutes

  authenticate_with Mdm::User
  httponly true
  secure true
  session_fixation_defense false

  before_destroy :reset_persistence_token
  before_create :reset_persistence_token

  private

  # Reset the cookie's persistence token.
  def reset_persistence_token
    record.reset_persistence_token!
  end
end
