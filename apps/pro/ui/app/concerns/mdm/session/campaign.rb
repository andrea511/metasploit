module Mdm::Session::Campaign
  extend ActiveSupport::Concern

  included do
    after_create :populate_campaign_id
  end

  private

  def populate_campaign_id
    camp_id  = self.datastore['CAMPAIGN_ID']

    if camp_id
      self.campaign_id = camp_id
      self.save
    end
  end
end