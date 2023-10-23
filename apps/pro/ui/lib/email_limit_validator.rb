class EmailLimitValidator
  attr_reader :limit

  def initialize(limit)
    @limit = limit
  end

  def valid?(email)
    campaign = email.campaign
    campaign.emails.count < limit 
  end
end
