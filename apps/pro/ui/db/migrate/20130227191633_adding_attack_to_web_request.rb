class AddingAttackToWebRequest < ActiveRecord::Migration[4.2]
  def change
    add_column :web_requests, :attack, :boolean, :default => :true
  end
end
