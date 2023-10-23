class SentEmailsFinder < Struct.new(:campaign)
  def find
    SocialEngineering::HumanTarget.where('id in (?)', get_human_target_ids)
  end

  # fields that we want to return in the result
  def datatable_columns
    [:email_address, :first_name, :last_name]
  end

  # fields that we want to be searchable
  def datatable_search_columns
    [:email_address, :first_name, :last_name]
  end

  private

  def get_human_target_ids
    campaign.emails.collect do |email|
      if email.target_list.present? && email.target_list.human_targets.present?
        email.target_list.human_targets
      else
        []
      end
    end.flatten.collect(&:id)
  end
end
