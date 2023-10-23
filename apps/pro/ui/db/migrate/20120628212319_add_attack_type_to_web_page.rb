class AddAttackTypeToWebPage < ActiveRecord::Migration[4.2]
  def up
    add_column :se_web_pages, :attack_type, :string
  end

  def down
    remove_column :se_web_pages, :attack_type
  end
end
