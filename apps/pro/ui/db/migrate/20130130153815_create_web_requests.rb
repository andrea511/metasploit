class CreateWebRequests < ActiveRecord::Migration[4.2]
  def up
    create_table :web_requests do |t|
      t.string :encloser_type, :null => false
      t.string :escaper_type, :null => false
      t.string :evader_type, :null => false
      t.string :executor_type, :null => false
      t.string :method, :null => false

      #
      # References
      #
      t.references :user, :null => false
      # Does not require to reference a Mdm::WebVuln if created manually
      t.references :vulnerability, :null => true
      t.references :workspace, :null => false
    end
  end

  def down
    drop_table :web_requests
  end
end
