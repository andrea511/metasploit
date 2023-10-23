class RemoveIdFromHumanTargetUniqueIndex < ActiveRecord::Migration[4.2]
  def change
    #add_index :se_human_targets, [:workspace_id, 'lower(email_address)', :first_name, :last_name], name: 'se_human_targets_compound_idx'
    reversible do |dir|
      dir.up {
        execute 'DROP INDEX se_human_targets_compound_idx'
        execute 'CREATE UNIQUE INDEX se_human_targets_compound_idx ON se_human_targets USING btree (workspace_id, LOWER(email_address), first_name, last_name)'
      }

      dir.down {
        execute 'DROP INDEX se_human_targets_compound_idx'
      }
    end
  end
end
