class CreateBruteForceReuseGroupsMetasploitCredentialCores < ActiveRecord::Migration[4.2]
  def change
    create_table :brute_force_reuse_groups_metasploit_credential_cores, id: false do |t|
      t.belongs_to :brute_force_reuse_group, null: false
      t.belongs_to :metasploit_credential_core, null: false
    end

    # Index name
    # 'index_brute_force_reuse_groups_metasploit_credential_cores_on_brute_force_reuse_group_id_and_metasploit_credential_core_id'
    # on table 'brute_force_reuse_groups_metasploit_credential_cores' is too long; the limit is 63 characters
    add_index :brute_force_reuse_groups_metasploit_credential_cores,
              [
                  :brute_force_reuse_group_id,
                  :metasploit_credential_core_id
              ],
              name: :unique_brute_force_reuse_groups_metasploit_credential_cores,
              unique: true
  end
end
