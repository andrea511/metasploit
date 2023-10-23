class ModifyWebCookieIntoACookieJar < ActiveRecord::Migration[4.2]
  def up
    change_table :web_cookies do |t|
      t.string :domain, null: false
      t.string :path
      t.boolean :secure, null: false, default: false
      t.boolean :http_only, null: false, default: false
      t.integer :version
      t.string :commnet
      t.string :comment_url
      t.boolean :discard, null: false, default: false
      t.text :ports
      t.integer :max_age
      t.datetime :expires_at

      t.timestamps null: true

      t.index [:request_group_id, :name]
    end
  end

  def down
    change_table :web_cookies do |t|
      t.remove :domain
      t.remove :path
      t.remove :secure
      t.remove :http_only
      t.remove :version
      t.remove :commnet
      t.remove :comment_url
      t.remove :discard
      t.remove :ports
      t.remove :max_age
      t.remove :expires_at

      t.remove_timestamps

      t.remove_index [:request_group_id, :name]
    end
  end
end
