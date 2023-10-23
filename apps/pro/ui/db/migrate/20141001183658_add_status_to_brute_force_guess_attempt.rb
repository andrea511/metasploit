class AddStatusToBruteForceGuessAttempt < ActiveRecord::Migration[4.2]
  def change
    add_column :brute_force_guess_attempts, :status, :string, default: "Untried"
  end
end
