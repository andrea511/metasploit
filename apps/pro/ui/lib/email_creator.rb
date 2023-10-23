class EmailCreator < Struct.new(:listener)
  def create_for(campaign_id, attributes)
    email = make_new_email(campaign_id, attributes)
    if save(email)
      listener.create_email_succeeded(email)
    else
      listener.create_email_failed(email)
    end
  end

  private

  def make_new_email(campaign_id, attributes)
    EmailBuilder.new(attributes, campaign_id).email
  end

  def save(email)
    email.save unless has_errors?(email)
  end

  def has_errors?(email)
    email.errors.count > 0
  end
end
