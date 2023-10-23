class AddOriginTypeToEmail < ActiveRecord::Migration[4.2]
  def change
    add_column :se_emails, :origin_type, :string
  end
end
