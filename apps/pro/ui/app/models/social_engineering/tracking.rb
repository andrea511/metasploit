require 'securerandom'

class SocialEngineering::Tracking < ApplicationRecord
    self.table_name = :se_trackings

    after_initialize do
      self.uuid ||= SecureRandom.uuid
    end

    belongs_to :email, :class_name => 'SocialEngineering::Email'
    belongs_to :human_target, :class_name => 'SocialEngineering::HumanTarget'
    validates :uuid, presence: true
end
