class BannerMessageUser < ApplicationRecord
  validates :banner_message_id, :user_id, presence: true
end
