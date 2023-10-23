class AddAttackTypeToEmail < ActiveRecord::Migration[4.2]
  def change
    add_column :se_emails, :attack_type, :string
  end
end
