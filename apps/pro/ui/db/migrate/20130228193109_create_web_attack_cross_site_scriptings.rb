class CreateWebAttackCrossSiteScriptings < ActiveRecord::Migration[4.2]
  def change
    create_table :web_attack_cross_site_scriptings do |t|
      t.string :encloser_type,  :null => false
      t.string :escaper_type,   :null => false
      t.string :evader_type,    :null => false
      t.string :executor_type,  :null => false

      t.timestamps null: false
    end
  end
end
