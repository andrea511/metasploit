class OpenedEmailsFinder < Struct.new(:campaign)

  # Find distinct EmailOpenings per HumanTarget for a given Email
  # I.e. if Joe Foo opens his email twice, we will note both openings 
  # in the DB, but this find will only show the first one.
  def find
    selects = [ 'email_address', 
                'MIN(se_email_openings.created_at) AS created_at', 
                'se_human_targets.id AS human_target_id',
                'first_name',
                'last_name' ]

    groups = [  'email_address',
                'se_human_targets.id',
                'first_name',
                'last_name' ]

    SocialEngineering::EmailOpening.where('email_id in (?)', email_ids)
      .joins([:human_target])
      .select(selects.join(','))
      .group(groups)
  end

  def email_ids
    campaign.emails.collect(&:id)
  end

  # fields that we want to return in the result
  def datatable_columns
    [:email_address, :first_name, :last_name, :created_at, :human_target_id]
  end

  # fields that we want to be searchable
  def datatable_search_columns
    [:email_address, :first_name, :last_name]
  end

  # renamed columns
  def datatable_virtual_columns
    [:created_at]
  end
end
