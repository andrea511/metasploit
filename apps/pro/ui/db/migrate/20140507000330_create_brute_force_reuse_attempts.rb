class CreateBruteForceReuseAttempts < ActiveRecord::Migration[4.2]
  def change
    create_table :brute_force_reuse_attempts do |t|
      #
      # Foreign Keys
      #

      t.references :brute_force_run, null: false
      t.references :metasploit_credential_core, null: false
      t.references :service, null: false

      #
      # timestamps null: false
      #

      t.datetime :attempted_at, null: true
      t.timestamps null: false
    end

    #
    # Unique indices
    #

    # Index name
    # 'index_brute_force_reuse_attempts_on_brute_force_run_id_and_metasploit_credential_core_id_and_service_id' on table
    # 'brute_force_reuse_attempts' is too long; the limit is 63 characters
    add_index :brute_force_reuse_attempts,
              [
                  :brute_force_run_id,
                  :metasploit_credential_core_id,
                  :service_id
              ],
              name: :unique_brute_force_reuse_attempts,
              unique: true

    #
    # Foreign key indices (not covered by unique indices)
    #

    # Index name 'index_brute_force_reuse_attempts_on_metasploit_credential_core_id' on table
    # 'brute_force_reuse_attempts' is too long; the limit is 63 characters
    add_index :brute_force_reuse_attempts,
              :metasploit_credential_core_id,
              name: :brute_force_reuse_attempts_metasploit_credential_core_ids
    add_index :brute_force_reuse_attempts,
              :service_id
  end
end
