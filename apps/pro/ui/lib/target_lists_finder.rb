class TargetListsFinder < Struct.new(:workspace)
  def find
    SocialEngineering::TargetList.joins(
      SocialEngineering::TargetList.join_association(:workspace),
      SocialEngineering::TargetList.join_association(:human_targets, Arel::Nodes::OuterJoin)
    ).group('se_target_lists.name,
              se_target_lists.id,
              se_target_lists.workspace_id,
              se_target_lists.created_at')
      .select('se_target_lists.name, 
               se_target_lists.id,
                       se_target_lists.workspace_id AS workspace_id, 
                       COUNT(se_human_targets.id) AS targets_count, 
                       se_target_lists.created_at')
      .where(:workspace_id => workspace.id)
  end

  # fields that we want to return in the result
  # these have to be in the same order they are displayed
  #   in order for sorting to work correctly
  def datatable_columns
    [:cbox, :name, :targets_count, :created_at, :id]
  end

  # fields that we want to be searchable
  def datatable_search_columns
    [:name]
  end

  # renamed columns
  def datatable_virtual_columns
    [:targets_count]
  end
end

