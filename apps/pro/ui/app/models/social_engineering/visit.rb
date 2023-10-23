class SocialEngineering::Visit < ApplicationRecord
  self.table_name = :se_visits

  include SocialEngineering::TargetInteractionCallbacks

  #
  # Attributes
  #

  # @!attribute [rw] address
  #   The originating IP address of the request for this visit. Necessary to
  #   avoid coercion to an `IPAddr` object.
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
  belongs_to :web_page, :class_name => 'SocialEngineering::WebPage', optional: true # this is likely a bug

  #
  # Scopes
  #

  scope :for_human_target, lambda{ |ht| where(:human_target_id => ht.id).includes(:email => :campaign) }
  scope :campaign_id, lambda{ |campaign_id| joins(:email).where(:se_emails => {:campaign_id => campaign_id})  }
  # TODO: refactor into polymorphic association or use Rails 5+ or and/or outer joins
  scope :email_in_campaign, lambda { |campaign|
    if campaign.email_campaign?
      where(email_id: campaign.emails)
    else
      none
    end
  }
  scope :web_in_campaign, lambda { |campaign|
    if campaign.web_campaign?
      where(web_page: campaign.web_pages)
    else
      none
    end
  }

  #
  # Validations
  #

  validates :human_target, :presence => true
end
