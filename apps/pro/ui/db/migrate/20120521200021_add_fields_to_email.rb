class AddFieldsToEmail < ActiveRecord::Migration[4.2]
  def up
    add_column :se_emails, :from_address, :string
    add_column :se_emails, :from_name, :string
    add_column :se_emails, :attack_list_id, :integer
    add_column :se_emails, :email_template_id, :integer
  end

  def down
    remove_column :se_emails, :from_address
    remove_column :se_emails, :from_name
    remove_column :se_emails, :attack_list_id
    remove_column :se_emails, :email_template_id
  end

end
