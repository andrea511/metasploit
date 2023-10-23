class AddLoginIdToBruteForceGuessAttempt < ActiveRecord::Migration[4.2]
  def change
    add_column :brute_force_guess_attempts, :login_id, :integer
  end
end
