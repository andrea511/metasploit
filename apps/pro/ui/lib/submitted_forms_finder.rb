class SubmittedFormsFinder < Struct.new(:campaign)
  def find
    SocialEngineering::PhishingResult.select(
      SocialEngineering::PhishingResult[:id].as('phishing_result_id'),
      SocialEngineering::HumanTarget[:email_address],
      SocialEngineering::PhishingResult[:created_at].as('created_at'),
      SocialEngineering::HumanTarget[:id].as('human_target_id'),
      SocialEngineering::HumanTarget[:first_name],
      SocialEngineering::HumanTarget[:last_name],
      SocialEngineering::PhishingResult[:web_page_id],
      SocialEngineering::WebPage[:name].as('web_page_name')
    ).joins(
      SocialEngineering::PhishingResult.join_association(:human_target, Arel::Nodes::OuterJoin),
      SocialEngineering::PhishingResult.join_association(:web_page)
    ).where(
      web_page_id: campaign.web_pages
    )
  end

  # fields that we want to return in the result
  def datatable_columns
    [:email_address, :first_name, :last_name, :web_page_name, :created_at, :phishing_result_id, :human_target_id, :web_page_id]
  end

  # fields that we want to be searchable
  def datatable_search_columns
    [:email_address, :first_name, :last_name, 'se_web_pages.name']
  end
end

