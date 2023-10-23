class CreateSocialEngineeringUsbKeys < ActiveRecord::Migration[4.2]
  def change
    create_table :se_usb_keys do |t|
      t.integer :campaign_id
      t.string :name

      t.timestamps null: false
    end
  end
end
