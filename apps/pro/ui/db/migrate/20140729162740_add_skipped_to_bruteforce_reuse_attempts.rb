class AddSkippedToBruteforceReuseAttempts < ActiveRecord::Migration[4.2]
  def change
    add_column :brute_force_reuse_attempts, :skipped, :boolean
  end
end
