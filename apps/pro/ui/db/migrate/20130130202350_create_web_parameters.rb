class CreateWebParameters < ActiveRecord::Migration[4.2]
  def up
    create_table :web_parameters do |t|
      t.boolean :attack_vector, :null => false
      t.string :name, :null => false
      t.string :value, :null => false

      #
      # References
      #
      t.references :request, :null => false
    end
  end

  def down
    drop_table :web_parameters
  end
end
