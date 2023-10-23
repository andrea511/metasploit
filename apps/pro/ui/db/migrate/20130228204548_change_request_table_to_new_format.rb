class ChangeRequestTableToNewFormat < ActiveRecord::Migration[4.2]
  def self.up
    change_table :web_requests do |t|
      t.remove :encloser_type
      t.remove :escaper_type
      t.remove :evader_type
      t.remove :executor_type
      
      t.boolean :requested
      t.boolean :attack_vector
      t.references :request_group
      t.index :request_group_id
      t.references :cross_site_scripting
      t.index :cross_site_scripting_id
    end
  end

  def self.down
    change_table :web_requests do |t|
      t.string :encloser_type
      t.string :escaper_type
      t.string :evader_type
      t.string :executor_type
      
      t.remove :requested
      t.remove :attack_vector
      t.remove_references :request_group
      t.remove_references :cross_site_scripting
    end
  end
end
