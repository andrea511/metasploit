class AddRawDataPhishingResults < ActiveRecord::Migration[4.2]
  def change
    add_column :se_phishing_results, :raw_data, :text
  end
end
