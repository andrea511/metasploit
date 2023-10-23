class AddCapturedCredsCountToMmDominoNodes < ActiveRecord::Migration[4.2]

  def change
    add_column :mm_domino_nodes, :captured_creds_count, :integer, default: 0
  end

end
