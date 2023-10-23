class AddIndexesToHumanTargets < ActiveRecord::Migration[4.2]
  def change
    add_index :se_target_list_human_targets, [:target_list_id, :human_target_id], name: 'se_target_list_human_targets_compound_idx', unique: true
    add_index :se_target_list_human_targets, [:human_target_id, :target_list_id], name: 'se_target_list_human_targets_r_compound_idx'

    #add_index :se_human_targets, [:workspace_id, 'lower(email_address)', :first_name, :last_name], name: 'se_human_targets_compound_idx'
    reversible do |dir|
      dir.up {
        execute 'CREATE UNIQUE INDEX se_human_targets_compound_idx ON se_human_targets USING btree (workspace_id, LOWER(email_address), first_name, last_name, id)'
      }

      dir.down {
        execute 'DROP INDEX se_human_targets_compound_idx'
      }
    end
  end
end
