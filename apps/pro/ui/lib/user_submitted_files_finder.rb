class UserSubmittedFilesFinder < Struct.new(:workspace)
  def find
    SocialEngineering::UserSubmittedFile.where(:workspace_id => workspace.id)
      .joins(:user)
      .select('se_campaign_files.name,
               users.username AS user_name,
               se_campaign_files.created_at,
               se_campaign_files.id,
               se_campaign_files.file_size')
  end

  # fields that we want to return in the result
  def datatable_columns
    [:cbox, :name, :user_name, :file_size, :created_at, :id]
  end

  # fields that we want to be searchable
  def datatable_search_columns
    [:name, :user_name]
  end

  # renamed columns
  def datatable_virtual_columns
    [:user_name]
  end
end
