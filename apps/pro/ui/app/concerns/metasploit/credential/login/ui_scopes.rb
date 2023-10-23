# Adds some scopes that are useful from the UI

module Metasploit::Credential::Login::UiScopes
  extend ActiveSupport::Concern

  included do
    include TableResponder::UiScopes


  end

end
