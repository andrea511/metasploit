class AddParsedUaInfoToPhishingResults < ActiveRecord::Migration[4.2]
  def change
    add_column :se_phishing_results, :browser_name, :string
    add_column :se_phishing_results, :browser_version, :string
    add_column :se_phishing_results, :os_name, :string
    add_column :se_phishing_results, :os_version, :string
  end
end
