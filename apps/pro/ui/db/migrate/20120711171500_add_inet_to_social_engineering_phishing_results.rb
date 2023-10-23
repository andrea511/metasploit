class AddInetToSocialEngineeringPhishingResults < ActiveRecord::Migration[4.2]
  def up
    add_column :se_phishing_results, :address, :inet
  end

  def down
    remove_column :se_phishing_results, :address
  end
end
