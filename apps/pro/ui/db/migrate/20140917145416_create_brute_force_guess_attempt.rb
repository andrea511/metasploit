class CreateBruteForceGuessAttempt < ActiveRecord::Migration[4.2]
  def change
    create_table :brute_force_guess_attempts do |t|
      #
      # Foreign Keys
      #

      t.references :brute_force_run, null: false
      t.references :brute_force_guess_core, null: false
      t.references :service, null: false

      #
      # timestamps null: false
      #

      t.datetime :attempted_at, null: true
      t.timestamps null: false
    end

    #
    # Unique indices
    #

    # Index name
    # 'index_brute_force_guess_attempts_on_brute_force_run_id_and_brute_force_guess_core_id_and_service_id' on table
    # 'brute_force_guess_attempts' is too long; the limit is 63 characters
    add_index :brute_force_guess_attempts,
              [
                :brute_force_run_id,
                :brute_force_guess_core_id,
                :service_id
              ],
              name: :unique_brute_force_guess_attempts,
              unique: true

    #
    # Foreign key indices (not covered by unique indices)
    #

    # Index name 'index_brute_force_guess_attempts_on_brute_force_guess_core_id' on table
    # 'brute_force_guess_attempts' is too long; the limit is 63 characters
    add_index :brute_force_guess_attempts,
              :brute_force_guess_core_id,
              name: :brute_force_guess_attempts_brute_force_guess_core_ids
    add_index :brute_force_guess_attempts,
              :service_id
  end
end
