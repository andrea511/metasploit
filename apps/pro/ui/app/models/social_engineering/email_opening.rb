class SocialEngineering::EmailOpening < ApplicationRecord
  self.table_name = :se_email_openings

  include SocialEngineering::TargetInteractionCallbacks

  #
  # Attributes
  #

  # @!attribute [rw] address
  #   The originating IP address of the request for the tracking image in this email.
  #   Necessary to avoid coercion to an `IPAddr` object.
  #
  #   @return [String]
  def address
    self[:address].to_s
  end

  #
  # Associations
  #

  belongs_to :email, :class_name => 'SocialEngineering::Email'
  belongs_to :human_target, :class_name => 'SocialEngineering::HumanTarget'

  #
  # Scopes
  #

  scope :for_human_target, lambda{|ht| where(:human_target_id => ht.id).includes(:email => :campaign) }
  scope :in_campaign, lambda { |campaign| where(email_id: campaign.emails) }
  scope :campaign_id, lambda { |campaign_id| joins(:email).where(:se_emails => {:campaign_id => campaign_id}) }

  #
  # Validations
  #

  validates :address, :presence => true, :ip_format => true
  validates :email, :presence => true
  validates :human_target, :presence => true
end
