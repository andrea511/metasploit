class CreateSocialEngineeringTracking < ActiveRecord::Migration[6.1]
  def up
    create_table :se_trackings do |t|
      t.uuid :uuid, null: false

      # Foreign Keys

      t.references :human_target, null: false
      t.references :email, null: false

      t.timestamps
    end
  end

  def down
    drop_table :se_trackings
  end
end
