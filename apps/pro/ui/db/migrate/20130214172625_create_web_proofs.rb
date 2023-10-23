# Creates the web_proofs table for {Web::Proof} model
class CreateWebProofs < ActiveRecord::Migration[4.2]
  # The name of the table being created/dropped
  TABLE_NAME = :web_proofs

  # Creates the web_proofs table
  #
  # @return [void]
  def up
    create_table TABLE_NAME do |t|
      #
      # Columns
      #

      # image and text are both :null => true because only one of them needs to be set and ensuring
      # at least one is set is handled in Rails instead of the database.
      t.string :image, :null => true
      t.text :text, :null => true

      #
      # References
      #
      t.references :vuln, :null => false
    end
  end

  # Drops the web_proofs table
  #
  # @return [void]
  def down
    drop_table TABLE_NAME
  end
end
