class AddSslCertIdtoSeCampaign < ActiveRecord::Migration[4.2]
  def change
    add_column :se_campaigns, :ssl_cert_id, :integer
  end
end
