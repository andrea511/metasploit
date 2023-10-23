class AddSessionIdToBruteForceGuessAttempt < ActiveRecord::Migration[4.2]
  def change
    add_column :brute_force_guess_attempts, :session_id, :integer
  end
end
