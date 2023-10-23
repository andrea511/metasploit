class CreateSocialEngineeringCampaignFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :se_campaign_files do |t|
      t.references :attachable, :polymorphic => true
      t.string :attachment

      t.timestamps null: false
    end
  end
end
