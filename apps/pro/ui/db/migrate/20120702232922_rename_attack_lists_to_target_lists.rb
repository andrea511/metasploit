class RenameAttackListsToTargetLists < ActiveRecord::Migration[4.2]
  def up
    rename_table :se_attack_lists, :se_target_lists
    rename_column :se_attack_list_human_targets, :attack_list_id, :target_list_id
    rename_table :se_attack_list_human_targets, :se_target_list_human_targets
    rename_column :se_emails, :attack_list_id, :target_list_id
  end

  def down
    rename_table :se_target_lists, :se_attack_lists
    rename_column :se_target_list_human_targets, :target_list_id, :attack_list_id
    rename_table :se_target_list_human_targets, :se_attack_list_human_targets
    rename_column :se_emails, :target_list_id, :attack_list_id
  end
end
