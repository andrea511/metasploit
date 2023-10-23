class RenameSocialEngineeringConstraints < ActiveRecord::Migration[4.2]

  def self.constraint_name(table)
    execute("SELECT conname FROM pg_constraint WHERE conrelid =
    (SELECT oid
    FROM pg_class
    WHERE relname = '#{table}');").values.flatten.first
  end

  # Renames primary key constraints missed in previous table renames.
  # Only applicable for upgrades to Rails 4, so verify key first:
  def change
    if RenameSocialEngineeringConstraints.constraint_name("se_portable_files") == "se_usb_keys_pkey"
      execute "ALTER TABLE se_portable_files DROP CONSTRAINT se_usb_keys_pkey;"
      execute "ALTER TABLE se_portable_files ADD PRIMARY KEY (id);"
    end

    if RenameSocialEngineeringConstraints.constraint_name("se_tracking_links") == "se_tracking_links_pkey"
      execute "ALTER TABLE se_tracking_links DROP CONSTRAINT se_tracking_links_pkey;"
      execute "ALTER TABLE se_tracking_links ADD PRIMARY KEY (id);"
    end

    if RenameSocialEngineeringConstraints.constraint_name("se_target_lists") == "se_attack_lists_pkey"
      execute "ALTER TABLE se_target_lists DROP CONSTRAINT se_attack_lists_pkey;"
      execute "ALTER TABLE se_target_lists ADD PRIMARY KEY (id);"
    end

    if RenameSocialEngineeringConstraints.constraint_name("se_target_list_human_targets") == "se_attack_list_human_targets_pkey"
      execute "ALTER TABLE se_target_list_human_targets DROP CONSTRAINT se_attack_list_human_targets_pkey;"
      execute "ALTER TABLE se_target_list_human_targets ADD PRIMARY KEY (id);"
    end
  end
end
