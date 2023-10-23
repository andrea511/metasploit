class SocialEngineering::PhishingResult < ApplicationRecord
  self.table_name = :se_phishing_results

  include SocialEngineering::TargetInteractionCallbacks

  #
  # Attributes
  #

  # @!attribute [rw] address
  #   The IP address for this result. Necessary to avoid coercion to an `IPAddr` object.
  #
  #   @return [String]
  def address
    self[:address].to_s
  end

  #
  # Associations
  #

  belongs_to :human_target, :class_name => 'SocialEngineering::HumanTarget', optional: true # allow for an anonymous target interaction
  belongs_to :web_page, :class_name => 'SocialEngineering::WebPage'

  #
  # Scopes
  #

  scope :for_human_target, lambda { |ht| where(:human_target_id => ht.id) }
  scope :in_campaign, lambda { |campaign| where(web_page_id: campaign.web_pages) }
  scope :campaign_id, lambda { |campaign_id| joins(:web_page).where(:se_web_pages => {:campaign_id => campaign_id}) }
end
