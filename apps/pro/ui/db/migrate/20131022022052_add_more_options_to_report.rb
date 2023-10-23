class AddMoreOptionsToReport < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :se_campaign_id, :integer
    add_column :reports, :app_run_id, :integer
    add_column :reports, :order_vulns_by, :string
  end
end
