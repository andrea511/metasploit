class ClickedLinkTargetsFinder < Struct.new(:campaign)
  def find
    selects = [ 'email_address', 
                'se_human_targets.id AS human_target_id',
                'MIN(se_visits.created_at) AS created_at',
                'first_name',
                'last_name' ]

    groups = [  'email_address',
                'se_human_targets.id',
                'first_name',
                'last_name' ]

    SocialEngineering::Visit.where('email_id in (?)', email_ids).
      joins([:human_target])
      .select(selects.join(','))
      .group(groups)
  end

  def email_ids
    campaign.emails.collect(&:id)
  end

  def datatable_columns
    [:email_address, :first_name, :last_name, :created_at, :human_target_id]
  end

  def datatable_search_columns
    [:email_address, :first_name, :last_name]
  end

  # renamed columns
  def datatable_virtual_columns
    [:created_at]
  end
end
