class SocialEngineering::EmailSend < ApplicationRecord
  self.table_name = :se_email_sends

  #
  # Associations
  #

  belongs_to :email, :class_name => "SocialEngineering::Email"
  belongs_to :human_target, :class_name => "SocialEngineering::HumanTarget"

  #
  # Scopes
  #

  scope :in_campaign, lambda { |campaign| where(email_id: campaign.emails) }

  #
  # Validations
  #

  validates :email, :presence => true
  validates :human_target, :presence => true
end
