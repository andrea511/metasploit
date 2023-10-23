module Mdm::Service::Validations
  extend ActiveSupport::Concern

  included do
    #
    # Validations
    #
    validates :name, presence: true, on: :single_host_view
    validates :name, length: {maximum: 255}

  end
end