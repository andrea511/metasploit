class CreateSonarAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :sonar_accounts do |t|
      t.string :email
      t.string :api_key

      t.timestamps null: false
    end
  end
end
