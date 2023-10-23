class RemoveSkippedFromBruteForceReuseAttempts < ActiveRecord::Migration[4.2]
  def change
    remove_column :brute_force_reuse_attempts, :skipped
  end
end
