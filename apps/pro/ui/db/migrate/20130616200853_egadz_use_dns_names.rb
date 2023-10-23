class EgadzUseDnsNames < ActiveRecord::Migration[4.2]
  def up
    rename_column :egadz_result_ranges, :target_ip_address, :target_host
  end

  def down
    rename_column :egadz_result_ranges, :target_host, :target_ip_address
  end
end
