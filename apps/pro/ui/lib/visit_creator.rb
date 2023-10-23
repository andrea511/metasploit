class VisitCreator
  def create(human_target, email, address)
    unless SocialEngineering::Visit.exists?(:email_id => email.id, :human_target_id => human_target.id)
      visit = SocialEngineering::Visit.new
      visit.address = address
      visit.email = email
      visit.human_target = human_target

      visit.save
    end
  end
end
