class CreateBannerMessages < ActiveRecord::Migration[4.2]
  def self.up
    create_table :banner_messages do |t|
      t.string :name

      t.timestamps null: false
    end

    # populate the table
    BannerMessage.create :name => "usage_metrics_announcement"
  end

  def self.down
    drop_table :banner_messages
  end
end
