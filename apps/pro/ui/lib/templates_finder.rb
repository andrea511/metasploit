class TemplatesFinder < Struct.new(:workspace, :base_class)
  def find
    selects = ['se_campaigns.workspace_id AS workspace_id', 'name', 
                'created_at', "#{base_class.table_name}.id AS id"]
    base_class.where(:workspace_id => workspace.id)
                                      .joins(:workspace)
  end

  # fields that we want to return in the result
  def datatable_columns
    [:cbox, :name, :created_at, :id]
  end

  # fields that we want to be searchable
  def datatable_search_columns
    [:name]
  end

end