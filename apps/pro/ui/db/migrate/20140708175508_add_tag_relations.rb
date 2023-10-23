class AddTagRelations < ActiveRecord::Migration[4.2]

  def change
    create_table :metasploit_credential_core_tags do |t|
      t.belongs_to :core, null: false
      t.belongs_to :tag, null: false
    end

    create_table :metasploit_credential_login_tags do |t|
      t.belongs_to :login, null: false
      t.belongs_to :tag, null: false
    end

    add_index :metasploit_credential_core_tags, [:core_id, :tag_id], unique: true
    add_index :metasploit_credential_login_tags, [:login_id, :tag_id], unique: true

  end

end
