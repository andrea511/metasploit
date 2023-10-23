# Explicit requires for engine/prosvc.rb
require 'authlogic'

module Mdm::User::Authentic
  extend ActiveSupport::Concern

  included do
    acts_as_authentic do |c|
      global_logged_in_timeout = UIServerSettings.new().logged_in_timeout
      if ApplicationRecord.connected?
        begin
          unless ApplicationRecord.connection.migration_context.needs_migration?
            current_profile = Mdm::Profile.find_by_active(true).ui_server_settings
            global_logged_in_timeout = current_profile.logged_in_timeout
          end
        rescue => _e
          # return the default when a value cannot be found in the database.
        end
      end

      c.session_class ::UserSession
      c.logged_in_timeout = global_logged_in_timeout
      silence_warnings do
        c.crypto_provider = Authlogic::CryptoProviders::Sha512
      end
    end

    USERNAME = /\A[a-zA-Z0-9_][a-zA-Z0-9\.+\-_@ ]+\z/

    #
    # Validations
    #

    validates :username,
      format: {
        with: USERNAME,
        message: proc {
          ::Authlogic::I18n.t(
              "error_messages.login_invalid",
              default: "should use only letters, numbers, spaces, and .-_@+ please."
          )
        }
      },
      length: { within: 3..100 },
      uniqueness: {
        case_sensitive: false,
        if: :will_save_change_to_username?
      }
    validates :password,
      confirmation: { if: :require_password? },
      length: {
        minimum: 8,
        if: :require_password?
      }
    validates :password_confirmation,
      length: {
        minimum: 8,
        if: :require_password?
      }
    validates :password, password_is_strong: true
    validates :password_confirmation, password_is_strong: true
  end
end
