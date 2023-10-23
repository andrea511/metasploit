# Adds some scopes that are useful from the UI

module Mdm::Service::UiScopes
  extend ActiveSupport::Concern

  included do
    include TableResponder::UiScopes

    scope :workspace_id, lambda { |wid|
      joins(:host).where(hosts: { workspace_id: wid })
    }
  end

end
