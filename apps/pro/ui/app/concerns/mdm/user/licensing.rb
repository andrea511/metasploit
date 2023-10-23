module Mdm::User::Licensing
  extend ActiveSupport::Concern

  included do
    validate :available_license, :on => :create
  end

  private

  def available_license
    unless license_available?
      errors.add(:base,  "would exceed user limit (#{License.get.users}) on this license")
    end
  end

  def license_available?
    if Rails.env.test?
      true
    else
      self.class.count < License.get.users
    end
  end
end
